<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"  uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Review Moderation – CineBook Admin</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Bebas+Neue&family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <style>
        :root{--bg:#07080d;--surface:#0d1117;--card:#0f1520;--border:#1a2035;--border-md:#252f45;--gold:#f5c518;--gold-dim:rgba(245,197,24,.12);--violet:#8b5cf6;--violet-dim:rgba(139,92,246,.12);--emerald:#10b981;--rose:#f43f5e;--text:#e8edf5;--muted:#8892a4;--dim:#3d4557;--r:12px}
        *{box-sizing:border-box;margin:0;padding:0}
        body{background:var(--bg);color:var(--text);font-family:'Poppins',sans-serif;min-height:100vh}
        body::before{content:'';position:fixed;inset:0;background:radial-gradient(ellipse 60% 40% at 90% 5%,rgba(139,92,246,.05),transparent 55%);pointer-events:none}
        .navbar{position:sticky;top:0;z-index:100;background:rgba(7,8,13,.88);backdrop-filter:blur(20px);border-bottom:1px solid var(--border);padding:0 2rem;height:64px;display:flex;align-items:center;justify-content:space-between}
        .nav-brand{font-family:'Bebas Neue';font-size:1.75rem;letter-spacing:4px;color:var(--gold);text-decoration:none;display:flex;align-items:center;gap:8px}
        .nav-links{display:flex;align-items:center;gap:4px}
        .nav-link{color:var(--muted);font-size:.78rem;text-decoration:none;padding:5px 11px;border-radius:8px;transition:color .2s,background .2s}
        .nav-link:hover,.nav-link.active{color:var(--gold);background:var(--gold-dim)}
        .admin-chip{background:rgba(244,63,94,.12);border:1px solid rgba(244,63,94,.25);color:#fca5a5;font-size:.62rem;font-weight:700;letter-spacing:1px;padding:2px 8px;border-radius:4px;text-transform:uppercase}
        .nav-username{color:var(--gold);font-size:.78rem;font-weight:600}
        .page{position:relative;z-index:1;max-width:1100px;margin:0 auto;padding:2rem}
        .page-header{display:flex;align-items:center;justify-content:space-between;margin-bottom:2rem;flex-wrap:wrap;gap:.75rem}
        .page-title{font-family:'Bebas Neue';font-size:2rem;letter-spacing:2px;color:var(--text)}

        .stat-grid{display:grid;grid-template-columns:repeat(3,1fr);gap:1rem;margin-bottom:2rem}
        .stat-card{background:var(--surface);border:1px solid var(--border);border-radius:var(--r);padding:1.1rem;text-align:center}
        .stat-num{font-family:'Bebas Neue';font-size:1.9rem;line-height:1}
        .stat-label{color:var(--dim);font-size:.68rem;font-weight:600;text-transform:uppercase;letter-spacing:1px;margin-top:3px}

        .filter-bar{display:flex;gap:6px;margin-bottom:1.25rem;flex-wrap:wrap}
        .filter-btn{padding:6px 16px;border:1px solid var(--border);border-radius:20px;font-size:.78rem;cursor:pointer;color:var(--muted);background:none;transition:all .15s;font-family:'Poppins'}
        .filter-btn.active,.filter-btn:hover{border-color:var(--gold);color:var(--gold);background:var(--gold-dim)}

        .flash-ok{background:rgba(16,185,129,.1);border:1px solid rgba(16,185,129,.3);color:#34d399;border-radius:var(--r);padding:.65rem 1rem;font-size:.82rem;margin-bottom:1.25rem}

        .review-row{background:var(--surface);border:1px solid var(--border);border-radius:var(--r);padding:1.1rem 1.25rem;margin-bottom:.65rem;transition:border-color .2s}
        .review-row:hover{border-color:var(--border-md)}
        .review-row.removed{opacity:.4;border-style:dashed}
        .rr-top{display:flex;align-items:flex-start;justify-content:space-between;gap:.75rem;flex-wrap:wrap;margin-bottom:.5rem}
        .rr-author{display:flex;align-items:center;gap:8px}
        .rr-avatar{width:32px;height:32px;border-radius:50%;background:var(--violet-dim);border:1px solid rgba(139,92,246,.2);display:flex;align-items:center;justify-content:center;color:#a78bfa;font-weight:700;font-size:.78rem;flex-shrink:0}
        .rr-name{color:var(--text);font-weight:600;font-size:.85rem}
        .rr-date{color:var(--dim);font-size:.7rem}
        .rr-movie-link{color:var(--gold);font-size:.78rem;text-decoration:none;display:flex;align-items:center;gap:4px}
        .rr-movie-link:hover{color:#e0b000}
        .rr-stars{color:var(--gold);font-size:.9rem;letter-spacing:1px}
        .rr-comment{color:var(--muted);font-size:.84rem;line-height:1.65;margin-top:.4rem}
        .badge-ok{background:rgba(16,185,129,.1);border:1px solid rgba(16,185,129,.25);color:#34d399;font-size:.62rem;padding:2px 8px;border-radius:4px;font-weight:600}
        .badge-removed{background:rgba(244,63,94,.08);border:1px solid rgba(244,63,94,.2);color:#fb7185;font-size:.62rem;padding:2px 8px;border-radius:4px}
        .rr-actions{display:flex;gap:5px;flex-shrink:0}
        .btn-mod{font-size:.72rem;padding:4px 11px;border-radius:6px;text-decoration:none;border:none;cursor:pointer;display:inline-flex;align-items:center;gap:4px;transition:filter .15s;font-family:'Poppins'}
        .btn-mod:hover{filter:brightness(1.15)}
        .btn-hide{background:rgba(245,197,24,.08);color:rgba(245,197,24,.7);border:1px solid rgba(245,197,24,.2)}
        .btn-delete{background:rgba(244,63,94,.08);color:#fb7185;border:1px solid rgba(244,63,94,.2)}
        .empty-state{text-align:center;padding:4rem 0;color:var(--dim)}
    </style>
</head>
<body>
<nav class="navbar">
    <a class="nav-brand" href="${pageContext.request.contextPath}/"><i class="bi bi-film"></i> CINEBOOK</a>
    <div class="nav-links">
        <a href="${pageContext.request.contextPath}/" class="nav-link">Gallery</a>
        <a href="${pageContext.request.contextPath}/showtime/scheduler" class="nav-link">Scheduler</a>
        <a href="${pageContext.request.contextPath}/booking/all" class="nav-link">Bookings</a>
        <a href="${pageContext.request.contextPath}/payment/all" class="nav-link">Payments</a>
        <a href="${pageContext.request.contextPath}/review/admin" class="nav-link active">Reviews</a>
        <span class="admin-chip">Admin</span>
        <c:if test="${not empty sessionScope.username}">
            <span class="nav-username">${sessionScope.username}</span>
            <a href="${pageContext.request.contextPath}/user/logout" class="nav-link">Logout</a>
        </c:if>
    </div>
</nav>

<div class="page">
    <c:if test="${not empty successMsg}"><div class="flash-ok"><i class="bi bi-check-circle-fill"></i> ${successMsg}</div></c:if>
    <div class="page-header">
        <div class="page-title"><i class="bi bi-chat-square-text-fill" style="vertical-align:middle;margin-right:8px"></i>Review Moderation</div>
    </div>

    <div class="stat-grid">
        <div class="stat-card"><div class="stat-num" style="color:var(--gold)">${totalCount}</div><div class="stat-label">Total</div></div>
        <div class="stat-card"><div class="stat-num" style="color:#34d399">${approvedCount}</div><div class="stat-label">Approved</div></div>
        <div class="stat-card"><div class="stat-num" style="color:#fb7185">${removedCount}</div><div class="stat-label">Removed</div></div>
    </div>

    <div class="filter-bar">
        <button class="filter-btn active" onclick="filterReviews('all',this)">All</button>
        <button class="filter-btn" onclick="filterReviews('approved',this)">Approved</button>
        <button class="filter-btn" onclick="filterReviews('removed',this)">Removed</button>
    </div>

    <c:choose>
        <c:when test="${empty reviews}">
            <div class="empty-state"><i class="bi bi-chat-square" style="font-size:3rem;display:block;margin-bottom:.75rem"></i><p>No reviews yet.</p></div>
        </c:when>
        <c:otherwise>
            <c:forEach var="r" items="${reviews}">
                <div class="review-row ${r.removed?'removed':''}" data-status="${r.removed?'removed':'approved'}">
                    <div class="rr-top">
                        <div class="rr-author">
                            <div class="rr-avatar">${fn:toUpperCase(fn:substring(r.username,0,1))}</div>
                            <div>
                                <div style="display:flex;align-items:center;gap:7px;flex-wrap:wrap">
                                    <span class="rr-name">@${r.username}</span>
                                    <span style="color:var(--dim);font-size:.75rem">&#8594;</span>
                                    <a href="${pageContext.request.contextPath}/review/movie?title=${r.movieTitle}" class="rr-movie-link">${r.movieTitle} <i class="bi bi-arrow-up-right" style="font-size:.65rem"></i></a>
                                    <span class="rr-date">${r.reviewDate}</span>
                                    <c:choose>
                                        <c:when test="${r.removed}"><span class="badge-removed"><i class="bi bi-eye-slash-fill"></i> Removed</span></c:when>
                                        <c:otherwise><span class="badge-ok"><i class="bi bi-check-circle-fill"></i> Approved</span></c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                        </div>
                        <div class="rr-actions">
                            <c:if test="${not r.removed}">
                                <a href="${pageContext.request.contextPath}/review/remove/${r.reviewId}?movieTitle=${r.movieTitle}" class="btn-mod btn-hide" onclick="return confirm('Hide this review?')"><i class="bi bi-eye-slash"></i> Hide</a>
                            </c:if>
                            <a href="${pageContext.request.contextPath}/review/delete/${r.reviewId}" class="btn-mod btn-delete" onclick="return confirm('Delete permanently?')"><i class="bi bi-trash3-fill"></i> Delete</a>
                        </div>
                    </div>
                    <div class="rr-stars">${r.starDisplay}</div>
                    <div class="rr-comment">${r.comment}</div>
                </div>
            </c:forEach>
        </c:otherwise>
    </c:choose>
</div>
<script>
function filterReviews(s,tab){
    document.querySelectorAll('.filter-btn').forEach(b=>b.classList.remove('active'));
    tab.classList.add('active');
    document.querySelectorAll('.review-row').forEach(r=>{
        r.style.display=(s==='all'||r.dataset.status===s)?'':'none';
    });
}
</script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
