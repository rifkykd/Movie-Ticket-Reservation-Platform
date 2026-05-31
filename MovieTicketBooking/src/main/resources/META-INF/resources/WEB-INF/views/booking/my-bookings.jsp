<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"  uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Tickets – CineBook</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Bebas+Neue&family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <style>
        :root{--bg:#07080d;--surface:#0d1117;--card:#0f1520;--border:#1a2035;--border-md:#252f45;--gold:#f5c518;--gold-dim:rgba(245,197,24,.12);--violet:#8b5cf6;--emerald:#10b981;--rose:#f43f5e;--text:#e8edf5;--muted:#8892a4;--dim:#3d4557;--r:12px}
        *{box-sizing:border-box;margin:0;padding:0}
        body{background:var(--bg);color:var(--text);font-family:'Poppins',sans-serif;min-height:100vh}
        body::before{content:'';position:fixed;inset:0;background:radial-gradient(ellipse 70% 50% at 10% 0%,rgba(139,92,246,.06),transparent 55%);pointer-events:none}

        .navbar{position:sticky;top:0;z-index:100;background:rgba(7,8,13,.85);backdrop-filter:blur(20px);border-bottom:1px solid var(--border);padding:0 2rem;height:64px;display:flex;align-items:center;justify-content:space-between}
        .nav-brand{font-family:'Bebas Neue';font-size:1.75rem;letter-spacing:4px;color:var(--gold);text-decoration:none;display:flex;align-items:center;gap:8px}
        .nav-links{display:flex;align-items:center;gap:6px}
        .nav-link{color:var(--muted);font-size:.82rem;text-decoration:none;padding:6px 12px;border-radius:8px;transition:color .2s,background .2s}
        .nav-link:hover{color:var(--text);background:rgba(255,255,255,.05)}
        .nav-link.active{color:var(--gold)}
        .nav-username{color:var(--gold);font-size:.82rem;font-weight:600}

        .page{position:relative;z-index:1;max-width:900px;margin:0 auto;padding:2rem}

        .page-header{display:flex;align-items:center;justify-content:space-between;margin-bottom:2rem;flex-wrap:wrap;gap:.75rem;padding-bottom:1.5rem;border-bottom:1px solid var(--border)}
        .page-title{font-family:'Bebas Neue';font-size:2.2rem;letter-spacing:2px;color:var(--text)}
        .page-sub{color:var(--muted);font-size:.85rem;margin-top:2px}
        .btn-book-new{background:var(--gold);color:#000;font-weight:700;font-size:.82rem;padding:8px 18px;border-radius:9px;text-decoration:none;display:inline-flex;align-items:center;gap:6px;transition:background .15s}
        .btn-book-new:hover{background:#e0b000;color:#000}

        .flash-ok{background:rgba(16,185,129,.1);border:1px solid rgba(16,185,129,.3);color:#34d399;border-radius:var(--r);padding:.65rem 1rem;font-size:.82rem;margin-bottom:1.25rem}
        .flash-err{background:rgba(244,63,94,.1);border:1px solid rgba(244,63,94,.3);color:#fb7185;border-radius:var(--r);padding:.65rem 1rem;font-size:.82rem;margin-bottom:1.25rem}

        /* Ticket card */
        .ticket{background:var(--surface);border:1px solid var(--border);border-radius:var(--r);overflow:hidden;margin-bottom:.9rem;display:flex;transition:border-color .2s,box-shadow .2s}
        .ticket:hover{border-color:var(--border-md);box-shadow:0 6px 24px rgba(0,0,0,.3)}
        .ticket.cancelled{opacity:.5}
        .ticket-stripe{width:5px;flex-shrink:0}
        .ts-confirmed{background:var(--emerald)}
        .ts-cancelled{background:var(--dim)}

        .ticket-body{padding:1.1rem 1.4rem;flex:1;display:flex;justify-content:space-between;align-items:center;flex-wrap:wrap;gap:.75rem}
        .tb-left{}
        .tb-movie{font-family:'Bebas Neue';font-size:1.3rem;letter-spacing:1.5px;color:#fff;margin-bottom:2px}
        .tb-meta{color:var(--muted);font-size:.78rem;display:flex;gap:10px;flex-wrap:wrap;margin-bottom:.5rem}
        .tb-meta span{display:flex;align-items:center;gap:4px}
        .tb-seats{display:flex;flex-wrap:wrap;gap:4px;margin-bottom:.5rem}
        .seat-chip{background:rgba(255,255,255,.05);border:1px solid var(--border);color:var(--muted);font-size:.68rem;padding:2px 7px;border-radius:4px}
        .tb-badges{display:flex;gap:5px;flex-wrap:wrap}
        .badge-confirmed{background:rgba(16,185,129,.1);border:1px solid rgba(16,185,129,.25);color:#34d399;font-size:.65rem;padding:2px 8px;border-radius:4px;font-weight:600}
        .badge-cancelled{background:rgba(255,255,255,.05);border:1px solid var(--border);color:var(--dim);font-size:.65rem;padding:2px 8px;border-radius:4px;font-weight:600}
        .booking-id{font-family:monospace;color:var(--dim);font-size:.7rem}

        .tb-right{text-align:right}
        .tb-price{color:var(--gold);font-family:'Bebas Neue';font-size:1.6rem;letter-spacing:1px;line-height:1}
        .tb-date{color:var(--dim);font-size:.72rem;margin-top:2px;margin-bottom:.5rem}
        .tb-actions{display:flex;gap:6px;justify-content:flex-end}
        .btn-ticket{font-size:.75rem;padding:5px 14px;border-radius:6px;text-decoration:none;border:none;cursor:pointer;display:inline-flex;align-items:center;gap:4px;transition:filter .15s,transform .1s;font-family:'Poppins'}
        .btn-ticket:hover{filter:brightness(1.1);transform:translateY(-1px)}
        .btn-view{background:var(--gold);color:#000;font-weight:700}
        .btn-cancel{background:rgba(244,63,94,.1);color:#fb7185;border:1px solid rgba(244,63,94,.25)}

        .empty-state{text-align:center;padding:5rem 0}
        .empty-icon{font-size:3.5rem;color:var(--dim);margin-bottom:1rem;display:block}
        .empty-title{font-family:'Bebas Neue';font-size:2rem;color:var(--muted);letter-spacing:2px}
    </style>
</head>
<body>
<nav class="navbar">
    <a class="nav-brand" href="${pageContext.request.contextPath}/"><i class="bi bi-film"></i> CINEBOOK</a>
    <div class="nav-links">
        <a href="${pageContext.request.contextPath}/" class="nav-link">Gallery</a>
        <a href="${pageContext.request.contextPath}/showtime/schedule" class="nav-link">Schedule</a>
        <a href="${pageContext.request.contextPath}/booking/my-bookings" class="nav-link active">My Tickets</a>
        <a href="${pageContext.request.contextPath}/payment/my-payments" class="nav-link">My Payments</a>
        <c:if test="${sessionScope.role=='ADMIN'}"><a href="${pageContext.request.contextPath}/booking/all" class="nav-link">All Bookings</a></c:if>
        <c:if test="${not empty sessionScope.username}">
            <span class="nav-username">${sessionScope.username}</span>
            <a href="${pageContext.request.contextPath}/user/profile" class="nav-link">Profile</a>
            <a href="${pageContext.request.contextPath}/user/logout" class="nav-link">Logout</a>
        </c:if>
    </div>
</nav>

<div class="page">
    <c:if test="${not empty successMsg}"><div class="flash-ok"><i class="bi bi-check-circle-fill"></i> ${successMsg}</div></c:if>
    <c:if test="${not empty errorMsg}"><div class="flash-err"><i class="bi bi-exclamation-triangle-fill"></i> ${errorMsg}</div></c:if>

    <div class="page-header">
        <div>
            <div class="page-title"><i class="bi bi-ticket-perforated-fill" style="font-size:1.8rem;vertical-align:middle;margin-right:10px"></i>My Tickets</div>
            <div class="page-sub">${fn:length(bookings)} booking(s) in history</div>
        </div>
        <a href="${pageContext.request.contextPath}/showtime/schedule" class="btn-book-new"><i class="bi bi-plus-circle"></i> Book New Tickets</a>
    </div>

    <c:choose>
        <c:when test="${empty bookings}">
            <div class="empty-state">
                <span class="empty-icon"><i class="bi bi-ticket-perforated"></i></span>
                <div class="empty-title">No Tickets Yet</div>
                <p style="color:var(--dim);font-size:.88rem;margin-top:.5rem">Browse shows and book your first tickets.</p>
                <a href="${pageContext.request.contextPath}/showtime/schedule" style="color:var(--gold);font-size:.88rem;text-decoration:none;display:inline-block;margin-top:.75rem">Browse Today's Shows &rarr;</a>
            </div>
        </c:when>
        <c:otherwise>
            <c:forEach var="b" items="${bookings}">
                <div class="ticket ${b.cancelled?'cancelled':''}">
                    <div class="ticket-stripe ${b.confirmed?'ts-confirmed':'ts-cancelled'}"></div>
                    <div class="ticket-body">
                        <div class="tb-left">
                            <div class="tb-movie">${b.movieTitle}</div>
                            <div class="tb-meta">
                                <span><i class="bi bi-building"></i>${b.hallName}</span>
                                <span><i class="bi bi-calendar3"></i>${b.showDate}</span>
                                <span><i class="bi bi-clock"></i>${b.showTime}</span>
                            </div>
                            <div class="tb-seats">
                                <c:forTokens var="s" items="${b.seats}" delims=","><span class="seat-chip">${s}</span></c:forTokens>
                            </div>
                            <div class="tb-badges">
                                <c:choose>
                                    <c:when test="${b.confirmed}"><span class="badge-confirmed"><i class="bi bi-check-circle-fill"></i> Confirmed</span></c:when>
                                    <c:otherwise><span class="badge-cancelled"><i class="bi bi-x-circle-fill"></i> Cancelled</span></c:otherwise>
                                </c:choose>
                                <span class="booking-id">${b.bookingId}</span>
                            </div>
                        </div>
                        <div class="tb-right">
                            <div class="tb-price">LKR ${b.totalPrice}</div>
                            <div class="tb-date">Booked ${b.bookingDate}</div>
                            <div class="tb-actions">
                                <a href="${pageContext.request.contextPath}/booking/detail/${b.bookingId}" class="btn-ticket btn-view"><i class="bi bi-eye"></i> View</a>
                                <c:if test="${b.confirmed}">
                                    <a href="${pageContext.request.contextPath}/booking/cancel/${b.bookingId}" class="btn-ticket btn-cancel" onclick="return confirm('Cancel booking ${b.bookingId}?')"><i class="bi bi-x-circle"></i> Cancel</a>
                                </c:if>
                            </div>
                        </div>
                    </div>
                </div>
            </c:forEach>
        </c:otherwise>
    </c:choose>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
