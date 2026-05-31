<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"  uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${pageTitle} – CineBook</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Bebas+Neue&family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <style>
        :root{--bg:#07080d;--surface:#0d1117;--card:#0f1520;--border:#1a2035;--border-md:#252f45;--gold:#f5c518;--gold-dim:rgba(245,197,24,.12);--violet:#8b5cf6;--violet-dim:rgba(139,92,246,.12);--emerald:#10b981;--rose:#f43f5e;--text:#e8edf5;--muted:#8892a4;--dim:#3d4557;--r:12px}
        *{box-sizing:border-box;margin:0;padding:0}
        body{background:var(--bg);color:var(--text);font-family:'Poppins',sans-serif;min-height:100vh}
        body::before{content:'';position:fixed;inset:0;background:radial-gradient(ellipse 70% 50% at 15% -5%,rgba(139,92,246,.07) 0%,transparent 60%),radial-gradient(ellipse 50% 40% at 85% 100%,rgba(245,197,24,.04) 0%,transparent 50%);pointer-events:none;z-index:0}

        /* Navbar */
        .navbar{position:sticky;top:0;z-index:100;background:rgba(7,8,13,.85);backdrop-filter:blur(20px);border-bottom:1px solid var(--border);padding:0 2rem;height:64px;display:flex;align-items:center;justify-content:space-between}
        .nav-brand{font-family:'Bebas Neue';font-size:1.75rem;letter-spacing:4px;color:var(--gold);text-decoration:none;display:flex;align-items:center;gap:8px}
        .nav-links{display:flex;align-items:center;gap:6px}
        .nav-link{color:var(--muted);font-size:.82rem;font-weight:500;text-decoration:none;padding:6px 12px;border-radius:8px;transition:color .2s,background .2s}
        .nav-link:hover{color:var(--text);background:rgba(255,255,255,.05)}
        .btn-login{padding:7px 16px;border-radius:8px;border:1px solid var(--border-md);color:var(--muted);font-size:.82rem;text-decoration:none}
        .btn-login:hover{border-color:var(--gold);color:var(--gold)}
        .btn-register{padding:7px 16px;border-radius:8px;background:var(--gold);color:#000;font-size:.82rem;font-weight:700;text-decoration:none}
        .nav-username{color:var(--gold);font-size:.82rem;font-weight:600}

        /* Page */
        .page{position:relative;z-index:1;max-width:1000px;margin:0 auto;padding:2rem}

        /* Hero */
        .movie-hero{background:linear-gradient(135deg,#0a0f20,#140a28);border:1px solid var(--border);border-radius:var(--r);padding:2rem 2.5rem;margin-bottom:2rem;position:relative;overflow:hidden}
        .movie-hero::before{content:'';position:absolute;inset:0;background:radial-gradient(ellipse 60% 80% at 100% 50%,rgba(139,92,246,.08),transparent);pointer-events:none}
        .hero-label{color:var(--dim);font-size:.7rem;font-weight:600;text-transform:uppercase;letter-spacing:2px;margin-bottom:.4rem}
        .hero-title{font-family:'Bebas Neue';font-size:clamp(2rem,5vw,3.5rem);letter-spacing:2px;color:#fff;line-height:1;margin-bottom:.75rem}
        .hero-meta{color:var(--muted);font-size:.84rem;display:flex;align-items:center;gap:12px;flex-wrap:wrap}
        .hero-dot{width:4px;height:4px;border-radius:50%;background:var(--dim)}

        /* Date group header */
        .date-header{display:flex;align-items:center;gap:10px;margin:1.75rem 0 .75rem;color:var(--dim);font-size:.72rem;font-weight:600;text-transform:uppercase;letter-spacing:1.5px}
        .date-header::after{content:'';flex:1;height:1px;background:var(--border)}

        /* Showtime row card */
        .st-card{background:var(--surface);border:1px solid var(--border);border-radius:var(--r);padding:1.1rem 1.4rem;margin-bottom:.65rem;display:flex;align-items:center;gap:1rem;flex-wrap:wrap;transition:border-color .2s,transform .2s,box-shadow .2s;cursor:default}
        .st-card:hover{border-color:var(--border-md);transform:translateX(4px);box-shadow:0 4px 20px rgba(0,0,0,.3)}

        .time-chip{background:var(--gold);color:#000;font-weight:700;font-family:'Bebas Neue';font-size:1.15rem;letter-spacing:1px;padding:5px 14px;border-radius:8px;white-space:nowrap;min-width:80px;text-align:center}

        .type-pill{font-size:.7rem;font-weight:600;padding:4px 12px;border-radius:20px;white-space:nowrap}
        .type-2d{background:rgba(59,130,246,.15);color:#93c5fd;border:1px solid rgba(59,130,246,.3)}
        .type-3d{background:var(--violet-dim);color:#a78bfa;border:1px solid rgba(139,92,246,.3)}
        .type-imax{background:rgba(244,63,94,.12);color:#fca5a5;border:1px solid rgba(244,63,94,.25)}

        .hall-info{color:var(--muted);font-size:.84rem;display:flex;align-items:center;gap:5px}
        .seats-info{margin-left:auto;display:flex;align-items:center;gap:6px;font-size:.82rem}
        .seats-avail{color:#34d399;font-weight:600}
        .seats-total{color:var(--dim)}

        .price-chip{color:var(--gold);font-family:'Bebas Neue';font-size:1.3rem;letter-spacing:1px;white-space:nowrap}

        .btn-seats{background:var(--gold);color:#000;font-weight:700;font-size:.8rem;padding:8px 20px;border-radius:8px;text-decoration:none;display:inline-flex;align-items:center;gap:5px;border:none;cursor:pointer;transition:background .15s,transform .1s;white-space:nowrap}
        .btn-seats:hover{background:#e0b000;transform:translateY(-1px);color:#000}
        .btn-seats-full{background:rgba(255,255,255,.05);color:var(--dim);padding:8px 20px;border-radius:8px;font-size:.8rem;border:1px solid var(--border)}

        .login-nudge{font-size:.68rem;color:var(--dim);margin-top:3px;text-align:center}
        .login-nudge a{color:var(--violet);text-decoration:none}

        .admin-btns{display:flex;gap:6px}
        .btn-admin-sm{padding:5px 11px;border-radius:6px;font-size:.72rem;font-weight:500;text-decoration:none;border:none;cursor:pointer;display:inline-flex;align-items:center;gap:4px;transition:filter .15s}
        .btn-admin-sm:hover{filter:brightness(1.2)}
        .btn-edit-sm{background:var(--gold-dim);color:var(--gold);border:1px solid rgba(245,197,24,.25)}
        .btn-del-sm{background:rgba(244,63,94,.1);color:#fb7185;border:1px solid rgba(244,63,94,.25)}

        /* Empty */
        .empty-state{text-align:center;padding:5rem 0;color:var(--dim)}
        .empty-icon{font-size:3.5rem;margin-bottom:1rem;display:block;color:var(--dim)}
        .empty-title{font-family:'Bebas Neue';font-size:2rem;color:var(--muted);letter-spacing:2px}
    </style>
</head>
<body>
<nav class="navbar">
    <a class="nav-brand" href="${pageContext.request.contextPath}/"><i class="bi bi-film"></i> CINEBOOK</a>
    <div class="nav-links">
        <a href="${pageContext.request.contextPath}/" class="nav-link">&#8592; Gallery</a>
        <a href="${pageContext.request.contextPath}/showtime/schedule" class="nav-link">Daily Schedule</a>
        <c:if test="${sessionScope.role=='ADMIN'}"><a href="${pageContext.request.contextPath}/showtime/scheduler" class="nav-link">Scheduler</a></c:if>
        <c:choose>
            <c:when test="${not empty sessionScope.username}">
                <a href="${pageContext.request.contextPath}/booking/my-bookings" class="nav-link">My Tickets</a>
                <span class="nav-username">${sessionScope.username}</span>
                <a href="${pageContext.request.contextPath}/user/logout" class="nav-link">Logout</a>
            </c:when>
            <c:otherwise>
                <a href="${pageContext.request.contextPath}/user/login" class="btn-login">Login</a>
                <a href="${pageContext.request.contextPath}/user/register" class="btn-register">Register</a>
            </c:otherwise>
        </c:choose>
    </div>
</nav>

<div class="page">
    <div class="movie-hero">
        <div class="hero-label">Showtimes for</div>
        <div class="hero-title">${movieTitle}</div>
        <div class="hero-meta">
            <span><i class="bi bi-calendar3"></i>&nbsp;${fn:length(showtimes)} showtime(s)</span>
            <c:if test="${sessionScope.role=='ADMIN'}">
                <span class="hero-dot"></span>
                <a href="${pageContext.request.contextPath}/showtime/add"
                   style="color:var(--gold);text-decoration:none;font-size:.8rem;font-weight:600;background:var(--gold-dim);border:1px solid rgba(245,197,24,.25);padding:4px 12px;border-radius:6px;">
                    <i class="bi bi-plus-circle"></i> Add Showtime
                </a>
            </c:if>
        </div>
    </div>

    <%-- Ended-movie warning banner --%>
    <c:if test="${movieEnded}">
        <div style="background:rgba(244,63,94,.1);border:1px solid rgba(244,63,94,.25);border-radius:var(--r);padding:.9rem 1.25rem;margin-bottom:1.25rem;display:flex;align-items:center;gap:10px;font-size:.88rem;color:#fb7185;">
            <i class="bi bi-exclamation-triangle-fill" style="font-size:1.1rem;flex-shrink:0"></i>
            <span><strong>This movie is no longer showing.</strong> Seat booking is disabled for ended movies.</span>
        </div>
    </c:if>
    <c:if test="${param.err == 'ended'}">
        <div style="background:rgba(244,63,94,.1);border:1px solid rgba(244,63,94,.25);border-radius:var(--r);padding:.9rem 1.25rem;margin-bottom:1.25rem;display:flex;align-items:center;gap:10px;font-size:.88rem;color:#fb7185;">
            <i class="bi bi-slash-circle-fill" style="font-size:1.1rem;flex-shrink:0"></i>
            <span><strong>Booking unavailable.</strong> This movie is no longer showing.</span>
        </div>
    </c:if>

    <c:choose>
        <c:when test="${empty showtimes}">
            <div class="empty-state">
                <span class="empty-icon"><i class="bi bi-ticket-perforated"></i></span>
                <div class="empty-title">No Showtimes Yet</div>
                <p style="font-size:.88rem;margin-top:.5rem">No scheduled screenings for <strong style="color:var(--text)">${movieTitle}</strong>.</p>
            </div>
        </c:when>
        <c:otherwise>
            <c:set var="lastDate" value=""/>
            <c:forEach var="s" items="${showtimes}">
                <c:if test="${s.showDate != lastDate}">
                    <div class="date-header"><i class="bi bi-calendar3"></i> ${s.showDate}</div>
                    <c:set var="lastDate" value="${s.showDate}"/>
                </c:if>
                <div class="st-card">
                    <span class="time-chip">${s.showTime}</span>
                    <c:choose>
                        <c:when test="${s.showType=='STANDARD_2D'}"><span class="type-pill type-2d">Standard 2D</span></c:when>
                        <c:when test="${s.showType=='PREMIUM_3D'}"><span class="type-pill type-3d">Premium 3D</span></c:when>
                        <c:otherwise><span class="type-pill type-imax">IMAX</span></c:otherwise>
                    </c:choose>
                    <span class="hall-info"><i class="bi bi-building"></i> ${s.hallName}</span>
                    <div class="seats-info">
                        <c:choose>
                            <c:when test="${s.availableSeats>0}">
                                <span class="seats-avail">${s.availableSeats}</span>
                                <span class="seats-total">/ ${s.totalSeats} seats</span>
                            </c:when>
                            <c:otherwise><span style="color:var(--rose);font-size:.82rem;">Sold Out</span></c:otherwise>
                        </c:choose>
                    </div>
                    <span class="price-chip">LKR ${s.finalPrice}</span>
                    <div>
                        <c:choose>
                            <c:when test="${movieEnded}">
                                <%-- Block booking for ended movies --%>
                                <span class="btn-seats-full" style="background:rgba(244,63,94,.08);color:#fb7185;border:1px solid rgba(244,63,94,.2);">
                                    <i class="bi bi-slash-circle"></i> Booking Closed
                                </span>
                            </c:when>
                            <c:when test="${s.availableSeats>0}">
                                <a href="${pageContext.request.contextPath}/showtime/hall-layout/${s.showtimeId}" class="btn-seats">
                                    <i class="bi bi-grid-3x3-gap"></i> View Seats
                                </a>
                                <c:if test="${empty sessionScope.username}">
                                    <div class="login-nudge"><a href="${pageContext.request.contextPath}/user/login">Login</a> required to book</div>
                                </c:if>
                            </c:when>
                            <c:otherwise><span class="btn-seats-full">Sold Out</span></c:otherwise>
                        </c:choose>
                    </div>
                    <c:if test="${sessionScope.role=='ADMIN'}">
                        <div class="admin-btns">
                            <a href="${pageContext.request.contextPath}/showtime/edit/${s.showtimeId}" class="btn-admin-sm btn-edit-sm"><i class="bi bi-pencil"></i></a>
                            <a href="${pageContext.request.contextPath}/showtime/delete/${s.showtimeId}" class="btn-admin-sm btn-del-sm" onclick="return confirm('Cancel this showtime?')"><i class="bi bi-trash3"></i></a>
                        </div>
                    </c:if>
                </div>
            </c:forEach>
        </c:otherwise>
    </c:choose>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
