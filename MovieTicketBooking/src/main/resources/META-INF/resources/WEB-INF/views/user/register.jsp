<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Create Account – CineBook</title>
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
        }
        * { box-sizing: border-box; margin: 0; padding: 0; }
        body {
            background: var(--bg);
            color: var(--text);
            font-family: 'Poppins', sans-serif;
            min-height: 100vh;
            padding: 2rem 0;
        }
        body::before {
            content: '';
            position: fixed; inset: 0; z-index: 0;
            background:
                radial-gradient(ellipse 60% 40% at 10% 0%, rgba(139,92,246,0.06) 0%, transparent 60%),
                radial-gradient(ellipse 50% 35% at 90% 100%, rgba(245,197,24,0.04) 0%, transparent 50%);
            pointer-events: none;
        }

        .page-wrap { position: relative; z-index: 1; max-width: 600px; margin: 0 auto; padding: 0 1.5rem; }

        /* Back link */
        .back-link {
            display: inline-flex; align-items: center; gap: 6px;
            color: var(--dim); font-size: 0.82rem; text-decoration: none;
            margin-bottom: 1.5rem; transition: color 0.15s;
        }
        .back-link:hover { color: var(--muted); }

        /* Header */
        .page-header { text-align: center; margin-bottom: 2rem; }
        .page-logo { font-family: 'Bebas Neue'; font-size: 2rem; letter-spacing: 4px; color: var(--gold); margin-bottom: 0.25rem; }
        .page-title { font-size: 1.5rem; font-weight: 700; color: var(--text); margin-bottom: 0.25rem; }
        .page-sub   { color: var(--muted); font-size: 0.84rem; }

        /* Card */
        .form-card {
            background: var(--surface);
            border: 1px solid var(--border);
            border-radius: 16px;
            padding: 2rem;
            margin-bottom: 1rem;
        }

        /* Section labels */
        .section-label {
            font-size: 0.7rem; font-weight: 700;
            text-transform: uppercase; letter-spacing: 1.5px;
            color: var(--dim); border-bottom: 1px solid var(--border);
            padding-bottom: 0.6rem; margin-bottom: 1.25rem; margin-top: 0.25rem;
            display: flex; align-items: center; gap: 8px;
        }
        .section-label i { color: var(--gold); }

        /* Input boxes */
        .field-wrap { margin-bottom: 1.1rem; }
        .field-label { color: var(--muted); font-size: 0.78rem; font-weight: 500; margin-bottom: 5px; display: block; }
        .input-box {
            display: flex; align-items: center;
            background: var(--card); border: 1px solid var(--border);
            border-radius: 10px; overflow: hidden;
            transition: border-color 0.2s, box-shadow 0.2s;
        }
        .input-box:focus-within { border-color: var(--gold); box-shadow: 0 0 0 3px var(--gold-dim); }
        .input-icon { width: 42px; display: flex; align-items: center; justify-content: center; color: var(--dim); font-size: 0.9rem; flex-shrink: 0; }
        .input-box input, .input-box select {
            flex: 1; background: transparent; border: none; outline: none;
            color: var(--text); font-size: 0.88rem; font-family: 'Poppins';
            padding: 0.65rem 0.5rem 0.65rem 0;
            -webkit-appearance: none;
        }
        .input-box select option { background: #0d1117; color: var(--text); }
        .input-box input::placeholder { color: var(--dim); }
        .input-toggle { width: 38px; background: transparent; border: none; color: var(--dim); cursor: pointer; font-size: 0.9rem; transition: color 0.15s; }
        .input-toggle:hover { color: var(--muted); }

        /* Password strength */
        .strength-bar { height: 3px; border-radius: 2px; margin-top: 6px; background: var(--border); overflow: hidden; }
        .strength-fill { height: 100%; border-radius: 2px; transition: width 0.3s, background 0.3s; width: 0; }
        .strength-text { font-size: 0.7rem; color: var(--dim); margin-top: 3px; }

        /* Match indicator */
        .match-ok  { color: var(--emerald); font-size: 0.72rem; margin-top: 3px; }
        .match-err { color: #fb7185; font-size: 0.72rem; margin-top: 3px; }

        /* Submit */
        .btn-create {
            width: 100%; padding: 0.8rem;
            background: var(--gold); color: #000;
            font-weight: 700; font-size: 0.95rem;
            border: none; border-radius: 10px; cursor: pointer;
            transition: background 0.2s, transform 0.1s;
            display: flex; align-items: center; justify-content: center; gap: 8px;
            margin-top: 1.5rem;
        }
        .btn-create:hover { background: #e0b000; transform: translateY(-1px); }

        .login-row { text-align: center; font-size: 0.84rem; color: var(--muted); margin-top: 1.25rem; }
        .login-row a { color: var(--gold); text-decoration: none; font-weight: 600; }
        .login-row a:hover { color: #e0b000; }

        .alert-error { background: rgba(244,63,94,0.1); border: 1px solid rgba(244,63,94,0.3); color: #fb7185; border-radius: 8px; padding: 0.65rem 1rem; font-size: 0.82rem; margin-bottom: 1.25rem; }


    </style>
</head>
<body>
<div class="page-wrap">

    <a href="${pageContext.request.contextPath}/" class="back-link">
        <i class="bi bi-arrow-left"></i> Back to Gallery
    </a>

    <div class="page-header">
        <div class="page-logo"><i class="bi bi-film"></i> CINEBOOK</div>
        <h1 class="page-title">Create your account</h1>
        <p class="page-sub">Free to join — start booking in minutes</p>
    </div>

    <c:if test="${not empty errorMsg}">
        <div class="alert-error"><i class="bi bi-exclamation-triangle-fill"></i> ${errorMsg}</div>
    </c:if>

    <form action="${pageContext.request.contextPath}/user/register" method="post">

        <!-- ── Account Info ── -->
        <div class="form-card">
            <div class="section-label"><i class="bi bi-person-circle"></i> Account Details</div>

            <div class="row g-3">
                <div class="col-md-6">
                    <div class="field-wrap">
                        <label class="field-label">Username</label>
                        <div class="input-box">
                            <span class="input-icon"><i class="bi bi-at"></i></span>
                            <input type="text" name="username" placeholder="e.g. john_doe" required>
                        </div>
                    </div>
                </div>
                <div class="col-md-6">
                    <div class="field-wrap">
                        <label class="field-label">Email Address</label>
                        <div class="input-box">
                            <span class="input-icon"><i class="bi bi-envelope"></i></span>
                            <input type="email" name="email" placeholder="you@example.com" required>
                        </div>
                    </div>
                </div>
            </div>

            <div class="field-wrap">
                <label class="field-label">New Password</label>
                <div class="input-box">
                    <span class="input-icon"><i class="bi bi-lock"></i></span>
                    <input type="password" id="pw1" name="password" placeholder="Create a strong password"
                           required oninput="checkStrength(this.value)">
                    <button class="input-toggle" type="button" onclick="togglePass('pw1','eye1')">
                        <i class="bi bi-eye" id="eye1"></i>
                    </button>
                </div>
                <div class="strength-bar"><div class="strength-fill" id="strengthFill"></div></div>
                <div class="strength-text" id="strengthText"></div>
            </div>

            <div class="field-wrap">
                <label class="field-label">Confirm Password</label>
                <div class="input-box">
                    <span class="input-icon"><i class="bi bi-lock-fill"></i></span>
                    <input type="password" id="pw2" name="confirmPassword"
                           placeholder="Repeat your password" required oninput="checkMatch()">
                    <button class="input-toggle" type="button" onclick="togglePass('pw2','eye2')">
                        <i class="bi bi-eye" id="eye2"></i>
                    </button>
                </div>
                <div id="matchMsg"></div>
            </div>
        </div>

        <!-- ── Personal Info ── -->
        <div class="form-card">
            <div class="section-label"><i class="bi bi-person-badge"></i> Personal Info</div>

            <div class="field-wrap">
                <label class="field-label">Full Name</label>
                <div class="input-box">
                    <span class="input-icon"><i class="bi bi-person"></i></span>
                    <input type="text" name="fullName" placeholder="Your full name" required>
                </div>
            </div>

            <div class="field-wrap">
                <label class="field-label">Phone Number</label>
                <div class="input-box">
                    <span class="input-icon"><i class="bi bi-phone"></i></span>
                    <input type="tel" name="phone" placeholder="+94 7X XXX XXXX">
                </div>
            </div>
        </div>



        <button type="submit" class="btn-create">
            <i class="bi bi-person-plus-fill"></i> Create Account
        </button>

        <div class="login-row">
            Already have an account? <a href="${pageContext.request.contextPath}/user/login">Sign in</a>
        </div>

    </form>
</div>

<script>
    function togglePass(id, eid) {
        const i = document.getElementById(id), e = document.getElementById(eid);
        i.type = i.type === 'password' ? 'text' : 'password';
        e.className = i.type === 'password' ? 'bi bi-eye' : 'bi bi-eye-slash';
    }
    function checkStrength(v) {
        const fill = document.getElementById('strengthFill');
        const text = document.getElementById('strengthText');
        let score = 0;
        if (v.length >= 8)                    score++;
        if (/[A-Z]/.test(v))                  score++;
        if (/[0-9]/.test(v))                  score++;
        if (/[^A-Za-z0-9]/.test(v))           score++;
        const pct   = [0,25,50,75,100][score];
        const color = ['#ef4444','#f97316','#eab308','#22c55e'][score-1] || '#3d4557';
        const label = ['','Weak','Fair','Good','Strong'][score];
        fill.style.width = pct + '%';
        fill.style.background = color;
        text.textContent = v.length ? label : '';
        text.style.color = color;
    }
    function checkMatch() {
        const p1 = document.getElementById('pw1').value;
        const p2 = document.getElementById('pw2').value;
        const d  = document.getElementById('matchMsg');
        if (!p2) { d.textContent = ''; return; }
        if (p1 === p2) { d.className = 'match-ok'; d.textContent = '✓ Passwords match'; }
        else            { d.className = 'match-err'; d.textContent = '✗ Passwords do not match'; }
    }
</script>
</body>
</html>
