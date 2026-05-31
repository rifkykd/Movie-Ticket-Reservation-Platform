package com.CompleteProject.completeproject.bean;

/*
  OOP Concepts:
    - Inheritance   : extends Movie, reuses all base fields
    - Polymorphism  : @Override displayInfo() with comedy-specific output
 */

// ComedyMovie – subclass of Movie
public class ComedyMovie extends Movie {

    // Extra attribute
    private String humorStyle;

    public ComedyMovie(String id, String title, String genre, int duration,
                       String language, String rating, String status,
                       String humorStyle, String imagePath) {
        super(id, title, genre, duration, language, rating, status, imagePath);
        this.humorStyle = humorStyle;
    }

    public String getHumorStyle()            { return humorStyle; }
    public void   setHumorStyle(String val)  { this.humorStyle = val; }

    @Override
    public String displayInfo() {
        return "[COMEDY] " + getTitle() +
               " | " + getDuration() + " min" +
               " | Humor Style: " + humorStyle +
               " | " + getLanguage() +
               " | Status: " + getStatus();
    }

    @Override public String getType()           { return "COMEDY"; }
    @Override public String getExtraAttribute() { return humorStyle; }
}
