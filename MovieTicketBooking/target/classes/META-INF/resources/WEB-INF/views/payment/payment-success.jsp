<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Payment Receipt – CineBook</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Bebas+Neue&family=Libre+Barcode+39&family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <style>
        :root{--bg:#f5f0e8;--surface:#fff;--card:#fdfaf6;--border:#e8e0d0;--border-md:#d4c8b8;--gold:#c9960a;--gold-light:#f5c518;--gold-dim:rgba(201,150,10,.1);--emerald:#059669;--text:#1c1917;--muted:#78716c;--dim:#a8a29e;--r:12px}
        *{box-sizing:border-box;margin:0;padding:0}
        body{background:var(--bg);color:var(--text);font-family:'Poppins',sans-serif;min-height:100vh}
        body::before{content:'';position:fixed;inset:0;background:radial-gradient(ellipse 70% 50% at 50% -10%,rgba(201,150,10,.06),transparent 55%);pointer-events:none}

        .navbar{background:#1c1917;padding:0 2rem;height:60px;display:flex;align-items:center;justify-content:space-between}
        .nav-brand{font-family:'Bebas Neue';font-size:1.6rem;letter-spacing:4px;color:#f5c518;text-decoration:none;display:flex;align-items:center;gap:7px}
        .nav-link{color:rgba(255,255,255,.5);font-size:.82rem;text-decoration:none;padding:5px 12px;border-radius:6px}
        .nav-link:hover{color:rgba(255,255,255,.9)}
        .nav-username{color:#f5c518;font-size:.82rem;font-weight:600}

        .page{max-width:660px;margin:0 auto;padding:2rem}

        /* Steps — all done */
        .steps{display:flex;gap:0;margin-bottom:2rem;border-radius:var(--r);overflow:hidden;border:1px solid var(--border)}
        .step{flex:1;text-align:center;padding:.5rem;font-size:.68rem;font-weight:600;letter-spacing:.8px;text-transform:uppercase;background:#f0fdf4;color:var(--emerald);border-right:1px solid var(--border)}
        .step:last-child{border-right:none}

        /* Success banner */
        .success-banner{text-align:center;margin-bottom:2rem;padding:.5rem 0}
        .success-circle{width:72px;height:72px;border-radius:50%;background:#f0fdf4;border:3px solid #bbf7d0;display:flex;align-items:center;justify-content:center;margin:0 auto 1rem;font-size:1.8rem;color:var(--emerald)}
        .success-title{font-family:'Bebas Neue';font-size:2.2rem;color:var(--text);letter-spacing:2px;margin-bottom:.25rem}
        .success-sub{color:var(--muted);font-size:.88rem}

        /* Receipt */
        .receipt{background:var(--surface);border:1px solid var(--border);border-radius:var(--r);overflow:hidden;box-shadow:0 8px 32px rgba(0,0,0,.08)}
        .receipt-header{background:linear-gradient(135deg,#1c1917,#292524);padding:1.5rem 2rem;position:relative}
        .receipt-header::after{content:'';display:block;height:2px;background:repeating-linear-gradient(90deg,var(--border) 0,var(--border) 10px,transparent 10px,transparent 20px);margin-top:1.25rem}
        .rh-pid{font-family:monospace;color:rgba(255,255,255,.3);font-size:.72rem;margin-bottom:.25rem}
        .rh-movie{font-family:'Bebas Neue';font-size:2rem;letter-spacing:2px;color:#fff}
        .rh-stamp{display:inline-block;border:2px solid #34d399;color:#34d399;font-family:'Bebas Neue';font-size:.9rem;letter-spacing:2px;padding:2px 10px;border-radius:4px;transform:rotate(-4deg);margin-top:.5rem}

        .receipt-body{padding:1.5rem 2rem}
        .detail-row{display:flex;justify-content:space-between;padding:.5rem 0;border-bottom:1px solid var(--border);font-size:.88rem}
        .detail-row:last-of-type{border:none}
        .detail-key{color:var(--muted);font-size:.7rem;font-weight:600;text-transform:uppercase;letter-spacing:.8px}
        .detail-val{color:var(--text);text-align:right;font-weight:500}

        /* Payment block */
        .pay-block{background:var(--card);border:1px solid var(--border);border-radius:8px;padding:1rem;margin-top:1rem}
        .pay-block-label{font-size:.68rem;font-weight:700;text-transform:uppercase;letter-spacing:1px;color:var(--dim);margin-bottom:.6rem;display:flex;align-items:center;gap:5px}
        .price-row{display:flex;justify-content:space-between;font-size:.85rem;padding:.25rem 0}
        .price-total-row{border-top:2px solid var(--border-md);margin-top:.5rem;padding-top:.6rem;font-weight:700;font-size:1rem;color:var(--gold)}
        .promo-badge{background:#fefce8;border:1px solid #fde68a;color:#92400e;font-size:.68rem;padding:2px 8px;border-radius:4px}

        /* Barcode */
        .receipt-footer{background:var(--card);border-top:2px dashed var(--border);padding:1.1rem 2rem;display:flex;align-items:center;justify-content:space-between}
        .barcode{font-family:'Libre Barcode 39',monospace;font-size:2.2rem;color:var(--text);letter-spacing:2px}
        .amount-final{text-align:right}
        .amount-label{font-size:.68rem;color:var(--dim);text-transform:uppercase;letter-spacing:1px}
        .amount-value{font-family:'Bebas Neue';font-size:1.8rem;color:var(--gold);letter-spacing:1px}

        /* Buttons */
        .btn-dark{background:#1c1917;color:#f5c518;font-weight:700;font-size:.85rem;padding:9px 22px;border-radius:9px;text-decoration:none;display:inline-flex;align-items:center;gap:6px;border:none;cursor:pointer;transition:background .15s;font-family:'Poppins'}
        .btn-dark:hover{background:#292524;color:#f5c518}
        .btn-outline{background:var(--surface);color:var(--muted);font-size:.85rem;padding:9px 22px;border-radius:9px;text-decoration:none;display:inline-flex;align-items:center;gap:6px;border:1px solid var(--border);transition:border-color .15s;font-family:'Poppins'}
        .btn-outline:hover{border-color:var(--border-md);color:var(--text)}

        @media print{
            .navbar,.steps,.success-banner,.action-row,.no-print{display:none!important}
            body{background:#fff}
            .receipt{box-shadow:none;border:1px solid #ccc}
            .receipt-header{background:#1c1917!important;-webkit-print-color-adjust:exact}
        }
    </style>
</head>
<body>
<nav class="navbar">
    <a class="nav-brand" href="${pageContext.request.contextPath}/"><i class="bi bi-film"></i> CINEBOOK</a>
    <div style="display:flex;align-items:center;gap:6px">
        <a href="${pageContext.request.contextPath}/booking/my-bookings" class="nav-link">My Tickets</a>
        <a href="${pageContext.request.contextPath}/payment/my-payments" class="nav-link">My Payments</a>
        <c:if test="${not empty sessionScope.username}">
            <span class="nav-username">${sessionScope.username}</span>
            <a href="${pageContext.request.contextPath}/user/logout" class="nav-link">Logout</a>
        </c:if>
    </div>
</nav>

<div class="page">
    <div class="steps no-print">
        <div class="step"><i class="bi bi-check-circle-fill"></i> Select Seats</div>
        <div class="step"><i class="bi bi-check-circle-fill"></i> Confirm</div>
        <div class="step"><i class="bi bi-check-circle-fill"></i> Payment</div>
        <div class="step"><i class="bi bi-check-circle-fill"></i> Receipt</div>
    </div>

    <div class="success-banner no-print">
        <div class="success-circle"><i class="bi bi-check-lg"></i></div>
        <div class="success-title">Payment Confirmed!</div>
        <p class="success-sub">Your booking is confirmed. Save or print this receipt.</p>
    </div>

    <div class="receipt">
        <div class="receipt-header">
            <div class="rh-pid">${payment.paymentId} · ${booking.bookingId}</div>
            <div class="rh-movie">${booking.movieTitle}</div>
            <div class="rh-stamp">&#10003; PAID</div>
        </div>

        <div class="receipt-body">
            <div class="detail-row"><span class="detail-key">Hall</span><span class="detail-val">${booking.hallName}</span></div>
            <div class="detail-row"><span class="detail-key">Date</span><span class="detail-val">${booking.showDate}</span></div>
            <div class="detail-row"><span class="detail-key">Time</span><span class="detail-val">${booking.showTime}</span></div>
            <div class="detail-row"><span class="detail-key">Show Type</span><span class="detail-val">${booking.showTypeLabel}</span></div>
            <div class="detail-row"><span class="detail-key">Seats</span><span class="detail-val" style="font-family:monospace">${booking.seats}</span></div>
            <div class="detail-row"><span class="detail-key">Booked by</span><span class="detail-val">${booking.username}</span></div>
            <div class="detail-row"><span class="detail-key">Payment Date</span><span class="detail-val">${payment.paymentDate}</span></div>

            <div class="pay-block">
                <div class="pay-block-label">
                    <c:choose>
                        <c:when test="${isOnline}"><i class="bi bi-credit-card"></i> Card Payment</c:when>
                        <c:otherwise><i class="bi bi-shop"></i> Counter Payment</c:otherwise>
                    </c:choose>
                </div>
                <c:if test="${isOnline}">
                    <div style="font-size:.82rem;color:var(--muted);margin-bottom:.5rem">
                        ${onlinePayment.cardType} **** **** **** ${onlinePayment.cardLastFour}
                        <span style="font-family:monospace;color:var(--dim);font-size:.7rem;margin-left:8px">${onlinePayment.transactionId}</span>
                    </div>
                </c:if>
                <div class="price-row"><span style="color:var(--muted)">Ticket total</span><span>LKR ${payment.amount}</span></div>
                <c:if test="${payment.discount>0}">
                    <div class="price-row"><span>Promo <span class="promo-badge">${payment.promoCode}</span></span><span style="color:var(--emerald)">− LKR ${payment.discount}</span></div>
                </c:if>
                <div class="price-row price-total-row"><span>Amount Paid</span><span>LKR ${payment.finalAmount}</span></div>
            </div>
        </div>

        <div class="receipt-footer">
            <div class="barcode">*${payment.paymentId}*</div>
            <div class="amount-final">
                <div class="amount-label">Total Paid</div>
                <div class="amount-value">LKR ${payment.finalAmount}</div>
            </div>
        </div>
    </div>

    <div class="d-flex gap-3 justify-content-center mt-4 flex-wrap action-row">
        <button class="btn-outline no-print" onclick="window.print()"><i class="bi bi-printer"></i> Print</button>
        <a href="${pageContext.request.contextPath}/booking/my-bookings" class="btn-dark"><i class="bi bi-ticket-perforated-fill"></i> My Tickets</a>
        <a href="${pageContext.request.contextPath}/" class="btn-outline no-print"><i class="bi bi-film"></i> Gallery</a>
    </div>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
