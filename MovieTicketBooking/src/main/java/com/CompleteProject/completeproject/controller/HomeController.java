package com.CompleteProject.completeproject.controller;

import com.CompleteProject.completeproject.bean.Movie;
import com.CompleteProject.completeproject.repository.FileHandler;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import java.util.ArrayList;
import java.util.List;

/*
 HomeController – serves the public landing page.
  "/" is now the movie gallery, visible to anyone (logged in or not).
  Login is only required when the user tries to book (hall-layout).
 */
@Controller
public class HomeController {

    @GetMapping("/")
    public String home(Model model) {
        try {
            List<Movie> allMovies  = FileHandler.getAllMovies();
            List<Movie> nowShowing = new ArrayList<>();
            for (Movie m : allMovies)
                if ("Now Showing".equals(m.getStatus())) nowShowing.add(m);

            model.addAttribute("movies", allMovies);
            model.addAttribute("nowShowing", nowShowing);
        } catch (Exception e) {
            model.addAttribute("movies", new ArrayList<>());
            model.addAttribute("nowShowing", new ArrayList<>());
        }
        return "movie/gallery";   // renders gallery.jsp — no session required
    }
}