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
        :root{--bg:#07080d;--surface:#0d1117;--card:#0f1520;--border:#1a2035;--border-md:#252f45;--gold:#f5c518;--gold-dim:rgba(245,197,24,.12);--violet:#8b5cf6;--emerald:#10b981;--text:#e8edf5;--muted:#8892a4;--dim:#3d4557;--r:12px}
        *{box-sizing:border-box;margin:0;padding:0}
        body{background:var(--bg);color:var(--text);font-family:'Poppins',sans-serif;min-height:100vh}
        body::before{content:'';position:fixed;inset:0;background:radial-gradient(ellipse 70% 50% at 80% 10%,rgba(139,92,246,.06),transparent 60%);pointer-events:none;z-index:0}

        .navbar{position:sticky;top:0;z-index:100;background:rgba(7,8,13,.85);backdrop-filter:blur(20px);border-bottom:1px solid var(--border);padding:0 2rem;height:64px;display:flex;align-items:center;justify-content:space-between}
        .nav-brand{font-family:'Bebas Neue';font-size:1.75rem;letter-spacing:4px;color:var(--gold);text-decoration:none;display:flex;align-items:center;gap:8px}
        .nav-links{display:flex;align-items:center;gap:6px}
        .nav-link{color:var(--muted);font-size:.82rem;text-decoration:none;padding:6px 12px;border-radius:8px;transition:color .2s,background .2s}
        .nav-link:hover{color:var(--text);background:rgba(255,255,255,.05)}
        .btn-login{padding:7px 16px;border-radius:8px;border:1px solid var(--border-md);color:var(--muted);font-size:.82rem;text-decoration:none}
        .btn-login:hover{border-color:var(--gold);color:var(--gold)}
        .btn-register{padding:7px 16px;border-radius:8px;background:var(--gold);color:#000;font-size:.82rem;font-weight:700;text-decoration:none}
        .nav-username{color:var(--gold);font-size:.82rem;font-weight:600}

        .page{position:relative;z-index:1;max-width:1100px;margin:0 auto;padding:2rem}

        /* Date picker */
        .date-picker-wrap{background:var(--surface);border:1px solid var(--border);border-radius:var(--r);padding:1.5rem 2rem;margin-bottom:2rem;display:flex;align-items:flex-end;gap:1rem;flex-wrap:wrap}
        .picker-label{color:var(--dim);font-size:.7rem;font-weight:600;text-transform:uppercase;letter-spacing:1.2px;margin-bottom:6px;display:block}
        input[type=date]{background:var(--card);border:1px solid var(--border);border-radius:8px;color:var(--text);font-family:'Poppins';font-size:.88rem;padding:.55rem .9rem;outline:none;transition:border-color .2s}
        input[type=date]:focus{border-color:var(--gold);box-shadow:0 0 0 3px var(--gold-dim)}
        .btn-find{background:var(--gold);color:#000;font-weight:700;font-size:.88rem;border:none;border-radius:8px;padding:.55rem 1.5rem;cursor:pointer;display:flex;align-items:center;gap:6px;transition:background .15s}
        .btn-find:hover{background:#e0b000}

        /* Section header */
        .section-header{display:flex;align-items:center;justify-content:space-between;margin-bottom:1.25rem}
        .section-title{font-family:'Poppins';font-weight:700;font-size:1.1rem;color:var(--text);display:flex;align-items:center;gap:10px}
        .section-title::before{content:'';display:block;width:3px;height:18px;background:var(--gold);border-radius:2px}

        /* Show cards grid */
        .shows-grid{display:grid;grid-template-columns:repeat(auto-fill,minmax(280px,1fr));gap:1rem}

        .show-card{background:var(--surface);border:1px solid var(--border);border-radius:var(--r);overflow:hidden;transition:border-color .2s,transform .2s,box-shadow .2s;display:flex;flex-direction:column}
        .show-card:hover{border-color:var(--border-md);transform:translateY(-3px);box-shadow:0 12px 30px rgba(0,0,0,.4)}

        .sc-header{padding:1.1rem 1.25rem;border-bottom:1px solid var(--border);display:flex;align-items:center;justify-content:space-between}
        .sc-time{background:var(--gold);color:#000;font-family:'Bebas Neue';font-size:1.2rem;letter-spacing:1px;padding:4px 12px;border-radius:7px}
        .type-pill{font-size:.68rem;font-weight:600;padding:3px 10px;border-radius:20px}
        .type-2d{background:rgba(59,130,246,.15);color:#93c5fd;border:1px solid rgba(59,130,246,.25)}
        .type-3d{background:rgba(139,92,246,.15);color:#a78bfa;border:1px solid rgba(139,92,246,.25)}
        .type-imax{background:rgba(244,63,94,.12);color:#fca5a5;border:1px solid rgba(244,63,94,.2)}

        .sc-body{padding:1.1rem 1.25rem;flex:1;display:flex;flex-direction:column}
        .sc-movie{font-family:'Bebas Neue';font-size:1.25rem;letter-spacing:1px;color:#fff;margin-bottom:4px}
        .sc-hall{color:var(--muted);font-size:.78rem;display:flex;align-items:center;gap:5px;margin-bottom:.9rem}
        .sc-seats-bar{height:4px;border-radius:2px;background:var(--border);overflow:hidden;margin-bottom:.5rem}
        .sc-seats-fill{height:100%;background:var(--emerald);border-radius:2px;transition:width .5s}
        .sc-seats-text{color:var(--muted);font-size:.72rem;display:flex;justify-content:space-between;margin-bottom:.9rem}
        .sc-seats-avail{color:#34d399}

        .sc-footer{display:flex;align-items:center;justify-content:space-between;margin-top:auto}
        .sc-price{color:var(--gold);font-family:'Bebas Neue';font-size:1.5rem;letter-spacing:1px}
        .btn-sc-book{background:var(--gold);color:#000;font-weight:700;font-size:.78rem;padding:7px 18px;border-radius:7px;text-decoration:none;display:inline-flex;align-items:center;gap:5px;transition:background .15s,transform .1s}
        .btn-sc-book:hover{background:#e0b000;transform:translateY(-1px);color:#000}
        .btn-sc-full{background:rgba(255,255,255,.04);color:var(--dim);padding:7px 18px;border-radius:7px;font-size:.78rem;border:1px solid var(--border)}

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
        <a href="${pageContext.request.contextPath}/showtime/schedule" class="nav-link" style="color:var(--gold)">Daily Schedule</a>
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
    <!-- Date picker -->
    <form action="${pageContext.request.contextPath}/showtime/schedule" method="get" class="date-picker-wrap">
        <div>
            <label class="picker-label"><i class="bi bi-calendar3"></i>&nbsp; Select Date</label>
            <input type="date" name="date" value="${searchDate}">
        </div>
        <button type="submit" class="btn-find"><i class="bi bi-search"></i> Find Shows</button>
    </form>

    <div class="section-header">
        <div class="section-title">${pageTitle}</div>
        <span style="color:var(--dim);font-size:.72rem;text-transform:uppercase;letter-spacing:1.5px">${fn:length(showtimes)} show(s)</span>
    </div>

    <c:choose>
        <c:when test="${empty showtimes}">
            <div class="empty-state">
                <span class="empty-icon"><i class="bi bi-camera-video-off"></i></span>
                <div class="empty-title">No Shows Today</div>
                <p style="color:var(--dim);font-size:.88rem;margin-top:.5rem">No available showtimes for this date. Try another day.</p>
            </div>
        </c:when>
        <c:otherwise>
            <div class="shows-grid">
                <c:forEach var="s" items="${showtimes}">
                    <c:set var="pct" value="${(s.bookedSeats*100)/s.totalSeats}"/>
                    <div class="show-card">
                        <div class="sc-header">
                            <span class="sc-time">${s.showTime}</span>
                            <c:choose>
                                <c:when test="${s.showType=='STANDARD_2D'}"><span class="type-pill type-2d">Standard 2D</span></c:when>
                                <c:when test="${s.showType=='PREMIUM_3D'}"><span class="type-pill type-3d">Premium 3D</span></c:when>
                                <c:otherwise><span class="type-pill type-imax">IMAX</span></c:otherwise>
                            </c:choose>
                        </div>
                        <div class="sc-body">
                            <div class="sc-movie">${s.movieTitle}</div>
                            <div class="sc-hall"><i class="bi bi-building"></i>${s.hallName}</div>
                            <div class="sc-seats-bar"><div class="sc-seats-fill" style="width:${pct}%"></div></div>
                            <div class="sc-seats-text">
                                <span><span class="sc-seats-avail">${s.availableSeats}</span> seats left</span>
                                <span>${s.bookedSeats} / ${s.totalSeats} booked</span>
                            </div>
                            <div class="sc-footer">
                                <span class="sc-price">LKR ${s.finalPrice}</span>
                                <c:choose>
                                    <c:when test="${s.availableSeats>0}">
                                        <a href="${pageContext.request.contextPath}/showtime/hall-layout/${s.showtimeId}" class="btn-sc-book">
                                            <i class="bi bi-ticket-perforated"></i> Book
                                        </a>
                                    </c:when>
                                    <c:otherwise><span class="btn-sc-full">Sold Out</span></c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </c:otherwise>
    </c:choose>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
