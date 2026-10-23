package com.projectledger.service;

import com.google.gson.JsonArray;
import com.google.gson.JsonElement;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;
import com.projectledger.dao.GitHubActivityDao;
import com.projectledger.dao.ProjectDao;
import com.projectledger.exception.GitHubException;
import com.projectledger.model.GitHubCommit;
import com.projectledger.model.Project;
import com.projectledger.util.AppConfig;

import java.io.IOException;
import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.time.Duration;
import java.time.Instant;
import java.time.LocalDateTime;
import java.time.ZoneId;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;
import java.util.logging.Level;
import java.util.logging.Logger;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

/**
 * Service managing integration with the GitHub REST API.
 * Uses java.net.http.HttpClient and Gson.
 * Features 10-minute memory caching for contributors and branches,
 * rate limit handling, and pagination.
 */
public class GitHubService {
    private static final Logger LOGGER = Logger.getLogger(GitHubService.class.getName());
    private static final String GITHUB_API_BASE = "https://api.github.com";
    private static final Pattern NEXT_LINK_PATTERN = Pattern.compile("<([^>]+)>;\\s*rel=\"next\"");

    private final HttpClient httpClient;
    private final GitHubActivityDao gitHubActivityDao;
    private final ProjectDao projectDao;

    // 10-minute in-memory cache for live branches and contributors
    private static final Map<String, CacheEntry<List<String>>> CACHE = new ConcurrentHashMap<>();
    private static final long CACHE_DURATION_MS = 10 * 60 * 1000; // 10 minutes

    private static class CacheEntry<T> {
        final T data;
        final long timestamp;

        CacheEntry(T data) {
            this.data = data;
            this.timestamp = System.currentTimeMillis();
        }

        boolean isExpired() {
            return (System.currentTimeMillis() - timestamp) > CACHE_DURATION_MS;
        }
    }

    public GitHubService() {
        this.httpClient = HttpClient.newBuilder()
                .connectTimeout(Duration.ofSeconds(10))
                .followRedirects(HttpClient.Redirect.NORMAL)
                .build();
        this.gitHubActivityDao = new GitHubActivityDao();
        this.projectDao = new ProjectDao();
    }

    public GitHubService(HttpClient httpClient, GitHubActivityDao gitHubActivityDao, ProjectDao projectDao) {
        this.httpClient = httpClient;
        this.gitHubActivityDao = gitHubActivityDao;
        this.projectDao = projectDao;
    }

    /**
     * Validates that the repository exists and is accessible.
     */
    public boolean validateRepository(String owner, String repo) {
        try {
            String url = GITHUB_API_BASE + "/repos/" + owner + "/" + repo;
            HttpRequest request = createRequestBuilder(url).GET().build();
            HttpResponse<String> response = httpClient.send(request, HttpResponse.BodyHandlers.ofString());
            handleResponseErrors(response);
            return response.statusCode() == 200;
        } catch (Exception e) {
            LOGGER.log(Level.WARNING, "GitHub repository validation failed for " + owner + "/" + repo, e);
            return false;
        }
    }

    /**
     * Synchronizes commits from GitHub, paginating up to 3 pages of 100 commits,
     * and upserts into the database.
     */
    public int syncCommits(Project project) {
        if (project.getRepoOwner() == null || project.getRepoName() == null) {
            throw new GitHubException("No GitHub repository configured for this project.");
        }

        String owner = project.getRepoOwner().trim();
        String repo = project.getRepoName().trim();
        String nextUrl = GITHUB_API_BASE + "/repos/" + owner + "/" + repo + "/commits?per_page=100";

        List<GitHubCommit> allCommits = new ArrayList<>();
        int pagesFetched = 0;
        final int MAX_PAGES = 3;

        try {
            while (nextUrl != null && pagesFetched < MAX_PAGES) {
                HttpRequest request = createRequestBuilder(nextUrl).GET().build();
                HttpResponse<String> response = httpClient.send(request, HttpResponse.BodyHandlers.ofString());

                handleResponseErrors(response);

                JsonElement root = JsonParser.parseString(response.body());
                if (root.isJsonArray()) {
                    JsonArray array = root.getAsJsonArray();
                    for (JsonElement el : array) {
                        JsonObject obj = el.getAsJsonObject();
                        GitHubCommit commit = parseCommitObject(project.getId(), obj);
                        if (commit != null) {
                            allCommits.add(commit);
                        }
                    }
                }

                pagesFetched++;
                nextUrl = extractNextPageUrl(response.headers().firstValue("Link").orElse(null));
            }

            gitHubActivityDao.upsertCommits(project.getId(), allCommits);
            LocalDateTime now = LocalDateTime.now();
            projectDao.updateLastSyncedAt(project.getId(), now);
            project.setLastSyncedAt(now);

            return allCommits.size();
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
            throw new GitHubException("GitHub synchronization was interrupted.", e);
        } catch (IOException e) {
            throw new GitHubException("Couldn't reach GitHub, try again.", e);
        }
    }

    /**
     * Retrieves contributors list, cached for 10 minutes.
     */
    public List<String> getContributors(String owner, String repo) {
        String cacheKey = "contrib_" + owner + "/" + repo;
        CacheEntry<List<String>> cached = CACHE.get(cacheKey);
        if (cached != null && !cached.isExpired()) {
            return cached.data;
        }

        try {
            String url = GITHUB_API_BASE + "/repos/" + owner + "/" + repo + "/contributors?per_page=30";
            HttpRequest request = createRequestBuilder(url).GET().build();
            HttpResponse<String> response = httpClient.send(request, HttpResponse.BodyHandlers.ofString());

            if (response.statusCode() == 200) {
                List<String> contributors = new ArrayList<>();
                JsonArray arr = JsonParser.parseString(response.body()).getAsJsonArray();
                for (JsonElement el : arr) {
                    JsonObject obj = el.getAsJsonObject();
                    if (obj.has("login")) {
                        contributors.add(obj.get("login").getAsString());
                    }
                }
                CACHE.put(cacheKey, new CacheEntry<>(contributors));
                return contributors;
            }
        } catch (Exception e) {
            LOGGER.log(Level.INFO, "Could not fetch contributors from GitHub: " + e.getMessage());
        }

        return cached != null ? cached.data : Collections.emptyList();
    }

    /**
     * Retrieves branches list, cached for 10 minutes.
     */
    public List<String> getBranches(String owner, String repo) {
        String cacheKey = "branches_" + owner + "/" + repo;
        CacheEntry<List<String>> cached = CACHE.get(cacheKey);
        if (cached != null && !cached.isExpired()) {
            return cached.data;
        }

        try {
            String url = GITHUB_API_BASE + "/repos/" + owner + "/" + repo + "/branches?per_page=30";
            HttpRequest request = createRequestBuilder(url).GET().build();
            HttpResponse<String> response = httpClient.send(request, HttpResponse.BodyHandlers.ofString());

            if (response.statusCode() == 200) {
                List<String> branches = new ArrayList<>();
                JsonArray arr = JsonParser.parseString(response.body()).getAsJsonArray();
                for (JsonElement el : arr) {
                    JsonObject obj = el.getAsJsonObject();
                    if (obj.has("name")) {
                        branches.add(obj.get("name").getAsString());
                    }
                }
                CACHE.put(cacheKey, new CacheEntry<>(branches));
                return branches;
            }
        } catch (Exception e) {
            LOGGER.log(Level.INFO, "Could not fetch branches from GitHub: " + e.getMessage());
        }

        return cached != null ? cached.data : Collections.emptyList();
    }

    private HttpRequest.Builder createRequestBuilder(String url) {
        HttpRequest.Builder builder = HttpRequest.newBuilder()
                .uri(URI.create(url))
                .timeout(Duration.ofSeconds(10))
                .header("Accept", "application/vnd.github+json")
                .header("X-GitHub-Api-Version", "2022-11-28")
                .header("User-Agent", "ProjectLedger");

        String token = AppConfig.getGitHubToken();
        if (token != null && !token.isBlank()) {
            builder.header("Authorization", "Bearer " + token.trim());
        }

        return builder;
    }

    private void handleResponseErrors(HttpResponse<String> response) {
        int code = response.statusCode();
        if (code == 404) {
            throw new GitHubException("Repository not found or private.", 404);
        } else if (code == 401) {
            throw new GitHubException("GitHub token invalid.", 401);
        } else if (code == 403 || code == 429) {
            String remaining = response.headers().firstValue("X-RateLimit-Remaining").orElse("1");
            if ("0".equals(remaining)) {
                String resetEpoch = response.headers().firstValue("X-RateLimit-Reset").orElse(null);
                String resetTimeStr = "shortly";
                if (resetEpoch != null) {
                    try {
                        long epoch = Long.parseLong(resetEpoch);
                        LocalDateTime resetTime = LocalDateTime.ofInstant(Instant.ofEpochSecond(epoch), ZoneId.systemDefault());
                        resetTimeStr = resetTime.format(DateTimeFormatter.ofPattern("HH:mm"));
                    } catch (Exception ignored) {
                    }
                }
                throw new GitHubException("GitHub rate limit reached, resets at " + resetTimeStr + ".", code);
            }
            throw new GitHubException("Access forbidden by GitHub: " + code, code);
        } else if (code >= 400) {
            throw new GitHubException("GitHub returned error status: " + code, code);
        }
    }

    private GitHubCommit parseCommitObject(int projectId, JsonObject obj) {
        try {
            String sha = obj.get("sha").getAsString();
            String authorLogin = null;
            if (obj.has("author") && !obj.get("author").isJsonNull()) {
                JsonObject authorObj = obj.getAsJsonObject("author");
                if (authorObj.has("login")) {
                    authorLogin = authorObj.get("login").getAsString();
                }
            }

            JsonObject commitObj = obj.getAsJsonObject("commit");
            JsonObject authorData = commitObj.getAsJsonObject("author");
            String authorName = authorData.get("name").getAsString();
            String message = commitObj.get("message").getAsString();
            String dateStr = authorData.get("date").getAsString();
            LocalDateTime committedAt = LocalDateTime.ofInstant(Instant.parse(dateStr), ZoneId.systemDefault());
            String htmlUrl = obj.get("html_url").getAsString();

            return new GitHubCommit(0, projectId, sha, authorLogin, authorName, message, committedAt, htmlUrl);
        } catch (Exception e) {
            LOGGER.log(Level.WARNING, "Failed to parse individual commit JSON", e);
            return null;
        }
    }

    private String extractNextPageUrl(String linkHeader) {
        if (linkHeader == null || linkHeader.isBlank()) {
            return null;
        }
        Matcher matcher = NEXT_LINK_PATTERN.matcher(linkHeader);
        if (matcher.find()) {
            return matcher.group(1);
        }
        return null;
    }
}
