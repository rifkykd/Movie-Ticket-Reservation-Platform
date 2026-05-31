package com.CompleteProject.completeproject.service;

import org.springframework.stereotype.Component;

import java.security.SecureRandom;
import java.time.Instant;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

/*
  OtpStore – manages one-time passwords for the forgot password flow

  Stored in memory only (not persisted to disk). If the server restarts,
  any pending OTPs are cleared, users simply request a new one.

  Each username may have only ONE active OTP at a time;
  generating a new one automatically invalidates the previous.

  Expiry - 10 minutes from generation.
 */
@Component
public class OtpStore {

    private static final int    OTP_LENGTH_DIGITS = 6;
    private static final long   EXPIRY_SECONDS    = 600;  // 10 minutes
    private static final int    MAX_ATTEMPTS      = 5;    // brute-force guard

    private final SecureRandom rng = new SecureRandom();

    // Inner record = the OTP value + when it expires + attempt counter
    private static class OtpEntry {
        final String  code;
        final Instant expiresAt;
        int           attempts;

        OtpEntry(String code) {
            this.code      = code;
            this.expiresAt = Instant.now().plusSeconds(EXPIRY_SECONDS);
            this.attempts  = 0;
        }

        boolean isExpired() {
            return Instant.now().isAfter(expiresAt);
        }
    }

    // username -> OtpEntry
    private final Map<String, OtpEntry> store = new ConcurrentHashMap<>();

    /*
     Generates a new 6 digit OTP for the given username, stores it,
     and returns the code so the caller can email it.
     Any previously stored OTP for this username is replaced.
     */
    public String generate(String username) {
        // Zero padded 6 digit number -> 000000 – 999999
        int    num  = rng.nextInt(1_000_000);
        String code = String.format("%06d", num);
        store.put(username.toLowerCase(), new OtpEntry(code));
        return code;
    }

    /*
     Verifies the submitted code against the stored OTP.

     Returns
       VerifyResult.OK            – code matches and is not expired
       VerifyResult.EXPIRED       – entry exists but has timed out
       VerifyResult.WRONG         – code does not match
       VerifyResult.TOO_MANY      – max attempts exceeded
       VerifyResult.NOT_FOUND     – no OTP for this username
     */
    public VerifyResult verify(String username, String submittedCode) {
        OtpEntry entry = store.get(username.toLowerCase());

        if (entry == null)          return VerifyResult.NOT_FOUND;
        if (entry.isExpired()) {
            store.remove(username.toLowerCase());
            return VerifyResult.EXPIRED;
        }
        if (entry.attempts >= MAX_ATTEMPTS) {
            store.remove(username.toLowerCase());
            return VerifyResult.TOO_MANY;
        }

        entry.attempts++;

        if (!entry.code.equals(submittedCode.trim())) {
            return VerifyResult.WRONG;
        }

        // Valid — consume the OTP so it cannot be reused
        store.remove(username.toLowerCase());
        return VerifyResult.OK;
    }

    // Invalidate

    public void invalidate(String username) {
        store.remove(username.toLowerCase());
    }


    public enum VerifyResult {
        OK,
        EXPIRED,
        WRONG,
        TOO_MANY,
        NOT_FOUND;

        public boolean isOk() { return this == OK; }
    }
}
