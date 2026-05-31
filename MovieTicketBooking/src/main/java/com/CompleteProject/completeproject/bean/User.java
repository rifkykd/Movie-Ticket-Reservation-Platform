package com.CompleteProject.completeproject.bean;

public abstract class User {
    private String userId;
    private String username;
    private String email;
    private String password;
    private String fullName;
    private String phone;
    private String role;
    private String securityQuestion;
    private String securityAnswer;
    private String status;

    public User() {}

    public User(String userId, String username, String email, String password, String fullName, 
                String phone, String role, String securityQuestion, String securityAnswer, String status) {
        this.userId = userId;
        this.username = username;
        this.email = email;
        this.password = password;
        this.fullName = fullName;
        this.phone = phone;
        this.role = role;
        this.securityQuestion = securityQuestion;
        this.securityAnswer = securityAnswer;
        this.status = status;
    }

    public String getUserId() { return userId; }
    public void setUserId(String userId) { this.userId = userId; }
    public String getUsername() { return username; }
    public void setUsername(String username) { this.username = username; }
    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }
    public String getPassword() { return password; }
    public void setPassword(String password) { this.password = password; }
    public String getFullName() { return fullName; }
    public void setFullName(String fullName) { this.fullName = fullName; }
    public String getPhone() { return phone; }
    public void setPhone(String phone) { this.phone = phone; }
    public String getRole() { return role; }
    public void setRole(String role) { this.role = role; }
    public String getSecurityQuestion() { return securityQuestion; }
    public void setSecurityQuestion(String securityQuestion) { this.securityQuestion = securityQuestion; }
    public String getSecurityAnswer() { return securityAnswer; }
    public void setSecurityAnswer(String securityAnswer) { this.securityAnswer = securityAnswer; }
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    //abstract method
    public abstract String getAccountType();

    public boolean isActive() {
        return "ACTIVE".equalsIgnoreCase(status);
    }


    public boolean isAdmin() {
        return "ADMIN".equalsIgnoreCase(role);
    }

    protected String baseToFileString() {
        return String.join("|",
                userId,
                username,
                email,
                password,
                fullName,
                phone,
                role,
                securityQuestion,
                securityAnswer,
                status
        );
    }
}
