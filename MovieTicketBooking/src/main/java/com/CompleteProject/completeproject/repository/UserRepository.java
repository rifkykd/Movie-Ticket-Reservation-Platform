package com.CompleteProject.completeproject.repository;

import com.CompleteProject.completeproject.bean.Admin;
import com.CompleteProject.completeproject.bean.Customer;
import com.CompleteProject.completeproject.bean.User;
import com.CompleteProject.completeproject.util.FilePathConstants;
import org.springframework.stereotype.Repository;

import java.io.*;
import java.util.ArrayList;
import java.util.List;


@Repository
public class UserRepository {

    private static final String USERS_FILE = FilePathConstants.USERS_FILE;


    //                      READ OPERATIONS

    public List<User> readAll() {
        List<User> users = new ArrayList<>();
        File file = new File(USERS_FILE);

        if (!file.exists()) {
            seedDefaultAdmin(); // Create a default admin on first run
            return readAll();
        }

        try (BufferedReader reader = new BufferedReader(new FileReader(file))) {
            String line;
            while ((line = reader.readLine()) != null) {
                line = line.trim();
                if (line.isEmpty()) continue;

                String[] parts = line.split("\\|");
                if (parts.length < 10) continue; // skip malformed lines

                // Check role field (index 6) to decide which class to use
                String role = parts[6];
                if ("ADMIN".equalsIgnoreCase(role)) {
                    users.add(Admin.fromFileString(line));
                } else {
                    users.add(Customer.fromFileString(line));
                }
            }
        } catch (IOException e) {
            System.err.println("Error reading users.txt: " + e.getMessage());
        }
        return users;
    }


    public void writeAll(List<User> users) {
        new File("data").mkdirs();
        try (BufferedWriter writer = new BufferedWriter(new FileWriter(USERS_FILE, false))) {
            for (User u : users) {
                // Determines Customer or Admin at runtime and calls correct method
                if (u instanceof Customer) {
                    writer.write(((Customer) u).toFileString());
                } else if (u instanceof Admin) {
                    writer.write(((Admin) u).toFileString());
                }
                writer.newLine();
            }
        } catch (IOException e) {
            System.err.println("Error writing users.txt: " + e.getMessage());
        }
    }


    //  FIND OPERATIONS

    public User findById(String userId) {
        return readAll().stream()
                .filter(u -> u.getUserId().equals(userId))
                .findFirst().orElse(null);
    }

    public User findByUsername(String username) {
        return readAll().stream()
                .filter(u -> u.getUsername().equalsIgnoreCase(username))
                .findFirst().orElse(null);
    }

    public User findByEmail(String email) {
        return readAll().stream()
                .filter(u -> u.getEmail().equalsIgnoreCase(email))
                .findFirst().orElse(null);
    }


    //WRITE OPERATIONS

    //Appends a new user to users.txt
    public void save(User user) {
        List<User> all = readAll();
        all.add(user);
        writeAll(all);
    }

    public boolean update(User updated) {
        List<User> all = readAll();
        boolean found = false;
        for (int i = 0; i < all.size(); i++) {
            if (all.get(i).getUserId().equals(updated.getUserId())) {
                all.set(i, updated);
                found = true;
                break;
            }
        }
        if (found) writeAll(all);
        return found;
    }


    public boolean delete(String userId) {
        List<User> all = readAll();
        boolean removed = all.removeIf(u -> u.getUserId().equals(userId));
        if (removed) writeAll(all);
        return removed;
    }

    //ID GENERATOR

    public String generateNextId(String role) {
        String prefix = "ADMIN".equalsIgnoreCase(role) ? "A" : "U";
        List<User> all = readAll();
        int max = 0;
        for (User u : all) {
            if (u.getUserId().startsWith(prefix)) {
                try {
                    int num = Integer.parseInt(u.getUserId().substring(1));
                    if (num > max) max = num;
                } catch (NumberFormatException ignored) {}
            }
        }
        return String.format("%s%03d", prefix, max + 1);
    }

    //FIRST-RUN SEED

    private void seedDefaultAdmin() {
        new File("data").mkdirs();
        Admin defaultAdmin = new Admin(
                "A001", "admin", "admin@cinebook.com",
                "admin123", "System Admin", "0700000000",
                "What is the name of this system?", "cinebook",
                "ACTIVE", "Management"
        );
        List<User> list = new ArrayList<>();
        list.add(defaultAdmin);
        writeAll(list);
        System.out.println(">>> Default admin created. Username: admin | Password: admin123");
    }
}
