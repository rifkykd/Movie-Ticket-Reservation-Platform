package com.CompleteProject.completeproject.service;

import com.CompleteProject.completeproject.bean.Payment;

import java.util.List;
import java.util.Map;

/*
  PaymentService – all payment and billing operations
 */
public interface PaymentService {

    /*
      CREATE – processes and saves an online (card) payment
      @return the saved Payment, or null if processing failed
     */
    Payment processOnlinePayment(String bookingId, String userId,
                                 double amount, String promoCode,
                                 String cardType, String cardLastFour);

    /*
      CREATE – processes and saves a counter (cash) payment.
      @return the saved Payment, or null if processing failed
     */
    Payment processCounterPayment(String bookingId, String userId,
                                  double amount, String promoCode);

    // READ – single payment by its ID
    Payment getPaymentById(String paymentId);

    // READ – payment for a specific booking (one-to-one)
    Payment getPaymentByBookingId(String bookingId);

    // READ – all payments for a customer (My Payments page)
    List<Payment> getPaymentsByUser(String userId);

    // READ (admin) – every payment in the system
    List<Payment> getAllPayments();

    /*
      UPDATE – refunds a completed payment.
      Sets status to REFUNDED. Should be called alongside booking cancellation.
     */
    boolean refundPayment(String paymentId, String requestingUserId);

    /*
      DELETE – removes a failed or expired payment record.
      Admin-only operation.
     */
    boolean deletePayment(String paymentId);

    /*
      READ – validates a promo code and returns the discount percentage (0–1).
      Returns 0.0 if the code is invalid or empty.

      Available codes:
        CINEBOOK10 → 10%
        FIRSTSHOW  → 15%
        WEEKEND20  → 20%
     */
    double validatePromoCode(String code);

    // Returns the map of all valid promo codes and their labels, for the UI
    Map<String, String> getPromoCodeHints();
}
