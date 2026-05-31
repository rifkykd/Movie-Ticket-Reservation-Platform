package com.CompleteProject.completeproject.service;

import com.CompleteProject.completeproject.bean.Customer;
import com.CompleteProject.completeproject.bean.User;
import com.CompleteProject.completeproject.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class UserServiceImpl implements UserService {

    @Autowired
    private UserRepository userRepository;

    // CREATE

    @Override
    public boolean registerCustomer(Customer customer) {
        if (isUsernameTaken(customer.getUsername())) return false;
        if (isEmailTaken(customer.getEmail()))       return false;

        customer.setUserId(userRepository.generateNextId("CUSTOMER"));
        customer.setRole("CUSTOMER");
        customer.setStatus("ACTIVE");
        customer.setTotalBookings(0);

        // Security question is no longer collected on registration.
        // Password recovery is handled via OTP email
        // Set empty defaults so the file format stays intact.
        customer.setSecurityQuestion("N/A");
        customer.setSecurityAnswer("N/A");

        userRepository.save(customer);
        return true;
    }

    // READ

    @Override
    public User findByUsername(String username) {
        return userRepository.findByUsername(username);
    }

    @Override
    public User findByEmail(String email) {
        return userRepository.findByEmail(email);
    }

    @Override
    public List<User> getAllUsers() {
        return userRepository.readAll();
    }

    @Override
    public User findById(String userId) {
        return userRepository.findById(userId);
    }

    // UPDATE

    @Override
    public boolean updateProfile(User user) {
        return userRepository.update(user);
    }

    @Override
    public boolean changePassword(String userId, String oldPassword, String newPassword) {
        User user = userRepository.findById(userId);
        if (user == null) return false;
        if (!user.getPassword().equals(oldPassword)) return false;
        user.setPassword(newPassword);
        return userRepository.update(user);
    }

    // DELETE

    @Override
    public boolean deactivateUser(String userId) {
        User user = userRepository.findById(userId);
        if (user == null) return false;
        user.setStatus("DEACTIVATED");
        return userRepository.update(user);
    }

    @Override
    public boolean deleteUser(String userId) {
        return userRepository.delete(userId);
    }

    // AUTHENTICATION

    @Override
    public User login(String username, String password) {
        User user = userRepository.findByUsername(username);
        if (user == null)                             return null;
        if (!user.isActive())                         return null;
        if (!user.getPassword().equals(password))     return null;
        return user;
    }

    @Override
    public boolean isUsernameTaken(String username) {
        return userRepository.findByUsername(username) != null;
    }

    @Override
    public boolean isEmailTaken(String email) {
        return userRepository.findByEmail(email) != null;
    }

    //  PASSWORD RESET (OTP-based — security question no longer used)

    /*
      getSecurityQuestion and verifySecurityAnswer are kept in the interface
      for backwards compatibility with existing users.txt records, but are
      no longer called by any controller. Password recovery now goes through
      OtpStore -> EmailService in UserController.
     */
    @Override
    public String getSecurityQuestion(String username) {
        return null;   // retired — OTP flow used instead
    }

    @Override
    public boolean verifySecurityAnswer(String username, String answer) {
        return false;  // retired — OTP flow used instead
    }

    @Override
    public boolean resetPassword(String username, String newPassword) {
        User user = userRepository.findByUsername(username);
        if (user == null) return false;
        user.setPassword(newPassword);
        return userRepository.update(user);
    }
}