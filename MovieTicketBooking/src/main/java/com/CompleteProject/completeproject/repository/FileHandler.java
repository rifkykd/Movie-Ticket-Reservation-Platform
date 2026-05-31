package com.CompleteProject.completeproject.repository;

import com.CompleteProject.completeproject.bean.*;
import com.CompleteProject.completeproject.util.FilePathConstants;

import java.io.*;
import java.util.*;

/*
  FileHandler – all file read/write operations on movies.txt

  File format :
    TYPE|ID|TITLE|GENRE|DURATION|LANGUAGE|RATING|STATUS|EXTRA|IMAGE

  Data is stored at: /MovieCatalogData/movies.txt
  Images stored at:  /MovieCatalogData/images/
 */
public class FileHandler {



    private static final String FILE_PATH;
    public  static final String IMAGE_DIR;

    static {
        FILE_PATH = FilePathConstants.MOVIES_FILE;   // → "data/movies.txt"
        IMAGE_DIR = "data/images";
        new File("data").mkdirs();
        new File(IMAGE_DIR).mkdirs();
    }


    // READ - Get all movies
    public static List<Movie> getAllMovies() throws IOException {
        List<Movie> movies = new ArrayList<>();
        File file = new File(FILE_PATH);
        if (!file.exists()) return movies;

        try (BufferedReader reader = new BufferedReader(new FileReader(file))) {
            String line;
            while ((line = reader.readLine()) != null) {
                line = line.trim();
                if (!line.isEmpty()) {
                    Movie m = parseLine(line);
                    if (m != null) movies.add(m);
                }
            }
        }
        return movies;
    }

    // READ - Find movie by ID
    public static Movie findById(String id) throws IOException {
        for (Movie m : getAllMovies())
            if (m.getId().equals(id)) return m;
        return null;
    }

    // READ - Search by genre
    public static List<Movie> searchByGenre(String genre) throws IOException {
        List<Movie> result = new ArrayList<>();
        for (Movie m : getAllMovies())
            if (m.getGenre().equalsIgnoreCase(genre)) result.add(m);
        return result;
    }

    // READ - Search by language
    public static List<Movie> searchByLanguage(String language) throws IOException {
        List<Movie> result = new ArrayList<>();
        for (Movie m : getAllMovies())
            if (m.getLanguage().equalsIgnoreCase(language)) result.add(m);
        return result;
    }

    // READ - Search by title
    public static List<Movie> searchByTitle(String keyword) throws IOException {
        List<Movie> result = new ArrayList<>();
        for (Movie m : getAllMovies())
            if (m.getTitle().toLowerCase().contains(keyword.toLowerCase()))
                result.add(m);
        return result;
    }

    // CREATE - Append new movie to file
    public static void addMovie(Movie movie) throws IOException {
        try (BufferedWriter writer = new BufferedWriter(new FileWriter(FILE_PATH, true))) {
            writer.write(movie.toFileString());
            writer.newLine();
        }
    }

    // UPDATE - Replace a movie line by ID
    public static boolean updateMovie(Movie updated) throws IOException {
        List<Movie> movies = getAllMovies();
        boolean found = false;
        for (int i = 0; i < movies.size(); i++) {
            if (movies.get(i).getId().equals(updated.getId())) {
                movies.set(i, updated);
                found = true;
                break;
            }
        }
        if (found) saveAllMovies(movies);
        return found;
    }

    // DELETE - Remove a movie by ID
    public static boolean deleteMovie(String id) throws IOException {
        List<Movie> movies = getAllMovies();
        boolean removed = movies.removeIf(m -> m.getId().equals(id));
        if (removed) saveAllMovies(movies);
        return removed;
    }

    // UTIL - Generate next available ID
    public static String generateId() throws IOException {
        List<Movie> movies = getAllMovies();
        int next = movies.size() + 1;
        while (idExists("MOV" + String.format("%03d", next), movies)) next++;
        return "MOV" + String.format("%03d", next);
    }

    // Private helpers
    private static boolean idExists(String id, List<Movie> movies) {
        for (Movie m : movies) if (m.getId().equals(id)) return true;
        return false;
    }

    private static void saveAllMovies(List<Movie> movies) throws IOException {
        try (BufferedWriter writer = new BufferedWriter(new FileWriter(FILE_PATH, false))) {
            for (Movie m : movies) {
                writer.write(m.toFileString());
                writer.newLine();
            }
        }
    }

    private static Movie parseLine(String line) {
        // -1 limit keeps trailing empty strings (for missing image column)
        String[] p = line.split("\\|", -1);
        if (p.length < 9) return null;

        String type     = p[0].trim();
        String id       = p[1].trim();
        String title    = p[2].trim();
        String genre    = p[3].trim();
        int    duration;
        try { duration  = Integer.parseInt(p[4].trim()); }
        catch (NumberFormatException e) { duration = 0; }
        String language = p[5].trim();
        String rating   = p[6].trim();
        String status   = p[7].trim();
        String extra    = p[8].trim();
        String image    = p.length > 9 ? p[9].trim() : "";

        switch (type) {
            case "ACTION":  return new ActionMovie(id, title, genre, duration, language, rating, status, extra, image);
            case "COMEDY":  return new ComedyMovie(id, title, genre, duration, language, rating, status, extra, image);
            default:        return new GeneralMovie(id, title, genre, duration, language, rating, status, image);
        }
    }
}
