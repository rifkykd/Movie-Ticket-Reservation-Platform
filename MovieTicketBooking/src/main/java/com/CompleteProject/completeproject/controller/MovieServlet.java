package com.CompleteProject.completeproject.controller;

import com.CompleteProject.completeproject.bean.*;
import com.CompleteProject.completeproject.repository.FileHandler;

import jakarta.servlet.*;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.*;
import java.util.List;
import java.util.UUID;

/*
  MovieServlet – CRUD for movies.

  PUBLIC  (no login needed): list, search, details
  PRIVATE (login needed)   : edit, delete, adminForm, add, update  — ADMIN only

  This matches real movie-booking apps: browsing is always open,
  management is resticted
 */
@WebServlet("/movie")
@MultipartConfig(maxFileSize = 5 * 1024 * 1024)
public class MovieServlet extends HttpServlet {

    // GET
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        if (action == null) action = "list";

        switch (action) {
            // Public actions (no session required)
            case "list":
                listMovies(request, response);
                break;
            case "search":
                searchMovies(request, response);
                break;
            case "details":
                showDetails(request, response);
                break;

            // ADMIN only
            case "edit":
                if (!isAdmin(request)) { sendForbidden(request, response); return; }
                showEditForm(request, response);
                break;
            case "delete":
                if (!isAdmin(request)) { sendForbidden(request, response); return; }
                deleteMovie(request, response);
                break;
            case "adminForm":
                if (!isAdmin(request)) { sendForbidden(request, response); return; }
                request.getRequestDispatcher("/WEB-INF/views/movie/admin-form.jsp")
                       .forward(request, response);
                break;

            default:
                listMovies(request, response);
        }
    }

    // post
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        if (!isAdmin(request)) { sendForbidden(request, response); return; }

        String action = request.getParameter("action");
        if (action == null) action = "";

        switch (action) {
            case "add":    addMovie(request, response);    break;
            case "update": updateMovie(request, response); break;
            default:
                response.sendRedirect(request.getContextPath() + "/movie?action=list");
        }
    }

    // Handlers

    private void listMovies(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        try {
            req.setAttribute("movies", FileHandler.getAllMovies());
        } catch (IOException e) {
            req.setAttribute("error", "Could not load movies: " + e.getMessage());
        }
        req.getRequestDispatcher("/WEB-INF/views/movie/gallery.jsp").forward(req, res);
    }

    private void searchMovies(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        String genre    = req.getParameter("genre");
        String language = req.getParameter("language");
        String title    = req.getParameter("title");
        List<Movie> movies;

        try {
            if (genre != null && !genre.isEmpty()) {
                movies = FileHandler.searchByGenre(genre);
                req.setAttribute("searchLabel", "Genre: " + genre);
            } else if (language != null && !language.isEmpty()) {
                movies = FileHandler.searchByLanguage(language);
                req.setAttribute("searchLabel", "Language: " + language);
            } else if (title != null && !title.isEmpty()) {
                movies = FileHandler.searchByTitle(title);
                req.setAttribute("searchLabel", "Title: " + title);
            } else {
                movies = FileHandler.getAllMovies();
            }
            req.setAttribute("movies", movies);
        } catch (IOException e) {
            req.setAttribute("error", "Search failed: " + e.getMessage());
            req.setAttribute("movies", java.util.Collections.emptyList());
        }
        req.getRequestDispatcher("/WEB-INF/views/movie/gallery.jsp").forward(req, res);
    }

    private void showDetails(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        try {
            Movie movie = FileHandler.findById(req.getParameter("id"));
            if (movie == null) {
                res.sendRedirect(req.getContextPath() + "/movie?action=list");
                return;
            }
            req.setAttribute("movie", movie);
        } catch (IOException e) {
            req.setAttribute("error", e.getMessage());
        }
        req.getRequestDispatcher("/WEB-INF/views/movie/details.jsp").forward(req, res);
    }

    private void showEditForm(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        try {
            Movie movie = FileHandler.findById(req.getParameter("id"));
            if (movie == null) {
                res.sendRedirect(req.getContextPath() + "/movie?action=list");
                return;
            }
            req.setAttribute("movie", movie);
        } catch (IOException e) {
            req.setAttribute("error", e.getMessage());
        }
        req.getRequestDispatcher("/WEB-INF/views/movie/edit-form.jsp").forward(req, res);
    }

    private void addMovie(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        try {
            String id        = FileHandler.generateId();
            String imageName = handleImageUpload(req);
            Movie  movie     = buildMovieFromRequest(req, id, imageName);
            FileHandler.addMovie(movie);
            res.sendRedirect(req.getContextPath() + "/movie?action=list&msg=Movie+added+successfully");
        } catch (Exception e) {
            req.setAttribute("error", "Failed to add movie: " + e.getMessage());
            req.getRequestDispatcher("/WEB-INF/views/movie/admin-form.jsp").forward(req, res);
        }
    }

    private void updateMovie(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        String id = req.getParameter("id");
        try {
            Movie  existing  = FileHandler.findById(id);
            String oldImage  = (existing != null && existing.getImagePath() != null)
                               ? existing.getImagePath() : "";
            String newImage   = handleImageUpload(req);
            String finalImage = (!newImage.isEmpty()) ? newImage : oldImage;
            Movie  movie      = buildMovieFromRequest(req, id, finalImage);
            FileHandler.updateMovie(movie);
            res.sendRedirect(req.getContextPath() + "/movie?action=list&msg=Movie+updated+successfully");
        } catch (Exception e) {
            req.setAttribute("error", "Failed to update: " + e.getMessage());
            req.getRequestDispatcher("/WEB-INF/views/movie/edit-form.jsp").forward(req, res);
        }
    }

    private void deleteMovie(HttpServletRequest req, HttpServletResponse res)
            throws IOException {
        FileHandler.deleteMovie(req.getParameter("id"));
        res.sendRedirect(req.getContextPath() + "/movie?action=list&msg=Movie+deleted");
    }

    // security

    private boolean isLoggedIn(HttpServletRequest req) {
        HttpSession s = req.getSession(false);
        return s != null && s.getAttribute("loggedInUser") != null;
    }

    private boolean isAdmin(HttpServletRequest req) {
        HttpSession s = req.getSession(false);
        if (s == null) return false;
        return "ADMIN".equalsIgnoreCase((String) s.getAttribute("role"));
    }

    private void sendForbidden(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        // Not logged in → go to login; logged in but not admin → back to gallery
        if (!isLoggedIn(req)) {
            res.sendRedirect(req.getContextPath() + "/user/login");
        } else {
            res.sendRedirect(req.getContextPath() + "/movie?action=list");
        }
    }

    // helpers

    private String handleImageUpload(HttpServletRequest req) throws Exception {
        Part filePart = req.getPart("image");
        if (filePart == null || filePart.getSize() == 0) return "";
        String originalName = filePart.getSubmittedFileName();
        if (originalName == null || originalName.isEmpty()) return "";
        String ext      = originalName.substring(originalName.lastIndexOf('.'));
        String fileName = UUID.randomUUID().toString() + ext;
        String savePath = FileHandler.IMAGE_DIR + File.separator + fileName;
        try (InputStream in  = filePart.getInputStream();
             OutputStream out = new FileOutputStream(savePath)) {
            byte[] buf = new byte[4096]; int n;
            while ((n = in.read(buf)) != -1) out.write(buf, 0, n);
        }
        return fileName;
    }

    private Movie buildMovieFromRequest(HttpServletRequest req, String id, String imageName) {
        String title    = req.getParameter("title").trim();
        String genre    = req.getParameter("genre").trim();
        int    duration = Integer.parseInt(req.getParameter("duration").trim());
        String language = req.getParameter("language").trim();
        String rating   = req.getParameter("rating").trim();
        String status   = req.getParameter("status").trim();
        String type     = req.getParameter("type").trim();
        String extra    = req.getParameter("extra") != null
                          ? req.getParameter("extra").trim() : "N/A";
        switch (type) {
            case "ACTION": return new ActionMovie(id, title, genre, duration, language, rating, status, extra, imageName);
            case "COMEDY": return new ComedyMovie(id, title, genre, duration, language, rating, status, extra, imageName);
            default:       return new GeneralMovie(id, title, genre, duration, language, rating, status, imageName);
        }
    }
}
