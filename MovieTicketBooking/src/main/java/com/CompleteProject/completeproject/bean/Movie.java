package com.CompleteProject.completeproject.bean;

/*
  Abstract base class for all movie types.
  OOP Concepts
    - Encapsulation : all fields private, accessed via getters/setters
    - Polymorphism  : abstract displayInfo() overridden by each subclass
 */
public abstract class Movie {


    private String id;
    private String title;
    private String genre;
    private int    duration;   // minutes
    private String language;
    private String rating;     // G | PG | PG-13 | R
    private String status;     // Now Showing | Coming Soon | No Longer Showing
    private String imagePath;  // filename stored in ~/MovieCatalogData/images/

    // Constructor
    public Movie(String id, String title, String genre, int duration,
                 String language, String rating, String status, String imagePath) {
        this.id        = id;
        this.title     = title;
        this.genre     = genre;
        this.duration  = duration;
        this.language  = language;
        this.rating    = rating;
        this.status    = status;
        this.imagePath = imagePath == null ? "" : imagePath;
    }

    // Getters & Setters
    public String getId()                  { return id; }
    public void   setId(String id)         { this.id = id; }

    public String getTitle()               { return title; }
    public void   setTitle(String t)       { this.title = t; }

    public String getGenre()               { return genre; }
    public void   setGenre(String g)       { this.genre = g; }

    public int    getDuration()            { return duration; }
    public void   setDuration(int d)       { this.duration = d; }

    public String getLanguage()            { return language; }
    public void   setLanguage(String l)    { this.language = l; }

    public String getRating()              { return rating; }
    public void   setRating(String r)      { this.rating = r; }

    public String getStatus()              { return status; }
    public void   setStatus(String s)      { this.status = s; }

    public String getImagePath()           { return imagePath; }
    public void   setImagePath(String img) { this.imagePath = img == null ? "" : img; }

    // Abstract methods
    public abstract String displayInfo();
    public abstract String getType();
    public abstract String getExtraAttribute();

    // Serialize to pipe-delimited line for movies.txt
    // Format - TYPE|ID|TITLE|GENRE|DURATION|LANGUAGE|RATING|STATUS|EXTRA|IMAGE
    public String toFileString() {
        return getType()           + "|" +
               id                  + "|" +
               title               + "|" +
               genre               + "|" +
               duration            + "|" +
               language            + "|" +
               rating              + "|" +
               status              + "|" +
               getExtraAttribute() + "|" +
               imagePath;
    }

    @Override
    public String toString() { return displayInfo(); }
}
