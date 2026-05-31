<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Add Movie – CineBook Admin</title>
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
        .page{max-width:760px;margin:0 auto;padding:2rem;position:relative;z-index:1}
        .page-title{font-family:'Bebas Neue';font-size:2rem;letter-spacing:2px;color:var(--text);margin-bottom:1.75rem;display:flex;align-items:center;gap:10px}

        .form-card{background:var(--surface);border:1px solid var(--border);border-radius:var(--r);padding:1.75rem;margin-bottom:1rem}
        .section-label{color:var(--dim);font-size:.68rem;font-weight:700;text-transform:uppercase;letter-spacing:1.2px;padding-bottom:.6rem;margin-bottom:1rem;border-bottom:1px solid var(--border);display:flex;align-items:center;gap:7px}
        .section-label i{color:var(--gold)}
        .field-label{color:var(--muted);font-size:.75rem;font-weight:500;margin-bottom:5px;display:block}
        .input-box{display:flex;align-items:center;background:var(--card);border:1px solid var(--border);border-radius:9px;overflow:hidden;transition:border-color .2s,box-shadow .2s;margin-bottom:0}
        .input-box:focus-within{border-color:var(--gold);box-shadow:0 0 0 3px var(--gold-dim)}
        .input-icon{width:40px;display:flex;align-items:center;justify-content:center;color:var(--dim);font-size:.9rem;flex-shrink:0}
        .input-box input,.input-box select,.input-box textarea{flex:1;background:transparent;border:none;outline:none;color:var(--text);font-family:'Poppins';font-size:.88rem;padding:.65rem .5rem .65rem 0}
        .input-box input::placeholder,.input-box textarea::placeholder{color:var(--dim)}
        .input-box select option{background:#0d1117}
        .input-box textarea{resize:none;padding:.65rem .65rem .65rem 0}

        /* Image upload */
        .upload-area{border:2px dashed var(--border);border-radius:var(--r);padding:1.5rem;text-align:center;cursor:pointer;transition:border-color .2s;position:relative}
        .upload-area:hover,.upload-area.dragover{border-color:var(--gold)}
        .upload-area input[type=file]{position:absolute;inset:0;opacity:0;cursor:pointer;width:100%;height:100%}
        .upload-icon{font-size:2rem;color:var(--dim);margin-bottom:.5rem;display:block}
        .upload-text{color:var(--muted);font-size:.82rem}
        .upload-hint{color:var(--dim);font-size:.72rem;margin-top:.25rem}
        #previewImg{width:100%;max-height:160px;object-fit:cover;border-radius:8px;margin-top:.75rem;display:none}

        /* Extra attr */
        #extraGroup{display:none}

        .btn-submit{background:var(--gold);color:#000;font-weight:700;font-size:.9rem;padding:10px 26px;border-radius:10px;border:none;cursor:pointer;display:inline-flex;align-items:center;gap:7px;transition:background .15s,transform .1s;font-family:'Poppins'}
        .btn-submit:hover{background:#e0b000;transform:translateY(-1px)}
        .btn-cancel{background:rgba(255,255,255,.04);color:var(--muted);font-size:.9rem;padding:10px 22px;border-radius:10px;border:1px solid var(--border);text-decoration:none;display:inline-flex;align-items:center;gap:7px;transition:background .15s;font-family:'Poppins'}
        .btn-cancel:hover{background:rgba(255,255,255,.07);color:var(--text)}
        .flash-err{background:rgba(244,63,94,.1);border:1px solid rgba(244,63,94,.3);color:#fb7185;border-radius:var(--r);padding:.65rem 1rem;font-size:.82rem;margin-bottom:1.25rem}
    </style>
</head>
<body>
<nav class="navbar">
    <a class="nav-brand" href="${pageContext.request.contextPath}/"><i class="bi bi-film"></i> CINEBOOK</a>
    <div style="display:flex;align-items:center;gap:6px">
        <a href="${pageContext.request.contextPath}/" class="nav-link">&#8592; Gallery</a>
        <c:if test="${not empty sessionScope.username}">
            <span class="nav-username">${sessionScope.username}</span>
            <a href="${pageContext.request.contextPath}/user/logout" class="nav-link">Logout</a>
        </c:if>
    </div>
</nav>

<div class="page">
    <div class="page-title"><i class="bi bi-film"></i> Add New Movie</div>

    <c:if test="${not empty error}"><div class="flash-err"><i class="bi bi-exclamation-triangle-fill"></i> ${error}</div></c:if>

    <form action="${pageContext.request.contextPath}/movie?action=add" method="post" enctype="multipart/form-data">
        <input type="hidden" name="action" value="add">

        <!-- Basic info -->
        <div class="form-card">
            <div class="section-label"><i class="bi bi-film"></i> Movie Details</div>
            <div class="mb-3">
                <label class="field-label">Title</label>
                <div class="input-box"><span class="input-icon"><i class="bi bi-type"></i></span><input type="text" name="title" placeholder="e.g. Inception" required></div>
            </div>
            <div class="row g-3 mb-3">
                <div class="col-md-6">
                    <label class="field-label">Genre</label>
                    <div class="input-box"><span class="input-icon"><i class="bi bi-tag"></i></span>
                        <select name="genre" required>
                            <option value="">— Select —</option>
                            <option>Action</option><option>Comedy</option><option>Drama</option>
                            <option>Horror</option><option>Thriller</option><option>Romance</option>
                            <option>Sci-Fi</option><option>Animation</option>
                        </select>
                    </div>
                </div>
                <div class="col-md-6">
                    <label class="field-label">Duration (minutes)</label>
                    <div class="input-box"><span class="input-icon"><i class="bi bi-clock"></i></span><input type="number" name="duration" placeholder="e.g. 148" min="30" required></div>
                </div>
            </div>
            <div class="row g-3 mb-3">
                <div class="col-md-4">
                    <label class="field-label">Language</label>
                    <div class="input-box"><span class="input-icon"><i class="bi bi-translate"></i></span>
                        <select name="language" required>
                            <option>English</option><option>Sinhala</option><option>Tamil</option>
                            <option>Hindi</option><option>Korean</option><option>French</option>
                        </select>
                    </div>
                </div>
                <div class="col-md-4">
                    <label class="field-label">Age Rating</label>
                    <div class="input-box"><span class="input-icon"><i class="bi bi-shield"></i></span>
                        <select name="rating" required>
                            <option>G</option><option>PG</option><option>PG-13</option><option>R</option>
                        </select>
                    </div>
                </div>
                <div class="col-md-4">
                    <label class="field-label">Status</label>
                    <div class="input-box"><span class="input-icon"><i class="bi bi-circle"></i></span>
                        <select name="status" required>
                            <option>Now Showing</option><option>Coming Soon</option><option>No Longer Showing</option>
                        </select>
                    </div>
                </div>
            </div>
        </div>

        <!-- Type & extra -->
        <div class="form-card">
            <div class="section-label"><i class="bi bi-layers"></i> Movie Type</div>
            <div class="mb-3">
                <label class="field-label">Type</label>
                <div class="input-box"><span class="input-icon"><i class="bi bi-collection"></i></span>
                    <select name="type" id="typeSelect" onchange="toggleExtra()" required>
                        <option value="GENERAL">General</option>
                        <option value="ACTION">Action</option>
                        <option value="COMEDY">Comedy</option>
                    </select>
                </div>
            </div>
            <div id="extraGroup">
                <label class="field-label" id="extraLabel">Extra Attribute</label>
                <div class="input-box"><span class="input-icon"><i class="bi bi-star"></i></span><input type="text" name="extra" id="extraInput" placeholder="e.g. High / Slapstick"></div>
            </div>
        </div>

        <!-- Poster -->
        <div class="form-card">
            <div class="section-label"><i class="bi bi-image"></i> Movie Poster</div>
            <div class="upload-area" id="uploadArea">
                <input type="file" name="image" accept="image/*" onchange="previewImage(this)">
                <span class="upload-icon"><i class="bi bi-cloud-upload"></i></span>
                <div class="upload-text">Click or drag &amp; drop a poster image</div>
                <div class="upload-hint">JPEG, PNG or WebP · Max 5MB</div>
                <img id="previewImg" src="" alt="Preview">
            </div>
        </div>

        <div class="d-flex gap-3">
            <button type="submit" class="btn-submit"><i class="bi bi-plus-circle-fill"></i> Add Movie</button>
            <a href="${pageContext.request.contextPath}/" class="btn-cancel">Cancel</a>
        </div>
    </form>
</div>

<script>
const extraConfigs={ACTION:{label:'Action Intensity',placeholder:'Low / Medium / High / Extreme'},COMEDY:{label:'Humor Style',placeholder:'Slapstick / Satire / Romantic / Dark'}};
function toggleExtra(){
    const v=document.getElementById('typeSelect').value;
    const g=document.getElementById('extraGroup');
    if(extraConfigs[v]){
        document.getElementById('extraLabel').textContent=extraConfigs[v].label;
        document.getElementById('extraInput').placeholder=extraConfigs[v].placeholder;
        g.style.display='block';
    }else{g.style.display='none';}
}
function previewImage(input){
    const img=document.getElementById('previewImg');
    if(input.files&&input.files[0]){
        const reader=new FileReader();
        reader.onload=e=>{img.src=e.target.result;img.style.display='block';};
        reader.readAsDataURL(input.files[0]);
        document.getElementById('uploadArea').querySelector('.upload-text').textContent=input.files[0].name;
    }
}
</script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
