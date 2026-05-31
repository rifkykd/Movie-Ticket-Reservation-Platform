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
        :root{--bg:#07080d;--surface:#0d1117;--card:#0f1520;--border:#1a2035;--border-md:#252f45;--gold:#f5c518;--gold-dim:rgba(245,197,24,.12);--violet:#8b5cf6;--violet-dim:rgba(139,92,246,.12);--text:#e8edf5;--muted:#8892a4;--dim:#3d4557;--r:12px}
        *{box-sizing:border-box;margin:0;padding:0}
        body{background:var(--bg);color:var(--text);font-family:'Poppins',sans-serif;min-height:100vh}
        body::before{content:'';position:fixed;inset:0;background:radial-gradient(ellipse 60% 50% at 20% 0%,rgba(139,92,246,.06),transparent 55%);pointer-events:none;z-index:0}

        .navbar{position:sticky;top:0;z-index:100;background:rgba(7,8,13,.85);backdrop-filter:blur(20px);border-bottom:1px solid var(--border);padding:0 2rem;height:64px;display:flex;align-items:center;justify-content:space-between}
        .nav-brand{font-family:'Bebas Neue';font-size:1.75rem;letter-spacing:4px;color:var(--gold);text-decoration:none;display:flex;align-items:center;gap:8px}
        .nav-links{display:flex;align-items:center;gap:6px}
        .nav-link{color:var(--muted);font-size:.82rem;text-decoration:none;padding:6px 12px;border-radius:8px;transition:color .2s,background .2s}
        .nav-link:hover{color:var(--text);background:rgba(255,255,255,.05)}
        .btn-login{padding:7px 16px;border-radius:8px;border:1px solid var(--border-md);color:var(--muted);font-size:.82rem;text-decoration:none}
        .btn-login:hover{border-color:var(--gold);color:var(--gold)}
        .btn-register{padding:7px 16px;border-radius:8px;background:var(--gold);color:#000;font-size:.82rem;font-weight:700;text-decoration:none}
        .nav-username{color:var(--gold);font-size:.82rem;font-weight:600}

        .page{position:relative;z-index:1;max-width:840px;margin:0 auto;padding:2rem}

        /* Hero */
        .reviews-hero{background:linear-gradient(135deg,#0a0f1e,#14092a);border:1px solid var(--border);border-radius:var(--r);padding:2rem 2.5rem;margin-bottom:2rem;position:relative;overflow:hidden}
        .reviews-hero::after{content:'"';position:absolute;right:2rem;top:-.5rem;font-size:8rem;color:rgba(139,92,246,.06);font-family:Georgia,serif;line-height:1;pointer-events:none}
        .hero-back{color:var(--dim);font-size:.78rem;text-decoration:none;display:inline-flex;align-items:center;gap:5px;margin-bottom:.75rem;transition:color .15s}
        .hero-back:hover{color:var(--muted)}
        .hero-movie{font-family:'Bebas Neue';font-size:clamp(2rem,5vw,3rem);letter-spacing:2px;color:#fff;line-height:1;margin-bottom:.75rem}
        .rating-summary{display:flex;align-items:center;gap:1.5rem;flex-wrap:wrap}
        .avg-score{font-family:'Bebas Neue';font-size:3rem;color:var(--gold);line-height:1}
        .avg-stars{font-size:1.4rem;color:var(--gold);letter-spacing:2px}
        .review-count-label{color:var(--muted);font-size:.8rem}

        /* Form panel */
        .form-panel{background:var(--surface);border:1px solid var(--border);border-radius:var(--r);padding:1.5rem;margin-bottom:2rem}
        .panel-title{color:var(--gold);font-size:.72rem;font-weight:700;text-transform:uppercase;letter-spacing:1.5px;margin-bottom:1.1rem;display:flex;align-items:center;gap:7px}
        .panel-title::before{content:'';width:3px;height:14px;background:var(--gold);border-radius:2px;display:block}

        .star-row{display:flex;gap:6px;margin-bottom:1rem}
        .star-btn{font-size:2rem;color:var(--border-md);background:none;border:none;cursor:pointer;padding:0;line-height:1;transition:color .1s,transform .1s}
        .star-btn.lit,.star-btn:hover{color:var(--gold);transform:scale(1.1)}

        .field-label{color:var(--muted);font-size:.75rem;font-weight:500;margin-bottom:5px;display:block}
        .textarea-box{width:100%;background:var(--card);border:1px solid var(--border);border-radius:8px;color:var(--text);font-family:'Poppins';font-size:.88rem;padding:.75rem 1rem;resize:vertical;min-height:90px;outline:none;transition:border-color .2s}
        .textarea-box:focus{border-color:var(--gold);box-shadow:0 0 0 3px var(--gold-dim)}
        .textarea-box::placeholder{color:var(--dim)}

        .btn-submit-review{background:var(--gold);color:#000;font-weight:700;font-size:.88rem;padding:9px 24px;border-radius:9px;border:none;cursor:pointer;display:inline-flex;align-items:center;gap:6px;transition:background .15s,transform .1s;margin-top:.75rem}
        .btn-submit-review:hover{background:#e0b000;transform:translateY(-1px)}
        .btn-remove-review{background:rgba(244,63,94,.1);color:#fb7185;border:1px solid rgba(244,63,94,.25);font-size:.8rem;padding:7px 16px;border-radius:8px;text-decoration:none;display:inline-flex;align-items:center;gap:5px;margin-top:.75rem;margin-left:.5rem}
        .btn-remove-review:hover{background:rgba(244,63,94,.2)}

        /* Review cards */
        .review-card{background:var(--surface);border:1px solid var(--border);border-radius:var(--r);padding:1.25rem;margin-bottom:.75rem;transition:border-color .2s}
        .review-card:hover{border-color:var(--border-md)}
        .review-card.removed{opacity:.4;border-style:dashed}
        .rc-top{display:flex;align-items:flex-start;justify-content:space-between;gap:.75rem;flex-wrap:wrap;margin-bottom:.6rem}
        .rc-author{display:flex;align-items:center;gap:10px}
        .rc-avatar{width:36px;height:36px;border-radius:50%;background:var(--violet-dim);border:1px solid rgba(139,92,246,.25);display:flex;align-items:center;justify-content:center;color:#a78bfa;font-weight:700;font-size:.85rem;flex-shrink:0}
        .rc-name{color:var(--text);font-weight:600;font-size:.88rem}
        .rc-date{color:var(--dim);font-size:.72rem}
        .rc-stars{font-size:.95rem;color:var(--gold);letter-spacing:1px}
        .rc-comment{color:var(--muted);font-size:.85rem;line-height:1.7;margin-top:.5rem}
        .badge-own{background:rgba(16,185,129,.1);border:1px solid rgba(16,185,129,.25);color:#34d399;font-size:.62rem;padding:2px 8px;border-radius:4px;font-weight:600}
        .badge-removed{background:rgba(244,63,94,.08);border:1px solid rgba(244,63,94,.2);color:#fb7185;font-size:.62rem;padding:2px 8px;border-radius:4px}
        .rc-actions{display:flex;gap:6px;flex-shrink:0}
        .btn-rc{font-size:.72rem;padding:4px 11px;border-radius:6px;text-decoration:none;border:none;cursor:pointer;display:inline-flex;align-items:center;gap:4px;transition:filter .15s}
        .btn-rc:hover{filter:brightness(1.2)}
        .btn-hide{background:rgba(245,197,24,.08);color:rgba(245,197,24,.7);border:1px solid rgba(245,197,24,.2)}
        .btn-delete{background:rgba(244,63,94,.08);color:#fb7185;border:1px solid rgba(244,63,94,.2)}

        .flash-ok{background:rgba(16,185,129,.1);border:1px solid rgba(16,185,129,.3);color:#34d399;border-radius:var(--r);padding:.65rem 1rem;font-size:.82rem;margin-bottom:1.25rem}
        .flash-err{background:rgba(244,63,94,.1);border:1px solid rgba(244,63,94,.3);color:#fb7185;border-radius:var(--r);padding:.65rem 1rem;font-size:.82rem;margin-bottom:1.25rem}

        .section-divider{height:1px;background:var(--border);margin:1.5rem 0}
        .reviews-count-label{color:var(--dim);font-size:.7rem;font-weight:600;text-transform:uppercase;letter-spacing:1.5px;margin-bottom:1rem}

        .empty-reviews{text-align:center;padding:3rem 0;color:var(--dim)}
        .admin-note{background:var(--violet-dim);border:1px solid rgba(139,92,246,.2);border-radius:8px;padding:.75rem 1rem;font-size:.8rem;color:#a78bfa;display:flex;align-items:center;gap:8px}
    </style>
</head>
<body>
<nav class="navbar">
    <a class="nav-brand" href="${pageContext.request.contextPath}/"><i class="bi bi-film"></i> CINEBOOK</a>
    <div class="nav-links">
        <a href="${pageContext.request.contextPath}/" class="nav-link">Gallery</a>
        <c:if test="${sessionScope.role=='ADMIN'}"><a href="${pageContext.request.contextPath}/review/admin" class="nav-link">Moderate Reviews</a></c:if>
        <c:choose>
            <c:when test="${not empty sessionScope.username}">
                <span class="nav-username">${sessionScope.username}</span>
                <a href="${pageContext.request.contextPath}/user/profile" class="nav-link">Profile</a>
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
    <c:if test="${not empty successMsg}"><div class="flash-ok"><i class="bi bi-check-circle-fill"></i> ${successMsg}</div></c:if>
    <c:if test="${not empty errorMsg}"><div class="flash-err"><i class="bi bi-exclamation-triangle-fill"></i> ${errorMsg}</div></c:if>

    <!-- Hero -->
    <div class="reviews-hero">
        <a href="javascript:history.back()" class="hero-back"><i class="bi bi-arrow-left"></i> Back</a>
        <div class="hero-movie">${movieTitle}</div>
        <div class="rating-summary">
            <c:choose>
                <c:when test="${reviewCount>0}">
                    <div class="avg-score">${avgRating}</div>
                    <div>
                        <div class="avg-stars">${avgStars}</div>
                        <div class="review-count-label">${reviewCount} review(s)</div>
                    </div>
                </c:when>
                <c:otherwise><span style="color:var(--dim);font-size:.88rem">No reviews yet — be the first!</span></c:otherwise>
            </c:choose>
        </div>
    </div>

    <!-- Write / Edit form -->
    <div class="form-panel">
        <c:choose>
            <c:when test="${sessionScope.role=='ADMIN'}">
                <div class="admin-note"><i class="bi bi-shield-check"></i> Viewing as administrator. Manage reviews below.</div>
            </c:when>
            <c:when test="${not empty userReview}">
                <div class="panel-title"><i class="bi bi-pencil-square"></i> Edit Your Review</div>
                <form action="${pageContext.request.contextPath}/review/update" method="post">
                    <input type="hidden" name="reviewId"   value="${userReview.reviewId}">
                    <input type="hidden" name="movieTitle" value="${movieTitle}">
                    <input type="hidden" name="rating"     id="ratingEditInput" value="${userReview.rating}">
                    <div class="star-row" id="starEdit">
                        <c:forEach begin="1" end="5" var="i">
                            <button type="button" class="star-btn ${i<=userReview.rating?'lit':''}" onclick="setRating(${i},'edit')">★</button>
                        </c:forEach>
                    </div>
                    <label class="field-label">Your comment</label>
                    <textarea class="textarea-box" name="comment" required>${userReview.comment}</textarea>
                    <div>
                        <button type="submit" class="btn-submit-review"><i class="bi bi-save2"></i> Update Review</button>
                        <a href="${pageContext.request.contextPath}/review/remove/${userReview.reviewId}?movieTitle=${movieTitle}"
                           class="btn-remove-review" onclick="return confirm('Remove your review?')">
                            <i class="bi bi-trash3"></i> Remove
                        </a>
                    </div>
                </form>
            </c:when>
            <c:when test="${not empty sessionScope.username}">
                <div class="panel-title"><i class="bi bi-star"></i> Write a Review</div>
                <form action="${pageContext.request.contextPath}/review/submit" method="post">
                    <input type="hidden" name="movieTitle" value="${movieTitle}">
                    <input type="hidden" name="rating"     id="ratingNewInput" value="0">
                    <div class="star-row" id="starNew">
                        <button type="button" class="star-btn" onclick="setRating(1,'new')">★</button>
                        <button type="button" class="star-btn" onclick="setRating(2,'new')">★</button>
                        <button type="button" class="star-btn" onclick="setRating(3,'new')">★</button>
                        <button type="button" class="star-btn" onclick="setRating(4,'new')">★</button>
                        <button type="button" class="star-btn" onclick="setRating(5,'new')">★</button>
                    </div>
                    <label class="field-label">Your thoughts about ${movieTitle}</label>
                    <textarea class="textarea-box" name="comment" placeholder="What did you think?" required></textarea>
                    <button type="submit" class="btn-submit-review" onclick="return validateRating()"><i class="bi bi-send-fill"></i> Submit Review</button>
                </form>
            </c:when>
            <c:otherwise>
                <div style="text-align:center;padding:.5rem 0;color:var(--muted);font-size:.88rem">
                    <a href="${pageContext.request.contextPath}/user/login" style="color:var(--gold);font-weight:600;text-decoration:none">Sign in</a> to write a review for this movie.
                </div>
            </c:otherwise>
        </c:choose>
    </div>

    <div class="section-divider"></div>
    <div class="reviews-count-label">${fn:length(reviews)} Review(s)</div>

    <c:choose>
        <c:when test="${empty reviews}">
            <div class="empty-reviews"><i class="bi bi-chat-square" style="font-size:3rem;display:block;margin-bottom:.75rem"></i><p>No reviews yet for <strong style="color:var(--text)">${movieTitle}</strong>.</p></div>
        </c:when>
        <c:otherwise>
            <c:forEach var="r" items="${reviews}">
                <div class="review-card ${r.removed?'removed':''}">
                    <div class="rc-top">
                        <div class="rc-author">
                            <div class="rc-avatar">${fn:toUpperCase(fn:substring(r.username,0,1))}</div>
                            <div>
                                <div style="display:flex;align-items:center;gap:6px;flex-wrap:wrap">
                                    <span class="rc-name">@${r.username}</span>
                                    <c:if test="${r.userId==sessionScope.userId}"><span class="badge-own">Your Review</span></c:if>
                                    <c:if test="${r.removed}"><span class="badge-removed">Removed</span></c:if>
                                </div>
                                <div class="rc-date">${r.reviewDate}</div>
                            </div>
                        </div>
                        <div class="rc-actions">
                            <c:if test="${sessionScope.role=='ADMIN'}">
                                <c:if test="${not r.removed}">
                                    <a href="${pageContext.request.contextPath}/review/remove/${r.reviewId}?movieTitle=${movieTitle}" class="btn-rc btn-hide" onclick="return confirm('Hide this review?')"><i class="bi bi-eye-slash"></i></a>
                                </c:if>
                                <a href="${pageContext.request.contextPath}/review/delete/${r.reviewId}" class="btn-rc btn-delete" onclick="return confirm('Delete permanently?')"><i class="bi bi-trash3"></i></a>
                            </c:if>
                        </div>
                    </div>
                    <div class="rc-stars">${r.starDisplay}</div>
                    <div class="rc-comment">${r.comment}</div>
                </div>
            </c:forEach>
        </c:otherwise>
    </c:choose>
</div>

<script>
function setRating(v,mode){
    const prefix=mode==='edit'?'Edit':'New';
    document.getElementById('rating'+prefix+'Input').value=v;
    document.getElementById('star'+prefix).querySelectorAll('.star-btn').forEach((b,i)=>{
        b.classList.toggle('lit',i<v);
    });
}
function validateRating(){
    if(!document.getElementById('ratingNewInput').value||document.getElementById('ratingNewInput').value==='0'){
        alert('Please select a star rating.');return false;
    }return true;
}
</script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
