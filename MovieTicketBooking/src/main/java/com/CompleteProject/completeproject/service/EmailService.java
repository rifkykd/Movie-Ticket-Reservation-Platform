package com.CompleteProject.completeproject.service;

/*
  EmailService – defines all outbound email operations

  Implementations may send real emails (Spring Mail / SMTP) or, in
  development, simply log the content to the console.
 */
public interface EmailService {

    /*
      Sends a login-notification email to the user.

      @param toEmail   recipient address
      @param username  the account username (shown in the email body)
      @param loginTime human-readable timestamp, e.g. "02 Jun 2026, 14:35"
     */
    void sendLoginNotification(String toEmail, String username, String loginTime);

    /*
      Sends a one-time password to the user for the forgot-password flow.

      @param toEmail  recipient address
      @param username the account username
      @param otp      the 6-digit code
     */
    void sendOtpEmail(String toEmail, String username, String otp);
}
