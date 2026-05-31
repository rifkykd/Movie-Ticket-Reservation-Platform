package com.CompleteProject.completeproject.service;

import com.CompleteProject.completeproject.bean.Review;

import java.util.List;

//OOP concept - abstraction
public interface ReviewService {

    /*
      CREATE – submit a new review.
      One review per user per movie — if one already exists, it is updated.
     */
    Review submitReview(String userId, String username,
                        String movieTitle, int rating, String comment);

    /*
      READ – get reviews for display, filtered by role.

     OOP: Polymorphism — same method, different behaviour based on role:
        Admin   → returns ALL reviews (including REMOVED), for moderation.
       Customer→ returns only APPROVED reviews, for public reading.

     This mirrors the "Different display views for Public vs Admin users

     */
    List<Review> getReviewsForDisplay(String movieTitle, boolean isAdmin);

    // READ – all reviews for a movie (admin unfiltered view)
    List<Review> getAllReviewsForMovie(String movieTitle);

    // READ – a single review by ID
    Review getReviewById(String reviewId);

    // READ – existing review by user for a specific movie (for edit pre-fill)
    Review getUserReviewForMovie(String userId, String movieTitle);

    // READ (admin) – every review in the system
    List<Review> getAllReviews();

    // UPDATE – edit a review's rating and/or comment
    boolean updateReview(String reviewId, String userId,
                         int newRating, String newComment);

    /*
      DELETE (soft) – marks a review as REMOVED.
      Only the review owner or an admin can remove a review.
     */
    boolean removeReview(String reviewId, String requestingUserId, boolean isAdmin);

    /*
     DELETE (hard) – permanently deletes a review record.
     Admin-only operation.
     */
    boolean deleteReview(String reviewId);

    /*
     READ – computes the average rating for a movie across all APPROVED reviews.
      Returns 0.0 if no reviews exist.
     */
    double getAverageRating(String movieTitle);

    // READ – total count of APPROVED reviews for a movie.
    int getReviewCount(String movieTitle);
}
