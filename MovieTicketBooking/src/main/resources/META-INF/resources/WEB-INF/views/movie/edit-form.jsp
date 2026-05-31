<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Edit Movie – CineBook Admin</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Bebas+Neue&family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <style>
        :root{--bg:#07080d;--surface:#0d1117;--card:#0f1520;--border:#1a2035;--border-md:#252f45;
              --gold:#f5c518;--gold-dim:rgba(245,197,24,.12);--text:#e8edf5;--muted:#8892a4;--dim:#3d4557;--r:12px}
        *{box-sizing:border-box;margin:0;padding:0}
        body{background:var(--bg);color:var(--text);font-family:'Poppins',sans-serif;min-height:100vh}

        .navbar{position:sticky;top:0;z-index:100;background:rgba(7,8,13,.88);backdrop-filter:blur(20px);
                border-bottom:1px solid var(--border);padding:0 2rem;height:64px;
                display:flex;align-items:center;justify-content:space-between}
        .nav-brand{font-family:'Bebas Neue';font-size:1.75rem;letter-spacing:4px;color:var(--gold);
                   text-decoration:none;display:flex;align-items:center;gap:8px}
        .nav-link{color:var(--muted);font-size:.82rem;text-decoration:none;padding:6px 12px;
                  border-radius:8px;transition:color .2s,background .2s}
        .nav-link:hover{color:var(--text);background:rgba(255,255,255,.05)}
        .nav-username{color:var(--gold);font-size:.82rem;font-weight:600}

        .page{max-width:760px;margin:0 auto;padding:2rem}

        .page-header{display:flex;align-items:center;gap:1rem;margin-bottom:2rem}
        .page-title{font-family:'Bebas Neue';font-size:1.9rem;letter-spacing:2px;color:var(--text)}
        .movie-id-badge{background:var(--card);border:1px solid var(--border);color:var(--dim);
                        font-family:monospace;font-size:.78rem;padding:4px 10px;border-radius:6px}

        .form-card{background:var(--surface);border:1px solid var(--border);
                   border-radius:var(--r);padding:1.75rem;margin-bottom:1rem}
        .section-label{color:var(--dim);font-size:.68rem;font-weight:700;text-transform:uppercase;
                       letter-spacing:1.2px;padding-bottom:.6rem;margin-bottom:1rem;
                       border-bottom:1px solid var(--border);display:flex;align-items:center;gap:7px}
        .section-label i{color:var(--gold)}

        .field-label{color:var(--muted);font-size:.75rem;font-weight:500;margin-bottom:5px;display:block}
        .input-box{display:flex;align-items:center;background:var(--card);border:1px solid var(--border);
                   border-radius:9px;overflow:hidden;transition:border-color .2s,box-shadow .2s}
        .input-box:focus-within{border-color:var(--gold);box-shadow:0 0 0 3px var(--gold-dim)}
        .input-icon{width:40px;display:flex;align-items:center;justify-content:center;
                    color:var(--dim);font-size:.9rem;flex-shrink:0}
        .input-box input,.input-box select{flex:1;background:transparent;border:none;outline:none;
                color:var(--text);font-family:'Poppins';font-size:.88rem;padding:.65rem .5rem .65rem 0}
        .input-box input::placeholder{color:var(--dim)}
        .input-box select option{background:#0d1117}

        /* Image upload */
        .upload-area{border:2px dashed var(--border);border-radius:var(--r);padding:1.25rem;
                     text-align:center;cursor:pointer;transition:border-color .2s;position:relative}
        .upload-area:hover{border-color:var(--gold)}
        .upload-area input[type=file]{position:absolute;inset:0;opacity:0;cursor:pointer;width:100%;height:100%}
        .upload-icon{font-size:1.75rem;color:var(--dim);margin-bottom:.4rem;display:block}
        .current-poster{width:100%;max-height:120px;object-fit:cover;border-radius:8px;
                        margin-bottom:.75rem;border:1px solid var(--border)}
        #previewImg{width:100%;max-height:120px;object-fit:cover;border-radius:8px;
                    margin-top:.75rem;display:none}

        /* Extra field */
        #extraGroup{display:none}

        .btn-submit{background:var(--gold);color:#000;font-weight:700;font-size:.9rem;
                    padding:10px 26px;border-radius:10px;border:none;cursor:pointer;
                    display:inline-flex;align-items:center;gap:7px;
                    transition:background .15s,transform .1s;font-family:'Poppins'}
        .btn-submit:hover{background:#e0b000;transform:translateY(-1px)}
        .btn-cancel{background:rgba(255,255,255,.04);color:var(--muted);font-size:.9rem;
                    padding:10px 22px;border-radius:10px;border:1px solid var(--border);
                    text-decoration:none;display:inline-flex;align-items:center;gap:7px;font-family:'Poppins'}
        .btn-cancel:hover{background:rgba(255,255,255,.07);color:var(--text)}

        .flash-err{background:rgba(244,63,94,.1);border:1px solid rgba(244,63,94,.3);color:#fb7185;
                   border-radius:var(--r);padding:.65rem 1rem;font-size:.82rem;margin-bottom:1.25rem}
    </style>
</head>
<body>

<nav class="navbar">
    <a class="nav-brand" href="${pageContext.request.contextPath}/"><i class="bi bi-film"></i> CINEBOOK</a>
    <div style="display:flex;align-items:center;gap:6px">
        <a href="${pageContext.request.contextPath}/movie?action=list" class="nav-link">&#8592; Gallery</a>
        <c:if test="${not empty sessionScope.username}">
            <span class="nav-username">${sessionScope.username}</span>
            <a href="${pageContext.request.contextPath}/user/logout" class="nav-link">Logout</a>
        </c:if>
    </div>
</nav>

<div class="page">

    <div class="page-header">
        <div class="page-title"><i class="bi bi-pencil-square" style="vertical-align:middle;margin-right:8px"></i>Edit Movie</div>
        <span class="movie-id-badge">${movie.id}</span>
    </div>

    <c:if test="${not empty error}">
        <div class="flash-err"><i class="bi bi-exclamation-triangle-fill"></i> ${error}</div>
    </c:if>

    <form action="${pageContext.request.contextPath}/movie" method="post" enctype="multipart/form-data">
        <input type="hidden" name="action" value="update">
        <input type="hidden" name="id"     value="${movie.id}">

        <!-- Basic Info -->
        <div class="form-card">
            <div class="section-label"><i class="bi bi-film"></i> Basic Information</div>

            <div class="mb-3">
                <label class="field-label">Movie Title *</label>
                <div class="input-box">
                    <span class="input-icon"><i class="bi bi-type"></i></span>
                    <input type="text" name="title" value="${movie.title}" required>
                </div>
            </div>

            <div class="row g-3 mb-3">
                <div class="col-md-6">
                    <label class="field-label">Genre *</label>
                    <div class="input-box">
                        <span class="input-icon"><i class="bi bi-tag"></i></span>
                        <select name="genre" required>
                            <option ${movie.genre=='Action'    ?'selected':''}>Action</option>
                            <option ${movie.genre=='Comedy'    ?'selected':''}>Comedy</option>
                            <option ${movie.genre=='Drama'     ?'selected':''}>Drama</option>
                            <option ${movie.genre=='Horror'    ?'selected':''}>Horror</option>
                            <option ${movie.genre=='Thriller'  ?'selected':''}>Thriller</option>
                            <option ${movie.genre=='Romance'   ?'selected':''}>Romance</option>
                            <option ${movie.genre=='Sci-Fi'    ?'selected':''}>Sci-Fi</option>
                            <option ${movie.genre=='Animation' ?'selected':''}>Animation</option>
                        </select>
                    </div>
                </div>
                <div class="col-md-6">
                    <label class="field-label">Duration (minutes) *</label>
                    <div class="input-box">
                        <span class="input-icon"><i class="bi bi-clock"></i></span>
                        <input type="number" name="duration" value="${movie.duration}" min="30" required>
                    </div>
                </div>
            </div>

            <div class="row g-3 mb-0">
                <div class="col-md-4">
                    <label class="field-label">Language *</label>
                    <div class="input-box">
                        <span class="input-icon"><i class="bi bi-translate"></i></span>
                        <select name="language" required>
                            <option ${movie.language=='English'?'selected':''}>English</option>
                            <option ${movie.language=='Sinhala'?'selected':''}>Sinhala</option>
                            <option ${movie.language=='Tamil'  ?'selected':''}>Tamil</option>
                            <option ${movie.language=='Hindi'  ?'selected':''}>Hindi</option>
                            <option ${movie.language=='Korean' ?'selected':''}>Korean</option>
                            <option ${movie.language=='French' ?'selected':''}>French</option>
                        </select>
                    </div>
                </div>
                <div class="col-md-4">
                    <label class="field-label">Age Rating *</label>
                    <div class="input-box">
                        <span class="input-icon"><i class="bi bi-shield"></i></span>
                        <select name="rating" required>
                            <option ${movie.rating=='G'    ?'selected':''}>G</option>
                            <option ${movie.rating=='PG'   ?'selected':''}>PG</option>
                            <option ${movie.rating=='PG-13'?'selected':''}>PG-13</option>
                            <option ${movie.rating=='R'    ?'selected':''}>R</option>
                        </select>
                    </div>
                </div>
                <div class="col-md-4">
                    <label class="field-label">Status *</label>
                    <div class="input-box">
                        <span class="input-icon"><i class="bi bi-circle"></i></span>
                        <select name="status" required>
                            <option ${movie.status=='Now Showing'       ?'selected':''}>Now Showing</option>
                            <option ${movie.status=='Coming Soon'       ?'selected':''}>Coming Soon</option>
                            <option ${movie.status=='No Longer Showing' ?'selected':''}>No Longer Showing</option>
                        </select>
                    </div>
                </div>
            </div>
        </div>

        <!-- Movie Type -->
        <div class="form-card">
            <div class="section-label"><i class="bi bi-layers"></i> Movie Type</div>

            <div class="mb-3">
                <label class="field-label">Type *</label>
                <div class="input-box">
                    <span class="input-icon"><i class="bi bi-collection"></i></span>
                    <select name="type" id="typeSelect" onchange="toggleExtra()" required>
                        <option value="GENERAL" ${movie.type=='GENERAL'?'selected':''}>General</option>
                        <option value="ACTION"  ${movie.type=='ACTION' ?'selected':''}>Action</option>
                        <option value="COMEDY"  ${movie.type=='COMEDY' ?'selected':''}>Comedy</option>
                    </select>
                </div>
            </div>

            <div id="extraGroup">
                <label class="field-label" id="extraLabel">Extra Attribute</label>
                <div class="input-box">
                    <span class="input-icon"><i class="bi bi-star"></i></span>
                    <input type="text" name="extra" id="extraInput"
                           value="${movie.extraAttribute != 'N/A' ? movie.extraAttribute : ''}">
                </div>
            </div>
        </div>

        <!-- Poster -->
        <div class="form-card">
            <div class="section-label"><i class="bi bi-image"></i> Movie Poster</div>

            <c:if test="${not empty movie.imagePath}">
                <img src="${pageContext.request.contextPath}/movie-image/${movie.imagePath}"
                     alt="Current poster" class="current-poster">
                <div style="color:var(--dim);font-size:.72rem;margin-bottom:.75rem">
                    Current poster — upload a new image below to replace it
                </div>
            </c:if>

            <div class="upload-area">
                <input type="file" name="image" accept="image/*" onchange="previewImage(this)">
                <span class="upload-icon"><i class="bi bi-cloud-upload"></i></span>
                <div style="color:var(--muted);font-size:.82rem">Click or drag to upload new poster</div>
                <div style="color:var(--dim);font-size:.7rem;margin-top:.25rem">JPEG, PNG or WebP · Max 5MB · Leave blank to keep current</div>
                <img id="previewImg" src="" alt="New poster preview">
            </div>
        </div>

        <div class="d-flex gap-3">
            <button type="submit" class="btn-submit">
                <i class="bi bi-save2"></i> Save Changes
            </button>
            <a href="${pageContext.request.contextPath}/movie?action=list" class="btn-cancel">Cancel</a>
        </div>

    </form>
</div>

<script>
    const extraConfigs = {
        ACTION: { label: 'Action Intensity', placeholder: 'Low / Medium / High / Extreme' },
        COMEDY: { label: 'Humor Style',      placeholder: 'Slapstick / Satire / Romantic / Dark' }
    };

    function toggleExtra() {
        const v = document.getElementById('typeSelect').value;
        const g = document.getElementById('extraGroup');
        if (extraConfigs[v]) {
            document.getElementById('extraLabel').textContent       = extraConfigs[v].label;
            document.getElementById('extraInput').placeholder       = extraConfigs[v].placeholder;
            g.style.display = 'block';
        } else {
            g.style.display = 'none';
        }
    }

    function previewImage(input) {
        const img = document.getElementById('previewImg');
        if (input.files && input.files[0]) {
            const reader = new FileReader();
            reader.onload = e => { img.src = e.target.result; img.style.display = 'block'; };
            reader.readAsDataURL(input.files[0]);
        }
    }

    // Run on load to show/hide extra field based on current movie type
    toggleExtra();
</script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
