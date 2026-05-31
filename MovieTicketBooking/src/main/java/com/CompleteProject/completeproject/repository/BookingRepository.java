package com.CompleteProject.completeproject.repository;

import com.CompleteProject.completeproject.bean.Booking;
import com.CompleteProject.completeproject.util.FilePathConstants;
import org.springframework.stereotype.Repository;

import java.io.*;
import java.util.ArrayList;
import java.util.List;


 // BookingRepository – all CRUD operations on bookings.txt.

 // File path : data/bookings.txt  (defined in FilePathConstants)
 // Format    : pipe-separated, 14 columns (see Booking.toFileString)

@Repository
public class BookingRepository {

    private static final String FILE_PATH = FilePathConstants.BOOKINGS_FILE;

    // READ

    public List<Booking> readAll() {
        List<Booking> list = new ArrayList<>();
        File file = new File(FILE_PATH);
        if (!file.exists()) return list;

        try (BufferedReader reader = new BufferedReader(new FileReader(file))) {
            String line;
            while ((line = reader.readLine()) != null) {
                line = line.trim();
                if (!line.isEmpty()) {
                    Booking b = Booking.fromFileString(line);
                    if (b != null) list.add(b);
                }
            }
        } catch (IOException e) {
            System.err.println("Error reading bookings.txt: " + e.getMessage());
        }
        return list;
    }

    private void writeAll(List<Booking> bookings) {
        new File("data").mkdirs();
        try (BufferedWriter writer = new BufferedWriter(new FileWriter(FILE_PATH, false))) {
            for (Booking b : bookings) {
                writer.write(b.toFileString());
                writer.newLine();
            }
        } catch (IOException e) {
            System.err.println("Error writing bookings.txt: " + e.getMessage());
        }
    }

    // FIND

    public Booking findById(String bookingId) {
        return readAll().stream()
                .filter(b -> b.getBookingId().equals(bookingId))
                .findFirst().orElse(null);
    }

    // All bookings belonging to a specific customer (by userId)
    public List<Booking> findByUserId(String userId) {
        List<Booking> result = new ArrayList<>();
        for (Booking b : readAll())
            if (b.getUserId().equals(userId)) result.add(b);
        return result;
    }

    // All bookings for a specific showtime (used to check seat occupancy)
    public List<Booking> findByShowtimeId(String showtimeId) {
        List<Booking> result = new ArrayList<>();
        for (Booking b : readAll())
            if (b.getShowtimeId().equals(showtimeId)) result.add(b);
        return result;
    }

    // WRITE
    public void save(Booking booking) {
        List<Booking> all = readAll();
        all.add(booking);
        writeAll(all);
    }

    public boolean update(Booking updated) {
        List<Booking> all = readAll();
        boolean found = false;
        for (int i = 0; i < all.size(); i++) {
            if (all.get(i).getBookingId().equals(updated.getBookingId())) {
                all.set(i, updated);
                found = true;
                break;
            }
        }
        if (found) writeAll(all);
        return found;
    }

    // ID GENERATOR

    public String generateNextId() {
        List<Booking> all = readAll();
        int max = 0;
        for (Booking b : all) {
            try {
                int num = Integer.parseInt(b.getBookingId().replace("BK", ""));
                if (num > max) max = num;
            } catch (NumberFormatException ignored) {}
        }
        return String.format("BK%03d", max + 1);
    }
}
