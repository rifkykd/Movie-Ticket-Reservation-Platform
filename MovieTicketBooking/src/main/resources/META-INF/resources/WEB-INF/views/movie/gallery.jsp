<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c"  uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>CineBook – Discover Movies</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Bebas+Neue&family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <style>
        /* ── Design tokens ── */
        :root {
            --bg:          #07080d;
            --surface:     #0d1117;
            --card:        #0f1520;
            --border:      #1a2035;
            --border-md:   #252f45;
            --gold:        #f5c518;
            --gold-dim:    rgba(245,197,24,0.15);
            --violet:      #8b5cf6;
            --violet-dim:  rgba(139,92,246,0.15);
            --emerald:     #10b981;
            --emerald-dim: rgba(16,185,129,0.15);
            --rose:        #f43f5e;
            --text:        #e8edf5;
            --muted:       #8892a4;
            --dim:         #3d4557;
            --radius:      12px;
        }

        * { box-sizing: border-box; margin: 0; padding: 0; }

        body {
            background: var(--bg);
            color: var(--text);
            font-family: 'Poppins', sans-serif;
            font-weight: 400;
            min-height: 100vh;
            overflow-x: hidden;
        }

        /* ── Ambient background ── */
        body::before {
            content: '';
            position: fixed; inset: 0; z-index: 0;
            background:
                radial-gradient(ellipse 80% 50% at 20% -10%, rgba(139,92,246,0.08) 0%, transparent 60%),
                radial-gradient(ellipse 60% 40% at 80% 100%, rgba(245,197,24,0.05) 0%, transparent 50%);
            pointer-events: none;
        }

        /* ── Glass Navbar ── */
        .navbar {
            position: sticky; top: 0; z-index: 100;
            background: rgba(7,8,13,0.82);
            backdrop-filter: blur(20px);
            -webkit-backdrop-filter: blur(20px);
            border-bottom: 1px solid var(--border);
            padding: 0 2rem;
            height: 64px;
            display: flex; align-items: center; justify-content: space-between;
        }
        .nav-brand {
            font-family: 'Bebas Neue';
            font-size: 1.75rem;
            letter-spacing: 4px;
            color: var(--gold);
            text-decoration: none;
            display: flex; align-items: center; gap: 8px;
        }
        .nav-brand i { font-size: 1.4rem; }
        .nav-links { display: flex; align-items: center; gap: 8px; }
        .nav-link {
            color: var(--muted);
            font-size: 0.82rem;
            font-weight: 500;
            letter-spacing: 0.3px;
            text-decoration: none;
            padding: 6px 14px;
            border-radius: 8px;
            transition: color 0.2s, background 0.2s;
        }
        .nav-link:hover { color: var(--text); background: rgba(255,255,255,0.05); }
        .btn-login {
            padding: 7px 18px; border-radius: 8px;
            border: 1px solid var(--border-md);
            color: var(--muted); font-size: 0.82rem; font-weight: 500;
            text-decoration: none; background: transparent;
            transition: all 0.2s;
        }
        .btn-login:hover { border-color: var(--gold); color: var(--gold); }
        .btn-register {
            padding: 7px 18px; border-radius: 8px;
            background: var(--gold); color: #000;
            font-size: 0.82rem; font-weight: 700;
            text-decoration: none; transition: all 0.2s;
        }
        .btn-register:hover { background: #e0b000; transform: translateY(-1px); }
        .nav-user-name { color: var(--gold); font-size: 0.82rem; font-weight: 600; }

        /* ── Page wrapper ── */
        .page { position: relative; z-index: 1; padding: 2rem; max-width: 1440px; margin: 0 auto; }

        /* ── Section headers ── */
        .section-header {
            display: flex; align-items: center; justify-content: space-between;
            margin-bottom: 1.25rem;
        }
        .section-title {
            font-family: 'Poppins'; font-weight: 700;
            font-size: 1.1rem; color: var(--text);
            display: flex; align-items: center; gap: 10px;
        }
        .section-title::before {
            content: '';
            display: block; width: 3px; height: 18px;
            background: var(--gold); border-radius: 2px;
        }
        .section-count {
            font-size: 0.72rem; color: var(--dim);
            text-transform: uppercase; letter-spacing: 1.5px;
        }

        /* ── Search bar ── */
        .search-wrap {
            background: var(--surface);
            border: 1px solid var(--border);
            border-radius: var(--radius);
            padding: 1.25rem 1.5rem;
            margin-bottom: 2.5rem;
            transition: border-color 0.2s;
        }
        .search-wrap:focus-within { border-color: var(--border-md); }

        .form-control, .form-select {
            background: var(--bg) !important;
            color: var(--text) !important;
            border: 1px solid var(--border) !important;
            border-radius: 8px !important;
            font-size: 0.88rem;
            font-family: 'Poppins';
            padding: 0.6rem 0.9rem;
            transition: border-color 0.2s, box-shadow 0.2s;
        }
        .form-control:focus, .form-select:focus {
            border-color: var(--gold) !important;
            box-shadow: 0 0 0 3px var(--gold-dim) !important;
        }
        .form-control::placeholder { color: var(--dim) !important; }
        .form-select option { background: #0d1117; }
        .form-label {
            color: var(--dim); font-size: 0.7rem;
            font-weight: 600; letter-spacing: 1.2px;
            text-transform: uppercase; margin-bottom: 6px;
        }
        .btn-search {
            background: var(--gold); color: #000;
            font-weight: 700; font-size: 0.88rem;
            border: none; border-radius: 8px;
            width: 100%; padding: 0.6rem;
            transition: background 0.2s, transform 0.1s;
            display: flex; align-items: center; justify-content: center; gap: 6px;
        }
        .btn-search:hover { background: #e0b000; transform: translateY(-1px); }

        /* ── NOW SHOWING hero strip ── */
        .hero-strip {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
            gap: 1rem;
            margin-bottom: 3rem;
        }
        .hero-card {
            position: relative;
            border-radius: var(--radius);
            overflow: hidden;
            aspect-ratio: 16/9;
            cursor: pointer;
            border: 1px solid var(--border);
            transition: transform 0.3s ease, border-color 0.3s;
        }
        .hero-card:hover { transform: scale(1.02); border-color: var(--gold); }
        .hero-card img, .hero-card-placeholder {
            width: 100%; height: 100%; object-fit: cover;
            display: block; transition: transform 0.5s ease;
        }
        .hero-card:hover img { transform: scale(1.05); }
        .hero-card-placeholder {
            background: linear-gradient(135deg, #0d1a35, #1a0d35);
            display: flex; flex-direction: column;
            align-items: center; justify-content: center;
            color: var(--dim); gap: 8px; font-size: 0.75rem;
        }
        .hero-card-overlay {
            position: absolute; inset: 0;
            background: linear-gradient(to top, rgba(7,8,13,0.95) 0%, rgba(7,8,13,0.4) 50%, transparent 100%);
        }
        .hero-card-content {
            position: absolute; bottom: 0; left: 0; right: 0;
            padding: 1.25rem;
        }
        .hero-card-title {
            font-family: 'Bebas Neue'; font-size: 1.5rem;
            letter-spacing: 1.5px; color: white;
            line-height: 1; margin-bottom: 6px;
        }
        .hero-card-meta { color: rgba(255,255,255,0.6); font-size: 0.75rem; }
        .hero-card-actions {
            display: flex; gap: 8px; margin-top: 10px;
            opacity: 0; transform: translateY(8px);
            transition: opacity 0.25s, transform 0.25s;
        }
        .hero-card:hover .hero-card-actions { opacity: 1; transform: translateY(0); }

        /* ── Standard movie grid ── */
        .movie-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(200px, 1fr));
            gap: 1.25rem;
        }

        /* ── Cinematic movie card ── */
        .movie-card {
            position: relative;
            border-radius: var(--radius);
            overflow: hidden;
            border: 1px solid var(--border);
            background: var(--card);
            cursor: pointer;
            transition: transform 0.3s ease, border-color 0.3s ease,
                        box-shadow 0.3s ease;
            aspect-ratio: 2/3;
        }
        .movie-card:hover {
            transform: translateY(-6px) scale(1.02);
            border-color: var(--gold);
            box-shadow: 0 20px 50px rgba(0,0,0,0.6),
                        0 0 0 1px var(--gold-dim),
                        0 0 30px rgba(245,197,24,0.1);
        }
        .movie-card-poster {
            position: absolute; inset: 0;
            width: 100%; height: 100%; object-fit: cover;
            transition: transform 0.5s ease;
        }
        .movie-card:hover .movie-card-poster { transform: scale(1.06); }
        .movie-card-placeholder {
            position: absolute; inset: 0;
            background: linear-gradient(160deg, #0d1a35 0%, #1a0d35 100%);
            display: flex; flex-direction: column;
            align-items: center; justify-content: center;
            color: var(--dim); gap: 8px;
        }

        /* Gradient overlay — always present */
        .movie-card-overlay {
            position: absolute; inset: 0;
            background: linear-gradient(
                to top,
                rgba(7,8,13,1)    0%,
                rgba(7,8,13,0.85) 35%,
                rgba(7,8,13,0.15) 65%,
                transparent       100%
            );
            transition: background 0.3s;
        }
        .movie-card:hover .movie-card-overlay {
            background: linear-gradient(
                to top,
                rgba(7,8,13,1)    0%,
                rgba(7,8,13,0.92) 50%,
                rgba(7,8,13,0.3)  75%,
                transparent       100%
            );
        }

        /* Top-left status badge */
        .status-badge {
            position: absolute; top: 10px; left: 10px;
            font-size: 0.6rem; font-weight: 700;
            letter-spacing: 0.8px; text-transform: uppercase;
            padding: 3px 9px; border-radius: 4px;
            backdrop-filter: blur(8px);
        }
        .status-now    { background: rgba(16,185,129,0.25); color: #34d399; border: 1px solid rgba(16,185,129,0.4); }
        .status-coming { background: rgba(139,92,246,0.25); color: #a78bfa; border: 1px solid rgba(139,92,246,0.4); }
        .status-ended  { background: rgba(255,255,255,0.07); color: var(--muted); border: 1px solid var(--border); }

        /* Genre badge top-right */
        .genre-badge {
            position: absolute; top: 10px; right: 10px;
            font-size: 0.6rem; font-weight: 600;
            padding: 3px 9px; border-radius: 4px;
            backdrop-filter: blur(8px);
            background: rgba(7,8,13,0.6);
            border: 1px solid var(--border-md);
            color: var(--muted);
        }

        /* Bottom content area */
        .movie-card-content {
            position: absolute; bottom: 0; left: 0; right: 0;
            padding: 1rem;
        }
        .mc-title {
            font-family: 'Bebas Neue';
            font-size: 1.1rem; letter-spacing: 1px;
            color: white; line-height: 1.1; margin-bottom: 3px;
        }
        .mc-meta { color: var(--muted); font-size: 0.7rem; margin-bottom: 10px; }

        /* Action buttons revealed on hover */
        .mc-actions {
            display: flex; gap: 6px; flex-wrap: wrap;
            opacity: 0; transform: translateY(10px);
            transition: opacity 0.25s ease, transform 0.25s ease;
        }
        .movie-card:hover .mc-actions { opacity: 1; transform: translateY(0); }

        .btn-card {
            font-size: 0.72rem; font-weight: 600;
            padding: 5px 12px; border-radius: 6px;
            text-decoration: none; border: none; cursor: pointer;
            transition: transform 0.1s, filter 0.15s;
            display: inline-flex; align-items: center; gap: 4px;
        }
        .btn-card:hover { transform: translateY(-1px); filter: brightness(1.1); }
        .btn-details   { background: var(--gold); color: #000; }
        .btn-showtimes { background: var(--emerald-dim); color: #34d399; border: 1px solid rgba(16,185,129,0.3); }
        .btn-admin-edit{ background: rgba(139,92,246,0.15); color: #a78bfa; border: 1px solid rgba(139,92,246,0.3); }
        .btn-admin-del { background: rgba(244,63,94,0.12); color: #fb7185; border: 1px solid rgba(244,63,94,0.25); }

        /* ── Flash messages ── */
        .flash-success { background: rgba(16,185,129,0.1); border: 1px solid rgba(16,185,129,0.3); color: #34d399; border-radius: var(--radius); padding: 0.75rem 1rem; margin-bottom: 1.5rem; font-size: 0.88rem; }
        .flash-error   { background: rgba(244,63,94,0.1);  border: 1px solid rgba(244,63,94,0.3);  color: #fb7185; border-radius: var(--radius); padding: 0.75rem 1rem; margin-bottom: 1.5rem; font-size: 0.88rem; }

        /* ── Empty state ── */
        .empty-state { text-align: center; padding: 6rem 0; }
        .empty-icon { font-size: 3.5rem; color: var(--dim); margin-bottom: 1rem; display: block; }
        .empty-title { font-family: 'Bebas Neue'; font-size: 2rem; color: var(--muted); letter-spacing: 2px; }
        .empty-sub { color: var(--dim); font-size: 0.88rem; margin-top: 0.5rem; }

        /* ── Divider ── */
        .section-divider { height: 1px; background: var(--border); margin: 2.5rem 0; }

        /* ── Scrollbar ── */
        ::-webkit-scrollbar { width: 6px; }
        ::-webkit-scrollbar-track { background: var(--bg); }
        ::-webkit-scrollbar-thumb { background: var(--border-md); border-radius: 3px; }
    </style>
</head>
<body>

<!-- ── Glass Navbar ─────────────────────────────────────────────────────── -->
<nav class="navbar">
    <a class="nav-brand" href="${pageContext.request.contextPath}/">
        <i class="bi bi-film"></i> CINEBOOK
    </a>
    <div class="nav-links">
        <a href="${pageContext.request.contextPath}/"                  class="nav-link">Gallery</a>
        <a href="${pageContext.request.contextPath}/showtime/schedule" class="nav-link">Daily Schedule</a>

        <%-- Admin-only management links --%>
        <c:if test="${sessionScope.role == 'ADMIN'}">
            <a href="${pageContext.request.contextPath}/showtime/scheduler" class="nav-link">Scheduler</a>
            <a href="${pageContext.request.contextPath}/booking/all"        class="nav-link">All Bookings</a>
            <a href="${pageContext.request.contextPath}/payment/all"        class="nav-link">All Payments</a>
            <a href="${pageContext.request.contextPath}/review/admin"       class="nav-link">Reviews</a>
            <a href="${pageContext.request.contextPath}/movie?action=adminForm"
               style="background:var(--gold-dim); color:var(--gold); border:1px solid rgba(245,197,24,0.25);"
               class="nav-link">+ Add Movie</a>
        </c:if>

        <%-- Customer-only links (hidden from admin to avoid duplicate Payments confusion) --%>
        <c:if test="${sessionScope.role != 'ADMIN' and not empty sessionScope.username}">
            <a href="${pageContext.request.contextPath}/booking/my-bookings" class="nav-link">My Tickets</a>
            <a href="${pageContext.request.contextPath}/payment/my-payments" class="nav-link">My Payments</a>
        </c:if>

        <c:choose>
            <c:when test="${not empty sessionScope.username}">
                <a href="${pageContext.request.contextPath}/user/profile"
                   class="nav-link" style="display:flex; align-items:center; gap:6px;">
                    <span style="width:26px; height:26px; border-radius:50%; background:var(--gold-dim); border:1px solid var(--gold); display:flex; align-items:center; justify-content:center; color:var(--gold); font-size:0.72rem; font-weight:700; flex-shrink:0;">
                        ${fn:toUpperCase(fn:substring(sessionScope.username,0,1))}
                    </span>
                    <span class="nav-user-name">${sessionScope.username}</span>
                </a>
                <a href="${pageContext.request.contextPath}/user/logout" class="nav-link">Logout</a>
            </c:when>
            <c:otherwise>
                <a href="${pageContext.request.contextPath}/user/login"    class="btn-login">Login</a>
                <a href="${pageContext.request.contextPath}/user/register" class="btn-register">Register</a>
            </c:otherwise>
        </c:choose>
    </div>
</nav>

<div class="page">

    <!-- Flash messages -->
    <c:if test="${not empty param.msg}">
        <div class="flash-success"><i class="bi bi-check-circle-fill"></i> ${param.msg}</div>
    </c:if>
    <c:if test="${not empty error}">
        <div class="flash-error"><i class="bi bi-exclamation-triangle-fill"></i> ${error}</div>
    </c:if>

    <!-- ── Search bar ──────────────────────────────────────────────────── -->
    <form action="${pageContext.request.contextPath}/movie" method="get" class="search-wrap">
        <input type="hidden" name="action" value="search">
        <div class="row g-2 align-items-end">
            <div class="col-md-4">
                <label class="form-label">Search by Title</label>
                <input type="text" name="title" class="form-control"
                       placeholder="e.g. Inception, Mad Max…" value="${param.title}">
            </div>
            <div class="col-md-3">
                <label class="form-label">Genre</label>
                <select name="genre" class="form-select">
                    <option value="">All Genres</option>
                    <option ${param.genre=='Action'    ?'selected':''}>Action</option>
                    <option ${param.genre=='Comedy'    ?'selected':''}>Comedy</option>
                    <option ${param.genre=='Drama'     ?'selected':''}>Drama</option>
                    <option ${param.genre=='Horror'    ?'selected':''}>Horror</option>
                    <option ${param.genre=='Thriller'  ?'selected':''}>Thriller</option>
                    <option ${param.genre=='Romance'   ?'selected':''}>Romance</option>
                    <option ${param.genre=='Sci-Fi'    ?'selected':''}>Sci-Fi</option>
                    <option ${param.genre=='Animation' ?'selected':''}>Animation</option>
                </select>
            </div>
            <div class="col-md-3">
                <label class="form-label">Language</label>
                <select name="language" class="form-select">
                    <option value="">All Languages</option>
                    <option ${param.language=='English'?'selected':''}>English</option>
                    <option ${param.language=='Sinhala'?'selected':''}>Sinhala</option>
                    <option ${param.language=='Tamil'  ?'selected':''}>Tamil</option>
                    <option ${param.language=='Hindi'  ?'selected':''}>Hindi</option>
                    <option ${param.language=='Korean' ?'selected':''}>Korean</option>
                    <option ${param.language=='French' ?'selected':''}>French</option>
                </select>
            </div>
            <div class="col-md-2">
                <label class="form-label" style="visibility:hidden;">Search</label>
                <button type="submit" class="btn-search">
                    <i class="bi bi-search"></i> Search
                </button>
            </div>
        </div>
    </form>

    <c:choose>
        <c:when test="${empty movies}">
            <div class="empty-state">
                <span class="empty-icon"><i class="bi bi-film"></i></span>
                <div class="empty-title">No Movies Found</div>
                <p class="empty-sub">
                    Try a different search
                    <c:if test="${sessionScope.role == 'ADMIN'}">
                        or <a href="${pageContext.request.contextPath}/movie?action=adminForm"
                              style="color:var(--gold); text-decoration:none;">add a movie</a>
                    </c:if>
                </p>
            </div>
        </c:when>
        <c:otherwise>

            <%-- ── NOW SHOWING hero section ──────────────────────────────── --%>
            <c:set var="nowShowingMovies" value="${[]}" />
            <c:forEach var="m" items="${movies}">
                <c:if test="${m.status == 'Now Showing'}">
                    <c:set var="nowShowingMovies" value="${nowShowingMovies}" />
                </c:if>
            </c:forEach>

            <div class="section-header">
                <div class="section-title">Now Showing</div>
                <span class="section-count">
                    ${fn:length(movies)} movie(s) total
                </span>
            </div>

            <%-- Hero strip: movies with posters as wide cards --%>
            <div class="hero-strip mb-4">
                <c:set var="heroCount" value="0"/>
                <c:forEach var="movie" items="${movies}">
                    <c:if test="${movie.status == 'Now Showing' and heroCount < 4}">
                        <c:set var="heroCount" value="${heroCount + 1}"/>
                        <div class="hero-card"
                             onclick="window.location='${pageContext.request.contextPath}/movie?action=details&id=${movie.id}'">
                            <c:choose>
                                <c:when test="${not empty movie.imagePath}">
                                    <img src="${pageContext.request.contextPath}/movie-image/${movie.imagePath}"
                                         alt="${movie.title}">
                                </c:when>
                                <c:otherwise>
                                    <div class="hero-card-placeholder" style="font-size:0.8rem;">
                                        <i class="bi bi-camera-reels" style="font-size:2rem;"></i>
                                        ${movie.title}
                                    </div>
                                </c:otherwise>
                            </c:choose>
                            <div class="hero-card-overlay"></div>
                            <div class="hero-card-content">
                                <div class="hero-card-title">${movie.title}</div>
                                <div class="hero-card-meta">${movie.language} &bull; ${movie.duration} min &bull; ${movie.rating}</div>
                                <div class="hero-card-actions">
                                    <a href="${pageContext.request.contextPath}/showtime/byMovie?title=${movie.title}"
                                       class="btn-card btn-showtimes" onclick="event.stopPropagation()">
                                        <i class="bi bi-ticket-perforated"></i> Book Now
                                    </a>
                                    <a href="${pageContext.request.contextPath}/movie?action=details&id=${movie.id}"
                                       class="btn-card btn-details" onclick="event.stopPropagation()">
                                        Details
                                    </a>
                                </div>
                            </div>
                        </div>
                    </c:if>
                </c:forEach>
            </div>

            <div class="section-divider"></div>

            <%-- ── All movies grid ──────────────────────────────────────── --%>
            <div class="section-header mb-3">
                <div class="section-title">All Movies</div>
                <c:if test="${not empty searchLabel}">
                    <span class="section-count">Filtered by: <span style="color:var(--gold);">${searchLabel}</span></span>
                </c:if>
            </div>

            <div class="movie-grid">
                <c:forEach var="movie" items="${movies}">
                    <div class="movie-card">

                        <%-- Poster --%>
                        <c:choose>
                            <c:when test="${not empty movie.imagePath}">
                                <img class="movie-card-poster"
                                     src="${pageContext.request.contextPath}/movie-image/${movie.imagePath}"
                                     alt="${movie.title}">
                            </c:when>
                            <c:otherwise>
                                <div class="movie-card-placeholder">
                                    <i class="bi bi-film" style="font-size:2.5rem;"></i>
                                    <span style="font-size:0.72rem; color:var(--dim);">No Poster</span>
                                </div>
                            </c:otherwise>
                        </c:choose>

                        <%-- Gradient overlay --%>
                        <div class="movie-card-overlay"></div>

                        <%-- Status badge top-left --%>
                        <c:choose>
                            <c:when test="${movie.status == 'Now Showing'}">
                                <span class="status-badge status-now">&#9679; Now Showing</span>
                            </c:when>
                            <c:when test="${movie.status == 'Coming Soon'}">
                                <span class="status-badge status-coming">&#8987; Coming Soon</span>
                            </c:when>
                            <c:otherwise>
                                <span class="status-badge status-ended">Ended</span>
                            </c:otherwise>
                        </c:choose>

                        <%-- Genre badge top-right --%>
                        <span class="genre-badge">${movie.genre}</span>

                        <%-- Bottom content --%>
                        <div class="movie-card-content">
                            <div class="mc-title">${movie.title}</div>
                            <div class="mc-meta">${movie.language} &bull; ${movie.duration}m &bull; ${movie.rating}</div>
                            <div class="mc-actions">
                                <a href="${pageContext.request.contextPath}/movie?action=details&id=${movie.id}"
                                   class="btn-card btn-details">Details</a>
                                <a href="${pageContext.request.contextPath}/showtime/byMovie?title=${movie.title}"
                                   class="btn-card btn-showtimes"><i class="bi bi-ticket-perforated"></i> Showtimes</a>
                                <c:if test="${sessionScope.role == 'ADMIN'}">
                                    <a href="${pageContext.request.contextPath}/movie?action=edit&id=${movie.id}"
                                       class="btn-card btn-admin-edit"><i class="bi bi-pencil"></i></a>
                                    <a href="${pageContext.request.contextPath}/movie?action=delete&id=${movie.id}"
                                       class="btn-card btn-admin-del"
                                       onclick="return confirm('Delete ${movie.title}?')">
                                        <i class="bi bi-trash3"></i>
                                    </a>
                                </c:if>
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
