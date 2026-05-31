<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${pageTitle} – CineBook</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Bebas+Neue&family=Libre+Barcode+39&family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <style>
        :root{
            --bg:#f5f0e8; --surface:#fff; --card:#fdfaf6;
            --border:#e8e0d0; --border-md:#d4c8b8;
            --gold:#c9960a; --gold-light:#f5c518; --gold-dim:rgba(201,150,10,.1);
            --emerald:#059669; --rose:#dc2626;
            --text:#1c1917; --muted:#78716c; --dim:#a8a29e;
            --r:12px;
        }
        *{box-sizing:border-box;margin:0;padding:0}
        body{background:var(--bg);color:var(--text);font-family:'Poppins',sans-serif;min-height:100vh}
        body::before{content:'';position:fixed;inset:0;
            background:radial-gradient(ellipse 70% 50% at 50% -10%,rgba(201,150,10,.06),transparent 55%);
            pointer-events:none}

        .navbar{background:#1c1917;padding:0 2rem;height:60px;display:flex;align-items:center;justify-content:space-between}
        .nav-brand{font-family:'Bebas Neue';font-size:1.6rem;letter-spacing:4px;color:#f5c518;text-decoration:none;display:flex;align-items:center;gap:7px}
        .nav-link{color:rgba(255,255,255,.5);font-size:.82rem;text-decoration:none;padding:5px 12px;border-radius:6px;transition:color .2s}
        .nav-link:hover{color:rgba(255,255,255,.9)}
        .nav-username{color:#f5c518;font-size:.82rem;font-weight:600}

        .page{max-width:620px;margin:0 auto;padding:2rem;position:relative;z-index:1}

        /* Ticket wrapper */
        .ticket{background:var(--surface);border:1px solid var(--border);
                border-radius:var(--r);overflow:hidden;
                box-shadow:0 8px 32px rgba(0,0,0,.09)}

        /* Header */
        .t-header{background:linear-gradient(135deg,#1c1917,#292524);padding:1.75rem 2rem;position:relative}
        .t-header::after{content:'';display:block;height:2px;
            background:repeating-linear-gradient(90deg,rgba(255,255,255,.07) 0,rgba(255,255,255,.07) 10px,transparent 10px,transparent 20px);
            margin-top:1.1rem}
        .t-bid{font-family:monospace;color:rgba(255,255,255,.3);font-size:.7rem;margin-bottom:.3rem}
        .t-movie{font-family:'Bebas Neue';font-size:2.2rem;letter-spacing:2px;color:#fff;line-height:1}

        .t-stamp{display:inline-block;font-family:'Bebas Neue';font-size:.9rem;
                 letter-spacing:3px;padding:3px 10px;border-radius:4px;
                 transform:rotate(-4deg);margin-top:.6rem}
        .stamp-confirmed{border:2px solid #34d399;color:#34d399}
        .stamp-cancelled{border:2px solid var(--dim);color:var(--dim)}

        /* Body */
        .t-body{padding:1.5rem 2rem}
        .t-row{display:flex;justify-content:space-between;padding:.5rem 0;
               border-bottom:1px solid var(--border);font-size:.88rem}
        .t-row:last-of-type{border:none}
        .t-key{color:var(--muted);font-size:.7rem;font-weight:600;
                text-transform:uppercase;letter-spacing:.8px}
        .t-val{color:var(--text);text-align:right;font-weight:500}

        /* Seat table */
        .seat-table{background:var(--card);border:1px solid var(--border);
                    border-radius:8px;padding:1rem;margin-top:1rem}
        .st-label{font-size:.68rem;font-weight:700;text-transform:uppercase;
                  letter-spacing:1px;color:var(--dim);margin-bottom:.6rem}
        .seat-item{display:flex;justify-content:space-between;align-items:center;
                   padding:.35rem 0;border-bottom:1px solid var(--border);font-size:.85rem}
        .seat-item:last-child{border:none}
        .pill-vip{background:#fefce8;border:1px solid #fde68a;color:#92400e;
                  font-size:.68rem;padding:2px 8px;border-radius:4px;font-weight:600;margin-left:6px}
        .pill-std{background:#f0fdf4;border:1px solid #bbf7d0;color:var(--emerald);
                  font-size:.68rem;padding:2px 8px;border-radius:4px;font-weight:600;margin-left:6px}
        .seat-price{color:var(--gold);font-weight:600}

        /* Total */
        .t-total{background:#fefce8;border:1px solid #fde68a;border-radius:8px;
                 padding:1rem 1.25rem;margin-top:1rem;
                 display:flex;justify-content:space-between;align-items:center}
        .t-total-label{color:var(--muted);font-size:.8rem;font-weight:600;text-transform:uppercase;letter-spacing:1px}
        .t-total-value{font-family:'Bebas Neue';font-size:1.8rem;letter-spacing:1px;color:var(--gold)}

        /* Barcode footer */
        .t-footer{background:var(--card);border-top:2px dashed var(--border);
                  padding:1.1rem 2rem;display:flex;align-items:center;justify-content:space-between}
        .barcode{font-family:'Libre Barcode 39',monospace;font-size:2.2rem;color:var(--text);letter-spacing:2px}
        .footer-right{text-align:right}
        .footer-label{font-size:.68rem;color:var(--dim);text-transform:uppercase;letter-spacing:1px}
        .footer-bid{font-family:monospace;font-size:.82rem;color:var(--muted);font-weight:600}

        /* Action buttons */
        .actions{display:flex;gap:.75rem;justify-content:flex-end;margin-top:1.25rem;flex-wrap:wrap}
        .btn-act{padding:9px 20px;border-radius:9px;font-size:.85rem;font-weight:600;
                 text-decoration:none;border:none;cursor:pointer;
                 display:inline-flex;align-items:center;gap:6px;
                 transition:filter .15s,transform .1s;font-family:'Poppins'}
        .btn-act:hover{filter:brightness(.95);transform:translateY(-1px)}
        .btn-back-act{background:var(--surface);color:var(--muted);border:1px solid var(--border)}
        .btn-cancel-act{background:#fef2f2;color:var(--rose);border:1px solid #fecaca}

        @media print{
            .navbar,.actions,.no-print{display:none!important}
            body{background:white}
            .ticket{box-shadow:none;border:1px solid #ccc}
            .t-header{background:#1c1917!important;-webkit-print-color-adjust:exact}
        }
    </style>
</head>
<body>
<nav class="navbar">
    <a class="nav-brand" href="${pageContext.request.contextPath}/"><i class="bi bi-film"></i> CINEBOOK</a>
    <div style="display:flex;align-items:center;gap:6px">
        <a href="${pageContext.request.contextPath}/booking/my-bookings" class="nav-link">&#8592; My Tickets</a>
        <c:if test="${not empty sessionScope.username}">
            <span class="nav-username">${sessionScope.username}</span>
            <a href="${pageContext.request.contextPath}/user/logout" class="nav-link">Logout</a>
        </c:if>
    </div>
</nav>

<div class="page">
    <div class="ticket">

        <!-- Ticket header -->
        <div class="t-header">
            <div class="t-bid">${booking.bookingId}</div>
            <div class="t-movie">${booking.movieTitle}</div>
            <c:choose>
                <c:when test="${booking.confirmed}">
                    <span class="t-stamp stamp-confirmed">&#10003; CONFIRMED</span>
                </c:when>
                <c:otherwise>
                    <span class="t-stamp stamp-cancelled">CANCELLED</span>
                </c:otherwise>
            </c:choose>
        </div>

        <!-- Details -->
        <div class="t-body">
            <div class="t-row"><span class="t-key">Hall</span><span class="t-val">${booking.hallName}</span></div>
            <div class="t-row"><span class="t-key">Date</span><span class="t-val">${booking.showDate}</span></div>
            <div class="t-row"><span class="t-key">Time</span><span class="t-val">${booking.showTime}</span></div>
            <div class="t-row"><span class="t-key">Show Type</span><span class="t-val">${booking.showTypeLabel}</span></div>
            <div class="t-row"><span class="t-key">Booked by</span><span class="t-val">${booking.username}</span></div>
            <div class="t-row"><span class="t-key">Booking Date</span><span class="t-val">${booking.bookingDate}</span></div>

            <!-- Seat breakdown -->
            <div class="seat-table">
                <div class="st-label">Seats (${booking.seatCount})</div>
                <c:forEach var="sd" items="${seatDetails}">
                    <div class="seat-item">
                        <span style="font-weight:600">
                            ${sd.seat}
                            <c:choose>
                                <c:when test="${sd.type == 'VIP'}"><span class="pill-vip">&#9733; VIP</span></c:when>
                                <c:otherwise><span class="pill-std">Standard</span></c:otherwise>
                            </c:choose>
                        </span>
                        <span class="seat-price">LKR ${sd.price}</span>
                    </div>
                </c:forEach>
            </div>

            <!-- Total -->
            <div class="t-total">
                <div>
                    <div class="t-total-label">Total Amount</div>
                    <div style="color:var(--muted);font-size:.75rem;margin-top:2px">${booking.seatCount} seat(s)</div>
                </div>
                <div class="t-total-value">LKR ${booking.totalPrice}</div>
            </div>
        </div>

        <!-- Barcode footer -->
        <div class="t-footer">
            <div class="barcode">*${booking.bookingId}*</div>
            <div class="footer-right">
                <div class="footer-label">Booking ID</div>
                <div class="footer-bid">${booking.bookingId}</div>
            </div>
        </div>

    </div>

    <!-- Actions -->
    <div class="actions">
        <button class="btn-act btn-back-act no-print" onclick="window.print()">
            <i class="bi bi-printer"></i> Print
        </button>
        <a href="${pageContext.request.contextPath}/booking/my-bookings" class="btn-act btn-back-act">
            <i class="bi bi-arrow-left"></i> All Tickets
        </a>
        <c:if test="${booking.confirmed}">
            <a href="${pageContext.request.contextPath}/booking/cancel/${booking.bookingId}"
               class="btn-act btn-cancel-act"
               onclick="return confirm('Cancel this booking? Seats will be released.')">
                <i class="bi bi-x-circle"></i> Cancel Booking
            </a>
        </c:if>
    </div>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
