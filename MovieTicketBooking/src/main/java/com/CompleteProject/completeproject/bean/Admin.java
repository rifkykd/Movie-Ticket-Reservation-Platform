package com.CompleteProject.completeproject.bean;

public class Admin extends User {
    private String department;

    public String getDepartment() { return department; }
    public void setDepartment(String department) { this.department = department; }

    public Admin() {}

    public Admin(String userId, String username, String email,
                 String password, String fullName, String phone,
                 String securityQuestion, String securityAnswer,
                 String status, String department) {

        super(userId, username, email, password, fullName, phone,
              "ADMIN", securityQuestion, securityAnswer, status);

        this.department = department;
    }


    @Override
    public String getAccountType() {
        return "Administrator Account";
    }

    public String toFileString() {
        return baseToFileString() + "|" + department;
    }


    public static Admin fromFileString(String line) {
        String[] p = line.split("\\|");
        return new Admin(
                p[0],                              // userId
                p[1],                              // username
                p[2],                              // email
                p[3],                              // password
                p[4],                              // fullName
                p[5],                              // phone
                p[7],                              // securityQuestion
                p[8],                              // securityAnswer
                p[9],                              // status
                p.length > 10 ? p[10] : "General" // department
        );
    }
}
