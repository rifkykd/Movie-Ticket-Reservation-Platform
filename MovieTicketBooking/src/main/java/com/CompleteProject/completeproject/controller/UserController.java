package com.CompleteProject.completeproject.controller;

import com.CompleteProject.completeproject.bean.Customer;
import com.CompleteProject.completeproject.bean.User;
import com.CompleteProject.completeproject.service.EmailService;
import com.CompleteProject.completeproject.service.OtpStore;
import com.CompleteProject.completeproject.service.UserService;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

@Controller
@RequestMapping("/user")
public class UserController {

    @Autowired private UserService   userService;
    @Autowired private EmailService  emailService;
    @Autowired private OtpStore      otpStore;

    private static final DateTimeFormatter LOGIN_FMT =
            DateTimeFormatter.ofPattern("dd MMM yyyy, HH:mm");

    // LOGIN

    @GetMapping("/login")
    public String showLoginPage(HttpSession session) {
        if (session.getAttribute("loggedInUser") != null)
            return "redirect:/";
        return "user/login";
    }

    @PostMapping("/login")
    public String processLogin(@RequestParam String username,
                               @RequestParam String password,
                               HttpSession session,
                               RedirectAttributes redirectAttrs) {

        User user = userService.login(username, password);

        if (user == null) {
            redirectAttrs.addFlashAttribute("errorMsg",
                    "Invalid username or password. Please try again.");
            return "redirect:/user/login";
        }

        // Store user in session
        session.setAttribute("loggedInUser", user);
        session.setAttribute("userId",       user.getUserId());
        session.setAttribute("username",     user.getUsername());
        session.setAttribute("role",         user.getRole());

        // Send login notification email
        // Runs in a new thread so it never blocks the login redirect.
        String loginTime = LocalDateTime.now().format(LOGIN_FMT);
        String toEmail   = user.getEmail();
        String uname     = user.getUsername();

        if (toEmail != null && !toEmail.isBlank()) {
            new Thread(() ->
                    emailService.sendLoginNotification(toEmail, uname, loginTime)
            ).start();
        }

        // Return to the page they were trying to reach before login (if any)
        String redirectTarget = (String) session.getAttribute("redirectAfterLogin");
        if (redirectTarget != null && !redirectTarget.isEmpty()) {
            session.removeAttribute("redirectAfterLogin");
            return "redirect:" + redirectTarget;
        }

        return "redirect:/";
    }

    //  LOGOUT

    @GetMapping("/logout")
    public String logout(HttpSession session, RedirectAttributes redirectAttrs) {
        session.invalidate();
        redirectAttrs.addFlashAttribute("successMsg", "You have been logged out.");
        return "redirect:/user/login";
    }

    // REGISTER

    @GetMapping("/register")
    public String showRegisterPage(Model model) {
        model.addAttribute("customer", new Customer());
        return "user/register";
    }

    @PostMapping("/register")
    public String processRegister(@ModelAttribute Customer customer,
                                  RedirectAttributes redirectAttrs) {

        boolean success = userService.registerCustomer(customer);
        if (success) {
            redirectAttrs.addFlashAttribute("successMsg",
                    "Account created! Please log in.");
            return "redirect:/user/login";
        }
        redirectAttrs.addFlashAttribute("errorMsg",
                "Username or email is already taken. Please try again.");
        return "redirect:/user/register";
    }

    // PROFILE

    @GetMapping("/profile")
    public String showProfile(HttpSession session, Model model) {
        User loggedIn = (User) session.getAttribute("loggedInUser");
        if (loggedIn == null) return "redirect:/user/login";
        model.addAttribute("user",      userService.findById(loggedIn.getUserId()));
        model.addAttribute("pageTitle", "My Profile");
        return "user/profile";
    }

    @PostMapping("/profile/update")
    public String updateProfile(@RequestParam String userId,
                                @RequestParam String fullName,
                                @RequestParam String phone,
                                @RequestParam String email,
                                HttpSession session,
                                RedirectAttributes redirectAttrs) {

        User user = userService.findById(userId);
        if (user == null) return "redirect:/user/login";

        user.setFullName(fullName);
        user.setPhone(phone);
        user.setEmail(email);

        if (userService.updateProfile(user)) {
            session.setAttribute("loggedInUser", user);
            redirectAttrs.addFlashAttribute("successMsg", "Profile updated successfully!");
        } else {
            redirectAttrs.addFlashAttribute("errorMsg", "Update failed. Please try again.");
        }
        return "redirect:/user/profile";
    }

    @PostMapping("/profile/password")
    public String changePassword(@RequestParam String userId,
                                 @RequestParam String oldPassword,
                                 @RequestParam String newPassword,
                                 @RequestParam String confirmPassword,
                                 RedirectAttributes redirectAttrs) {

        if (!newPassword.equals(confirmPassword)) {
            redirectAttrs.addFlashAttribute("errorMsg", "New passwords do not match!");
            return "redirect:/user/profile";
        }
        if (userService.changePassword(userId, oldPassword, newPassword)) {
            redirectAttrs.addFlashAttribute("successMsg", "Password changed successfully!");
        } else {
            redirectAttrs.addFlashAttribute("errorMsg", "Current password is incorrect!");
        }
        return "redirect:/user/profile";
    }

    // DEACTIVATE

    @GetMapping("/deactivate")
    public String deactivateAccount(HttpSession session,
                                    RedirectAttributes redirectAttrs) {
        User user = (User) session.getAttribute("loggedInUser");
        if (user == null) return "redirect:/user/login";
        userService.deactivateUser(user.getUserId());
        session.invalidate();
        redirectAttrs.addFlashAttribute("successMsg", "Your account has been deactivated.");
        return "redirect:/user/login";
    }

    //  FORGOT PASSWORD — OTP FLOW
    //  Step 1  GET  /user/forgot-password     → show username form
    //  Step 1  POST /user/forgot-password     → look up user, send OTP email
    //  Step 2  POST /user/verify-otp          → validate OTP code
    //  Step 3  POST /user/reset-password      → save new password

    // Step 1 – show the username entry form
    @GetMapping("/forgot-password")
    public String showForgotPasswordPage() {
        return "user/forgot-password";
    }

    /*
      Step 1 POST – look up the user, generate an OTP, email it.
      We intentionally show the same "check your email" message whether
      or not the username exists, to prevent username enumeration.
     */
    @PostMapping("/forgot-password")
    public String sendOtp(@RequestParam String username, Model model) {

        User user = userService.findByUsername(username);

        if (user != null && user.getEmail() != null && !user.getEmail().isBlank()) {
            // Generate OTP and fire email on a background thread
            String otp = otpStore.generate(username);
            String email = user.getEmail();
            new Thread(() ->
                    emailService.sendOtpEmail(email, username, otp)
            ).start();
        }
        // Always show the OTP entry step, regardless of whether the user exists
        model.addAttribute("username",    username);
        model.addAttribute("otpSent",     true);
        model.addAttribute("infoMsg",
                "If that username exists, a 6-digit code has been sent to the " +
                        "registered email address. Check your inbox.");
        return "user/forgot-password";
    }

    // Step 2 POST – verify the OTP the user typed in.

    @PostMapping("/verify-otp")
    public String verifyOtp(@RequestParam String username,
                            @RequestParam String otpCode,
                            Model model) {

        OtpStore.VerifyResult result = otpStore.verify(username, otpCode);

        if (result.isOk()) {
            // OTP correct — show the new-password form
            model.addAttribute("username",      username);
            model.addAttribute("showResetForm", true);
            return "user/forgot-password";
        }

        // OTP failed — show error and stay on step 2
        String msg;
        switch (result) {
            case EXPIRED:   msg = "That code has expired. Please request a new one."; break;
            case TOO_MANY:  msg = "Too many incorrect attempts. Please request a new code."; break;
            case NOT_FOUND: msg = "No active code found. Please request a new one."; break;
            default:        msg = "Incorrect code. Please try again.";
        }

        model.addAttribute("username",  username);
        model.addAttribute("otpSent",   true);
        model.addAttribute("errorMsg",  msg);
        return "user/forgot-password";
    }

    // Step 3 POST – save the new password.

    @PostMapping("/reset-password")
    public String resetPassword(@RequestParam String username,
                                @RequestParam String newPassword,
                                @RequestParam String confirmPassword,
                                RedirectAttributes redirectAttrs) {

        if (!newPassword.equals(confirmPassword)) {
            redirectAttrs.addFlashAttribute("errorMsg", "Passwords do not match!");
            return "redirect:/user/forgot-password";
        }

        boolean success = userService.resetPassword(username, newPassword);

        // Clean up any lingering OTP entry (already consumed, but be safe)
        otpStore.invalidate(username);

        if (success) {
            redirectAttrs.addFlashAttribute("successMsg",
                    "Password reset successfully! Please log in with your new password.");
        } else {
            redirectAttrs.addFlashAttribute("errorMsg",
                    "Password reset failed. Please try again.");
        }
        return "redirect:/user/login";
    }

}