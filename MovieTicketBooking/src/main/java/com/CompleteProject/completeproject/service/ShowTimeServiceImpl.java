package com.CompleteProject.completeproject.service;

import com.CompleteProject.completeproject.bean.ShowTime;
import com.CompleteProject.completeproject.bean.TheaterHall;
import com.CompleteProject.completeproject.repository.ShowTimeRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.stream.Collectors;

@Service
public class ShowTimeServiceImpl implements ShowTimeService {

    @Autowired
    private ShowTimeRepository showTimeRepository;

    // CREATE

    @Override
    public boolean addShowTime(ShowTime showTime) {
        if (!isHallAvailable(showTime.getHallId(), showTime.getShowDate(),
                             showTime.getShowTime(), null)) {
            return false;
        }
        showTime.setShowtimeId(showTimeRepository.generateNextId());
        showTime.setBookedSeats(0);
        showTimeRepository.save(showTime);
        return true;
    }

    // READ

    @Override
    public ShowTime getShowTimeByID(String showtimeId) {
        return showTimeRepository.findById(showtimeId);
    }

    @Override
    public List<ShowTime> getAllShowTimes() {
        return showTimeRepository.readAll();
    }

    @Override
    public List<ShowTime> getShowTimesByDate(String date) {
        return showTimeRepository.findByDate(date);
    }

    @Override
    public List<ShowTime> getShowTimesByHall(String hallId) {
        return showTimeRepository.findByHall(hallId);
    }

    /*
      Returns all showtimes whose movieTitle matches – used by the gallery's
      "Showtimes" button to list shows for a specific movie
     */
    @Override
    public List<ShowTime> getShowTimesByMovieTitle(String movieTitle) {
        return showTimeRepository.findByMovieTitle(movieTitle);
    }

    // UPDATE

    @Override
    public boolean updateShowTime(ShowTime showTime) {
        if (!isHallAvailable(showTime.getHallId(), showTime.getShowDate(),
                             showTime.getShowTime(), showTime.getShowtimeId())) {
            return false;
        }
        return showTimeRepository.update(showTime);
    }

    // DELETE

    @Override
    public boolean deleteShowTime(String showTimeId) {
        return showTimeRepository.delete(showTimeId);
    }

    // AVAILABILITY

    @Override
    public boolean isHallAvailable(String hallId, String date, String showtime, String excludeId) {
        for (ShowTime s : showTimeRepository.readAll()) {
            if (excludeId != null && s.getShowtimeId().equals(excludeId)) continue;
            if (s.getHallId().equals(hallId)
                    && s.getShowDate().equals(date)
                    && s.getShowTime().equals(showtime)) {
                return false;
            }
        }
        return true;
    }

    @Override
    public List<ShowTime> getAvailableShowtimes(String date) {
        return showTimeRepository.findByDate(date)
                .stream()
                .filter(ShowTime::isAvailable)
                .collect(Collectors.toList());
    }

    //  HALLS

    @Override
    public List<TheaterHall> getAllHalls() {
        return showTimeRepository.readAllHalls();
    }

    @Override
    public TheaterHall getHallById(String hallId) {
        return showTimeRepository.findHallById(hallId);
    }
}
