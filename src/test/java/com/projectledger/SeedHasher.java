package com.projectledger;

import org.mindrot.jbcrypt.BCrypt;

/**
 * Utility main class to generate verified BCrypt password hashes for database/seed.sql.
 */
public class SeedHasher {
    public static void main(String[] args) {
        String adminHash = BCrypt.hashpw("Admin@123", BCrypt.gensalt(12));
        String facultyHash = BCrypt.hashpw("Faculty@123", BCrypt.gensalt(12));
        String studentHash = BCrypt.hashpw("Student@123", BCrypt.gensalt(12));

        System.out.println("Admin@123: " + adminHash);
        System.out.println("Faculty@123: " + facultyHash);
        System.out.println("Student@123: " + studentHash);
    }
}
