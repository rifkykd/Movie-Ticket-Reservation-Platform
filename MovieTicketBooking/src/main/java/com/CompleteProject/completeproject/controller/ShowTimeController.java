package com.CompleteProject.completeproject.controller;

import com.CompleteProject.completeproject.bean.Booking;
import com.CompleteProject.completeproject.bean.Movie;
import com.CompleteProject.completeproject.bean.ShowTime;
import com.CompleteProject.completeproject.bean.ShowType;
import com.CompleteProject.completeproject.bean.TheaterHall;
import com.CompleteProject.completeproject.repository.FileHandler;
import com.CompleteProject.completeproject.service.BookingService;
import com.CompleteProject.completeproject.service.ShowTimeService;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.time.LocalDate;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

@Controller
@RequestMapping("/showtime")
public class ShowTimeController {

    @Autowired
    private ShowTimeService showTimeService;

    @Autowired
    private BookingService bookingService;

    // ADMIN ONLY

    @GetMapping("/scheduler")
    public String showScheduler(HttpSession session, Model model) {
        if (!isAdmin(session)) return adminGuard(session);
        model.addAttribute("showtimes", showTimeService.getAllShowTimes());
        model.addAttribute("pageTitle", "Showtime Scheduler");
        return "showtime/scheduler";
    }

    @GetMapping("/add")
    public String showAddForm(HttpSession session, Model model) {
        if (!isAdmin(session)) return adminGuard(session);
        model.addAttribute("showtime",  new ShowTime());
        model.addAttribute("halls",     showTimeService.getAllHalls());
        model.addAttribute("showTypes", ShowType.values());
        model.addAttribute("movies",    safeGetAllMovies());
        model.addAttribute("pageTitle", "Add New Showtime");
        return "showtime/add-form";
    }

    @PostMapping("/add")
    public String addShowtime(@ModelAttribute ShowTime showtime,
                              @RequestParam String hallId,
                              HttpSession session,
                              RedirectAttributes ra) {
        if (!isAdmin(session)) return adminGuard(session);

        // Block scheduling for ended movies
        String movieStatus = getMovieStatus(showtime.getMovieTitle());
        if ("No Longer Showing".equals(movieStatus)) {
            ra.addFlashAttribute("errorMsg",
                    "Cannot add a showtime — \"" + showtime.getMovieTitle()
                            + "\" is no longer showing. Update the movie status first.");
            return "redirect:/showtime/add";
        }

        TheaterHall hall = showTimeService.getHallById(hallId);
        if (hall != null) {
            showtime.setHallId(hall.getHallId());
            showtime.setHallName(hall.getHallName());
            showtime.setTotalSeats(hall.getTotalSeats());
        }
        boolean ok = showTimeService.addShowTime(showtime);
        if (ok) ra.addFlashAttribute("successMsg", "Showtime added successfully!");
        else    ra.addFlashAttribute("errorMsg",   "That hall is already booked at that date/time.");
        return "redirect:/showtime/scheduler";
    }

    @GetMapping("/edit/{id}")
    public String showEditForm(@PathVariable String id, HttpSession session, Model model) {
        if (!isAdmin(session)) return adminGuard(session);
        ShowTime st = showTimeService.getShowTimeByID(id);
        if (st == null) return "redirect:/showtime/scheduler";
        model.addAttribute("showtime",  st);
        model.addAttribute("halls",     showTimeService.getAllHalls());
        model.addAttribute("showTypes", ShowType.values());
        model.addAttribute("movies",    safeGetAllMovies());
        model.addAttribute("pageTitle", "Edit Showtime");
        return "showtime/edit-form";
    }

    @PostMapping("/edit")
    public String editShowtime(@ModelAttribute ShowTime showtime,
                               @RequestParam String hallId,
                               HttpSession session, RedirectAttributes ra) {
        if (!isAdmin(session)) return adminGuard(session);

        // Block re-assigning a showtime to an ended movie
        String movieStatus = getMovieStatus(showtime.getMovieTitle());
        if ("No Longer Showing".equals(movieStatus)) {
            ra.addFlashAttribute("errorMsg",
                    "Cannot save — \"" + showtime.getMovieTitle()
                            + "\" is no longer showing. Update the movie status first.");
            return "redirect:/showtime/edit/" + showtime.getShowtimeId();
        }

        TheaterHall hall = showTimeService.getHallById(hallId);
        if (hall != null) {
            showtime.setHallId(hall.getHallId());
            showtime.setHallName(hall.getHallName());
            showtime.setTotalSeats(hall.getTotalSeats());
        }
        boolean ok = showTimeService.updateShowTime(showtime);
        if (ok) ra.addFlashAttribute("successMsg", "Showtime updated successfully!");
        else    ra.addFlashAttribute("errorMsg",   "That hall is already booked at that date/time.");
        return "redirect:/showtime/scheduler";
    }

    @GetMapping("/delete/{id}")
    public String deleteShowtime(@PathVariable String id, HttpSession session, RedirectAttributes ra) {
        if (!isAdmin(session)) return adminGuard(session);
        boolean deleted = showTimeService.deleteShowTime(id);
        if (deleted) ra.addFlashAttribute("successMsg", "Showtime cancelled.");
        else         ra.addFlashAttribute("errorMsg",   "Showtime not found.");
        return "redirect:/showtime/scheduler";
    }

    // PUBLIC — no login required

    /*
      Movie-specific showtime list.
      Reached from the gallery's "Showtimes" button — publicly visible.
      Login prompt only appears when user clicks "View Seats" (hall-layout).
     */
    @GetMapping("/byMovie")
    public String showsByMovie(@RequestParam String title, Model model) {
        List<ShowTime> showtimes = showTimeService.getShowTimesByMovieTitle(title);

        // Look up movie status so the JSP can warn/block for ended movies
        String movieStatus = "Unknown";
        try {
            List<Movie> allMovies = FileHandler.getAllMovies();
            for (Movie m : allMovies) {
                if (m.getTitle().equalsIgnoreCase(title)) {
                    movieStatus = m.getStatus();
                    break;
                }
            }
        } catch (Exception ignored) {}

        boolean movieEnded = "No Longer Showing".equals(movieStatus);

        model.addAttribute("showtimes",   showtimes);
        model.addAttribute("movieTitle",  title);
        model.addAttribute("movieStatus", movieStatus);
        model.addAttribute("movieEnded",  movieEnded);
        model.addAttribute("pageTitle",   "Showtimes for " + title);
        return "showtime/movie-showtimes";
    }

    // Daily schedule — publicly browsable.
    @GetMapping("/schedule")
    public String dailySchedule(@RequestParam(required = false) String date, Model model) {
        if (date == null || date.isEmpty()) date = LocalDate.now().toString();
        model.addAttribute("showtimes",  showTimeService.getAvailableShowtimes(date));
        model.addAttribute("searchDate", date);
        model.addAttribute("pageTitle",  "Movies on " + date);
        return "showtime/daily-schedule";
    }

    // LOGIN REQUIRED

    /*
      Hall seat layout — this is the booking entry point.
      If the user is not logged in, they are redirected to login
      and then returned here after authenticating.

      This matches real ticketing apps: you can browse freely,
      but must log in to select seats and book.
     */
    @GetMapping("/hall-layout/{showtimeId}")
    public String hallLayout(@PathVariable String showtimeId,
                             HttpSession session, Model model) {

        // Only this step requires login — the natural gate before booking
        if (!isLoggedIn(session)) {
            // Store where they were trying to go so we can redirect back after login
            if (session != null)
                session.setAttribute("redirectAfterLogin",
                        "/showtime/hall-layout/" + showtimeId);
            return "redirect:/user/login";
        }

        ShowTime showtime = showTimeService.getShowTimeByID(showtimeId);
        if (showtime == null) return "redirect:/showtime/schedule";

        // Block booking if the movie has ended
        try {
            List<Movie> allMovies = FileHandler.getAllMovies();
            for (Movie m : allMovies) {
                if (m.getTitle().equalsIgnoreCase(showtime.getMovieTitle())) {
                    if ("No Longer Showing".equals(m.getStatus())) {
                        // Redirect back to the showtime page with an error flag
                        return "redirect:/showtime/byMovie?title="
                                + java.net.URLEncoder.encode(showtime.getMovieTitle(), "UTF-8")
                                + "&err=ended";
                    }
                    break;
                }
            }
        } catch (Exception ignored) {}

        TheaterHall hall      = showTimeService.getHallById(showtime.getHallId());
        double      finalPrice = showtime.getFinalPrice();

        // Build exact set of booked seat labels from confirmed bookings
        Set<String> bookedSeatSet = new HashSet<>();
        for (Booking b : bookingService.getBookingsByShowtime(showtimeId))
            for (String seat : b.getSeats().split(","))
                bookedSeatSet.add(seat.trim().toUpperCase());

        int actualBooked    = bookedSeatSet.size();
        int actualAvailable = showtime.getTotalSeats() - actualBooked;

        model.addAttribute("showtime",       showtime);
        model.addAttribute("hall",           hall);
        model.addAttribute("pageTitle",      "Hall Layout – " + showtime.getMovieTitle());
        model.addAttribute("totalSeats",     showtime.getTotalSeats());
        model.addAttribute("bookedSeats",    actualBooked);
        model.addAttribute("availableSeats", actualAvailable);
        model.addAttribute("finalPriceStr",  String.format("%.2f", finalPrice));
        model.addAttribute("finalPrice",     finalPrice);
        model.addAttribute("bookedSeatsStr", String.join(",", bookedSeatSet));
        return "showtime/hall-layout";
    }

    // HELPERS

    private boolean isLoggedIn(HttpSession session) {
        return session != null && session.getAttribute("loggedInUser") != null;
    }

    private boolean isAdmin(HttpSession session) {
        if (session == null) return false;
        return "ADMIN".equalsIgnoreCase((String) session.getAttribute("role"));
    }

    private String adminGuard(HttpSession session) {
        if (!isLoggedIn(session)) return "redirect:/user/login";
        return "redirect:/movie?action=list";
    }

    /*
      Looks up a movie's status from movies.txt by title (case-insensitive).
      Returns the status string, or "Unknown" if the movie is not found.
     */
    private String getMovieStatus(String title) {
        try {
            for (Movie m : FileHandler.getAllMovies()) {
                if (m.getTitle().equalsIgnoreCase(title)) return m.getStatus();
            }
        } catch (Exception ignored) {}
        return "Unknown";
    }

    private List<Movie> safeGetAllMovies() {
        try { return FileHandler.getAllMovies(); }
        catch (Exception e) { return java.util.Collections.emptyList(); }
    }
}