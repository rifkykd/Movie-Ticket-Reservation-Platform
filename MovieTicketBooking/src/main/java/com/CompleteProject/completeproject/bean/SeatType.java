package com.CompleteProject.completeproject.bean;



 //   Rows A & B  → VIP     (first 2 rows of any hall)
 //   Row  C+     → STANDARD

 // Final price per seat = showType.calculatePrice(basePrice) × seatType multiplier

public enum SeatType {

    STANDARD {
        @Override
        public double calculatePrice(double showTypePrice) {
            return showTypePrice * 1.0;
        }
        @Override
        public String getLabel() { return "Standard"; }
        @Override
        public String getBadgeColor() { return "#198754"; }
    },

    VIP {
        @Override
        public double calculatePrice(double showTypePrice) {
            return showTypePrice * 1.5;
        }
        @Override
        public String getLabel() { return "VIP"; }
        @Override
        public String getBadgeColor() { return "#f5c518"; }
    };

    // Applies seat-type multiplier on top of the show-type price.
    public abstract double calculatePrice(double showTypePrice);

    public abstract String getLabel();

    // CSS hex colour used in JSP badges.
    public abstract String getBadgeColor();


     // Derives SeatType from a seat label such as "A3" or "B10".
     // Row letter A or B → VIP; everything else → STANDARD.

    public static SeatType fromSeatLabel(String seatLabel) {
        if (seatLabel == null || seatLabel.isEmpty()) return STANDARD;
        char row = Character.toUpperCase(seatLabel.charAt(0));
        return (row == 'A' || row == 'B') ? VIP : STANDARD;
    }
}
