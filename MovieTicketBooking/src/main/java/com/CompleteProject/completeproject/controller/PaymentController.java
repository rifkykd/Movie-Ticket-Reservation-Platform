package com.CompleteProject.completeproject.controller;

import com.CompleteProject.completeproject.bean.Booking;
import com.CompleteProject.completeproject.bean.OnlinePayment;
import com.CompleteProject.completeproject.bean.Payment;
import com.CompleteProject.completeproject.bean.User;
import com.CompleteProject.completeproject.service.BookingService;
import com.CompleteProject.completeproject.service.PaymentService;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.List;

/*
  PaymentController – manages the checkout and billing flow

  URL map
    GET  /payment/checkout?bookingId=X   -> checkout.jsp  (payment form)
    POST /payment/process                -> process payment, redirect to receipt
    GET  /payment/success/{paymentId}    -> payment-success.jsp  (receipt)
    GET  /payment/my-payments            -> my-payments.jsp
    GET  /payment/refund/{paymentId}     -> refund + redirect
    GET  /payment/all           (admin)  -> all-payments.jsp
 */
@Controller
@RequestMapping("/payment")
public class PaymentController {

    @Autowired
    private PaymentService paymentService;

    @Autowired
    private BookingService bookingService;

    //  CHECKOUT – entry point from BookingController after booking saved

    @GetMapping("/checkout")
    public String showCheckout(@RequestParam String bookingId,
                               HttpSession session, Model model) {

        if (!isLoggedIn(session)) return "redirect:/user/login";

        Booking booking = bookingService.getBookingById(bookingId);
        if (booking == null) return "redirect:/booking/my-bookings";

        // Guard: if payment already exists for this booking, go straight to receipt
        Payment existing = paymentService.getPaymentByBookingId(bookingId);
        if (existing != null)
            return "redirect:/payment/success/" + existing.getPaymentId();

        model.addAttribute("booking",       booking);
        model.addAttribute("promoCodes",    paymentService.getPromoCodeHints());
        model.addAttribute("pageTitle",     "Checkout – " + booking.getMovieTitle());
        return "payment/checkout";
    }

    //  PROCESS PAYMENT (POST from checkout form)

    @PostMapping("/process")
    public String processPayment(@RequestParam String bookingId,
                                 @RequestParam String paymentType,
                                 @RequestParam(required = false, defaultValue = "") String promoCode,
                                 @RequestParam(required = false, defaultValue = "") String cardType,
                                 @RequestParam(required = false, defaultValue = "") String cardNumber,
                                 HttpSession session,
                                 RedirectAttributes redirectAttrs) {

        if (!isLoggedIn(session)) return "redirect:/user/login";

        User user     = (User) session.getAttribute("loggedInUser");
        Booking booking = bookingService.getBookingById(bookingId);

        if (booking == null) {
            redirectAttrs.addFlashAttribute("errorMsg", "Booking not found.");
            return "redirect:/booking/my-bookings";
        }

        double amount = booking.getTotalPrice();
        Payment payment;

        if ("ONLINE".equals(paymentType)) {
            // Extract last 4 digits only — never store the full number
            String lastFour = cardNumber.length() >= 4
                    ? cardNumber.replaceAll("\\s", "").substring(cardNumber.replaceAll("\\s","").length() - 4)
                    : cardNumber;

            payment = paymentService.processOnlinePayment(
                    bookingId, user.getUserId(), amount,
                    promoCode, cardType.isEmpty() ? "VISA" : cardType, lastFour);
        } else {
            payment = paymentService.processCounterPayment(
                    bookingId, user.getUserId(), amount, promoCode);
        }

        if (payment == null) {
            redirectAttrs.addFlashAttribute("errorMsg",
                    "Payment processing failed. Please check your card details and try again.");
            return "redirect:/payment/checkout?bookingId=" + bookingId;
        }

        return "redirect:/payment/success/" + payment.getPaymentId();
    }

    //  PAYMENT SUCCESS / RECEIPT

    @GetMapping("/success/{paymentId}")
    public String paymentSuccess(@PathVariable String paymentId,
                                 HttpSession session, Model model) {

        if (!isLoggedIn(session)) return "redirect:/user/login";

        Payment payment = paymentService.getPaymentById(paymentId);
        if (payment == null) return "redirect:/booking/my-bookings";

        User user = (User) session.getAttribute("loggedInUser");
        // Security - only the owner or admin can view
        if (!payment.getUserId().equals(user.getUserId()) && !isAdmin(session))
            return "redirect:/booking/my-bookings";

        Booking booking = bookingService.getBookingById(payment.getBookingId());

        // Pass extra details for the online payment receipt card
        boolean isOnline = payment instanceof OnlinePayment;

        model.addAttribute("payment",       payment);
        model.addAttribute("booking",       booking);
        model.addAttribute("isOnline",      isOnline);
        if (isOnline) {
            model.addAttribute("onlinePayment", (OnlinePayment) payment);
        }
        model.addAttribute("pageTitle",     "Payment Receipt – " + payment.getPaymentId());
        return "payment/payment-success";
    }

    //  MY PAYMENTS (customer view)

    @GetMapping("/my-payments")
    public String myPayments(HttpSession session, Model model) {
        if (!isLoggedIn(session)) return "redirect:/user/login";

        User user = (User) session.getAttribute("loggedInUser");
        List<Payment> payments = paymentService.getPaymentsByUser(user.getUserId());
        model.addAttribute("payments",   payments);
        model.addAttribute("pageTitle",  "My Payments");
        return "payment/my-payments";
    }

    @GetMapping("/refund/{paymentId}")
    public String refundPayment(@PathVariable String paymentId,
                                HttpSession session,
                                RedirectAttributes redirectAttrs) {

        if (!isLoggedIn(session)) return "redirect:/user/login";

        User user = (User) session.getAttribute("loggedInUser");
        boolean success = paymentService.refundPayment(paymentId, user.getUserId());

        if (success) {
            redirectAttrs.addFlashAttribute("successMsg",
                    "Refund for " + paymentId + " has been processed.");
        } else {
            redirectAttrs.addFlashAttribute("errorMsg",
                    "Refund could not be processed. Payment may already be refunded.");
        }
        return "redirect:/payment/my-payments";
    }

    //  ADMIN – all payments

    @GetMapping("/all")
    public String allPayments(HttpSession session, Model model) {
        if (!isAdmin(session)) return isLoggedIn(session)
                ? "redirect:/movie?action=list" : "redirect:/user/login";

        List<Payment> payments = paymentService.getAllPayments();

        // Revenue stats
        double totalRevenue = payments.stream()
                .filter(Payment::isCompleted)
                .mapToDouble(Payment::getFinalAmount).sum();
        double totalRefunded = payments.stream()
                .filter(Payment::isRefunded)
                .mapToDouble(Payment::getFinalAmount).sum();

        model.addAttribute("payments",      payments);
        model.addAttribute("totalRevenue",  String.format("%.2f", totalRevenue));
        model.addAttribute("totalRefunded", String.format("%.2f", totalRefunded));
        model.addAttribute("pageTitle",     "All Payments");
        return "payment/all-payments";
    }

    // Helpers

    private boolean isLoggedIn(HttpSession session) {
        return session != null && session.getAttribute("loggedInUser") != null;
    }

    private boolean isAdmin(HttpSession session) {
        if (session == null) return false;
        return "ADMIN".equalsIgnoreCase((String) session.getAttribute("role"));
    }
}
