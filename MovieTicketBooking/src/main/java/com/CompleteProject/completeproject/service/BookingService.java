package com.CompleteProject.completeproject.service;

import com.CompleteProject.completeproject.bean.Booking;

import java.util.List;

public interface BookingService {


     // CREATE – confirms a new booking, saves to bookings.txt,
     // and increments bookedSeats on the showtime.
     // Returns null if seats are no longer available.

    Booking createBooking(String userId, String username,
                          String showtimeId, String seats);

    //READ – all bookings for a customer (My Tickets page).
    List<Booking> getBookingsByUser(String userId);

    //READ – single booking by ID (ticket detail view).
    Booking getBookingById(String bookingId);


     // READ – all CONFIRMED bookings for a specific showtime.
     // Used by ShowTimeController to determine which seat labels
     // are already taken so the hall grid shows the right seats as booked.

    List<Booking> getBookingsByShowtime(String showtimeId);

    //READ (admin) – every booking in the system.
    List<Booking> getAllBookings();


     // DELETE (soft) – cancels a booking, marks it CANCELLED,
     // and decrements bookedSeats on the showtime.

    boolean cancelBooking(String bookingId, String requestingUserId);
}