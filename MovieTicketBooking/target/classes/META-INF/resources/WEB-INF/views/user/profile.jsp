<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"  uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Profile – CineBook</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Bebas+Neue&family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <style>
        :root{--bg:#07080d;--surface:#0d1117;--card:#0f1520;--border:#1a2035;--border-md:#252f45;--gold:#f5c518;--gold-dim:rgba(245,197,24,.12);--violet:#8b5cf6;--violet-dim:rgba(139,92,246,.12);--emerald:#10b981;--rose:#f43f5e;--text:#e8edf5;--muted:#8892a4;--dim:#3d4557;--r:12px}
        *{box-sizing:border-box;margin:0;padding:0}
        body{background:var(--bg);color:var(--text);font-family:'Poppins',sans-serif;min-height:100vh}
        body::before{content:'';position:fixed;inset:0;background:radial-gradient(ellipse 60% 40% at 15% 0%,rgba(139,92,246,.06),transparent 55%);pointer-events:none}
        .navbar{position:sticky;top:0;z-index:100;background:rgba(7,8,13,.85);backdrop-filter:blur(20px);border-bottom:1px solid var(--border);padding:0 2rem;height:64px;display:flex;align-items:center;justify-content:space-between}
        .nav-brand{font-family:'Bebas Neue';font-size:1.75rem;letter-spacing:4px;color:var(--gold);text-decoration:none;display:flex;align-items:center;gap:8px}
        .nav-link{color:var(--muted);font-size:.82rem;text-decoration:none;padding:6px 12px;border-radius:8px;transition:color .2s,background .2s}
        .nav-link:hover{color:var(--text);background:rgba(255,255,255,.05)}
        .nav-link.active{color:var(--gold)}
        .nav-username{color:var(--gold);font-size:.82rem;font-weight:600}
        .page{position:relative;z-index:1;max-width:760px;margin:0 auto;padding:2rem}

        /* Profile header */
        .profile-header{background:linear-gradient(135deg,#0a0f20,#14092a);border:1px solid var(--border);border-radius:var(--r);padding:2rem;margin-bottom:1.5rem;display:flex;align-items:center;gap:1.5rem;flex-wrap:wrap}
        .avatar{width:72px;height:72px;border-radius:50%;background:linear-gradient(135deg,var(--gold),#e07b00);display:flex;align-items:center;justify-content:center;font-family:'Bebas Neue';font-size:2rem;color:#000;flex-shrink:0}
        .profile-info{}
        .profile-name{font-family:'Bebas Neue';font-size:1.6rem;letter-spacing:1px;color:#fff}
        .profile-username{color:var(--muted);font-size:.84rem;margin-top:2px}
        .role-pill{font-size:.68rem;font-weight:700;padding:3px 10px;border-radius:4px;margin-top:.4rem;display:inline-flex;align-items:center;gap:5px}
        .role-admin{background:rgba(244,63,94,.12);border:1px solid rgba(244,63,94,.25);color:#fca5a5}
        .role-customer{background:var(--gold-dim);border:1px solid rgba(245,197,24,.25);color:var(--gold)}

        /* Section cards */
        .section-card{background:var(--surface);border:1px solid var(--border);border-radius:var(--r);padding:1.5rem;margin-bottom:1.25rem}
        .section-title{color:var(--dim);font-size:.68rem;font-weight:700;text-transform:uppercase;letter-spacing:1.2px;margin-bottom:1.1rem;display:flex;align-items:center;gap:7px;padding-bottom:.75rem;border-bottom:1px solid var(--border)}
        .section-title i{color:var(--gold)}

        /* Inputs */
        .field-label{color:var(--muted);font-size:.75rem;font-weight:500;margin-bottom:5px;display:block}
        .input-box{display:flex;align-items:center;background:var(--card);border:1px solid var(--border);border-radius:9px;overflow:hidden;transition:border-color .2s,box-shadow .2s}
        .input-box:focus-within{border-color:var(--gold);box-shadow:0 0 0 3px var(--gold-dim)}
        .input-box.disabled{background:rgba(255,255,255,.02);border-color:var(--border)}
        .input-icon{width:40px;display:flex;align-items:center;justify-content:center;color:var(--dim);font-size:.9rem;flex-shrink:0}
        .input-box input{flex:1;background:transparent;border:none;outline:none;color:var(--text);font-family:'Poppins';font-size:.88rem;padding:.65rem .5rem .65rem 0}
        .input-box input:disabled{color:var(--dim)}
        .input-box input::placeholder{color:var(--dim)}
        .input-toggle{width:38px;background:transparent;border:none;color:var(--dim);cursor:pointer;font-size:.9rem;transition:color .15s}
        .input-toggle:hover{color:var(--muted)}

        /* Password strength */
        .strength-bar{height:3px;border-radius:2px;background:var(--border);overflow:hidden;margin-top:5px}
        .strength-fill{height:100%;border-radius:2px;transition:width .3s,background .3s;width:0}
        .match-ok{color:#34d399;font-size:.72rem;margin-top:3px}
        .match-err{color:#fb7185;font-size:.72rem;margin-top:3px}

        /* Buttons */
        .btn-save{background:var(--gold);color:#000;font-weight:700;font-size:.88rem;padding:9px 22px;border-radius:9px;border:none;cursor:pointer;display:inline-flex;align-items:center;gap:6px;transition:background .15s,transform .1s;font-family:'Poppins'}
        .btn-save:hover{background:#e0b000;transform:translateY(-1px)}

        /* Danger zone */
        .danger-zone{background:rgba(244,63,94,.06);border:1px solid rgba(244,63,94,.2);border-radius:var(--r);padding:1.25rem}
        .danger-title{color:#fb7185;font-weight:600;font-size:.9rem;margin-bottom:.4rem;display:flex;align-items:center;gap:6px}
        .btn-danger{background:rgba(244,63,94,.1);color:#fb7185;border:1px solid rgba(244,63,94,.25);font-size:.82rem;padding:7px 16px;border-radius:8px;text-decoration:none;display:inline-flex;align-items:center;gap:5px;transition:background .15s;font-family:'Poppins';font-weight:500}
        .btn-danger:hover{background:rgba(244,63,94,.2);color:#fb7185}

        .flash-ok{background:rgba(16,185,129,.1);border:1px solid rgba(16,185,129,.3);color:#34d399;border-radius:var(--r);padding:.65rem 1rem;font-size:.82rem;margin-bottom:1.25rem}
        .flash-err{background:rgba(244,63,94,.1);border:1px solid rgba(244,63,94,.3);color:#fb7185;border-radius:var(--r);padding:.65rem 1rem;font-size:.82rem;margin-bottom:1.25rem}
    </style>
</head>
<body>
<nav class="navbar">
    <a class="nav-brand" href="${pageContext.request.contextPath}/"><i class="bi bi-film"></i> CINEBOOK</a>
    <div style="display:flex;align-items:center;gap:6px">
        <a href="${pageContext.request.contextPath}/" class="nav-link">Gallery</a>
        <a href="${pageContext.request.contextPath}/booking/my-bookings" class="nav-link">My Tickets</a>
        <a href="${pageContext.request.contextPath}/payment/my-payments" class="nav-link">My Payments</a>
        <a href="${pageContext.request.contextPath}/user/profile" class="nav-link active">Profile</a>
        <a href="${pageContext.request.contextPath}/user/logout" class="nav-link">Logout</a>
    </div>
</nav>

<div class="page">
    <c:if test="${not empty successMsg}"><div class="flash-ok"><i class="bi bi-check-circle-fill"></i> ${successMsg}</div></c:if>
    <c:if test="${not empty errorMsg}"><div class="flash-err"><i class="bi bi-exclamation-triangle-fill"></i> ${errorMsg}</div></c:if>

    <!-- Profile header -->
    <div class="profile-header">
        <div class="avatar">${fn:toUpperCase(fn:substring(user.fullName,0,1))}</div>
        <div class="profile-info">
            <div class="profile-name">${user.fullName}</div>
            <div class="profile-username">@${user.username}</div>
            <c:choose>
                <c:when test="${user.admin}"><span class="role-pill role-admin"><i class="bi bi-shield-fill"></i> Administrator</span></c:when>
                <c:otherwise><span class="role-pill role-customer"><i class="bi bi-person-fill"></i> Customer</span></c:otherwise>
            </c:choose>
        </div>
    </div>

    <!-- Edit profile -->
    <div class="section-card">
        <div class="section-title"><i class="bi bi-pencil-square"></i> Edit Profile</div>
        <form action="${pageContext.request.contextPath}/user/profile/update" method="post">
            <input type="hidden" name="userId" value="${user.userId}">
            <div class="mb-3">
                <label class="field-label">Username (cannot be changed)</label>
                <div class="input-box disabled"><span class="input-icon"><i class="bi bi-at"></i></span><input type="text" value="${user.username}" disabled></div>
            </div>
            <div class="mb-3">
                <label class="field-label">Full Name</label>
                <div class="input-box"><span class="input-icon"><i class="bi bi-person"></i></span><input type="text" name="fullName" value="${user.fullName}" required></div>
            </div>
            <div class="row g-3 mb-3">
                <div class="col-md-6">
                    <label class="field-label">Email</label>
                    <div class="input-box"><span class="input-icon"><i class="bi bi-envelope"></i></span><input type="email" name="email" value="${user.email}" required></div>
                </div>
                <div class="col-md-6">
                    <label class="field-label">Phone</label>
                    <div class="input-box"><span class="input-icon"><i class="bi bi-phone"></i></span><input type="tel" name="phone" value="${user.phone}"></div>
                </div>
            </div>
            <button type="submit" class="btn-save"><i class="bi bi-save2"></i> Save Changes</button>
        </form>
    </div>

    <!-- Change password -->
    <div class="section-card">
        <div class="section-title"><i class="bi bi-key-fill"></i> Change Password</div>
        <form action="${pageContext.request.contextPath}/user/profile/password" method="post">
            <input type="hidden" name="userId" value="${user.userId}">
            <div class="mb-3">
                <label class="field-label">Current Password</label>
                <div class="input-box">
                    <span class="input-icon"><i class="bi bi-lock"></i></span>
                    <input type="password" id="oldPw" name="oldPassword" placeholder="Enter current password" required>
                    <button class="input-toggle" type="button" onclick="tog('oldPw','ei0')"><i class="bi bi-eye" id="ei0"></i></button>
                </div>
            </div>
            <div class="row g-3 mb-3">
                <div class="col-md-6">
                    <label class="field-label">New Password</label>
                    <div class="input-box">
                        <span class="input-icon"><i class="bi bi-lock-fill"></i></span>
                        <input type="password" id="newPw" name="newPassword" placeholder="New password" required oninput="strength(this.value)">
                        <button class="input-toggle" type="button" onclick="tog('newPw','ei1')"><i class="bi bi-eye" id="ei1"></i></button>
                    </div>
                    <div class="strength-bar"><div class="strength-fill" id="sFill"></div></div>
                </div>
                <div class="col-md-6">
                    <label class="field-label">Confirm Password</label>
                    <div class="input-box">
                        <span class="input-icon"><i class="bi bi-lock-fill"></i></span>
                        <input type="password" id="cfPw" name="confirmPassword" placeholder="Repeat new password" required oninput="matchChk()">
                    </div>
                    <div id="matchMsg"></div>
                </div>
            </div>
            <button type="submit" class="btn-save"><i class="bi bi-shield-check"></i> Update Password</button>
        </form>
    </div>

    <!-- Danger zone -->
    <div class="danger-zone">
        <div class="danger-title"><i class="bi bi-exclamation-triangle-fill"></i> Danger Zone</div>
        <p style="color:var(--muted);font-size:.82rem;margin-bottom:1rem">Deactivating your account prevents future logins until an admin reactivates it.</p>
        <a href="${pageContext.request.contextPath}/user/deactivate" class="btn-danger" onclick="return confirm('Deactivate your account?')">
            <i class="bi bi-person-x"></i> Deactivate Account
        </a>
    </div>
</div>

<script>
function tog(id,eid){const i=document.getElementById(id),e=document.getElementById(eid);i.type=i.type==='password'?'text':'password';e.className=i.type==='password'?'bi bi-eye':'bi bi-eye-slash';}
function strength(v){const f=document.getElementById('sFill');let s=0;if(v.length>=8)s++;if(/[A-Z]/.test(v))s++;if(/[0-9]/.test(v))s++;if(/[^A-Za-z0-9]/.test(v))s++;const c=['#ef4444','#f97316','#eab308','#22c55e'][s-1]||'var(--border)';f.style.width=[0,25,50,75,100][s]+'%';f.style.background=c;}
function matchChk(){const p1=document.getElementById('newPw').value,p2=document.getElementById('cfPw').value,d=document.getElementById('matchMsg');if(!p2){d.textContent='';return;}if(p1===p2){d.className='match-ok';d.textContent='✓ Passwords match';}else{d.className='match-err';d.textContent='✗ Passwords do not match';}}
</script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
