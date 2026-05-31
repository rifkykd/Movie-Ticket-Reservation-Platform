<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>CineBook – Movie Catalog</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Bebas+Neue&family=Inter:wght@300;400;600&display=swap" rel="stylesheet">
    <style>
        :root { --gold: #f5c518; --dark: #0d0d0d; }
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { background: var(--dark); color: #e0e0e0; font-family: 'Inter', sans-serif; }

        /* Navbar */
        .navbar { background: rgba(13,13,13,0.97); border-bottom: 1px solid #1a1a1a; position: sticky; top: 0; z-index: 100; padding: 0.75rem 2rem; }
        .navbar-brand { font-family: 'Bebas Neue'; font-size: 1.8rem; color: var(--gold) !important; letter-spacing: 3px; text-decoration: none; }
        .nav-link { color: #aaa !important; font-size: 0.85rem; letter-spacing: 1px; text-decoration: none; }
        .nav-link:hover { color: var(--gold) !important; }

        /* Hero */
        .hero {
            min-height: 70vh;
            background: linear-gradient(180deg, #0d0d0d 0%, #1a0a2e 60%, #0d0d0d 100%);
            display: flex; align-items: center; justify-content: center; text-align: center; padding: 4rem 1rem;
        }
        .hero-title { font-family: 'Bebas Neue'; font-size: clamp(4rem, 12vw, 8rem); letter-spacing: 0.05em; line-height: 1; color: white; }
        .hero-title span { color: var(--gold); }
        .hero-subtitle { font-size: 0.85rem; font-weight: 300; letter-spacing: 0.3em; text-transform: uppercase; color: #555; margin-top: 0.5rem; }

        /* Buttons */
        .btn-gold { background: var(--gold); color: #000; font-weight: 700; padding: 0.75rem 2.5rem; border-radius: 4px; text-decoration: none; letter-spacing: 0.05em; transition: all 0.2s; display: inline-block; border: none; }
        .btn-gold:hover { background: #d4a900; color: #000; transform: translateY(-2px); }
        .btn-outline { border: 1px solid #444; color: #aaa; padding: 0.75rem 2rem; border-radius: 4px; text-decoration: none; transition: all 0.2s; display: inline-block; }
        .btn-outline:hover { border-color: var(--gold); color: var(--gold); }

        /* Section headings */
        .section-label { font-size: 0.72rem; text-transform: uppercase; letter-spacing: 3px; color: #555; margin-bottom: 0.3rem; }
        .section-title { font-family: 'Bebas Neue'; font-size: 2.2rem; color: white; letter-spacing: 2px; margin-bottom: 1.5rem; }
        .section-title span { color: var(--gold); }

        /* Now Showing horizontal scroll strip */
        .scroll-strip { display: flex; gap: 16px; overflow-x: auto; padding-bottom: 12px; scrollbar-width: thin; scrollbar-color: #333 transparent; }
        .scroll-strip::-webkit-scrollbar { height: 4px; }
        .scroll-strip::-webkit-scrollbar-thumb { background: #333; border-radius: 4px; }
        .strip-card { flex: 0 0 160px; border-radius: 8px; overflow: hidden; background: #16213e; border: 1px solid #1f2d4e; transition: transform 0.2s, border-color 0.2s; text-decoration: none; display: block; }
        .strip-card:hover { transform: translateY(-6px); border-color: var(--gold); }
        .strip-card img { width: 100%; height: 220px; object-fit: cover; display: block; }
        .strip-card .no-poster { width: 100%; height: 220px; background: #0d1525; display: flex; align-items: center; justify-content: center; color: #333; font-size: 0.75rem; }
        .strip-card .card-info { padding: 10px; }
        .strip-card .card-title { font-family: 'Bebas Neue'; font-size: 1rem; color: white; letter-spacing: 1px; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; }
        .strip-card .card-meta { font-size: 0.7rem; color: #555; margin-top: 3px; }

        /* All Movies grid */
        .featured-grid { display: grid; grid-template-columns: repeat(auto-fill, minmax(200px, 1fr)); gap: 20px; }
        .featured-card { border-radius: 10px; overflow: hidden; background: #16213e; border: 1px solid #1f2d4e; transition: transform 0.2s, border-color 0.2s; text-decoration: none; display: block; }
        .featured-card:hover { transform: translateY(-5px); border-color: var(--gold); }
        .featured-card img { width: 100%; height: 260px; object-fit: cover; display: block; }
        .featured-card .no-poster { width: 100%; height: 260px; background: #0d1525; display: flex; flex-direction: column; align-items: center; justify-content: center; color: #333; font-size: 0.75rem; gap: 8px; }
        .featured-card .card-body-custom { padding: 12px; }
        .featured-card .card-title { font-family: 'Bebas Neue'; font-size: 1.1rem; color: white; letter-spacing: 1px; margin-bottom: 4px; }
        .featured-card .card-meta { font-size: 0.72rem; color: #555; }

        /* Status badges */
        .badge-now    { background: #198754; font-size: 0.62rem; padding: 3px 8px; border-radius: 10px; color: white; white-space: nowrap; }
        .badge-coming { background: #0d6efd; font-size: 0.62rem; padding: 3px 8px; border-radius: 10px; color: white; white-space: nowrap; }
        .badge-old    { background: #444;    font-size: 0.62rem; padding: 3px 8px; border-radius: 10px; color: white; white-space: nowrap; }

        /* Footer */
        footer { border-top: 1px solid #1a1a1a; color: #333; font-size: 0.8rem; padding: 1.5rem; text-align: center; }
    </style>
</head>
<body>

<!-- Navbar -->
<nav class="navbar d-flex align-items-center">
    <a class="navbar-brand me-auto" href="/">CINE<span style="color:white">BOOK</span></a>
    <div class="d-flex gap-4 align-items-center">
        <a href="movie?action=list"      class="nav-link">GALLERY</a>
        <a href="movie?action=adminForm" class="nav-link">+ ADD MOVIE</a>
    </div>
</nav>

<!-- Hero -->
<section class="hero">
    <div>
        <div class="hero-title">CINE<span>BOOK</span></div>
        <p class="hero-subtitle">Online Movie Reservation System</p>
        <div class="d-flex gap-3 justify-content-center mt-4 flex-wrap">
            <a href="movie?action=list"      class="btn-gold">Browse All Movies</a>
            <a href="movie?action=adminForm" class="btn-outline">+ Add Movie</a>
        </div>
    </div>
</section>

<!-- Now Showing Strip -->
<c:if test="${not empty nowShowing}">
    <section style="padding: 3rem 2rem;">
        <div class="section-label">On Screen Now</div>
        <div class="section-title">Now <span>Showing</span></div>
        <div class="scroll-strip">
            <c:forEach var="movie" items="${nowShowing}">
                <a href="movie?action=details&id=${movie.id}" class="strip-card">
                    <c:choose>
                        <c:when test="${not empty movie.imagePath}">
                            <img src="${pageContext.request.contextPath}/movie-image/${movie.imagePath}"
                                 alt="${movie.title}">
                        </c:when>
                        <c:otherwise>
                            <div class="no-poster">No Poster</div>
                        </c:otherwise>
                    </c:choose>
                    <div class="card-info">
                        <div class="card-title">${movie.title}</div>
                        <div class="card-meta">${movie.genre} &bull; ${movie.duration} min</div>
                    </div>
                </a>
            </c:forEach>
        </div>
    </section>
</c:if>

<!-- All Movies Grid -->
<c:if test="${not empty allMovies}">
    <section style="padding: 2rem 2rem 4rem;">
        <div class="section-label">Complete Catalog</div>
        <div class="section-title">All <span>Movies</span></div>
        <div class="featured-grid">
            <c:forEach var="movie" items="${allMovies}">
                <a href="movie?action=details&id=${movie.id}" class="featured-card">

                    <c:choose>
                        <c:when test="${not empty movie.imagePath}">
                            <img src="${pageContext.request.contextPath}/movie-image/${movie.imagePath}"
                                 alt="${movie.title}">
                        </c:when>
                        <c:otherwise>
                            <div class="no-poster">
                                <span style="font-size:2rem;">&#127916;</span>
                                No Poster
                            </div>
                        </c:otherwise>
                    </c:choose>

                    <div class="card-body-custom">
                        <div class="d-flex justify-content-between align-items-start mb-1">
                            <div class="card-title">${movie.title}</div>
                            <c:choose>
                                <c:when test="${movie.status == 'Now Showing'}">
                                    <span class="badge-now">Now</span>
                                </c:when>
                                <c:when test="${movie.status == 'Coming Soon'}">
                                    <span class="badge-coming">Soon</span>
                                </c:when>
                                <c:otherwise>
                                    <span class="badge-old">Ended</span>
                                </c:otherwise>
                            </c:choose>
                        </div>
                        <div class="card-meta">${movie.genre} &bull; ${movie.language} &bull; ${movie.duration} min</div>
                    </div>

                </a>
            </c:forEach>
        </div>
    </section>
</c:if>

<!-- Empty state -->
<c:if test="${empty allMovies}">
    <div style="text-align:center; padding:6rem 1rem; color:#444;">
        <div style="font-family:'Bebas Neue'; font-size:2.5rem; margin-bottom:1rem;">No Movies Yet</div>
        <a href="movie?action=adminForm" class="btn-gold">Add Your First Movie</a>
    </div>
</c:if>

<!-- Footer -->
<footer>CineBook &mdash; Movie Catalog Management &mdash; SE1020 Project</footer>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
