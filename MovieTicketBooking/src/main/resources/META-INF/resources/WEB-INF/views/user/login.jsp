<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Sign In – CineBook</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Bebas+Neue&family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <style>
        :root {
            --bg: #07080d; --surface: #0d1117; --card: #0f1520;
            --border: #1a2035; --border-md: #252f45;
            --gold: #f5c518; --gold-dim: rgba(245,197,24,0.12);
            --violet: #8b5cf6; --violet-dim: rgba(139,92,246,0.12);
            --text: #e8edf5; --muted: #8892a4; --dim: #3d4557;
        }
        * { box-sizing: border-box; margin: 0; padding: 0; }
        body {
            background: var(--bg);
            font-family: 'Poppins', sans-serif;
            min-height: 100vh;
            display: flex;
        }

        /* ── Left cinematic panel ── */
        .cinema-panel {
            flex: 1; min-height: 100vh;
            background: linear-gradient(160deg, #0a0f1e 0%, #130a28 50%, #0a1a14 100%);
            display: flex; flex-direction: column;
            align-items: center; justify-content: center;
            padding: 3rem; position: relative; overflow: hidden;
        }
        /* Ambient orbs */
        .cinema-panel::before {
            content: '';
            position: absolute; width: 500px; height: 500px;
            border-radius: 50%;
            background: radial-gradient(circle, rgba(139,92,246,0.12) 0%, transparent 70%);
            top: -100px; left: -100px; pointer-events: none;
        }
        .cinema-panel::after {
            content: '';
            position: absolute; width: 400px; height: 400px;
            border-radius: 50%;
            background: radial-gradient(circle, rgba(245,197,24,0.07) 0%, transparent 70%);
            bottom: -80px; right: -80px; pointer-events: none;
        }
        /* Floating film strip decoration */
        .film-strip {
            position: absolute; opacity: 0.04;
            font-size: 12rem; color: white;
            transform: rotate(-20deg);
            pointer-events: none; user-select: none;
        }
        .film-strip-1 { top: 5%; left: -5%; }
        .film-strip-2 { bottom: 5%; right: -5%; font-size: 8rem; }

        .cinema-content { position: relative; z-index: 1; text-align: center; max-width: 420px; }
        .cinema-logo {
            font-family: 'Bebas Neue'; font-size: 4rem;
            letter-spacing: 8px; color: var(--gold);
            line-height: 1; margin-bottom: 0.5rem;
        }
        .cinema-tagline { color: var(--muted); font-size: 0.9rem; margin-bottom: 3rem; }

        /* Feature list */
        .feature-list { list-style: none; text-align: left; display: flex; flex-direction: column; gap: 1.25rem; }
        .feature-item { display: flex; align-items: flex-start; gap: 14px; }
        .feature-icon {
            width: 40px; height: 40px; border-radius: 10px; flex-shrink: 0;
            display: flex; align-items: center; justify-content: center;
            font-size: 1.1rem;
        }
        .fi-gold   { background: var(--gold-dim); color: var(--gold); border: 1px solid rgba(245,197,24,0.2); }
        .fi-violet { background: var(--violet-dim); color: #a78bfa; border: 1px solid rgba(139,92,246,0.2); }
        .fi-green  { background: rgba(16,185,129,0.1); color: #34d399; border: 1px solid rgba(16,185,129,0.2); }
        .feature-text strong { display: block; color: var(--text); font-size: 0.88rem; font-weight: 600; }
        .feature-text span   { color: var(--muted); font-size: 0.78rem; }

        /* ── Right form panel ── */
        .form-panel {
            width: 460px; flex-shrink: 0;
            background: var(--surface);
            border-left: 1px solid var(--border);
            display: flex; flex-direction: column;
            align-items: center; justify-content: center;
            padding: 3rem 3rem;
        }
        .form-inner { width: 100%; max-width: 360px; }

        .form-heading { font-size: 1.6rem; font-weight: 700; color: var(--text); margin-bottom: 0.25rem; }
        .form-subheading { color: var(--muted); font-size: 0.84rem; margin-bottom: 2rem; }

        /* Input groups */
        .field-wrap { margin-bottom: 1.25rem; }
        .field-label { color: var(--muted); font-size: 0.78rem; font-weight: 500; margin-bottom: 6px; display: block; }
        .input-box {
            display: flex; align-items: center;
            background: var(--card); border: 1px solid var(--border);
            border-radius: 10px; overflow: hidden;
            transition: border-color 0.2s, box-shadow 0.2s;
        }
        .input-box:focus-within {
            border-color: var(--gold);
            box-shadow: 0 0 0 3px var(--gold-dim);
        }
        .input-icon {
            width: 44px; display: flex; align-items: center; justify-content: center;
            color: var(--dim); font-size: 0.95rem; flex-shrink: 0;
        }
        .input-box input {
            flex: 1; background: transparent; border: none; outline: none;
            color: var(--text); font-size: 0.9rem; font-family: 'Poppins';
            padding: 0.7rem 0.5rem 0.7rem 0;
        }
        .input-box input::placeholder { color: var(--dim); }
        .input-toggle {
            width: 40px; height: 100%; display: flex;
            align-items: center; justify-content: center;
            background: transparent; border: none;
            color: var(--dim); cursor: pointer; font-size: 0.95rem;
            transition: color 0.15s;
        }
        .input-toggle:hover { color: var(--muted); }

        .forgot-link {
            display: block; text-align: right;
            color: var(--violet); font-size: 0.78rem;
            text-decoration: none; margin-bottom: 1.5rem;
            transition: color 0.15s;
        }
        .forgot-link:hover { color: #c4b5fd; }

        .btn-signin {
            width: 100%; padding: 0.8rem;
            background: var(--gold); color: #000;
            font-weight: 700; font-size: 0.95rem;
            border: none; border-radius: 10px; cursor: pointer;
            transition: background 0.2s, transform 0.1s;
            display: flex; align-items: center; justify-content: center; gap: 8px;
        }
        .btn-signin:hover { background: #e0b000; transform: translateY(-1px); }
        .btn-signin:active { transform: translateY(0); }

        .divider-line {
            display: flex; align-items: center; gap: 12px;
            margin: 1.5rem 0; color: var(--dim); font-size: 0.78rem;
        }
        .divider-line::before, .divider-line::after {
            content: ''; flex: 1; height: 1px; background: var(--border);
        }

        .register-row { text-align: center; font-size: 0.84rem; }
        .register-row span { color: var(--muted); }
        .register-row a { color: var(--gold); text-decoration: none; font-weight: 600; }
        .register-row a:hover { color: #e0b000; }

        /* Alerts */
        .alert-success {
            background: rgba(16,185,129,0.1); border: 1px solid rgba(16,185,129,0.3);
            color: #34d399; border-radius: 8px; padding: 0.65rem 1rem;
            font-size: 0.82rem; margin-bottom: 1.25rem;
        }
        .alert-error {
            background: rgba(244,63,94,0.1); border: 1px solid rgba(244,63,94,0.3);
            color: #fb7185; border-radius: 8px; padding: 0.65rem 1rem;
            font-size: 0.82rem; margin-bottom: 1.25rem;
        }

        /* Mobile: stack panels */
        @media (max-width: 768px) {
            body { flex-direction: column; }
            .cinema-panel { min-height: 200px; padding: 2rem; }
            .cinema-logo { font-size: 2.5rem; }
            .feature-list { display: none; }
            .form-panel { width: 100%; border-left: none; border-top: 1px solid var(--border); padding: 2rem 1.5rem; }
        }
    </style>
</head>
<body>

<!-- ── Left: Cinematic brand panel ──────────────────────────────────────── -->
<div class="cinema-panel">
    <i class="bi bi-film film-strip film-strip-1"></i>
    <i class="bi bi-film film-strip film-strip-2"></i>

    <div class="cinema-content">
        <div class="cinema-logo">CINEBOOK</div>
        <p class="cinema-tagline">Your premium movie ticket experience</p>

        <ul class="feature-list">
            <li class="feature-item">
                <div class="feature-icon fi-gold"><i class="bi bi-film"></i></div>
                <div class="feature-text">
                    <strong>Browse &amp; Discover</strong>
                    <span>Explore our full catalog — no login required</span>
                </div>
            </li>
            <li class="feature-item">
                <div class="feature-icon fi-violet"><i class="bi bi-grid-3x3-gap"></i></div>
                <div class="feature-text">
                    <strong>Choose Your Seats</strong>
                    <span>Visual hall map with VIP &amp; Standard sections</span>
                </div>
            </li>
            <li class="feature-item">
                <div class="feature-icon fi-green"><i class="bi bi-ticket-perforated"></i></div>
                <div class="feature-text">
                    <strong>Instant Digital Tickets</strong>
                    <span>Receive a digital receipt with every booking</span>
                </div>
            </li>
        </ul>
    </div>
</div>

<!-- ── Right: Sign In form ───────────────────────────────────────────────── -->
<div class="form-panel">
    <div class="form-inner">

        <h1 class="form-heading">Welcome back</h1>
        <p class="form-subheading">Sign in to book your tickets</p>

        <c:if test="${not empty successMsg}">
            <div class="alert-success"><i class="bi bi-check-circle-fill"></i> ${successMsg}</div>
        </c:if>
        <c:if test="${not empty errorMsg}">
            <div class="alert-error"><i class="bi bi-exclamation-triangle-fill"></i> ${errorMsg}</div>
        </c:if>

        <form action="${pageContext.request.contextPath}/user/login" method="post">

            <div class="field-wrap">
                <label class="field-label">Username</label>
                <div class="input-box">
                    <span class="input-icon"><i class="bi bi-person"></i></span>
                    <input type="text" name="username" placeholder="Enter your username" required autofocus>
                </div>
            </div>

            <div class="field-wrap">
                <label class="field-label">Password</label>
                <div class="input-box">
                    <span class="input-icon"><i class="bi bi-lock"></i></span>
                    <input type="password" id="passInput" name="password" placeholder="Enter your password" required>
                    <button class="input-toggle" type="button" onclick="togglePass()">
                        <i class="bi bi-eye" id="eyeIcon"></i>
                    </button>
                </div>
            </div>

            <a href="${pageContext.request.contextPath}/user/forgot-password" class="forgot-link">
                Forgot password?
            </a>

            <button type="submit" class="btn-signin">
                <i class="bi bi-box-arrow-in-right"></i> Sign In
            </button>
        </form>

        <div class="divider-line">or</div>

        <div class="register-row">
            <span>Don't have an account? </span>
            <a href="${pageContext.request.contextPath}/user/register">Create one</a>
        </div>

        <div style="text-align:center; margin-top:2rem;">
            <a href="${pageContext.request.contextPath}/"
               style="color:var(--dim); font-size:0.78rem; text-decoration:none; display:inline-flex; align-items:center; gap:5px;">
                <i class="bi bi-arrow-left"></i> Continue browsing without signing in
            </a>
        </div>

    </div>
</div>

<script>
    function togglePass() {
        const i = document.getElementById('passInput');
        const e = document.getElementById('eyeIcon');
        i.type = i.type === 'password' ? 'text' : 'password';
        e.className = i.type === 'password' ? 'bi bi-eye' : 'bi bi-eye-slash';
    }
</script>
</body>
</html>
