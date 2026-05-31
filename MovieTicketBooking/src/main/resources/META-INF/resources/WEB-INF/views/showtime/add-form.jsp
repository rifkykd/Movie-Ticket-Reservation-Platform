<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Add Showtime – CineBook Admin</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Bebas+Neue&family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <style>
        :root{--bg:#07080d;--surface:#0d1117;--card:#0f1520;--border:#1a2035;--border-md:#252f45;--gold:#f5c518;--gold-dim:rgba(245,197,24,.12);--text:#e8edf5;--muted:#8892a4;--dim:#3d4557;--r:12px}
        *{box-sizing:border-box;margin:0;padding:0}
        body{background:var(--bg);color:var(--text);font-family:'Poppins',sans-serif;min-height:100vh}
        .navbar{position:sticky;top:0;z-index:100;background:rgba(7,8,13,.88);backdrop-filter:blur(20px);border-bottom:1px solid var(--border);padding:0 2rem;height:64px;display:flex;align-items:center;justify-content:space-between}
        .nav-brand{font-family:'Bebas Neue';font-size:1.75rem;letter-spacing:4px;color:var(--gold);text-decoration:none;display:flex;align-items:center;gap:8px}
        .nav-link{color:var(--muted);font-size:.82rem;text-decoration:none;padding:6px 12px;border-radius:8px;transition:color .2s,background .2s}
        .nav-link:hover{color:var(--text);background:rgba(255,255,255,.05)}
        .nav-username{color:var(--gold);font-size:.82rem;font-weight:600}
        .page{max-width:700px;margin:0 auto;padding:2rem;position:relative;z-index:1}
        .page-title{font-family:'Bebas Neue';font-size:1.9rem;letter-spacing:2px;color:var(--text);margin-bottom:1.75rem;display:flex;align-items:center;gap:10px}
        .form-card{background:var(--surface);border:1px solid var(--border);border-radius:var(--r);padding:1.75rem}
        .field-label{color:var(--muted);font-size:.75rem;font-weight:500;margin-bottom:5px;display:block}
        .input-box{display:flex;align-items:center;background:var(--card);border:1px solid var(--border);border-radius:9px;overflow:hidden;transition:border-color .2s,box-shadow .2s}
        .input-box:focus-within{border-color:var(--gold);box-shadow:0 0 0 3px var(--gold-dim)}
        .input-icon{width:40px;display:flex;align-items:center;justify-content:center;color:var(--dim);font-size:.9rem;flex-shrink:0}
        .input-box input,.input-box select{flex:1;background:transparent;border:none;outline:none;color:var(--text);font-family:'Poppins';font-size:.88rem;padding:.65rem .5rem .65rem 0}
        .input-box input::placeholder{color:var(--dim)}
        .input-box select option{background:#0d1117}
        .section-label{color:var(--dim);font-size:.68rem;font-weight:700;text-transform:uppercase;letter-spacing:1.2px;padding-bottom:.6rem;margin-bottom:1rem;border-bottom:1px solid var(--border);display:flex;align-items:center;gap:7px;margin-top:.25rem}
        .section-label i{color:var(--gold)}
        .price-preview{background:var(--card);border:1px solid var(--border);border-left:3px solid var(--gold);border-radius:var(--r);padding:.75rem 1rem;font-size:.88rem;color:var(--muted);margin-top:.5rem}
        .price-preview strong{color:var(--gold);font-size:1.1rem}
        .btn-submit{background:var(--gold);color:#000;font-weight:700;font-size:.9rem;padding:10px 26px;border-radius:10px;border:none;cursor:pointer;display:inline-flex;align-items:center;gap:7px;transition:background .15s,transform .1s;font-family:'Poppins'}
        .btn-submit:hover{background:#e0b000;transform:translateY(-1px)}
        .btn-cancel{background:rgba(255,255,255,.04);color:var(--muted);font-size:.9rem;padding:10px 22px;border-radius:10px;border:1px solid var(--border);text-decoration:none;display:inline-flex;align-items:center;gap:7px;transition:background .15s}
        .btn-cancel:hover{background:rgba(255,255,255,.07);color:var(--text)}
        .form-text-hint{color:var(--dim);font-size:.7rem;margin-top:3px}
    </style>
</head>
<body>
<nav class="navbar">
    <a class="nav-brand" href="${pageContext.request.contextPath}/"><i class="bi bi-film"></i> CINEBOOK</a>
    <div style="display:flex;align-items:center;gap:6px">
        <a href="${pageContext.request.contextPath}/showtime/scheduler" class="nav-link">&#8592; Scheduler</a>
        <a href="${pageContext.request.contextPath}/" class="nav-link">Gallery</a>
        <c:if test="${not empty sessionScope.username}">
            <span class="nav-username">${sessionScope.username}</span>
            <a href="${pageContext.request.contextPath}/user/logout" class="nav-link">Logout</a>
        </c:if>
    </div>
</nav>

<div class="page">
    <div class="page-title"><i class="bi bi-calendar-plus"></i> Add New Showtime</div>
    <div class="form-card">
        <form action="${pageContext.request.contextPath}/showtime/add" method="post">

            <div class="section-label"><i class="bi bi-film"></i> Movie &amp; Venue</div>

            <div class="mb-3">
                <label class="field-label">Movie</label>
                <div class="input-box">
                    <span class="input-icon"><i class="bi bi-camera-reels"></i></span>
                    <c:choose>
                        <c:when test="${not empty movies}">
                            <select name="movieTitle" required>
                                <option value="">— Select a Movie —</option>
                                <c:forEach var="m" items="${movies}">
                                    <c:choose>
                                    <c:when test="${m.status=='No Longer Showing'}">
                                        <%-- Disabled so admin cannot accidentally select an ended movie --%>
                                        <option value="${m.title}" disabled
                                                style="color:#6b7280;">
                                            ${m.title} — Ended
                                        </option>
                                    </c:when>
                                    <c:when test="${m.status=='Now Showing'}">
                                        <option value="${m.title}">${m.title} ● Now Showing</option>
                                    </c:when>
                                    <c:otherwise>
                                        <option value="${m.title}">${m.title} ○ Coming Soon</option>
                                    </c:otherwise>
                                </c:choose>
                                </c:forEach>
                            </select>
                        </c:when>
                        <c:otherwise>
                            <input type="text" name="movieTitle" placeholder="Enter movie title" required>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>

            <div class="mb-3">
                <label class="field-label">Theater Hall</label>
                <div class="input-box">
                    <span class="input-icon"><i class="bi bi-building"></i></span>
                    <select name="hallId" required>
                        <option value="">— Select a Hall —</option>
                        <c:forEach var="h" items="${halls}">
                            <option value="${h.hallId}">${h.hallName} (${h.totalSeats} seats – ${h.hallType})</option>
                        </c:forEach>
                    </select>
                </div>
            </div>

            <div class="section-label" style="margin-top:1.25rem"><i class="bi bi-clock"></i> Date &amp; Time</div>
            <div class="row g-3 mb-3">
                <div class="col-6">
                    <label class="field-label">Show Date</label>
                    <div class="input-box"><span class="input-icon"><i class="bi bi-calendar3"></i></span><input type="date" name="showDate" required></div>
                </div>
                <div class="col-6">
                    <label class="field-label">Show Time</label>
                    <div class="input-box"><span class="input-icon"><i class="bi bi-clock"></i></span><input type="time" name="showTime" required></div>
                </div>
            </div>

            <div class="section-label" style="margin-top:1.25rem"><i class="bi bi-ticket-perforated"></i> Show Type &amp; Pricing</div>
            <div class="mb-3">
                <label class="field-label">Show Type</label>
                <div class="input-box">
                    <span class="input-icon"><i class="bi bi-camera-video"></i></span>
                    <select name="showType" id="showType" onchange="updatePreview()" required>
                        <option value="">— Select Show Type —</option>
                        <c:forEach var="t" items="${showTypes}">
                            <option value="${t.name()}">${t.label}</option>
                        </c:forEach>
                    </select>
                </div>
                <div class="form-text-hint">Standard 2D ×1.0 &nbsp;|&nbsp; Premium 3D ×2.0 &nbsp;|&nbsp; IMAX ×3.0</div>
            </div>
            <div class="mb-3">
                <label class="field-label">Base Ticket Price (LKR)</label>
                <div class="input-box"><span class="input-icon"><i class="bi bi-currency-dollar"></i></span><input type="number" name="basePrice" id="basePrice" value="500" min="100" step="50" oninput="updatePreview()" required></div>
            </div>
            <div class="price-preview">Final price per seat: <strong id="priceOut">LKR —</strong></div>

            <div class="d-flex gap-3 mt-4">
                <button type="submit" class="btn-submit"><i class="bi bi-save2"></i> Add Showtime</button>
                <a href="${pageContext.request.contextPath}/showtime/scheduler" class="btn-cancel">Cancel</a>
            </div>
        </form>
    </div>
</div>
<script>
const M={STANDARD_2D:1.0,PREMIUM_3D:2.0,IMAX:3.0};
function updatePreview(){
    const t=document.getElementById('showType').value;
    const b=parseFloat(document.getElementById('basePrice').value)||0;
    document.getElementById('priceOut').textContent=M[t]?'LKR '+(b*M[t]).toFixed(2):'LKR —';
}
updatePreview();
</script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
