<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"  uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>All Bookings – CineBook Admin</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Bebas+Neue&family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <style>
        :root{--bg:#07080d;--surface:#0d1117;--card:#0f1520;--border:#1a2035;--border-md:#252f45;--gold:#f5c518;--gold-dim:rgba(245,197,24,.12);--emerald:#10b981;--rose:#f43f5e;--text:#e8edf5;--muted:#8892a4;--dim:#3d4557;--r:12px}
        *{box-sizing:border-box;margin:0;padding:0}
        body{background:var(--bg);color:var(--text);font-family:'Poppins',sans-serif;min-height:100vh}
        body::before{content:'';position:fixed;inset:0;background:radial-gradient(ellipse 60% 40% at 80% 0%,rgba(16,185,129,.04),transparent 55%);pointer-events:none}

        .navbar{position:sticky;top:0;z-index:100;background:rgba(7,8,13,.88);backdrop-filter:blur(20px);border-bottom:1px solid var(--border);padding:0 2rem;height:64px;display:flex;align-items:center;justify-content:space-between}
        .nav-brand{font-family:'Bebas Neue';font-size:1.75rem;letter-spacing:4px;color:var(--gold);text-decoration:none;display:flex;align-items:center;gap:8px}
        .nav-links{display:flex;align-items:center;gap:4px}
        .nav-link{color:var(--muted);font-size:.78rem;text-decoration:none;padding:5px 11px;border-radius:8px;transition:color .2s,background .2s}
        .nav-link:hover,.nav-link.active{color:var(--gold);background:var(--gold-dim)}
        .admin-chip{background:rgba(244,63,94,.12);border:1px solid rgba(244,63,94,.25);color:#fca5a5;font-size:.62rem;font-weight:700;letter-spacing:1px;padding:2px 8px;border-radius:4px;text-transform:uppercase}
        .nav-username{color:var(--gold);font-size:.78rem;font-weight:600}

        .page{position:relative;z-index:1;max-width:1300px;margin:0 auto;padding:2rem}
        .page-title{font-family:'Bebas Neue';font-size:2rem;letter-spacing:2px;color:var(--text);margin-bottom:.25rem}
        .page-sub{color:var(--muted);font-size:.85rem;margin-bottom:2rem}

        /* Stat grid */
        .stat-grid{display:grid;grid-template-columns:repeat(auto-fill,minmax(200px,1fr));gap:1rem;margin-bottom:2rem}
        .stat-card{background:var(--surface);border:1px solid var(--border);border-radius:var(--r);padding:1.25rem;transition:border-color .2s}
        .stat-card:hover{border-color:var(--border-md)}
        .stat-icon{width:38px;height:38px;border-radius:9px;display:flex;align-items:center;justify-content:center;font-size:1rem;margin-bottom:.7rem}
        .stat-num{font-family:'Bebas Neue';font-size:1.9rem;letter-spacing:1px;line-height:1}
        .stat-label{color:var(--muted);font-size:.68rem;font-weight:600;text-transform:uppercase;letter-spacing:1px;margin-top:3px}

        /* Table */
        .table-card{background:var(--surface);border:1px solid var(--border);border-radius:var(--r);overflow:hidden}
        .table-header{padding:1rem 1.5rem;border-bottom:1px solid var(--border);display:flex;align-items:center;justify-content:space-between}
        .table-title{font-weight:600;font-size:.9rem}
        table{width:100%;border-collapse:collapse}
        thead th{background:var(--card);color:var(--muted);font-size:.66rem;font-weight:700;text-transform:uppercase;letter-spacing:.8px;padding:.7rem 1rem;border-bottom:1px solid var(--border);text-align:left}
        tbody tr{border-bottom:1px solid var(--border);transition:background .15s}
        tbody tr:hover{background:var(--card)}
        tbody tr:last-child{border:none}
        td{padding:.7rem 1rem;font-size:.82rem}
        td code{font-size:.72rem;color:var(--muted);background:var(--card);padding:2px 6px;border-radius:4px}
        .b-ok{background:rgba(16,185,129,.1);border:1px solid rgba(16,185,129,.25);color:#34d399;font-size:.62rem;padding:2px 8px;border-radius:4px;font-weight:600}
        .b-cancel{background:rgba(255,255,255,.05);border:1px solid var(--border);color:var(--dim);font-size:.62rem;padding:2px 8px;border-radius:4px;font-weight:600}
        .amount-cell{color:var(--gold);font-weight:700}
        .btn-icon{width:28px;height:28px;display:inline-flex;align-items:center;justify-content:center;border-radius:6px;text-decoration:none;font-size:.8rem;background:var(--card);border:1px solid var(--border);color:var(--muted);transition:background .15s,border-color .15s}
        .btn-icon:hover{background:var(--gold-dim);border-color:rgba(245,197,24,.25);color:var(--gold)}
        .seats-cell{font-family:monospace;font-size:.72rem;color:var(--muted)}
    </style>
</head>
<body>
<nav class="navbar">
    <a class="nav-brand" href="${pageContext.request.contextPath}/"><i class="bi bi-film"></i> CINEBOOK</a>
    <div class="nav-links">
        <a href="${pageContext.request.contextPath}/" class="nav-link">Gallery</a>
        <a href="${pageContext.request.contextPath}/showtime/scheduler" class="nav-link">Scheduler</a>
        <a href="${pageContext.request.contextPath}/booking/all" class="nav-link active">Bookings</a>
        <a href="${pageContext.request.contextPath}/payment/all" class="nav-link">Payments</a>
        <a href="${pageContext.request.contextPath}/review/admin" class="nav-link">Reviews</a>
        <span class="admin-chip">Admin</span>
        <c:if test="${not empty sessionScope.username}">
            <span class="nav-username">${sessionScope.username}</span>
            <a href="${pageContext.request.contextPath}/user/logout" class="nav-link">Logout</a>
        </c:if>
    </div>
</nav>

<div class="page">
    <div class="page-title"><i class="bi bi-ticket-perforated-fill" style="vertical-align:middle;margin-right:8px"></i>All Bookings</div>
    <div class="page-sub">Complete reservation overview</div>

    <div class="stat-grid">
        <div class="stat-card">
            <div class="stat-icon" style="background:var(--gold-dim);color:var(--gold)"><i class="bi bi-ticket-perforated"></i></div>
            <div class="stat-num" style="color:var(--gold)">${fn:length(bookings)}</div>
            <div class="stat-label">Total Bookings</div>
        </div>
        <div class="stat-card">
            <c:set var="confC" value="0"/>
            <c:forEach var="b" items="${bookings}"><c:if test="${b.confirmed}"><c:set var="confC" value="${confC+1}"/></c:if></c:forEach>
            <div class="stat-icon" style="background:rgba(16,185,129,.1);color:#34d399"><i class="bi bi-check-circle-fill"></i></div>
            <div class="stat-num" style="color:#34d399">${confC}</div>
            <div class="stat-label">Confirmed</div>
        </div>
        <div class="stat-card">
            <div class="stat-icon" style="background:rgba(255,255,255,.05);color:var(--muted)"><i class="bi bi-x-circle"></i></div>
            <div class="stat-num" style="color:var(--muted)">${fn:length(bookings)-confC}</div>
            <div class="stat-label">Cancelled</div>
        </div>
    </div>

    <div class="table-card">
        <div class="table-header">
            <span class="table-title">Booking Records</span>
            <span style="color:var(--muted);font-size:.78rem">${fn:length(bookings)} total</span>
        </div>
        <div style="overflow-x:auto">
            <table>
                <thead><tr><th>Booking ID</th><th>Customer</th><th>Movie</th><th>Date &amp; Time</th><th>Seats</th><th>Amount</th><th>Status</th><th>Booked On</th><th></th></tr></thead>
                <tbody>
                    <c:choose>
                        <c:when test="${empty bookings}">
                            <tr><td colspan="9" style="text-align:center;padding:3rem;color:var(--dim)">No bookings yet.</td></tr>
                        </c:when>
                        <c:otherwise>
                            <c:forEach var="b" items="${bookings}">
                                <tr>
                                    <td><code>${b.bookingId}</code></td>
                                    <td style="color:var(--muted)">${b.username}</td>
                                    <td style="font-weight:600">${b.movieTitle}</td>
                                    <td style="color:var(--muted)">${b.showDate} ${b.showTime}</td>
                                    <td class="seats-cell">${b.seats}</td>
                                    <td class="amount-cell">${b.totalPrice}</td>
                                    <td><c:choose><c:when test="${b.confirmed}"><span class="b-ok"><i class="bi bi-check-circle-fill"></i> Confirmed</span></c:when><c:otherwise><span class="b-cancel"><i class="bi bi-x-circle-fill"></i> Cancelled</span></c:otherwise></c:choose></td>
                                    <td style="color:var(--dim);font-size:.75rem">${b.bookingDate}</td>
                                    <td><a href="${pageContext.request.contextPath}/booking/detail/${b.bookingId}" class="btn-icon" title="View Ticket"><i class="bi bi-eye"></i></a></td>
                                </tr>
                            </c:forEach>
                        </c:otherwise>
                    </c:choose>
                </tbody>
            </table>
        </div>
    </div>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
