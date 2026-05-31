<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Forgot Password – CineBook</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Bebas+Neue&family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <style>
        :root{--bg:#07080d;--surface:#0d1117;--card:#0f1520;--border:#1a2035;--border-md:#252f45;
              --gold:#f5c518;--gold-dim:rgba(245,197,24,.12);--violet:#8b5cf6;
              --violet-dim:rgba(139,92,246,.12);--emerald:#10b981;--rose:#f43f5e;
              --text:#e8edf5;--muted:#8892a4;--dim:#3d4557;--r:12px}
        *{box-sizing:border-box;margin:0;padding:0}
        body{background:var(--bg);color:var(--text);font-family:'Poppins',sans-serif;
             min-height:100vh;display:flex;flex-direction:column;
             align-items:center;justify-content:center;padding:2rem}
        body::before{content:'';position:fixed;inset:0;
             background:radial-gradient(ellipse 70% 50% at 30% 20%,rgba(139,92,246,.07),transparent 60%);
             pointer-events:none}

        .card{background:var(--surface);border:1px solid var(--border);border-radius:var(--r);
              padding:2.5rem;width:100%;max-width:440px;position:relative;z-index:1;
              box-shadow:0 20px 60px rgba(0,0,0,.5)}

        /* Brand */
        .brand{text-align:center;margin-bottom:2rem}
        .brand-logo{font-family:'Bebas Neue';font-size:1.8rem;letter-spacing:4px;color:var(--gold)}

        /* Step dots */
        .step-dots{display:flex;gap:6px;justify-content:center;margin-bottom:1.5rem}
        .dot{width:8px;height:8px;border-radius:50%;background:var(--border)}
        .dot.active{background:var(--gold);width:24px;border-radius:4px}
        .dot.done{background:var(--emerald)}

        /* Card text */
        .card-title{font-size:1.2rem;font-weight:700;color:var(--text);margin-bottom:.25rem}
        .card-sub{color:var(--muted);font-size:.84rem;margin-bottom:1.75rem;line-height:1.5}

        /* Inputs */
        .field-label{color:var(--muted);font-size:.75rem;font-weight:500;margin-bottom:5px;display:block}
        .input-box{display:flex;align-items:center;background:var(--card);border:1px solid var(--border);
                   border-radius:9px;overflow:hidden;transition:border-color .2s,box-shadow .2s;
                   margin-bottom:1.1rem}
        .input-box:focus-within{border-color:var(--gold);box-shadow:0 0 0 3px var(--gold-dim)}
        .input-icon{width:40px;display:flex;align-items:center;justify-content:center;
                    color:var(--dim);font-size:.9rem;flex-shrink:0}
        .input-box input{flex:1;background:transparent;border:none;outline:none;color:var(--text);
                         font-family:'Poppins';font-size:.88rem;padding:.65rem .5rem .65rem 0}
        .input-box input::placeholder{color:var(--dim)}

        /* OTP input — large digits */
        .otp-wrap{display:flex;justify-content:center;gap:10px;margin-bottom:1.25rem}
        .otp-cell{width:44px;height:54px;background:var(--card);border:1.5px solid var(--border);
                  border-radius:9px;text-align:center;font-size:1.4rem;font-weight:700;
                  color:var(--text);font-family:monospace;outline:none;
                  transition:border-color .2s,box-shadow .2s;caret-color:var(--gold)}
        .otp-cell:focus{border-color:var(--gold);box-shadow:0 0 0 3px var(--gold-dim)}
        .otp-cell.filled{border-color:var(--border-md)}

        /* Resend row */
        .resend-row{text-align:center;font-size:.78rem;color:var(--dim);margin-top:.25rem;margin-bottom:1.25rem}
        .resend-row a{color:var(--violet);text-decoration:none}
        .resend-row a:hover{color:#c4b5fd}

        /* Password strength */
        .strength-bar{height:3px;border-radius:2px;background:var(--border);overflow:hidden;margin-top:4px}
        .strength-fill{height:100%;border-radius:2px;transition:width .3s,background .3s;width:0}
        .match-ok{color:#34d399;font-size:.72rem;margin-top:3px}
        .match-err{color:#fb7185;font-size:.72rem;margin-top:3px}

        /* Primary button */
        .btn-primary{width:100%;padding:.8rem;background:var(--gold);color:#000;font-weight:700;
                     font-size:.95rem;border:none;border-radius:var(--r);cursor:pointer;
                     transition:background .15s,transform .1s;display:flex;align-items:center;
                     justify-content:center;gap:7px;font-family:'Poppins';margin-top:.25rem}
        .btn-primary:hover{background:#e0b000;transform:translateY(-1px)}
        .btn-primary:active{transform:translateY(0)}

        /* Alert boxes */
        .alert-info{background:var(--violet-dim);border:1px solid rgba(139,92,246,.25);color:#c4b5fd;
                    border-radius:8px;padding:.7rem 1rem;font-size:.82rem;margin-bottom:1.1rem;
                    display:flex;align-items:flex-start;gap:8px;line-height:1.5}
        .alert-info i{flex-shrink:0;margin-top:1px}
        .alert-err{background:rgba(244,63,94,.1);border:1px solid rgba(244,63,94,.3);color:#fb7185;
                   border-radius:8px;padding:.7rem 1rem;font-size:.82rem;margin-bottom:1.1rem}
        .alert-ok{background:rgba(16,185,129,.1);border:1px solid rgba(16,185,129,.3);color:#34d399;
                  border-radius:8px;padding:.7rem 1rem;font-size:.82rem;margin-bottom:1.1rem}

        .back-link{display:block;text-align:center;color:var(--dim);font-size:.8rem;
                   text-decoration:none;margin-top:1.25rem;transition:color .15s}
        .back-link:hover{color:var(--muted)}

        /* Email hint badge */
        .email-badge{display:inline-flex;align-items:center;gap:6px;background:var(--gold-dim);
                     border:1px solid rgba(245,197,24,.25);color:var(--gold);font-size:.78rem;
                     padding:4px 12px;border-radius:6px;margin-bottom:1rem}
    </style>
</head>
<body>
<div class="card">

    <div class="brand">
        <div class="brand-logo"><i class="bi bi-film"></i> CINEBOOK</div>
    </div>

    <c:if test="${not empty errorMsg}">
        <div class="alert-err"><i class="bi bi-exclamation-triangle-fill"></i> ${errorMsg}</div>
    </c:if>

    <%-- ════════════════════════════════════════════════════════════
         STEP 1 — Enter username
         Condition: no otpSent flag and no showResetForm flag
         ════════════════════════════════════════════════════════════ --%>
    <c:if test="${empty otpSent and empty showResetForm}">

        <div class="step-dots">
            <div class="dot active"></div>
            <div class="dot"></div>
            <div class="dot"></div>
        </div>

        <div class="card-title">Forgot Password?</div>
        <div class="card-sub">
            Enter your username and we'll send a 6-digit verification
            code to your registered email address.
        </div>

        <form action="${pageContext.request.contextPath}/user/forgot-password" method="post">
            <label class="field-label">Username</label>
            <div class="input-box">
                <span class="input-icon"><i class="bi bi-person"></i></span>
                <input type="text" name="username" placeholder="Your username" required autofocus>
            </div>
            <button type="submit" class="btn-primary">
                <i class="bi bi-send-fill"></i> Send Verification Code
            </button>
        </form>

        <a href="${pageContext.request.contextPath}/user/login" class="back-link">
            &#8592; Back to Sign In
        </a>

    </c:if>

    <%-- ════════════════════════════════════════════════════════════
         STEP 2 — Enter OTP
         Condition: otpSent is set, showResetForm is not
         ════════════════════════════════════════════════════════════ --%>
    <c:if test="${not empty otpSent and empty showResetForm}">

        <div class="step-dots">
            <div class="dot done"></div>
            <div class="dot active"></div>
            <div class="dot"></div>
        </div>

        <div class="card-title">Enter Verification Code</div>
        <div class="card-sub">
            A 6-digit code has been sent to the email registered to
            <strong style="color:var(--text)">${username}</strong>.
        </div>

        <c:if test="${not empty infoMsg}">
            <div class="alert-info"><i class="bi bi-envelope-fill"></i> ${infoMsg}</div>
        </c:if>

        <form action="${pageContext.request.contextPath}/user/verify-otp" method="post"
              id="otpForm">
            <input type="hidden" name="username" value="${username}">

            <%-- Six individual OTP cells — JS joins them into one hidden field --%>
            <div class="otp-wrap" id="otpWrap">
                <input class="otp-cell" maxlength="1" pattern="\d" inputmode="numeric" id="c0">
                <input class="otp-cell" maxlength="1" pattern="\d" inputmode="numeric" id="c1">
                <input class="otp-cell" maxlength="1" pattern="\d" inputmode="numeric" id="c2">
                <input class="otp-cell" maxlength="1" pattern="\d" inputmode="numeric" id="c3">
                <input class="otp-cell" maxlength="1" pattern="\d" inputmode="numeric" id="c4">
                <input class="otp-cell" maxlength="1" pattern="\d" inputmode="numeric" id="c5">
            </div>
            <input type="hidden" name="otpCode" id="otpHidden">

            <button type="submit" class="btn-primary" id="verifyBtn" disabled>
                <i class="bi bi-shield-check-fill"></i> Verify Code
            </button>
        </form>

        <%-- Countdown timer + resend link --%>
        <div class="resend-row">
            Didn't receive it?
            <span id="countdownWrap">
                Resend available in <span id="countdown">120</span>s
            </span>
            <span id="resendWrap" style="display:none">
                <a href="${pageContext.request.contextPath}/user/forgot-password?resend=true"
                   onclick="document.getElementById('resendUsername').value='${username}';
                            document.getElementById('resendForm').submit(); return false;">
                    Resend code
                </a>
            </span>
        </div>

        <%-- Hidden resend form --%>
        <form id="resendForm" action="${pageContext.request.contextPath}/user/forgot-password"
              method="post" style="display:none">
            <input type="hidden" id="resendUsername" name="username" value="${username}">
        </form>

        <a href="${pageContext.request.contextPath}/user/forgot-password" class="back-link">
            &#8592; Try a different username
        </a>

    </c:if>

    <%-- ════════════════════════════════════════════════════════════
         STEP 3 — Set new password
         Condition: showResetForm is set
         ════════════════════════════════════════════════════════════ --%>
    <c:if test="${not empty showResetForm}">

        <div class="step-dots">
            <div class="dot done"></div>
            <div class="dot done"></div>
            <div class="dot active"></div>
        </div>

        <div class="card-title">Set New Password</div>
        <div class="card-sub">
            Identity verified. Choose a strong password for
            <strong style="color:var(--text)">@${username}</strong>.
        </div>

        <form action="${pageContext.request.contextPath}/user/reset-password" method="post">
            <input type="hidden" name="username" value="${username}">

            <label class="field-label">New Password</label>
            <div class="input-box" style="margin-bottom:.4rem">
                <span class="input-icon"><i class="bi bi-lock-fill"></i></span>
                <input type="password" id="np" name="newPassword"
                       placeholder="Create a strong password"
                       required autofocus oninput="str(this.value)">
            </div>
            <div class="strength-bar" style="margin-bottom:1rem">
                <div class="strength-fill" id="sBar"></div>
            </div>

            <label class="field-label">Confirm Password</label>
            <div class="input-box" style="margin-bottom:.4rem">
                <span class="input-icon"><i class="bi bi-lock-fill"></i></span>
                <input type="password" id="cp" name="confirmPassword"
                       placeholder="Repeat your password"
                       required oninput="chkMatch()">
            </div>
            <div id="mMsg" style="margin-bottom:1rem"></div>

            <button type="submit" class="btn-primary">
                <i class="bi bi-check-circle-fill"></i> Reset Password
            </button>
        </form>

    </c:if>

</div><!-- /.card -->

<script>
/* ── OTP cell navigation ──────────────────────────────────────────────── */
const cells = Array.from(document.querySelectorAll('.otp-cell'));
const verifyBtn = document.getElementById('verifyBtn');
const otpHidden = document.getElementById('otpHidden');

if (cells.length) {
    cells[0].focus();

    cells.forEach((cell, idx) => {
        cell.addEventListener('input', e => {
            // Allow digits only
            cell.value = cell.value.replace(/\D/g, '').slice(-1);
            cell.classList.toggle('filled', cell.value !== '');
            if (cell.value && idx < 5) cells[idx + 1].focus();
            updateOtp();
        });

        cell.addEventListener('keydown', e => {
            if (e.key === 'Backspace' && !cell.value && idx > 0) {
                cells[idx - 1].focus();
            }
            if (e.key === 'ArrowLeft'  && idx > 0) cells[idx - 1].focus();
            if (e.key === 'ArrowRight' && idx < 5) cells[idx + 1].focus();
        });

        // Handle paste: spread digits across cells
        cell.addEventListener('paste', e => {
            e.preventDefault();
            const digits = (e.clipboardData.getData('text') || '').replace(/\D/g,'').slice(0,6);
            digits.split('').forEach((d, i) => {
                if (cells[idx + i]) {
                    cells[idx + i].value = d;
                    cells[idx + i].classList.add('filled');
                }
            });
            const next = Math.min(idx + digits.length, 5);
            cells[next].focus();
            updateOtp();
        });
    });

    function updateOtp() {
        const code = cells.map(c => c.value).join('');
        otpHidden.value = code;
        if (verifyBtn) verifyBtn.disabled = code.length < 6;
    }
}

/* ── Countdown timer ──────────────────────────────────────────────────── */
const countEl = document.getElementById('countdown');
if (countEl) {
    let secs = 120;
    const timer = setInterval(() => {
        secs--;
        countEl.textContent = secs;
        if (secs <= 0) {
            clearInterval(timer);
            document.getElementById('countdownWrap').style.display = 'none';
            document.getElementById('resendWrap').style.display    = '';
        }
    }, 1000);
}

/* ── Password strength ────────────────────────────────────────────────── */
function str(v) {
    const bar = document.getElementById('sBar');
    if (!bar) return;
    let s = 0;
    if (v.length >= 8)           s++;
    if (/[A-Z]/.test(v))         s++;
    if (/[0-9]/.test(v))         s++;
    if (/[^A-Za-z0-9]/.test(v)) s++;
    const colours = ['#ef4444','#f97316','#eab308','#22c55e'];
    bar.style.width      = [0,25,50,75,100][s] + '%';
    bar.style.background = colours[s - 1] || 'var(--border)';
}

function chkMatch() {
    const p1 = document.getElementById('np');
    const p2 = document.getElementById('cp');
    const d  = document.getElementById('mMsg');
    if (!p1 || !p2 || !d) return;
    if (!p2.value) { d.textContent = ''; return; }
    if (p1.value === p2.value) {
        d.className  = 'match-ok';
        d.textContent = '✓ Passwords match';
    } else {
        d.className  = 'match-err';
        d.textContent = '✗ Passwords do not match';
    }
}
</script>
</body>
</html>
