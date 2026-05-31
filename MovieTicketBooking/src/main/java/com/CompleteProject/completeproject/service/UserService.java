package com.CompleteProject.completeproject.service;

import com.CompleteProject.completeproject.bean.User;
import com.CompleteProject.completeproject.bean.Customer;

import java.util.List;

// Interface : OOP concept abstraction
public interface UserService {



    // CREATE – registers a new customer account
    boolean registerCustomer(Customer customer);

    //READ – find a user by their username (for login)
    User findByUsername(String username);

    //READ – find a user by their email
    User findByEmail(String email);

    //READ – get all users (admin view)
    List<User> getAllUsers();

    //READ – get a user by their ID
    User findById(String userId);

    //UPDATE – save changes to profile (name, phone, email)
    boolean updateProfile(User user);

    //UPDATE – change password after verifying the old one
    boolean changePassword(String userId, String oldPassword, String newPassword);

    // DELETE – deactivate a user account (soft delete)
    boolean deactivateUser(String userId);

    //DELETE – permanently remove a user (admin only)
    boolean deleteUser(String userId);

    User login(String username, String password);

    // Returns true if a username is already taken
    boolean isUsernameTaken(String username);

    // Returns true if an email is already registered
    boolean isEmailTaken(String email);

    //  FORGOT PASSWORD
    String getSecurityQuestion(String username);


    boolean verifySecurityAnswer(String username, String answer);

    boolean resetPassword(String username, String newPassword);
}
