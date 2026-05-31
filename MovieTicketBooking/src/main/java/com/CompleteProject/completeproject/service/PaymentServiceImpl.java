package com.CompleteProject.completeproject.service;

import com.CompleteProject.completeproject.bean.CounterPayment;
import com.CompleteProject.completeproject.bean.OnlinePayment;
import com.CompleteProject.completeproject.bean.Payment;
import com.CompleteProject.completeproject.repository.PaymentRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.util.*;

/*
  PaymentServiceImpl – core payment processing engine.

  OOP Concepts:
    - Polymorphism : processPayment() is called on whichever Payment subclass
                     is created. The same method name executes different logic
                     (card charge vs counter confirmation) without any if/switch.
    - Abstraction  : this class works entirely through the Payment interface;
                     it never casts to OnlinePayment or CounterPayment after
                     construction — only calls processPayment() polymorphically.
 */
@Service
public class PaymentServiceImpl implements PaymentService {

    @Autowired
    private PaymentRepository paymentRepository;

    // Promo code definitions
    // Maps code → discount fraction (0.10 = 10%)
    private static final Map<String, Double> PROMO_CODES;
    static {
        PROMO_CODES = new LinkedHashMap<>();
        PROMO_CODES.put("CINEBOOK10", 0.10);
        PROMO_CODES.put("FIRSTSHOW",  0.15);
        PROMO_CODES.put("WEEKEND20",  0.20);
    }

    // CREATE: Online payment

    @Override
    public Payment processOnlinePayment(String bookingId, String userId,
                                        double amount, String promoCode,
                                        String cardType, String cardLastFour) {

        double discount    = calculateDiscount(amount, promoCode);
        double finalAmount = round2(amount - discount);

        // Build the concrete subclass
        OnlinePayment payment = new OnlinePayment(cardType, cardLastFour);
        fillCommonFields(payment, bookingId, userId, amount, promoCode, discount, finalAmount);

        // Polymorphic call — OnlinePayment.processPayment() runs
        if (!payment.processPayment()) return null;

        paymentRepository.save(payment);
        return payment;
    }

    // CREATE: Counter payment

    @Override
    public Payment processCounterPayment(String bookingId, String userId,
                                         double amount, String promoCode) {

        double discount    = calculateDiscount(amount, promoCode);
        double finalAmount = round2(amount - discount);

        String receiptNo = "RCP" + System.currentTimeMillis() % 100000;
        CounterPayment payment = new CounterPayment("CTR-1", receiptNo);
        fillCommonFields(payment, bookingId, userId, amount, promoCode, discount, finalAmount);

        // Polymorphic call — CounterPayment.processPayment() runs
        if (!payment.processPayment()) return null;

        paymentRepository.save(payment);
        return payment;
    }

    // READ

    @Override
    public Payment getPaymentById(String paymentId) {
        return paymentRepository.findById(paymentId);
    }

    @Override
    public Payment getPaymentByBookingId(String bookingId) {
        return paymentRepository.findByBookingId(bookingId);
    }

    @Override
    public List<Payment> getPaymentsByUser(String userId) {
        List<Payment> list = paymentRepository.findByUserId(userId);
        list.sort((a, b) -> b.getPaymentDate().compareTo(a.getPaymentDate()));
        return list;
    }

    @Override
    public List<Payment> getAllPayments() {
        List<Payment> list = paymentRepository.readAll();
        list.sort((a, b) -> b.getPaymentDate().compareTo(a.getPaymentDate()));
        return list;
    }

    // UPDATE: Refund

    @Override
    public boolean refundPayment(String paymentId, String requestingUserId) {
        Payment payment = paymentRepository.findById(paymentId);
        if (payment == null || payment.isRefunded()) return false;
        if (!payment.getUserId().equals(requestingUserId))  return false;

        payment.setStatus("REFUNDED");
        return paymentRepository.update(payment);
    }

    // DELETE

    @Override
    public boolean deletePayment(String paymentId) {
        return paymentRepository.delete(paymentId);
    }

    // PROMO CODES

    @Override
    public double validatePromoCode(String code) {
        if (code == null || code.isBlank()) return 0.0;
        return PROMO_CODES.getOrDefault(code.trim().toUpperCase(), 0.0);
    }

    @Override
    public Map<String, String> getPromoCodeHints() {
        Map<String, String> hints = new LinkedHashMap<>();
        PROMO_CODES.forEach((code, frac) ->
                hints.put(code, (int)(frac * 100) + "% off"));
        return hints;
    }

    // PRIVATE HELPERS

    private void fillCommonFields(Payment payment, String bookingId, String userId,
                                  double amount, String promoCode,
                                  double discount, double finalAmount) {
        payment.setPaymentId(  paymentRepository.generateNextId());
        payment.setBookingId(  bookingId);
        payment.setUserId(     userId);
        payment.setAmount(     round2(amount));
        payment.setPromoCode(  promoCode == null || promoCode.isBlank() ? "NONE" : promoCode.toUpperCase().trim());
        payment.setDiscount(   round2(discount));
        payment.setFinalAmount(round2(finalAmount));
        payment.setPaymentDate(LocalDate.now().toString());
    }

    private double calculateDiscount(double amount, String promoCode) {
        double fraction = validatePromoCode(promoCode);
        return round2(amount * fraction);
    }

    private double round2(double v) {
        return Math.round(v * 100.0) / 100.0;
    }
}
