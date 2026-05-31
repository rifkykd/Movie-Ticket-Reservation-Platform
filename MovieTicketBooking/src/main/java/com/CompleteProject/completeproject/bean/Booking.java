package com.CompleteProject.completeproject.bean;


public class Booking {
    private String bookingId;
    private String userId;
    private String username;
    private String showtimeId;
    private String movieTitle;
    private String hallName;
    private String showDate;
    private String showTime;
    private String showType;
    private String seats;
    private int    seatCount;
    private double totalPrice;
    private String status;
    private String bookingDate;

    public Booking() {}

    public Booking(String bookingId, String userId, String username, String showtimeId, String movieTitle, 
                   String hallName, String showDate, String showTime, String showType, String seats, 
                   int seatCount, double totalPrice, String status, String bookingDate) {
        this.bookingId = bookingId;
        this.userId = userId;
        this.username = username;
        this.showtimeId = showtimeId;
        this.movieTitle = movieTitle;
        this.hallName = hallName;
        this.showDate = showDate;
        this.showTime = showTime;
        this.showType = showType;
        this.seats = seats;
        this.seatCount = seatCount;
        this.totalPrice = totalPrice;
        this.status = status;
        this.bookingDate = bookingDate;
    }

    public String getBookingId() { return bookingId; }
    public void setBookingId(String bookingId) { this.bookingId = bookingId; }
    public String getUserId() { return userId; }
    public void setUserId(String userId) { this.userId = userId; }
    public String getUsername() { return username; }
    public void setUsername(String username) { this.username = username; }
    public String getShowtimeId() { return showtimeId; }
    public void setShowtimeId(String showtimeId) { this.showtimeId = showtimeId; }
    public String getMovieTitle() { return movieTitle; }
    public void setMovieTitle(String movieTitle) { this.movieTitle = movieTitle; }
    public String getHallName() { return hallName; }
    public void setHallName(String hallName) { this.hallName = hallName; }
    public String getShowDate() { return showDate; }
    public void setShowDate(String showDate) { this.showDate = showDate; }
    public String getShowTime() { return showTime; }
    public void setShowTime(String showTime) { this.showTime = showTime; }
    public String getShowType() { return showType; }
    public void setShowType(String showType) { this.showType = showType; }
    public String getSeats() { return seats; }
    public void setSeats(String seats) { this.seats = seats; }
    public int getSeatCount() { return seatCount; }
    public void setSeatCount(int seatCount) { this.seatCount = seatCount; }
    public double getTotalPrice() { return totalPrice; }
    public void setTotalPrice(double totalPrice) { this.totalPrice = totalPrice; }
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    public String getBookingDate() { return bookingDate; }
    public void setBookingDate(String bookingDate) { this.bookingDate = bookingDate; }

    // Derived helpers

    public boolean isConfirmed()  { return "CONFIRMED".equalsIgnoreCase(status); }
    public boolean isCancelled()  { return "CANCELLED".equalsIgnoreCase(status); }

    // Human-readable show type label (mirrors ShowType.getLabel()).
    public String getShowTypeLabel() {
        if (showType == null) return "";
        switch (showType) {
            case "STANDARD_2D": return "Standard 2D";
            case "PREMIUM_3D":  return "Premium 3D";
            case "IMAX":        return "IMAX";
            default:            return showType;
        }
    }

    // Serialisation

    public String toFileString() {
        return String.join("|",
                bookingId,
                userId,
                username,
                showtimeId,
                movieTitle,
                hallName,
                showDate,
                showTime,
                showType,
                seats,
                String.valueOf(seatCount),
                String.valueOf(totalPrice),
                status,
                bookingDate);
    }

    public static Booking fromFileString(String line) {
        String[] p = line.split("\\|", -1);
        if (p.length < 14) return null;

        Booking b = new Booking();
        b.setBookingId(p[0].trim());
        b.setUserId(p[1].trim());
        b.setUsername(p[2].trim());
        b.setShowtimeId(p[3].trim());
        b.setMovieTitle(p[4].trim());
        b.setHallName(p[5].trim());
        b.setShowDate(p[6].trim());
        b.setShowTime(p[7].trim());
        b.setShowType(p[8].trim());
        b.setSeats(p[9].trim());
        b.setSeatCount(Integer.parseInt(p[10].trim()));
        b.setTotalPrice(Double.parseDouble(p[11].trim()));
        b.setStatus(p[12].trim());
        b.setBookingDate(p[13].trim());
        return b;
    }
}
