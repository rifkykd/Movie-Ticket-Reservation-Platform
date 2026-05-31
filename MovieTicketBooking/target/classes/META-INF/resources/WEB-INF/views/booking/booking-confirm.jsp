<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"  uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Confirm Booking – CineBook</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Bebas+Neue&family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <style>
        :root{
            --bg:#f5f0e8; --surface:#fff; --card:#fdfaf6;
            --border:#e8e0d0; --border-md:#d4c8b8;
            --gold:#c9960a; --gold-light:#f5c518; --gold-dim:rgba(201,150,10,.1);
            --emerald:#059669; --violet:#7c3aed;
            --text:#1c1917; --muted:#78716c; --dim:#a8a29e;
            --r:12px;
        }
        *{box-sizing:border-box;margin:0;padding:0}
        body{background:var(--bg);color:var(--text);font-family:'Poppins',sans-serif;min-height:100vh}
        body::before{content:'';position:fixed;inset:0;
            background:radial-gradient(ellipse 70% 50% at 50% -10%,rgba(201,150,10,.06),transparent 55%);
            pointer-events:none}

        /* Dark navbar for contrast against light page */
        .navbar{background:#1c1917;padding:0 2rem;height:60px;display:flex;align-items:center;justify-content:space-between}
        .nav-brand{font-family:'Bebas Neue';font-size:1.6rem;letter-spacing:4px;color:#f5c518;text-decoration:none;display:flex;align-items:center;gap:7px}
        .nav-link{color:rgba(255,255,255,.5);font-size:.82rem;text-decoration:none;padding:5px 12px;border-radius:6px;transition:color .2s}
        .nav-link:hover{color:rgba(255,255,255,.9)}
        .nav-username{color:#f5c518;font-size:.82rem;font-weight:600}

        .page{max-width:680px;margin:0 auto;padding:2rem;position:relative;z-index:1}

        /* Steps */
        .steps{display:flex;margin-bottom:2rem;border-radius:var(--r);overflow:hidden;border:1px solid var(--border)}
        .step{flex:1;text-align:center;padding:.6rem;font-size:.68rem;font-weight:600;letter-spacing:.8px;
              text-transform:uppercase;background:var(--surface);color:var(--dim);
              border-right:1px solid var(--border)}
        .step:last-child{border-right:none}
        .step.done{background:#f0fdf4;color:var(--emerald)}
        .step.active{background:#fefce8;color:var(--gold)}

        /* Main card */
        .confirm-card{background:var(--surface);border:1px solid var(--border);
                      border-radius:var(--r);overflow:hidden;
                      box-shadow:0 4px 24px rgba(0,0,0,.07);margin-bottom:1.25rem}

        /* Card header */
        .card-header{background:linear-gradient(135deg,#1c1917,#292524);padding:1.5rem 2rem}
        .card-header::after{content:'';display:block;height:2px;
            background:repeating-linear-gradient(90deg,rgba(255,255,255,.06) 0,rgba(255,255,255,.06) 10px,transparent 10px,transparent 20px);
            margin-top:1.1rem}
        .ch-label{color:rgba(255,255,255,.35);font-size:.7rem;font-weight:600;
                  text-transform:uppercase;letter-spacing:2px;margin-bottom:.3rem}
        .ch-movie{font-family:'Bebas Neue';font-size:2rem;letter-spacing:2px;color:#fff;line-height:1}

        /* Type badge */
        .type-badge{display:inline-flex;align-items:center;gap:5px;font-size:.72rem;
                    font-weight:600;padding:3px 10px;border-radius:4px;margin-top:.5rem}
        .type-2d{background:rgba(59,130,246,.15);color:#93c5fd;border:1px solid rgba(59,130,246,.25)}
        .type-3d{background:rgba(139,92,246,.15);color:#c4b5fd;border:1px solid rgba(139,92,246,.25)}
        .type-imax{background:rgba(244,63,94,.12);color:#fca5a5;border:1px solid rgba(244,63,94,.2)}

        /* Detail rows */
        .card-body{padding:1.5rem 2rem}
        .detail-section{margin-bottom:1.25rem}
        .section-label{font-size:.68rem;font-weight:700;text-transform:uppercase;
                       letter-spacing:1.2px;color:var(--dim);margin-bottom:.75rem;
                       display:flex;align-items:center;gap:7px;padding-bottom:.5rem;
                       border-bottom:1px solid var(--border)}
        .section-label i{color:var(--gold)}
        .detail-row{display:flex;justify-content:space-between;padding:.45rem 0;
                    border-bottom:1px solid var(--border);font-size:.88rem}
        .detail-row:last-child{border:none}
        .dk{color:var(--muted)}
        .dv{color:var(--text);font-weight:500;text-align:right}

        /* Seat chips */
        .seat-pills{display:flex;flex-wrap:wrap;gap:6px;padding:.75rem 0 .25rem}
        .pill-vip{background:#fefce8;border:1px solid #fde68a;color:#92400e;
                  font-size:.72rem;padding:4px 10px;border-radius:6px;font-weight:600}
        .pill-std{background:#f0fdf4;border:1px solid #bbf7d0;color:var(--emerald);
                  font-size:.72rem;padding:4px 10px;border-radius:6px;font-weight:600}
        .vip-note{color:var(--dim);font-size:.72rem;margin-top:.5rem;display:flex;align-items:center;gap:5px}

        /* Price summary */
        .price-section{background:var(--card);border:1px solid var(--border);
                       border-radius:8px;padding:1rem 1.25rem;margin-top:.5rem}
        .price-row{display:flex;justify-content:space-between;padding:.3rem 0;font-size:.88rem}
        .price-row span:first-child{color:var(--muted)}
        .price-total{border-top:2px solid var(--border-md);margin-top:.5rem;padding-top:.6rem;
                     display:flex;justify-content:space-between;font-size:1.15rem;
                     font-weight:700;color:var(--text)}
        .price-total span:last-child{color:var(--gold)}

        /* Buttons */
        .btn-confirm{width:100%;padding:.9rem;background:#1c1917;color:#f5c518;
                     font-weight:700;font-size:1rem;border:none;border-radius:var(--r);
                     cursor:pointer;display:flex;align-items:center;justify-content:center;
                     gap:8px;transition:background .15s,transform .1s;font-family:'Poppins'}
        .btn-confirm:hover{background:#292524;transform:translateY(-1px)}
        .btn-back{width:100%;padding:.8rem;background:var(--surface);color:var(--muted);
                  font-size:.9rem;border:1px solid var(--border);border-radius:var(--r);
                  cursor:pointer;display:flex;align-items:center;justify-content:center;
                  gap:8px;transition:background .15s;text-decoration:none;
                  font-family:'Poppins';margin-top:.75rem}
        .btn-back:hover{background:var(--bg);color:var(--text)}

        /* Warning box */
        .info-box{background:#fffbeb;border:1px solid #fde68a;border-radius:8px;
                  padding:.75rem 1rem;font-size:.8rem;color:#92400e;
                  display:flex;align-items:flex-start;gap:8px;margin-bottom:1rem}
        .info-box i{flex-shrink:0;margin-top:1px}
    </style>
</head>
<body>
<nav class="navbar">
    <a class="nav-brand" href="${pageContext.request.contextPath}/"><i class="bi bi-film"></i> CINEBOOK</a>
    <div style="display:flex;align-items:center;gap:6px">
        <a href="${pageContext.request.contextPath}/" class="nav-link">Gallery</a>
        <a href="${pageContext.request.contextPath}/booking/my-bookings" class="nav-link">My Tickets</a>
        <c:if test="${not empty sessionScope.username}">
            <span class="nav-username">${sessionScope.username}</span>
            <a href="${pageContext.request.contextPath}/user/logout" class="nav-link">Logout</a>
        </c:if>
    </div>
</nav>

<div class="page">
    <!-- Steps -->
    <div class="steps">
        <div class="step done"><i class="bi bi-check-circle-fill"></i> Select Seats</div>
        <div class="step active"><i class="bi bi-clipboard-check"></i> Confirm</div>
        <div class="step">Payment</div>
        <div class="step">Receipt</div>
    </div>

    <div class="info-box">
        <i class="bi bi-info-circle-fill"></i>
        <span>Please review your booking details carefully. Once confirmed, you will be directed to payment.</span>
    </div>

    <div class="confirm-card">
        <!-- Header -->
        <div class="card-header">
            <div class="ch-label">Booking Confirmation</div>
            <div class="ch-movie">${showtime.movieTitle}</div>
            <c:choose>
                <c:when test="${showtime.showType == 'STANDARD_2D'}"><span class="type-badge type-2d"><i class="bi bi-display"></i> Standard 2D</span></c:when>
                <c:when test="${showtime.showType == 'PREMIUM_3D'}"><span class="type-badge type-3d"><i class="bi bi-badge-3d"></i> Premium 3D</span></c:when>
                <c:otherwise><span class="type-badge type-imax"><i class="bi bi-fullscreen"></i> IMAX</span></c:otherwise>
            </c:choose>
        </div>

        <div class="card-body">

            <!-- Show details -->
            <div class="detail-section">
                <div class="section-label"><i class="bi bi-camera-reels"></i> Show Details</div>
                <div class="detail-row"><span class="dk">Hall</span><span class="dv">${showtime.hallName}</span></div>
                <div class="detail-row"><span class="dk">Date</span><span class="dv">${showtime.showDate}</span></div>
                <div class="detail-row"><span class="dk">Time</span><span class="dv">${showtime.showTime}</span></div>
            </div>

            <!-- Selected seats -->
            <div class="detail-section">
                <div class="section-label"><i class="bi bi-grid-3x3-gap"></i> Selected Seats (${count})</div>
                <div class="seat-pills">
                    <c:forEach var="sd" items="${seatDetails}">
                        <c:choose>
                            <c:when test="${sd.type == 'VIP'}">
                                <span class="pill-vip">&#9733; ${sd.seat}</span>
                            </c:when>
                            <c:otherwise>
                                <span class="pill-std">${sd.seat}</span>
                            </c:otherwise>
                        </c:choose>
                    </c:forEach>
                </div>
                <div class="vip-note">
                    <i class="bi bi-info-circle"></i>
                    Rows A &amp; B are VIP (1.5× base). Base show price: LKR ${showTypePrice}/seat
                </div>
            </div>

            <!-- Price breakdown -->
            <div class="detail-section">
                <div class="section-label"><i class="bi bi-receipt"></i> Price Breakdown</div>
                <div class="price-section">
                    <c:if test="${stdCount > 0}">
                        <div class="price-row">
                            <span>Standard seats (${stdCount}) × LKR ${showTypePrice}</span>
                            <span style="font-weight:600">LKR ${stdTotal}</span>
                        </div>
                    </c:if>
                    <c:if test="${vipCount > 0}">
                        <div class="price-row">
                            <span style="color:var(--gold)">&#9733; VIP seats (${vipCount}) × LKR ${vipPrice}</span>
                            <span style="font-weight:600;color:var(--gold)">LKR ${vipTotal}</span>
                        </div>
                    </c:if>
                    <div class="price-total">
                        <span>Total Amount</span>
                        <span>LKR ${totalPrice}</span>
                    </div>
                </div>
            </div>

            <!-- Action buttons -->
            <form action="${pageContext.request.contextPath}/booking/confirm" method="post">
                <input type="hidden" name="showtimeId" value="${showtime.showtimeId}">
                <input type="hidden" name="seats"      value="${seats}">
                <button type="submit" class="btn-confirm">
                    <i class="bi bi-ticket-perforated-fill"></i>
                    Confirm &amp; Proceed to Payment — LKR ${totalPrice}
                </button>
            </form>
            <a href="javascript:history.back()" class="btn-back">
                <i class="bi bi-arrow-left"></i> Go Back &amp; Change Seats
            </a>

        </div>
    </div>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
