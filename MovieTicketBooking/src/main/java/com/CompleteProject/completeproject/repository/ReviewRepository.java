package com.CompleteProject.completeproject.repository;

import com.CompleteProject.completeproject.bean.Review;
import com.CompleteProject.completeproject.util.FilePathConstants;
import org.springframework.stereotype.Repository;

import java.io.*;
import java.util.ArrayList;
import java.util.List;

@Repository
public class ReviewRepository {

    private static final String FILE_PATH = FilePathConstants.REVIEWS_FILE;

    // READ

    public List<Review> readAll() {
        List<Review> list = new ArrayList<>();
        File file = new File(FILE_PATH);
        if (!file.exists()) return list;

        try (BufferedReader reader = new BufferedReader(new FileReader(file))) {
            String line;
            while ((line = reader.readLine()) != null) {
                line = line.trim();
                if (!line.isEmpty()) {
                    Review r = Review.fromFileString(line);
                    if (r != null) list.add(r);
                }
            }
        } catch (IOException e) {
            System.err.println("Error reading reviews.txt: " + e.getMessage());
        }
        return list;
    }

    private void writeAll(List<Review> reviews) {
        new File("data").mkdirs();
        try (BufferedWriter writer = new BufferedWriter(new FileWriter(FILE_PATH, false))) {
            for (Review r : reviews) {
                writer.write(r.toFileString());
                writer.newLine();
            }
        } catch (IOException e) {
            System.err.println("Error writing reviews.txt: " + e.getMessage());
        }
    }

    // FIND

    public Review findById(String reviewId) {
        return readAll().stream()
                .filter(r -> r.getReviewId().equals(reviewId))
                .findFirst().orElse(null);
    }

    public List<Review> findByMovieTitle(String movieTitle) {
        List<Review> result = new ArrayList<>();
        for (Review r : readAll())
            if (r.getMovieTitle().equalsIgnoreCase(movieTitle)) result.add(r);
        return result;
    }

    public List<Review> findByUserId(String userId) {
        List<Review> result = new ArrayList<>();
        for (Review r : readAll())
            if (r.getUserId().equals(userId)) result.add(r);
        return result;
    }

    // Find an existing review by a specific user for a specific movie
    public Review findByUserAndMovie(String userId, String movieTitle) {
        return readAll().stream()
                .filter(r -> r.getUserId().equals(userId)
                          && r.getMovieTitle().equalsIgnoreCase(movieTitle))
                .findFirst().orElse(null);
    }

    // WRITE

    public void save(Review review) {
        List<Review> all = readAll();
        all.add(review);
        writeAll(all);
    }

    public boolean update(Review updated) {
        List<Review> all = readAll();
        boolean found = false;
        for (int i = 0; i < all.size(); i++) {
            if (all.get(i).getReviewId().equals(updated.getReviewId())) {
                all.set(i, updated);
                found = true;
                break;
            }
        }
        if (found) writeAll(all);
        return found;
    }

    public boolean delete(String reviewId) {
        List<Review> all = readAll();
        boolean removed = all.removeIf(r -> r.getReviewId().equals(reviewId));
        if (removed) writeAll(all);
        return removed;
    }

    // ID GENERATOR

    public String generateNextId() {
        List<Review> all = readAll();
        int max = 0;
        for (Review r : all) {
            try {
                int num = Integer.parseInt(r.getReviewId().replace("RV", ""));
                if (num > max) max = num;
            } catch (NumberFormatException ignored) {}
        }
        return String.format("RV%03d", max + 1);
    }
}
