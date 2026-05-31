package com.CompleteProject.completeproject.bean;

public class TheaterHall {
    private String hallId;
    private String hallName;
    private int rows;
    private int columns;
    private String HallType;

    public TheaterHall() {}

    public TheaterHall(String hallId, String hallName, int rows, int columns, String HallType) {
        this.hallId = hallId;
        this.hallName = hallName;
        this.rows = rows;
        this.columns = columns;
        this.HallType = HallType;
    }

    public String getHallId() { return hallId; }
    public void setHallId(String hallId) { this.hallId = hallId; }
    public String getHallName() { return hallName; }
    public void setHallName(String hallName) { this.hallName = hallName; }
    public int getRows() { return rows; }
    public void setRows(int rows) { this.rows = rows; }
    public int getColumns() { return columns; }
    public void setColumns(int columns) { this.columns = columns; }
    public String getHallType() { return HallType; }
    public void setHallType(String HallType) { this.HallType = HallType; }

    public int getTotalSeats(){
        return rows*columns;
    }

    public String toFileString(){

        return String.join("|",hallId,hallName,String.valueOf(rows),String.valueOf(columns),HallType);
    }

    public static TheaterHall fromFileString(String line){

        String[] parts = line.split("\\|");
        return new TheaterHall(parts[0],parts[1],Integer.parseInt(parts[2]),
                Integer.parseInt(parts[3]),parts[4]);


    }
}
