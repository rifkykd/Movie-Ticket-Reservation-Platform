package com.CompleteProject.completeproject.controller;

import com.CompleteProject.completeproject.bean.Booking;
import com.CompleteProject.completeproject.bean.SeatType;
import com.CompleteProject.completeproject.bean.ShowTime;
import com.CompleteProject.completeproject.bean.User;
import com.CompleteProject.completeproject.service.BookingService;
import com.CompleteProject.completeproject.service.BookingServiceImpl;
import com.CompleteProject.completeproject.service.ShowTimeService;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;


@Controller
@RequestMapping("/booking")
public class BookingController {

    @Autowired
    private BookingService bookingService;

    @Autowired
    private BookingServiceImpl bookingServiceImpl;   // for buildPriceBreakdown

    @Autowired
    private ShowTimeService showTimeService;


    //  STEP 1 – Show confirmation page (entry point from hall-layout.jsp)


    @GetMapping("/new")
    public String showConfirmPage(@RequestParam String showtimeId,
                                  @RequestParam String seats,
                                  @RequestParam int count,
                                  HttpSession session, Model model) {

        if (!isLoggedIn(session)) return "redirect:/user/login";

        ShowTime showtime = showTimeService.getShowTimeByID(showtimeId);
        if (showtime == null)
            return "redirect:/showtime/schedule";

        // Build seat-by-seat breakdown using SeatType polymorphism
        double showTypePrice = showtime.getFinalPrice();
        String[] seatArray   = seats.split(",");

        // Map: seatLabel → {type, price}
        List<Map<String, String>> seatDetails = new ArrayList<>();
        double totalPrice = 0.0;
        int    vipCount   = 0;
        int    stdCount   = 0;

        for (String seat : seatArray) {
            seat = seat.trim();
            SeatType seatType = SeatType.fromSeatLabel(seat);
            double   price    = seatType.calculatePrice(showTypePrice);
            totalPrice       += price;

            Map<String, String> detail = new LinkedHashMap<>();
            detail.put("seat",      seat);
            detail.put("type",      seatType.getLabel());
            detail.put("price",     String.format("%.2f", price));
            detail.put("badgeColor", seatType.getBadgeColor());
            seatDetails.add(detail);

            if (seatType == SeatType.VIP) vipCount++;
            else                          stdCount++;
        }

        model.addAttribute("showtime",     showtime);
        model.addAttribute("seats",        seats);
        model.addAttribute("count",        count);
        model.addAttribute("seatDetails",  seatDetails);
        model.addAttribute("totalPrice",   String.format("%.2f", totalPrice));
        model.addAttribute("showTypePrice",String.format("%.2f", showTypePrice));
        model.addAttribute("vipCount",     vipCount);
        model.addAttribute("stdCount",     stdCount);
        model.addAttribute("pageTitle",    "Confirm Booking");
        return "booking/booking-confirm";
    }


    //  STEP 2 – Process booking (form POST from confirm page)


    @PostMapping("/confirm")
    public String processBooking(@RequestParam String showtimeId,
                                 @RequestParam String seats,
                                 HttpSession session,
                                 RedirectAttributes redirectAttrs) {

        if (!isLoggedIn(session)) return "redirect:/user/login";

        User user = (User) session.getAttribute("loggedInUser");

        Booking booking = bookingService.createBooking(
                user.getUserId(), user.getUsername(), showtimeId, seats);

        if (booking == null) {
            redirectAttrs.addFlashAttribute("errorMsg",
                    "Booking failed – selected seats are no longer available. Please try again.");
            return "redirect:/showtime/hall-layout/" + showtimeId;
        }

        // Hand off to Component 05 (Payment & Billing) for checkout
        return "redirect:/payment/checkout?bookingId=" + booking.getBookingId();
    }


    //  MY BOOKINGS (customer's ticket list)


    @GetMapping("/my-bookings")
    public String myBookings(HttpSession session, Model model) {

        if (!isLoggedIn(session)) return "redirect:/user/login";

        User user = (User) session.getAttribute("loggedInUser");
        List<Booking> bookings = bookingService.getBookingsByUser(user.getUserId());

        model.addAttribute("bookings",   bookings);
        model.addAttribute("pageTitle",  "My Tickets");
        return "booking/my-bookings";
    }


    //  BOOKING DETAIL / TICKET VIEW


    @GetMapping("/detail/{id}")
    public String bookingDetail(@PathVariable String id,
                                HttpSession session, Model model) {

        if (!isLoggedIn(session)) return "redirect:/user/login";

        User    user    = (User) session.getAttribute("loggedInUser");
        Booking booking = bookingService.getBookingById(id);

        if (booking == null)
            return "redirect:/booking/my-bookings";

        // Security: only owner or admin can view a booking
        if (!booking.getUserId().equals(user.getUserId()) && !isAdmin(session))
            return "redirect:/booking/my-bookings";

        // Build seat details for the ticket view
        ShowTime showtime = showTimeService.getShowTimeByID(booking.getShowtimeId());
        double showTypePrice = (showtime != null) ? showtime.getFinalPrice() : 0.0;

        List<Map<String, String>> seatDetails = new ArrayList<>();
        for (String seat : booking.getSeats().split(",")) {
            seat = seat.trim();
            SeatType seatType = SeatType.fromSeatLabel(seat);
            double   price    = seatType.calculatePrice(showTypePrice);

            Map<String, String> detail = new LinkedHashMap<>();
            detail.put("seat",       seat);
            detail.put("type",       seatType.getLabel());
            detail.put("price",      String.format("%.2f", price));
            detail.put("badgeColor", seatType.getBadgeColor());
            seatDetails.add(detail);
        }

        model.addAttribute("booking",     booking);
        model.addAttribute("seatDetails", seatDetails);
        model.addAttribute("pageTitle",   "Ticket – " + booking.getBookingId());
        return "booking/booking-detail";
    }


    //  CANCEL BOOKING


    @GetMapping("/cancel/{id}")
    public String cancelBooking(@PathVariable String id,
                                HttpSession session,
                                RedirectAttributes redirectAttrs) {

        if (!isLoggedIn(session)) return "redirect:/user/login";

        User user = (User) session.getAttribute("loggedInUser");

        boolean cancelled = bookingService.cancelBooking(id, user.getUserId());

        if (cancelled) {
            redirectAttrs.addFlashAttribute("successMsg",
                    "Booking " + id + " has been cancelled. Seats have been released.");
        } else {
            redirectAttrs.addFlashAttribute("errorMsg",
                    "Could not cancel booking " + id + ". It may already be cancelled.");
        }
        return "redirect:/booking/my-bookings";
    }


    //  ADMIN – all bookings


    @GetMapping("/all")
    public String allBookings(HttpSession session, Model model) {
        if (!isAdmin(session)) return isLoggedIn(session)
                ? "redirect:/movie?action=list" : "redirect:/user/login";

        model.addAttribute("bookings",  bookingService.getAllBookings());
        model.addAttribute("pageTitle", "All Bookings");
        return "booking/all-bookings";
    }


    //  SECURITY HELPERS


    private boolean isLoggedIn(HttpSession session) {
        return session != null && session.getAttribute("loggedInUser") != null;
    }

    private boolean isAdmin(HttpSession session) {
        if (session == null) return false;
        return "ADMIN".equalsIgnoreCase((String) session.getAttribute("role"));
    }
}
