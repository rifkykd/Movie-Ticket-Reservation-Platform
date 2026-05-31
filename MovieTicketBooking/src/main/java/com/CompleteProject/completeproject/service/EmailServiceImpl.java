package com.CompleteProject.completeproject.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.stereotype.Service;

import jakarta.mail.internet.MimeMessage;

/*
  EmailServiceImpl – sends emails via Spring Mail (SMTP).

  If JavaMailSender is not configured (mail.enabled=false inapplication.properties),
  all emails are printed to the console instead, so development works without an SMTP server.

  Setup required in application.properties:
    mail.enabled=true
    spring.mail.host=smtp.gmail.com
    spring.mail.port=587
    spring.mail.username=your-email@gmail.com
    spring.mail.password=your-app-password
    spring.mail.properties.mail.smtp.auth=true
    spring.mail.properties.mail.smtp.starttls.enable=true
    cinebook.mail.from=your-email@gmail.com
 */
@Service
public class EmailServiceImpl implements EmailService {

    @Autowired(required = false)
    private JavaMailSender mailSender;

    // Set to false in application.properties to disable real emails
    @Value("${mail.enabled:false}")
    private boolean mailEnabled;

    @Value("${cinebook.mail.from:noreply@cinebook.com}")
    private String fromAddress;

    // LOGIN NOTIFICATION

    @Override
    public void sendLoginNotification(String toEmail, String username,
                                      String loginTime) {

        String subject = "CineBook – New Sign-In Detected";

        String html = buildHtml(
            "New Sign-In to Your CineBook Account",
            "Hi <strong>" + escape(username) + "</strong>,",
            "A successful sign-in was recorded on your account.",
            "<table style='margin:1rem 0;border-collapse:collapse;width:100%'>" +
            "  <tr><td style='padding:6px 12px;background:#f5f0e8;color:#78716c;font-size:.8rem;font-weight:600;width:110px'>Time</td>" +
            "      <td style='padding:6px 12px;color:#1c1917'>" + escape(loginTime) + "</td></tr>" +
            "  <tr><td style='padding:6px 12px;background:#f5f0e8;color:#78716c;font-size:.8rem;font-weight:600'>Account</td>" +
            "      <td style='padding:6px 12px;color:#1c1917'>@" + escape(username) + "</td></tr>" +
            "</table>" +
            "<p style='font-size:.85rem;color:#78716c'>" +
            "If this was you, no action is needed.<br>" +
            "If you did not sign in, please " +
            "<a href='#' style='color:#c9960a'>reset your password</a> immediately." +
            "</p>"
        );

        send(toEmail, subject, html);
    }

    // OTP EMAIL

    @Override
    public void sendOtpEmail(String toEmail, String username, String otp) {

        String subject = "CineBook – Your Password Reset Code";

        String html = buildHtml(
            "Password Reset Code",
            "Hi <strong>" + escape(username) + "</strong>,",
            "Use the code below to reset your CineBook password.",
            "<div style='text-align:center;margin:2rem 0'>" +
            "  <div style='display:inline-block;background:#1c1917;border-radius:12px;padding:1.25rem 2.5rem'>" +
            "    <div style='color:#f5c518;font-size:2.5rem;font-weight:700;letter-spacing:.5rem;" +
            "                font-family:monospace'>" + escape(otp) + "</div>" +
            "    <div style='color:#a8a29e;font-size:.78rem;margin-top:.4rem'>Valid for 10 minutes</div>" +
            "  </div>" +
            "</div>" +
            "<p style='font-size:.85rem;color:#78716c;text-align:center'>" +
            "If you did not request this, you can safely ignore this email." +
            "</p>"
        );

        send(toEmail, subject, html);
    }

    // PRIVATE HELPERS

    private void send(String to, String subject, String htmlBody) {
        if (!mailEnabled || mailSender == null) {
            // Development fallback — print to console
            System.out.println("\n==============================");
            System.out.println("📧  EMAIL (console fallback)");
            System.out.println("To:      " + to);
            System.out.println("Subject: " + subject);
            System.out.println("------------------------------");
            // Extract just the OTP / key info from the body for readability
            System.out.println("[HTML body omitted — see actual email for formatting]");
            if (htmlBody.contains("letter-spacing:.5rem")) {
                // Extract OTP digits from the html
                int start = htmlBody.indexOf("monospace'>") + 11;
                int end   = htmlBody.indexOf("</div>", start);
                if (start > 11 && end > start)
                    System.out.println("OTP CODE: " + htmlBody.substring(start, end).trim());
            }
            System.out.println("==============================\n");
            return;
        }

        try {
            MimeMessage msg = mailSender.createMimeMessage();
            MimeMessageHelper helper = new MimeMessageHelper(msg, true, "UTF-8");
            helper.setFrom(fromAddress, "CineBook");
            helper.setTo(to);
            helper.setSubject(subject);
            helper.setText(htmlBody, true);
            mailSender.send(msg);
        } catch (Exception e) {
            System.err.println("⚠ EmailService: failed to send email to " + to
                               + " — " + e.getMessage());
        }
    }

    // Minimal HTML email template matching the CineBook warm light theme
    private String buildHtml(String heading, String greeting,
                             String intro, String body) {
        return "<!DOCTYPE html><html><head>" +
               "<meta charset='UTF-8'>" +
               "<style>body{font-family:'Segoe UI',sans-serif;background:#f5f0e8;margin:0;padding:20px}" +
               ".wrap{max-width:520px;margin:0 auto;background:#fff;border-radius:12px;overflow:hidden;" +
               "      box-shadow:0 4px 24px rgba(0,0,0,.08)}" +
               ".hdr{background:#1c1917;padding:28px 32px;text-align:center}" +
               ".hdr-brand{color:#f5c518;font-size:1.5rem;font-weight:700;letter-spacing:3px}" +
               ".hdr-sub{color:rgba(255,255,255,.4);font-size:.78rem;margin-top:4px}" +
               ".body{padding:28px 32px}" +
               ".heading{font-size:1.1rem;font-weight:700;color:#1c1917;margin-bottom:.5rem}" +
               "p{color:#44403c;font-size:.9rem;line-height:1.6;margin:.5rem 0}" +
               ".ftr{background:#fdfaf6;border-top:1px solid #e8e0d0;padding:16px 32px;" +
               "     text-align:center;color:#a8a29e;font-size:.75rem}" +
               "</style></head><body>" +
               "<div class='wrap'>" +
               "  <div class='hdr'>" +
               "    <div class='hdr-brand'>🎬 CINEBOOK</div>" +
               "    <div class='hdr-sub'>Your movie ticket platform</div>" +
               "  </div>" +
               "  <div class='body'>" +
               "    <div class='heading'>" + heading + "</div>" +
               "    <p>" + greeting + "</p>" +
               "    <p>" + intro + "</p>" +
               body +
               "  </div>" +
               "  <div class='ftr'>This is an automated message from CineBook. " +
               "Please do not reply to this email.</div>" +
               "</div></body></html>";
    }

    // Escapes HTML special characters to prevent injection in email content
    private String escape(String s) {
        if (s == null) return "";
        return s.replace("&", "&amp;")
                .replace("<", "&lt;")
                .replace(">", "&gt;")
                .replace("\"", "&quot;");
    }
}
