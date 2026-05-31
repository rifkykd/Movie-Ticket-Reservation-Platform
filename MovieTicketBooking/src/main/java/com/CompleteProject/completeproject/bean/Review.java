package com.CompleteProject.completeproject.bean;

/*
  Review – represents a customer's movie review and star rating

  OOP Concepts
    - Encapsulation : all fields private; accessed only via Lombok getters/setters.
                      Sensitive fields (userId) are hidden from public display

  status  : APPROVED / REMOVED
 */
public class Review {
    private String reviewId;
    private String movieTitle;
    private String userId;
    private String username;
    private int    rating;
    private String comment;
    private String reviewDate;
    private String status;

    public Review() {}

    public Review(String reviewId, String movieTitle, String userId, String username, 
                  int rating, String comment, String reviewDate, String status) {
        this.reviewId = reviewId;
        this.movieTitle = movieTitle;
        this.userId = userId;
        this.username = username;
        this.rating = rating;
        this.comment = comment;
        this.reviewDate = reviewDate;
        this.status = status;
    }

    public String getReviewId() { return reviewId; }
    public void setReviewId(String reviewId) { this.reviewId = reviewId; }
    public String getMovieTitle() { return movieTitle; }
    public void setMovieTitle(String movieTitle) { this.movieTitle = movieTitle; }
    public String getUserId() { return userId; }
    public void setUserId(String userId) { this.userId = userId; }
    public String getUsername() { return username; }
    public void setUsername(String username) { this.username = username; }
    public int getRating() { return rating; }
    public void setRating(int rating) { this.rating = rating; }
    public String getComment() { return comment; }
    public void setComment(String comment) { this.comment = comment; }
    public String getReviewDate() { return reviewDate; }
    public void setReviewDate(String reviewDate) { this.reviewDate = reviewDate; }
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    // Derived helpers

    public boolean isApproved() { return "APPROVED".equalsIgnoreCase(status); }
    public boolean isRemoved()  { return "REMOVED".equalsIgnoreCase(status); }


    public String getStarDisplay() {
        StringBuilder sb = new StringBuilder();
        for (int i = 1; i <= 5; i++)
            sb.append(i <= rating ? "★" : "☆");
        return sb.toString();
    }

    // Serialisation

    public String toFileString() {
        return String.join("|",
                reviewId,
                movieTitle,
                userId,
                username,
                String.valueOf(rating),
                comment.replace("|", "｜"),
                reviewDate,
                status);
    }

    public static Review fromFileString(String line) {
        String[] p = line.split("\\|", 8);
        if (p.length < 8) return null;

        Review r = new Review();
        r.setReviewId(  p[0].trim());
        r.setMovieTitle(p[1].trim());
        r.setUserId(    p[2].trim());
        r.setUsername(  p[3].trim());
        try { r.setRating(Integer.parseInt(p[4].trim())); }
        catch (NumberFormatException e) { r.setRating(3); }
        r.setComment(   p[5].trim().replace("｜", "|"));
        r.setReviewDate(p[6].trim());
        r.setStatus(    p[7].trim());
        return r;
    }
}
