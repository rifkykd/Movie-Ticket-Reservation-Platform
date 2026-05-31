package com.CompleteProject.completeproject.service;

import com.CompleteProject.completeproject.bean.Booking;
import com.CompleteProject.completeproject.bean.SeatType;
import com.CompleteProject.completeproject.bean.ShowTime;
import com.CompleteProject.completeproject.repository.BookingRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.util.List;
import java.util.stream.Collectors;

@Service
public class BookingServiceImpl implements BookingService {

    @Autowired
    private BookingRepository bookingRepository;

    @Autowired
    private ShowTimeService showTimeService;

    //  CREATE

    @Override
    public Booking createBooking(String userId, String username,
                                 String showtimeId, String seats) {

        ShowTime showtime = showTimeService.getShowTimeByID(showtimeId);
        if (showtime == null) return null;

        String[] seatArray = seats.split(",");
        int seatCount = seatArray.length;

        if (showtime.getAvailableSeats() < seatCount) return null;

        // Polymorphic price calculation using SeatType
        double showTypePrice = showtime.getFinalPrice();
        double totalPrice    = 0.0;
        for (String seat : seatArray) {
            SeatType type = SeatType.fromSeatLabel(seat.trim());
            totalPrice   += type.calculatePrice(showTypePrice);
        }

        Booking booking = new Booking();
        booking.setBookingId(bookingRepository.generateNextId());
        booking.setUserId(userId);
        booking.setUsername(username);
        booking.setShowtimeId(showtimeId);
        booking.setMovieTitle(showtime.getMovieTitle());
        booking.setHallName(showtime.getHallName());
        booking.setShowDate(showtime.getShowDate());
        booking.setShowTime(showtime.getShowTime());
        booking.setShowType(showtime.getShowType().name());
        booking.setSeats(seats.trim());
        booking.setSeatCount(seatCount);
        booking.setTotalPrice(Math.round(totalPrice * 100.0) / 100.0);
        booking.setStatus("CONFIRMED");
        booking.setBookingDate(LocalDate.now().toString());

        bookingRepository.save(booking);

        // Increment bookedSeats count on the showtime
        showtime.setBookedSeats(showtime.getBookedSeats() + seatCount);
        showTimeService.updateShowTime(showtime);

        return booking;
    }

    //  READ

    @Override
    public List<Booking> getBookingsByUser(String userId) {
        List<Booking> list = bookingRepository.findByUserId(userId);
        list.sort((a, b) -> b.getBookingDate().compareTo(a.getBookingDate()));
        return list;
    }

    @Override
    public Booking getBookingById(String bookingId) {
        return bookingRepository.findById(bookingId);
    }

    /*
      Returns only CONFIRMED bookings for a showtime.
      Cancelled bookings are excluded so their seats appear available again.
      Used by ShowTimeController to build the exact set of booked seat labels.
     */
    @Override
    public List<Booking> getBookingsByShowtime(String showtimeId) {
        return bookingRepository.findByShowtimeId(showtimeId)
                .stream()
                .filter(Booking::isConfirmed)
                .collect(Collectors.toList());
    }

    @Override
    public List<Booking> getAllBookings() {
        List<Booking> list = bookingRepository.readAll();
        list.sort((a, b) -> b.getBookingDate().compareTo(a.getBookingDate()));
        return list;
    }

    // DELETE (soft cancel)

    @Override
    public boolean cancelBooking(String bookingId, String requestingUserId) {
        Booking booking = bookingRepository.findById(bookingId);
        if (booking == null || booking.isCancelled()) return false;
        if (!booking.getUserId().equals(requestingUserId))  return false;

        booking.setStatus("CANCELLED");
        bookingRepository.update(booking);

        // Release seats back on the showtime
        ShowTime showtime = showTimeService.getShowTimeByID(booking.getShowtimeId());
        if (showtime != null) {
            showtime.setBookedSeats(Math.max(0, showtime.getBookedSeats() - booking.getSeatCount()));
            showTimeService.updateShowTime(showtime);
        }
        return true;
    }

    //  HELPER (used by BookingController for confirm page)

    public String buildPriceBreakdown(String seats, double showTypePrice) {
        StringBuilder sb = new StringBuilder();
        for (String seat : seats.split(",")) {
            seat = seat.trim();
            SeatType type = SeatType.fromSeatLabel(seat);
            double   price = type.calculatePrice(showTypePrice);
            if (sb.length() > 0) sb.append("|");
            sb.append(seat).append("~").append(type.getLabel())
                    .append("~").append(String.format("%.2f", price));
        }
        return sb.toString();
    }
}