package com.CompleteProject.completeproject.service;

import com.CompleteProject.completeproject.bean.Review;
import com.CompleteProject.completeproject.repository.ReviewRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.util.List;
import java.util.stream.Collectors;

/*
  ReviewServiceImpl – core review and feedback engine.

  OOP Concepts:

    Polymorphism
      getReviewsForDisplay(movieTitle, isAdmin) is the polymorphic method.
      When isAdmin=true  → behaves like an admin view (all reviews visible).
      When isAdmin=false → behaves like a public view (only APPROVED visible).
      Same method name, different runtime behaviour based on the boolean role.
      This mirrors "Polymorphism: Different display views for Public vs. Admin".

    Encapsulation
      All review mutations go through this service; the repository is never
      accessed directly from controllers, keeping data logic in one place.
 */
@Service
public class ReviewServiceImpl implements ReviewService {

    @Autowired
    private ReviewRepository reviewRepository;

    // CREATE / UPDATE

    @Override
    public Review submitReview(String userId, String username,
                               String movieTitle, int rating, String comment) {

        // Clamp rating to valid range
        rating = Math.max(1, Math.min(5, rating));

        // One review per user per movie — update if exists
        Review existing = reviewRepository.findByUserAndMovie(userId, movieTitle);

        if (existing != null) {
            existing.setRating(rating);
            existing.setComment(comment.trim());
            existing.setReviewDate(LocalDate.now().toString());
            existing.setStatus("APPROVED");
            reviewRepository.update(existing);
            return existing;
        }

        // New review
        Review review = new Review();
        review.setReviewId(  reviewRepository.generateNextId());
        review.setMovieTitle(movieTitle);
        review.setUserId(    userId);
        review.setUsername(  username);
        review.setRating(    rating);
        review.setComment(   comment.trim());
        review.setReviewDate(LocalDate.now().toString());
        review.setStatus(    "APPROVED");

        reviewRepository.save(review);
        return review;
    }

    // READ (Polymorphic display)

    /*
      Polymorphic display — the same method returns a different result set
      depending on whether the caller is an admin or a regular user.

      Admin  view : all reviews for the movie, including REMOVED ones
                   (so the admin can see what was moderated).
      Public view : only APPROVED reviews — removed reviews are hidden.
     */
    @Override
    public List<Review> getReviewsForDisplay(String movieTitle, boolean isAdmin) {
        List<Review> all = reviewRepository.findByMovieTitle(movieTitle);
        if (isAdmin) {
            // Admin sees everything — sort by date descending
            all.sort((a, b) -> b.getReviewDate().compareTo(a.getReviewDate()));
            return all;
        }
        // Public sees only approved reviews
        return all.stream()
                .filter(Review::isApproved)
                .sorted((a, b) -> b.getReviewDate().compareTo(a.getReviewDate()))
                .collect(Collectors.toList());
    }

    @Override
    public List<Review> getAllReviewsForMovie(String movieTitle) {
        return reviewRepository.findByMovieTitle(movieTitle);
    }

    @Override
    public Review getReviewById(String reviewId) {
        return reviewRepository.findById(reviewId);
    }

    @Override
    public Review getUserReviewForMovie(String userId, String movieTitle) {
        return reviewRepository.findByUserAndMovie(userId, movieTitle);
    }

    @Override
    public List<Review> getAllReviews() {
        List<Review> all = reviewRepository.readAll();
        all.sort((a, b) -> b.getReviewDate().compareTo(a.getReviewDate()));
        return all;
    }

    // UPDATE

    @Override
    public boolean updateReview(String reviewId, String userId,
                                int newRating, String newComment) {
        Review review = reviewRepository.findById(reviewId);
        if (review == null) return false;
        if (!review.getUserId().equals(userId)) return false;  // ownership check

        review.setRating(    Math.max(1, Math.min(5, newRating)));
        review.setComment(   newComment.trim());
        review.setReviewDate(LocalDate.now().toString());
        review.setStatus(    "APPROVED");
        return reviewRepository.update(review);
    }

    // DELETE

    /*
      Soft delete — marks the review as REMOVED so admin can still see it
      in the moderation panel, but it disappears from the public view.
      Only the review owner or an admin can remove it.
     */
    @Override
    public boolean removeReview(String reviewId, String requestingUserId,
                                boolean isAdmin) {
        Review review = reviewRepository.findById(reviewId);
        if (review == null) return false;
        if (!isAdmin && !review.getUserId().equals(requestingUserId)) return false;

        review.setStatus("REMOVED");
        return reviewRepository.update(review);
    }

    // Hard delete — admin only, permanently removes the record
    @Override
    public boolean deleteReview(String reviewId) {
        return reviewRepository.delete(reviewId);
    }

    // STATS

    @Override
    public double getAverageRating(String movieTitle) {
        List<Review> approved = reviewRepository.findByMovieTitle(movieTitle)
                .stream().filter(Review::isApproved).collect(Collectors.toList());
        if (approved.isEmpty()) return 0.0;
        double sum = approved.stream().mapToInt(Review::getRating).sum();
        return Math.round((sum / approved.size()) * 10.0) / 10.0;
    }

    @Override
    public int getReviewCount(String movieTitle) {
        return (int) reviewRepository.findByMovieTitle(movieTitle)
                .stream().filter(Review::isApproved).count();
    }
}
