<%@ page contentType="text/html;charset=UTF-8" %>
<%-- Prevent browser caching so navbar always reflects real session state --%>
<%
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
    response.setHeader("Pragma",        "no-cache");
    response.setDateHeader("Expires",   0);
%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${movie.title} – CineBook</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Bebas+Neue&family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <style>
        :root {
            --bg: #07080d; --surface: #0d1117; --card: #0f1520;
            --border: #1a2035; --border-md: #252f45;
            --gold: #f5c518; --gold-dim: rgba(245,197,24,0.12);
            --violet: #8b5cf6; --violet-dim: rgba(139,92,246,0.12);
            --emerald: #10b981;
            --text: #e8edf5; --muted: #8892a4; --dim: #3d4557;
            --radius: 12px;
        }
        * { box-sizing: border-box; margin: 0; padding: 0; }
        body { background: var(--bg); color: var(--text); font-family: 'Poppins', sans-serif; overflow-x: hidden; }

        /* ── Navbar ── */
        .navbar {
            position: sticky; top: 0; z-index: 100;
            background: rgba(7,8,13,0.82);
            backdrop-filter: blur(20px); -webkit-backdrop-filter: blur(20px);
            border-bottom: 1px solid var(--border);
            padding: 0 2rem; height: 64px;
            display: flex; align-items: center; justify-content: space-between;
        }
        .nav-brand { font-family: 'Bebas Neue'; font-size: 1.75rem; letter-spacing: 4px; color: var(--gold); text-decoration: none; display: flex; align-items: center; gap: 8px; }
        .nav-links { display: flex; align-items: center; gap: 8px; }
        .nav-link  { color: var(--muted); font-size: 0.82rem; font-weight: 500; text-decoration: none; padding: 6px 12px; border-radius: 8px; transition: color 0.2s, background 0.2s; }
        .nav-link:hover { color: var(--text); background: rgba(255,255,255,0.05); }
        .btn-login    { padding: 7px 16px; border-radius: 8px; border: 1px solid var(--border-md); color: var(--muted); font-size: 0.82rem; font-weight: 500; text-decoration: none; }
        .btn-login:hover { border-color: var(--gold); color: var(--gold); }
        .btn-register { padding: 7px 16px; border-radius: 8px; background: var(--gold); color: #000; font-size: 0.82rem; font-weight: 700; text-decoration: none; }
        .btn-register:hover { background: #e0b000; }
        .nav-user-name { color: var(--gold); font-size: 0.82rem; font-weight: 600; }

        /* ── Backdrop blur hero ── */
        .hero-backdrop {
            position: relative; min-height: 480px;
            display: flex; align-items: flex-end;
            overflow: hidden;
        }
        .hero-bg {
            position: absolute; inset: 0;
            background-size: cover; background-position: center;
            filter: blur(28px) brightness(0.35) saturate(1.2);
            transform: scale(1.1);
        }
        .hero-bg-gradient {
            position: absolute; inset: 0;
            background: linear-gradient(to bottom,
                rgba(7,8,13,0.3) 0%,
                rgba(7,8,13,0.5) 50%,
                rgba(7,8,13,1)   100%);
        }
        .hero-content {
            position: relative; z-index: 1;
            width: 100%; max-width: 1200px; margin: 0 auto;
            padding: 2rem 2rem 2.5rem;
            display: flex; gap: 2.5rem; align-items: flex-end;
        }

        /* Poster */
        .poster-wrap { flex-shrink: 0; }
        .poster-img {
            width: 190px; height: 285px; object-fit: cover;
            border-radius: 12px;
            border: 1px solid rgba(255,255,255,0.12);
            box-shadow: 0 20px 60px rgba(0,0,0,0.7);
        }
        .poster-placeholder {
            width: 190px; height: 285px; border-radius: 12px;
            border: 1px dashed var(--border-md);
            background: var(--card);
            display: flex; flex-direction: column;
            align-items: center; justify-content: center;
            color: var(--dim); gap: 10px;
        }

        /* Hero text */
        .hero-info { flex: 1; padding-bottom: 0.5rem; }
        .hero-title {
            font-family: 'Bebas Neue';
            font-size: clamp(2.5rem, 6vw, 4.5rem);
            letter-spacing: 2px; color: white; line-height: 1;
            margin-bottom: 0.75rem;
        }
        .hero-pills { display: flex; flex-wrap: wrap; gap: 8px; margin-bottom: 1rem; }
        .pill {
            padding: 4px 14px; border-radius: 20px;
            font-size: 0.75rem; font-weight: 500;
            background: rgba(255,255,255,0.08);
            border: 1px solid rgba(255,255,255,0.12);
            color: rgba(255,255,255,0.75);
        }
        .pill-gold   { background: var(--gold-dim); border-color: rgba(245,197,24,0.25); color: var(--gold); }
        .pill-green  { background: rgba(16,185,129,0.15); border-color: rgba(16,185,129,0.3); color: #34d399; }
        .pill-violet { background: var(--violet-dim); border-color: rgba(139,92,246,0.25); color: #a78bfa; }
        .pill-gray   { background: rgba(255,255,255,0.05); border-color: var(--border); color: var(--muted); }

        .status-indicator { display: flex; align-items: center; gap: 8px; margin-bottom: 1.25rem; }
        .status-dot { width: 8px; height: 8px; border-radius: 50%; }
        .dot-green  { background: var(--emerald); box-shadow: 0 0 8px var(--emerald); }
        .dot-violet { background: var(--violet); }
        .dot-gray   { background: var(--muted); }
        .status-text { font-size: 0.84rem; font-weight: 500; }

        /* Reviews shortcut */
        .reviews-link {
            display: inline-flex; align-items: center; gap: 6px;
            color: #a78bfa; font-size: 0.8rem; text-decoration: none;
            background: var(--violet-dim); border: 1px solid rgba(139,92,246,0.2);
            padding: 4px 12px; border-radius: 6px;
            transition: background 0.15s;
        }
        .reviews-link:hover { background: rgba(139,92,246,0.2); color: #c4b5fd; }

        /* ── Detail body ── */
        .detail-body { max-width: 1200px; margin: 0 auto; padding: 2rem; }

        /* Info grid */
        .info-grid {
            display: grid; grid-template-columns: 1fr 1fr;
            gap: 0; background: var(--surface);
            border: 1px solid var(--border); border-radius: var(--radius);
            overflow: hidden; margin-bottom: 1.5rem;
        }
        .info-cell {
            padding: 1rem 1.25rem;
            border-bottom: 1px solid var(--border);
            border-right: 1px solid var(--border);
        }
        .info-cell:nth-child(even) { border-right: none; }
        .info-cell:nth-last-child(-n+2) { border-bottom: none; }
        .info-key { color: var(--dim); font-size: 0.68rem; font-weight: 600; text-transform: uppercase; letter-spacing: 1px; margin-bottom: 4px; }
        .info-val { color: var(--text); font-size: 0.9rem; font-weight: 500; }



        /* Action buttons */
        .action-row { display: flex; gap: 10px; flex-wrap: wrap; }
        .btn-action {
            padding: 10px 22px; border-radius: 10px; font-size: 0.85rem;
            font-weight: 600; text-decoration: none; border: none; cursor: pointer;
            display: inline-flex; align-items: center; gap: 7px;
            transition: transform 0.15s, filter 0.15s;
            font-family: 'Poppins';
        }
        .btn-action:hover { transform: translateY(-2px); filter: brightness(1.1); }
        .btn-back      { background: rgba(255,255,255,0.06); color: var(--muted); border: 1px solid var(--border-md); }
        .btn-showtimes { background: rgba(16,185,129,0.15); color: #34d399; border: 1px solid rgba(16,185,129,0.3); }
        .btn-reviews   { background: var(--violet-dim); color: #a78bfa; border: 1px solid rgba(139,92,246,0.25); }
        .btn-edit      { background: var(--gold-dim); color: var(--gold); border: 1px solid rgba(245,197,24,0.25); }
    </style>
</head>
<body>

<!-- Navbar -->
<nav class="navbar">
    <a class="nav-brand" href="${pageContext.request.contextPath}/">
        <i class="bi bi-film"></i> CINEBOOK
    </a>
    <div class="nav-links">
        <a href="${pageContext.request.contextPath}/" class="nav-link">Gallery</a>
        <c:if test="${sessionScope.role == 'ADMIN'}">
            <a href="${pageContext.request.contextPath}/movie?action=adminForm" class="nav-link">+ Add Movie</a>
        </c:if>
        <c:choose>
            <c:when test="${not empty sessionScope.username}">
                <a href="${pageContext.request.contextPath}/booking/my-bookings" class="nav-link">My Tickets</a>
                <span class="nav-user-name">${sessionScope.username}</span>
                <a href="${pageContext.request.contextPath}/user/profile" class="nav-link">Profile</a>
                <a href="${pageContext.request.contextPath}/user/logout"  class="nav-link">Logout</a>
            </c:when>
            <c:otherwise>
                <a href="${pageContext.request.contextPath}/user/login"    class="btn-login">Login</a>
                <a href="${pageContext.request.contextPath}/user/register" class="btn-register">Register</a>
            </c:otherwise>
        </c:choose>
    </div>
</nav>

<c:if test="${not empty movie}">

    <!-- ── Backdrop hero ─────────────────────────────────────────────────── -->
    <div class="hero-backdrop">
        <c:if test="${not empty movie.imagePath}">
            <div class="hero-bg"
                 style="background-image: url('${pageContext.request.contextPath}/movie-image/${movie.imagePath}');">
            </div>
        </c:if>
        <c:if test="${empty movie.imagePath}">
            <div class="hero-bg" style="background: linear-gradient(135deg,#0d1a35,#1a0d35);"></div>
        </c:if>
        <div class="hero-bg-gradient"></div>

        <div class="hero-content">
            <!-- Poster -->
            <div class="poster-wrap">
                <c:choose>
                    <c:when test="${not empty movie.imagePath}">
                        <img src="${pageContext.request.contextPath}/movie-image/${movie.imagePath}"
                             alt="${movie.title}" class="poster-img">
                    </c:when>
                    <c:otherwise>
                        <div class="poster-placeholder">
                            <i class="bi bi-film" style="font-size:2.5rem;"></i>
                            <span style="font-size:0.72rem;">No Poster</span>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>

            <!-- Info -->
            <div class="hero-info">
                <div class="hero-pills">
                    <span class="pill">${movie.genre}</span>
                    <span class="pill">${movie.language}</span>
                    <span class="pill">${movie.duration} min</span>
                    <span class="pill pill-gold">${movie.rating}</span>
                    <c:if test="${movie.extraAttribute != 'N/A'}">
                        <span class="pill pill-violet">${movie.extraAttribute}</span>
                    </c:if>
                </div>

                <h1 class="hero-title">${movie.title}</h1>

                <div class="status-indicator">
                    <c:choose>
                        <c:when test="${movie.status == 'Now Showing'}">
                            <span class="status-dot dot-green"></span>
                            <span class="status-text" style="color:#34d399;">Now Showing</span>
                        </c:when>
                        <c:when test="${movie.status == 'Coming Soon'}">
                            <span class="status-dot dot-violet"></span>
                            <span class="status-text" style="color:#a78bfa;">Coming Soon</span>
                        </c:when>
                        <c:otherwise>
                            <span class="status-dot dot-gray"></span>
                            <span class="status-text" style="color:var(--muted);">No Longer Showing</span>
                        </c:otherwise>
                    </c:choose>
                </div>

                <a href="${pageContext.request.contextPath}/review/movie?title=${movie.title}"
                   class="reviews-link">
                    <i class="bi bi-star-fill"></i> See Reviews &amp; Ratings
                </a>
            </div>
        </div>
    </div>

    <!-- ── Detail body ────────────────────────────────────────────────────── -->
    <div class="detail-body">

        <!-- Info grid -->
        <div class="info-grid">
            <div class="info-cell"><div class="info-key">Movie ID</div><div class="info-val" style="font-family:monospace; color:var(--dim); font-size:0.82rem;">${movie.id}</div></div>
            <div class="info-cell"><div class="info-key">Type</div><div class="info-val">${movie.type}</div></div>
            <div class="info-cell"><div class="info-key">Genre</div><div class="info-val">${movie.genre}</div></div>
            <div class="info-cell"><div class="info-key">Duration</div><div class="info-val">${movie.duration} minutes</div></div>
            <div class="info-cell"><div class="info-key">Language</div><div class="info-val">${movie.language}</div></div>
            <div class="info-cell"><div class="info-key">Age Rating</div><div class="info-val">${movie.rating}</div></div>
            <div class="info-cell"><div class="info-key">Status</div><div class="info-val">${movie.status}</div></div>
            <c:choose>
                <c:when test="${movie.extraAttribute != 'N/A'}">
                    <div class="info-cell">
                        <div class="info-key">
                            <c:choose>
                                <c:when test="${movie.type == 'ACTION'}">Action Intensity</c:when>
                                <c:when test="${movie.type == 'COMEDY'}">Humor Style</c:when>
                                <c:otherwise>Extra</c:otherwise>
                            </c:choose>
                        </div>
                        <div class="info-val">${movie.extraAttribute}</div>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="info-cell"><div class="info-key">Extra</div><div class="info-val" style="color:var(--dim);">—</div></div>
                </c:otherwise>
            </c:choose>
        </div>



        <!-- Action buttons -->


        <div class="action-row">
            <a href="${pageContext.request.contextPath}/" class="btn-action btn-back">
                <i class="bi bi-arrow-left"></i> Back
            </a>
            <a href="${pageContext.request.contextPath}/showtime/byMovie?title=${movie.title}"
               class="btn-action btn-showtimes">
                <i class="bi bi-ticket-perforated"></i> Showtimes
            </a>
            <a href="${pageContext.request.contextPath}/review/movie?title=${movie.title}"
               class="btn-action btn-reviews">
                <i class="bi bi-star"></i> Reviews
            </a>
            <c:if test="${sessionScope.role == 'ADMIN'}">
                <a href="${pageContext.request.contextPath}/movie?action=edit&id=${movie.id}"
                   class="btn-action btn-edit">
                    <i class="bi bi-pencil"></i> Edit Movie
                </a>
            </c:if>
        </div>

    </div>

</c:if>

<c:if test="${empty movie}">
    <div style="text-align:center; padding:6rem 2rem;">
        <p style="color:var(--muted); font-size:1rem;">Movie not found.</p>
        <a href="${pageContext.request.contextPath}/" style="color:var(--gold); text-decoration:none;">&#8592; Back to Gallery</a>
    </div>
</c:if>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
