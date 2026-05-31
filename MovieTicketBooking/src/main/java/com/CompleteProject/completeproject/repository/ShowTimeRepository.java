package com.CompleteProject.completeproject.repository;

import com.CompleteProject.completeproject.util.FilePathConstants;
import com.CompleteProject.completeproject.bean.ShowTime;
import com.CompleteProject.completeproject.bean.TheaterHall;
import org.springframework.stereotype.Repository;

import java.io.*;
import java.util.ArrayList;
import java.util.List;

@Repository
public class ShowTimeRepository {

    private static final String SHOWTIMES_FILE = FilePathConstants.SHOWTIMES_FILE;
    private static final String HALLS_FILE     = FilePathConstants.HALLS_FILE;

    // READ

    public List<ShowTime> readAll() {
        List<ShowTime> list = new ArrayList<>();
        File file = new File(SHOWTIMES_FILE);
        if (!file.exists()) return list;

        try (BufferedReader reader = new BufferedReader(new FileReader(file))) {
            String line;
            while ((line = reader.readLine()) != null) {
                line = line.trim();
                if (!line.isEmpty()) {
                    ShowTime s = ShowTime.fromFileString(line);
                    if (s != null) list.add(s);
                }
            }
        } catch (IOException e) {
            System.err.println("Error reading showtimes.txt: " + e.getMessage());
        }
        return list;
    }

    public void writeAll(List<ShowTime> showTimes) {
        new File("data").mkdirs();
        try (BufferedWriter writer = new BufferedWriter(new FileWriter(SHOWTIMES_FILE, false))) {
            for (ShowTime s : showTimes) {
                writer.write(s.toFileString());
                writer.newLine();
            }
        } catch (IOException e) {
            System.err.println("Error writing to showtimes.txt: " + e.getMessage());
        }
    }

    // FIND

    public ShowTime findById(String showtimeId) {
        return readAll().stream()
                .filter(s -> s.getShowtimeId().equals(showtimeId))
                .findFirst().orElse(null);
    }

    public List<ShowTime> findByDate(String date) {
        List<ShowTime> result = new ArrayList<>();
        for (ShowTime s : readAll())
            if (s.getShowDate().equals(date)) result.add(s);
        return result;
    }

    public List<ShowTime> findByHall(String hallId) {
        List<ShowTime> result = new ArrayList<>();
        for (ShowTime s : readAll())
            if (s.getHallId().equals(hallId)) result.add(s);
        return result;
    }

    /*
      Find all showtimes whose movieTitle matches the given title
      (case-insensitive). This is the bridge between Component 2 and 3:
      the gallery's "Showtimes" button passes the movie title here.
     */
    public List<ShowTime> findByMovieTitle(String title) {
        List<ShowTime> result = new ArrayList<>();
        for (ShowTime s : readAll())
            if (s.getMovieTitle().equalsIgnoreCase(title)) result.add(s);
        return result;
    }

    // WRITE

    public void save(ShowTime showTime) {
        List<ShowTime> all = readAll();
        all.add(showTime);
        writeAll(all);
    }

    public boolean update(ShowTime updated) {
        List<ShowTime> all = readAll();
        boolean found = false;
        for (int i = 0; i < all.size(); i++) {
            if (all.get(i).getShowtimeId().equals(updated.getShowtimeId())) {
                all.set(i, updated);
                found = true;
                break;
            }
        }
        if (found) writeAll(all);
        return found;
    }

    public boolean delete(String showtimeId) {
        List<ShowTime> all = readAll();
        boolean removed = all.removeIf(s -> s.getShowtimeId().equals(showtimeId));
        if (removed) writeAll(all);
        return removed;
    }

    // ID GENERATOR
    public String generateNextId() {
        List<ShowTime> all = readAll();
        int max = 0;
        for (ShowTime s : all) {
            try {
                int num = Integer.parseInt(s.getShowtimeId().replace("ST", ""));
                if (num > max) max = num;
            } catch (NumberFormatException ignored) {}
        }
        return String.format("ST%03d", max + 1);
    }

    // HALLS

    public List<TheaterHall> readAllHalls() {
        List<TheaterHall> halls = new ArrayList<>();
        File file = new File(HALLS_FILE);

        if (!file.exists()) return seedDefaultHalls();

        try (BufferedReader reader = new BufferedReader(new FileReader(file))) {
            String line;
            while ((line = reader.readLine()) != null) {
                line = line.trim();
                if (!line.isEmpty()) halls.add(TheaterHall.fromFileString(line));
            }
        } catch (IOException e) {
            System.err.println("Error reading halls.txt: " + e.getMessage());
            return seedDefaultHalls();
        }
        return halls;
    }

    public void writeAllHalls(List<TheaterHall> halls) {
        new File("data").mkdirs();
        try (BufferedWriter writer = new BufferedWriter(new FileWriter(HALLS_FILE, false))) {
            for (TheaterHall h : halls) {
                writer.write(h.toFileString());
                writer.newLine();
            }
        } catch (IOException e) {
            System.err.println("Error writing halls.txt: " + e.getMessage());
        }
    }

    public TheaterHall findHallById(String hallId) {
        return readAllHalls().stream()
                .filter(h -> h.getHallId().equals(hallId))
                .findFirst().orElse(null);
    }

    private List<TheaterHall> seedDefaultHalls() {
        List<TheaterHall> defaults = new ArrayList<>();
        defaults.add(new TheaterHall("H001", "Hall A",     8,  10, "STANDARD_2D"));
        defaults.add(new TheaterHall("H002", "Hall B",     8,  10, "PREMIUM_3D"));
        defaults.add(new TheaterHall("H003", "IMAX Hall", 10,  15, "IMAX"));
        writeAllHalls(defaults);
        return defaults;
    }
}
