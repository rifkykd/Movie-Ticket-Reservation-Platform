<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"  uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Showtime Scheduler – CineBook Admin</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Bebas+Neue&family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <style>
        :root{--bg:#07080d;--surface:#0d1117;--card:#0f1520;--border:#1a2035;--border-md:#252f45;--gold:#f5c518;--gold-dim:rgba(245,197,24,.12);--violet:#8b5cf6;--emerald:#10b981;--rose:#f43f5e;--text:#e8edf5;--muted:#8892a4;--dim:#3d4557;--r:12px}
        *{box-sizing:border-box;margin:0;padding:0}
        body{background:var(--bg);color:var(--text);font-family:'Poppins',sans-serif;min-height:100vh}
        body::before{content:'';position:fixed;inset:0;background:radial-gradient(ellipse 60% 40% at 85% 0%,rgba(139,92,246,.05),transparent 55%);pointer-events:none}

        .navbar{position:sticky;top:0;z-index:100;background:rgba(7,8,13,.88);backdrop-filter:blur(20px);border-bottom:1px solid var(--border);padding:0 2rem;height:64px;display:flex;align-items:center;justify-content:space-between}
        .nav-brand{font-family:'Bebas Neue';font-size:1.75rem;letter-spacing:4px;color:var(--gold);text-decoration:none;display:flex;align-items:center;gap:8px}
        .nav-links{display:flex;align-items:center;gap:4px}
        .nav-link{color:var(--muted);font-size:.78rem;text-decoration:none;padding:5px 11px;border-radius:8px;transition:color .2s,background .2s}
        .nav-link:hover,.nav-link.active{color:var(--gold);background:var(--gold-dim)}
        .admin-chip{background:rgba(244,63,94,.12);border:1px solid rgba(244,63,94,.25);color:#fca5a5;font-size:.62rem;font-weight:700;letter-spacing:1px;padding:2px 8px;border-radius:4px;text-transform:uppercase}
        .nav-username{color:var(--gold);font-size:.78rem;font-weight:600}

        .page{position:relative;z-index:1;max-width:1300px;margin:0 auto;padding:2rem}
        .page-header{display:flex;align-items:center;justify-content:space-between;margin-bottom:2rem;flex-wrap:wrap;gap:.75rem}
        .page-title{font-family:'Bebas Neue';font-size:2rem;letter-spacing:2px;color:var(--text)}
        .btn-add{background:var(--gold);color:#000;font-weight:700;font-size:.85rem;padding:9px 20px;border-radius:9px;text-decoration:none;display:inline-flex;align-items:center;gap:6px;transition:background .15s}
        .btn-add:hover{background:#e0b000;color:#000}

        .flash-ok{background:rgba(16,185,129,.1);border:1px solid rgba(16,185,129,.3);color:#34d399;border-radius:var(--r);padding:.65rem 1rem;font-size:.82rem;margin-bottom:1.25rem}
        .flash-err{background:rgba(244,63,94,.1);border:1px solid rgba(244,63,94,.3);color:#fb7185;border-radius:var(--r);padding:.65rem 1rem;font-size:.82rem;margin-bottom:1.25rem}

        /* Table */
        .table-card{background:var(--surface);border:1px solid var(--border);border-radius:var(--r);overflow:hidden}
        table{width:100%;border-collapse:collapse}
        thead th{background:var(--card);color:var(--muted);font-size:.66rem;font-weight:700;text-transform:uppercase;letter-spacing:.8px;padding:.75rem 1rem;border-bottom:1px solid var(--border);text-align:left}
        tbody tr{border-bottom:1px solid var(--border);transition:background .15s}
        tbody tr:hover{background:var(--card)}
        tbody tr:last-child{border:none}
        td{padding:.75rem 1rem;font-size:.84rem}
        td code{font-size:.72rem;color:var(--muted);background:var(--card);padding:2px 6px;border-radius:4px}

        .type-pill{font-size:.65rem;padding:2px 9px;border-radius:20px;font-weight:600}
        .type-2d{background:rgba(59,130,246,.15);color:#93c5fd;border:1px solid rgba(59,130,246,.25)}
        .type-3d{background:rgba(139,92,246,.15);color:#a78bfa;border:1px solid rgba(139,92,246,.25)}
        .type-imax{background:rgba(244,63,94,.12);color:#fca5a5;border:1px solid rgba(244,63,94,.2)}
        .price-cell{color:var(--gold);font-weight:700}
        .seats-ok{color:#34d399}
        .seats-dim{color:var(--dim)}

        .td-actions{display:flex;gap:5px}
        .btn-icon{width:30px;height:30px;display:inline-flex;align-items:center;justify-content:center;border-radius:7px;text-decoration:none;font-size:.82rem;border:1px solid var(--border);background:var(--card);color:var(--muted);transition:all .15s;cursor:pointer}
        .btn-icon:hover{border-color:var(--border-md);color:var(--text)}
        .btn-icon-blue:hover{background:rgba(59,130,246,.1);border-color:rgba(59,130,246,.3);color:#93c5fd}
        .btn-icon-gold:hover{background:var(--gold-dim);border-color:rgba(245,197,24,.25);color:var(--gold)}
        .btn-icon-red:hover{background:rgba(244,63,94,.1);border-color:rgba(244,63,94,.25);color:#fb7185}

        .movie-link{color:var(--text);text-decoration:none;font-weight:600;display:flex;align-items:center;gap:5px;transition:color .15s}
        .movie-link:hover{color:var(--gold)}
        .empty-row td{text-align:center;padding:3rem;color:var(--dim);font-size:.88rem}
    </style>
</head>
<body>
<nav class="navbar">
    <a class="nav-brand" href="${pageContext.request.contextPath}/"><i class="bi bi-film"></i> CINEBOOK</a>
    <div class="nav-links">
        <a href="${pageContext.request.contextPath}/" class="nav-link">Gallery</a>
        <a href="${pageContext.request.contextPath}/showtime/scheduler" class="nav-link active">Scheduler</a>
        <a href="${pageContext.request.contextPath}/showtime/schedule" class="nav-link">Daily View</a>
        <a href="${pageContext.request.contextPath}/booking/all" class="nav-link">Bookings</a>
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
    <c:if test="${not empty successMsg}"><div class="flash-ok"><i class="bi bi-check-circle-fill"></i> ${successMsg}</div></c:if>
    <c:if test="${not empty errorMsg}"><div class="flash-err"><i class="bi bi-exclamation-triangle-fill"></i> ${errorMsg}</div></c:if>

    <div class="page-header">
        <div>
            <div class="page-title"><i class="bi bi-calendar-week" style="vertical-align:middle;margin-right:8px"></i>Showtime Scheduler</div>
        </div>
        <a href="${pageContext.request.contextPath}/showtime/add" class="btn-add"><i class="bi bi-plus-circle-fill"></i> Add New Showtime</a>
    </div>

    <div class="table-card">
        <div style="overflow-x:auto">
            <table>
                <thead><tr><th>ID</th><th>Movie</th><th>Hall</th><th>Date</th><th>Time</th><th>Type</th><th>Final Price</th><th>Seats</th><th>Actions</th></tr></thead>
                <tbody>
                    <c:choose>
                        <c:when test="${empty showtimes}">
                            <tr class="empty-row"><td colspan="9">No showtimes scheduled. <a href="${pageContext.request.contextPath}/showtime/add" style="color:var(--gold)">Add one now</a>.</td></tr>
                        </c:when>
                        <c:otherwise>
                            <c:forEach var="s" items="${showtimes}">
                                <tr>
                                    <td><code>${s.showtimeId}</code></td>
                                    <td>
                                        <a href="${pageContext.request.contextPath}/showtime/byMovie?title=${s.movieTitle}" class="movie-link">
                                            ${s.movieTitle} <i class="bi bi-arrow-up-right" style="font-size:.7rem;color:var(--dim)"></i>
                                        </a>
                                    </td>
                                    <td style="color:var(--muted)">${s.hallName}</td>
                                    <td style="color:var(--muted)">${s.showDate}</td>
                                    <td><span style="background:var(--gold-dim);color:var(--gold);font-weight:700;padding:2px 9px;border-radius:5px;font-size:.8rem">${s.showTime}</span></td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${s.showType=='STANDARD_2D'}"><span class="type-pill type-2d">2D</span></c:when>
                                            <c:when test="${s.showType=='PREMIUM_3D'}"><span class="type-pill type-3d">3D</span></c:when>
                                            <c:otherwise><span class="type-pill type-imax">IMAX</span></c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td class="price-cell">LKR ${s.finalPrice}</td>
                                    <td><span class="seats-ok">${s.availableSeats}</span><span class="seats-dim"> / ${s.totalSeats}</span></td>
                                    <td>
                                        <div class="td-actions">
                                            <a href="${pageContext.request.contextPath}/showtime/hall-layout/${s.showtimeId}" class="btn-icon btn-icon-blue" title="Hall Layout"><i class="bi bi-grid-3x3-gap"></i></a>
                                            <a href="${pageContext.request.contextPath}/showtime/edit/${s.showtimeId}" class="btn-icon btn-icon-gold" title="Edit"><i class="bi bi-pencil-square"></i></a>
                                            <a href="${pageContext.request.contextPath}/showtime/delete/${s.showtimeId}" class="btn-icon btn-icon-red" title="Cancel" onclick="return confirm('Cancel this showtime?')"><i class="bi bi-trash3"></i></a>
                                        </div>
                                    </td>
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
