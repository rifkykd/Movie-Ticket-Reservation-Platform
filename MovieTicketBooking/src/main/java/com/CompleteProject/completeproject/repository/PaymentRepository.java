package com.CompleteProject.completeproject.repository;

import com.CompleteProject.completeproject.bean.Payment;
import com.CompleteProject.completeproject.util.FilePathConstants;
import org.springframework.stereotype.Repository;

import java.io.*;
import java.util.ArrayList;
import java.util.List;

/*
  PaymentRepository – all CRUD operations on payments.txt.

  Uses Payment.fromFileString() factory to deserialise each line into
  the correct concrete subclass (OnlinePayment or CounterPayment).
 */
@Repository
public class PaymentRepository {

    private static final String FILE_PATH = FilePathConstants.PAYMENTS_FILE;

    // READ

    public List<Payment> readAll() {
        List<Payment> list = new ArrayList<>();
        File file = new File(FILE_PATH);
        if (!file.exists()) return list;

        try (BufferedReader reader = new BufferedReader(new FileReader(file))) {
            String line;
            while ((line = reader.readLine()) != null) {
                line = line.trim();
                if (!line.isEmpty()) {
                    Payment p = Payment.fromFileString(line);
                    if (p != null) list.add(p);
                }
            }
        } catch (IOException e) {
            System.err.println("Error reading payments.txt: " + e.getMessage());
        }
        return list;
    }

    private void writeAll(List<Payment> payments) {
        new File("data").mkdirs();
        try (BufferedWriter writer = new BufferedWriter(new FileWriter(FILE_PATH, false))) {
            for (Payment p : payments) {
                writer.write(p.toFileString());
                writer.newLine();
            }
        } catch (IOException e) {
            System.err.println("Error writing payments.txt: " + e.getMessage());
        }
    }

    // FIND

    public Payment findById(String paymentId) {
        return readAll().stream()
                .filter(p -> p.getPaymentId().equals(paymentId))
                .findFirst().orElse(null);
    }

    public Payment findByBookingId(String bookingId) {
        return readAll().stream()
                .filter(p -> p.getBookingId().equals(bookingId))
                .findFirst().orElse(null);
    }

    public List<Payment> findByUserId(String userId) {
        List<Payment> result = new ArrayList<>();
        for (Payment p : readAll())
            if (p.getUserId().equals(userId)) result.add(p);
        return result;
    }

    // WRITE

    public void save(Payment payment) {
        List<Payment> all = readAll();
        all.add(payment);
        writeAll(all);
    }

    public boolean update(Payment updated) {
        List<Payment> all = readAll();
        boolean found = false;
        for (int i = 0; i < all.size(); i++) {
            if (all.get(i).getPaymentId().equals(updated.getPaymentId())) {
                all.set(i, updated);
                found = true;
                break;
            }
        }
        if (found) writeAll(all);
        return found;
    }

    public boolean delete(String paymentId) {
        List<Payment> all = readAll();
        boolean removed = all.removeIf(p -> p.getPaymentId().equals(paymentId));
        if (removed) writeAll(all);
        return removed;
    }

    // ID GENERATOR

    public String generateNextId() {
        List<Payment> all = readAll();
        int max = 0;
        for (Payment p : all) {
            try {
                int num = Integer.parseInt(p.getPaymentId().replace("PAY", ""));
                if (num > max) max = num;
            } catch (NumberFormatException ignored) {}
        }
        return String.format("PAY%03d", max + 1);
    }
}
