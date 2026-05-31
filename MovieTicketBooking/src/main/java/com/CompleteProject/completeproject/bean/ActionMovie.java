package com.CompleteProject.completeproject.bean;

/*
  OOP Concepts
    - Inheritance   : extends Movie, reuses all base fields
    - Polymorphism  : @Override displayInfo() with action-specific output

 */
// ActionMovie – subclass of Movie
public class ActionMovie extends Movie {

    // Extra attribute
    private String actionIntensity;

    public ActionMovie(String id, String title, String genre, int duration,
                       String language, String rating, String status,
                       String actionIntensity, String imagePath) {
        super(id, title, genre, duration, language, rating, status, imagePath);
        this.actionIntensity = actionIntensity;
    }

    public String getActionIntensity()              { return actionIntensity; }
    public void   setActionIntensity(String val)    { this.actionIntensity = val; }

    @Override
    public String displayInfo() {
        return "[ACTION] " + getTitle() +
               " | " + getDuration() + " min" +
               " | Intensity: " + actionIntensity +
               " | " + getLanguage() +
               " | Status: " + getStatus();
    }

    @Override public String getType()           { return "ACTION"; }
    @Override public String getExtraAttribute() { return actionIntensity; }
}
