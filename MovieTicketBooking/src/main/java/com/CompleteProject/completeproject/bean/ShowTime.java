package com.CompleteProject.completeproject.bean;

public class ShowTime {
    private String showtimeId;
    private String movieTitle;
    private String hallId;
    private String hallName;
    private String showDate;
    private String showTime;
    private ShowType showType;
    private double basePrice;
    private int totalSeats;
    private int bookedSeats;

    public ShowTime() {}

    public ShowTime(String showtimeId, String movieTitle, String hallId, String hallName, 
                    String showDate, String showTime, ShowType showType, double basePrice, 
                    int totalSeats, int bookedSeats) {
        this.showtimeId = showtimeId;
        this.movieTitle = movieTitle;
        this.hallId = hallId;
        this.hallName = hallName;
        this.showDate = showDate;
        this.showTime = showTime;
        this.showType = showType;
        this.basePrice = basePrice;
        this.totalSeats = totalSeats;
        this.bookedSeats = bookedSeats;
    }

    public String getShowtimeId() { return showtimeId; }
    public void setShowtimeId(String showtimeId) { this.showtimeId = showtimeId; }
    public String getMovieTitle() { return movieTitle; }
    public void setMovieTitle(String movieTitle) { this.movieTitle = movieTitle; }
    public String getHallId() { return hallId; }
    public void setHallId(String hallId) { this.hallId = hallId; }
    public String getHallName() { return hallName; }
    public void setHallName(String hallName) { this.hallName = hallName; }
    public String getShowDate() { return showDate; }
    public void setShowDate(String showDate) { this.showDate = showDate; }
    public String getShowTime() { return showTime; }
    public void setShowTime(String showTime) { this.showTime = showTime; }
    public ShowType getShowType() { return showType; }
    public void setShowType(ShowType showType) { this.showType = showType; }
    public double getBasePrice() { return basePrice; }
    public void setBasePrice(double basePrice) { this.basePrice = basePrice; }
    public int getTotalSeats() { return totalSeats; }
    public void setTotalSeats(int totalSeats) { this.totalSeats = totalSeats; }
    public int getBookedSeats() { return bookedSeats; }
    public void setBookedSeats(int bookedSeats) { this.bookedSeats = bookedSeats; }

    public int getAvailableSeats(){
        return totalSeats-bookedSeats;
    }

    public boolean isAvailable(){
        return getAvailableSeats()>0;
    }
    public double getFinalPrice(){
        return showType.calculatePrice(basePrice);
    }

    public String toFileString(){

        return String.join("|",
                showtimeId,
                movieTitle,
                hallId,
                hallName,
                showDate,
                showTime,
                String.valueOf(showType),
                String.valueOf(basePrice),
                String.valueOf(totalSeats),
                String.valueOf(bookedSeats));

    }


    public static ShowTime fromFileString(String line){
        String[] parts = line.split("\\|");
        if(parts.length<10){
            return null;
        }
        ShowTime st = new ShowTime();
        st.setShowtimeId(parts[0]);
        st.setMovieTitle(parts[1]);
        st.setHallId(parts[2]);
        st.setHallName(parts[3]);
        st.setShowDate(parts[4]);
        st.setShowTime(parts[5]);
        st.setShowType(ShowType.valueOf(parts[6]));
        st.setBasePrice(Double.parseDouble(parts[7]));
        st.setTotalSeats(Integer.parseInt(parts[8]));
        st.setBookedSeats(Integer.parseInt(parts[9]));

        return st;



    }



}
