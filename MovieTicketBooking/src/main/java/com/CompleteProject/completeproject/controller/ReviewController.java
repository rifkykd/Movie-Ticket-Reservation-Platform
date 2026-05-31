package com.CompleteProject.completeproject.controller;

import com.CompleteProject.completeproject.bean.Review;
import com.CompleteProject.completeproject.bean.User;
import com.CompleteProject.completeproject.service.ReviewService;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.List;

/*
  ReviewController – manages the review and feedback flow

  URL map
    GET  /review/movie?title=X          → movie-reviews.jsp  (public + form)
    POST /review/submit                  → submit/update review, redirect back
    POST /review/update                  → edit rating/comment, redirect back
    GET  /review/remove/{id}             → soft-remove (own or admin)
    GET  /review/delete/{id}  (admin)    → hard-delete
    GET  /review/admin         (admin)   → admin-reviews.jsp
 */
@Controller
@RequestMapping("/review")
public class ReviewController {

    @Autowired
    private ReviewService reviewService;

    //  MOVIE REVIEWS PAGE — entry point from details.jsp

    @GetMapping("/movie")
    public String movieReviews(@RequestParam String title,
                               HttpSession session, Model model) {

        if (!isLoggedIn(session)) return "redirect:/user/login";

        boolean isAdmin = isAdmin(session);

        // Polymorphic call — admin gets all reviews, customer gets approved only
        List<Review> reviews = reviewService.getReviewsForDisplay(title, isAdmin);

        double avgRating   = reviewService.getAverageRating(title);
        int    reviewCount = reviewService.getReviewCount(title);

        // Check if logged-in user already reviewed this movie
        User   user        = (User) session.getAttribute("loggedInUser");
        Review userReview  = reviewService.getUserReviewForMovie(user.getUserId(), title);

        // Pre-compute star string for average (e.g. 4 → "★★★★☆")
        String avgStars = buildStarString(avgRating);

        model.addAttribute("movieTitle",   title);
        model.addAttribute("reviews",      reviews);
        model.addAttribute("avgRating",    String.format("%.1f", avgRating));
        model.addAttribute("avgStars",     avgStars);
        model.addAttribute("reviewCount",  reviewCount);
        model.addAttribute("userReview",   userReview);   // null if not reviewed yet
        model.addAttribute("pageTitle",    "Reviews – " + title);
        return "review/movie-reviews";
    }

    //  SUBMIT NEW REVIEW

    @PostMapping("/submit")
    public String submitReview(@RequestParam String movieTitle,
                               @RequestParam int    rating,
                               @RequestParam String comment,
                               HttpSession session,
                               RedirectAttributes redirectAttrs) {

        if (!isLoggedIn(session)) return "redirect:/user/login";

        User user = (User) session.getAttribute("loggedInUser");
        reviewService.submitReview(user.getUserId(), user.getUsername(),
                                   movieTitle, rating, comment);

        redirectAttrs.addFlashAttribute("successMsg", "Your review has been submitted!");
        return "redirect:/review/movie?title=" + encode(movieTitle);
    }

    //  UPDATE EXISTING REVIEW

    @PostMapping("/update")
    public String updateReview(@RequestParam String reviewId,
                               @RequestParam String movieTitle,
                               @RequestParam int    rating,
                               @RequestParam String comment,
                               HttpSession session,
                               RedirectAttributes redirectAttrs) {

        if (!isLoggedIn(session)) return "redirect:/user/login";

        User user = (User) session.getAttribute("loggedInUser");
        boolean ok = reviewService.updateReview(reviewId, user.getUserId(), rating, comment);

        if (ok) redirectAttrs.addFlashAttribute("successMsg", "Review updated successfully!");
        else    redirectAttrs.addFlashAttribute("errorMsg",   "Could not update review.");
        return "redirect:/review/movie?title=" + encode(movieTitle);
    }

    //  REMOVE (soft delete — owner or admin)

    @GetMapping("/remove/{id}")
    public String removeReview(@PathVariable String id,
                               @RequestParam(required = false, defaultValue = "") String movieTitle,
                               HttpSession session,
                               RedirectAttributes redirectAttrs) {

        if (!isLoggedIn(session)) return "redirect:/user/login";

        User    user  = (User) session.getAttribute("loggedInUser");
        boolean admin = isAdmin(session);
        boolean ok    = reviewService.removeReview(id, user.getUserId(), admin);

        if (ok) redirectAttrs.addFlashAttribute("successMsg", "Review removed.");
        else    redirectAttrs.addFlashAttribute("errorMsg",   "Could not remove review.");

        // Redirect back to the movie reviews page if we know the movie
        if (!movieTitle.isEmpty())
            return "redirect:/review/movie?title=" + encode(movieTitle);
        return admin ? "redirect:/review/admin" : "redirect:/booking/my-bookings";
    }

    //  DELETE (hard delete — admin only)

    @GetMapping("/delete/{id}")
    public String deleteReview(@PathVariable String id,
                               HttpSession session,
                               RedirectAttributes redirectAttrs) {

        if (!isAdmin(session)) return isLoggedIn(session)
                ? "redirect:/movie?action=list" : "redirect:/user/login";

        reviewService.deleteReview(id);
        redirectAttrs.addFlashAttribute("successMsg", "Review permanently deleted.");
        return "redirect:/review/admin";
    }

    //  ADMIN MODERATION PANEL

    @GetMapping("/admin")
    public String adminPanel(HttpSession session, Model model) {
        if (!isAdmin(session)) return isLoggedIn(session)
                ? "redirect:/movie?action=list" : "redirect:/user/login";

        List<Review> allReviews = reviewService.getAllReviews();

        // Stats
        long approved = allReviews.stream().filter(Review::isApproved).count();
        long removed  = allReviews.stream().filter(Review::isRemoved).count();

        model.addAttribute("reviews",       allReviews);
        model.addAttribute("approvedCount", approved);
        model.addAttribute("removedCount",  removed);
        model.addAttribute("totalCount",    allReviews.size());
        model.addAttribute("pageTitle",     "Review Moderation");
        return "review/admin-reviews";
    }

    // HELPERS

    private boolean isLoggedIn(HttpSession session) {
        return session != null && session.getAttribute("loggedInUser") != null;
    }

    private boolean isAdmin(HttpSession session) {
        if (session == null) return false;
        return "ADMIN".equalsIgnoreCase((String) session.getAttribute("role"));
    }

    private String encode(String s) {
        try { return java.net.URLEncoder.encode(s, "UTF-8"); }
        catch (Exception e) { return s; }
    }

    /*
      Builds a 5-star string from a double average, e.g. 4 → "★★★★☆".
      Rounds to nearest whole star for the display string.
     */
    private String buildStarString(double avg) {
        int filled = (int) Math.round(avg);
        StringBuilder sb = new StringBuilder();
        for (int i = 1; i <= 5; i++) sb.append(i <= filled ? "★" : "☆");
        return sb.toString();
    }
}
