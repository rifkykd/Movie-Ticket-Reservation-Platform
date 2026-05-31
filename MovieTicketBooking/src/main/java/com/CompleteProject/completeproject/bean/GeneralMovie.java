package com.CompleteProject.completeproject.bean;

/*
 OOP Concepts
   - Inheritance   : extends Movie
   - Polymorphism  : @Override displayInfo() with genre-specific output
 */

// GeneralMovie – subclass of Movie for Drama, Thriller, Sci-Fi, etc
public class GeneralMovie extends Movie {

    public GeneralMovie(String id, String title, String genre, int duration,
                        String language, String rating, String status,
                        String imagePath) {
        super(id, title, genre, duration, language, rating, status, imagePath);
    }

    @Override
    public String displayInfo() {
        return "[" + getGenre().toUpperCase() + "] " + getTitle() +
               " | " + getDuration() + " min" +
               " | " + getLanguage() +
               " | Status: " + getStatus();
    }

    @Override public String getType()           { return "GENERAL"; }
    @Override public String getExtraAttribute() { return "N/A"; }
}
