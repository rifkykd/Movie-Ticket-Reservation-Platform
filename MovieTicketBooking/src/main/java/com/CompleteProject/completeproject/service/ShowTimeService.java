package com.CompleteProject.completeproject.service;

import com.CompleteProject.completeproject.bean.ShowTime;
import com.CompleteProject.completeproject.bean.TheaterHall;

import java.util.List;

public interface ShowTimeService {

    boolean addShowTime(ShowTime showTime);

    ShowTime getShowTimeByID(String showtimeId);

    List<ShowTime> getAllShowTimes();

    List<ShowTime> getShowTimesByDate(String date);

    List<ShowTime> getShowTimesByHall(String hallId);

    /*
      Returns all showtimes for a given movie title
      Used by the "Showtimes" button on the movie gallery
     */
    List<ShowTime> getShowTimesByMovieTitle(String movieTitle);

    boolean updateShowTime(ShowTime showTime);

    boolean deleteShowTime(String showTimeId);

    boolean isHallAvailable(String hallId, String date, String showTime, String excludeId);

    List<ShowTime> getAvailableShowtimes(String date);

    List<TheaterHall> getAllHalls();

    TheaterHall getHallById(String hallId);
}
