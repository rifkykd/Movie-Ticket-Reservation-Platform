<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"  uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Payments – CineBook</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Bebas+Neue&family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <style>
        :root{--bg:#f5f0e8;--surface:#fff;--card:#fdfaf6;--border:#e8e0d0;--border-md:#d4c8b8;--gold:#c9960a;--gold-dim:rgba(201,150,10,.1);--emerald:#059669;--violet:#7c3aed;--rose:#dc2626;--text:#1c1917;--muted:#78716c;--dim:#a8a29e;--r:12px}
        *{box-sizing:border-box;margin:0;padding:0}
        body{background:var(--bg);color:var(--text);font-family:'Poppins',sans-serif;min-height:100vh}
        body::before{content:'';position:fixed;inset:0;background:radial-gradient(ellipse 70% 50% at 50% -10%,rgba(201,150,10,.05),transparent 55%);pointer-events:none}

        .navbar{background:#1c1917;padding:0 2rem;height:60px;display:flex;align-items:center;justify-content:space-between}
        .nav-brand{font-family:'Bebas Neue';font-size:1.6rem;letter-spacing:4px;color:#f5c518;text-decoration:none;display:flex;align-items:center;gap:7px}
        .nav-link{color:rgba(255,255,255,.5);font-size:.82rem;text-decoration:none;padding:5px 12px;border-radius:6px;transition:color .2s}
        .nav-link:hover{color:rgba(255,255,255,.9)}
        .nav-link.active{color:#f5c518}
        .nav-username{color:#f5c518;font-size:.82rem;font-weight:600}

        .page{max-width:900px;margin:0 auto;padding:2rem;position:relative;z-index:1}

        .page-header{display:flex;align-items:center;justify-content:space-between;margin-bottom:2rem;flex-wrap:wrap;gap:.75rem}
        .page-title{font-family:'Bebas Neue';font-size:2.2rem;letter-spacing:2px;color:var(--text)}
        .page-sub{color:var(--muted);font-size:.85rem;margin-top:2px}
        .btn-dark{background:#1c1917;color:#f5c518;font-weight:700;font-size:.82rem;padding:8px 18px;border-radius:8px;text-decoration:none;display:inline-flex;align-items:center;gap:6px;transition:background .15s}
        .btn-dark:hover{background:#292524;color:#f5c518}

        .flash-ok{background:#f0fdf4;border:1px solid #bbf7d0;color:var(--emerald);border-radius:var(--r);padding:.65rem 1rem;font-size:.82rem;margin-bottom:1.25rem}
        .flash-err{background:#fef2f2;border:1px solid #fecaca;color:var(--rose);border-radius:var(--r);padding:.65rem 1rem;font-size:.82rem;margin-bottom:1.25rem}

        /* Payment card */
        .pay-card{background:var(--surface);border:1px solid var(--border);border-radius:var(--r);overflow:hidden;margin-bottom:.75rem;transition:border-color .2s,box-shadow .2s;display:flex}
        .pay-card:hover{border-color:var(--border-md);box-shadow:0 4px 16px rgba(0,0,0,.06)}
        .pay-accent{width:4px;flex-shrink:0}
        .ac-completed{background:var(--emerald)}
        .ac-refunded{background:var(--violet)}
        .ac-pending{background:#d97706}
        .ac-failed{background:var(--rose)}

        .pay-body{padding:1rem 1.25rem;flex:1;display:flex;justify-content:space-between;align-items:center;flex-wrap:wrap;gap:.75rem}
        .pay-left{}
        .pay-pid{font-family:monospace;color:var(--dim);font-size:.7rem;margin-bottom:2px}
        .pay-booking{color:var(--text);font-weight:600;font-size:.92rem;display:flex;align-items:center;gap:6px}
        .pay-date{color:var(--muted);font-size:.75rem;display:flex;align-items:center;gap:4px;margin-top:2px}
        .pay-badges{display:flex;gap:5px;flex-wrap:wrap;margin-top:5px}
        .badge-sm{font-size:.65rem;padding:2px 8px;border-radius:4px;font-weight:600}
        .b-ok{background:#f0fdf4;border:1px solid #bbf7d0;color:var(--emerald)}
        .b-ref{background:#f5f3ff;border:1px solid #ddd6fe;color:var(--violet)}
        .b-pend{background:#fffbeb;border:1px solid #fde68a;color:#92400e}
        .b-fail{background:#fef2f2;border:1px solid #fecaca;color:var(--rose)}
        .b-online{background:#eff6ff;border:1px solid #bfdbfe;color:#1e40af}
        .b-counter{background:#fefce8;border:1px solid #fde68a;color:#713f12}
        .b-promo{background:#fefce8;border:1px solid #fde68a;color:#92400e}

        .pay-right{text-align:right}
        .pay-amount{font-family:'Bebas Neue';font-size:1.6rem;letter-spacing:1px;color:var(--gold)}
        .pay-saved{color:var(--emerald);font-size:.72rem}
        .pay-actions{display:flex;gap:6px;margin-top:.4rem;justify-content:flex-end}
        .btn-receipt{background:#1c1917;color:#f5c518;font-size:.75rem;padding:5px 14px;border-radius:6px;text-decoration:none;display:inline-flex;align-items:center;gap:4px;transition:background .15s}
        .btn-receipt:hover{background:#292524;color:#f5c518}
        .btn-refund{background:var(--bg);color:var(--rose);border:1px solid #fecaca;font-size:.75rem;padding:5px 14px;border-radius:6px;text-decoration:none;display:inline-flex;align-items:center;gap:4px;transition:background .15s}
        .btn-refund:hover{background:#fef2f2}

        .empty-state{text-align:center;padding:5rem 0}
        .empty-icon{font-size:3.5rem;margin-bottom:1rem;display:block;color:var(--dim)}
        .empty-title{font-family:'Bebas Neue';font-size:2rem;color:var(--muted);letter-spacing:2px}
    </style>
</head>
<body>
<nav class="navbar">
    <a class="nav-brand" href="${pageContext.request.contextPath}/"><i class="bi bi-film"></i> CINEBOOK</a>
    <div style="display:flex;align-items:center;gap:4px">
        <a href="${pageContext.request.contextPath}/" class="nav-link">Gallery</a>
        <a href="${pageContext.request.contextPath}/booking/my-bookings" class="nav-link">My Tickets</a>
        <a href="${pageContext.request.contextPath}/payment/my-payments" class="nav-link active">My Payments</a>
        <c:if test="${sessionScope.role=='ADMIN'}"><a href="${pageContext.request.contextPath}/payment/all" class="nav-link">All Payments</a></c:if>
        <c:if test="${not empty sessionScope.username}">
            <span class="nav-username">${sessionScope.username}</span>
            <a href="${pageContext.request.contextPath}/user/logout" class="nav-link">Logout</a>
        </c:if>
    </div>
</nav>

<div class="page">
    <c:if test="${not empty successMsg}"><div class="flash-ok"><i class="bi bi-check-circle-fill"></i> ${successMsg}</div></c:if>
    <c:if test="${not empty errorMsg}"><div class="flash-err"><i class="bi bi-exclamation-triangle-fill"></i> ${errorMsg}</div></c:if>

    <div class="page-header">
        <div>
            <div class="page-title"><i class="bi bi-wallet2" style="font-size:1.7rem;vertical-align:middle;margin-right:10px"></i>My Payments</div>
            <div class="page-sub">${fn:length(payments)} payment record(s)</div>
        </div>
        <a href="${pageContext.request.contextPath}/showtime/schedule" class="btn-dark"><i class="bi bi-ticket-perforated"></i> Book Tickets</a>
    </div>

    <c:choose>
        <c:when test="${empty payments}">
            <div class="empty-state">
                <span class="empty-icon"><i class="bi bi-wallet2"></i></span>
                <div class="empty-title">No Payments Yet</div>
                <p style="color:var(--muted);font-size:.88rem;margin-top:.5rem">Your payment history will appear here after booking.</p>
            </div>
        </c:when>
        <c:otherwise>
            <c:forEach var="p" items="${payments}">
                <div class="pay-card">
                    <div class="pay-accent ${p.completed?'ac-completed':p.refunded?'ac-refunded':p.pending?'ac-pending':'ac-failed'}"></div>
                    <div class="pay-body">
                        <div class="pay-left">
                            <div class="pay-pid">${p.paymentId} · ${p.bookingId}</div>
                            <div class="pay-booking"><i class="bi bi-ticket-perforated"></i>${p.bookingId}</div>
                            <div class="pay-date"><i class="bi bi-calendar3"></i>${p.paymentDate}</div>
                            <div class="pay-badges">
                                <c:choose>
                                    <c:when test="${p.completed}"><span class="badge-sm b-ok">&#10003; Paid</span></c:when>
                                    <c:when test="${p.refunded}"><span class="badge-sm b-ref">&#8635; Refunded</span></c:when>
                                    <c:when test="${p.pending}"><span class="badge-sm b-pend">&#8987; Pending</span></c:when>
                                    <c:otherwise><span class="badge-sm b-fail">&#10007; Failed</span></c:otherwise>
                                </c:choose>
                                <c:choose>
                                    <c:when test="${p.paymentType=='ONLINE'}"><span class="badge-sm b-online"><i class="bi bi-credit-card"></i> Online</span></c:when>
                                    <c:otherwise><span class="badge-sm b-counter"><i class="bi bi-shop"></i> Counter</span></c:otherwise>
                                </c:choose>
                                <c:if test="${p.promoCode!='NONE' and not empty p.promoCode}"><span class="badge-sm b-promo"><i class="bi bi-tag-fill"></i> ${p.promoCode}</span></c:if>
                            </div>
                        </div>
                        <div class="pay-right">
                            <div class="pay-amount">LKR ${p.finalAmount}</div>
                            <c:if test="${p.discount>0}"><div class="pay-saved"><i class="bi bi-tag-fill"></i> Saved LKR ${p.discount}</div></c:if>
                            <div class="pay-actions">
                                <a href="${pageContext.request.contextPath}/payment/success/${p.paymentId}" class="btn-receipt"><i class="bi bi-receipt"></i> Receipt</a>
                                <c:if test="${p.completed}">
                                    <a href="${pageContext.request.contextPath}/payment/refund/${p.paymentId}" class="btn-refund" onclick="return confirm('Request refund?')"><i class="bi bi-arrow-counterclockwise"></i> Refund</a>
                                </c:if>
                            </div>
                        </div>
                    </div>
                </div>
            </c:forEach>
        </c:otherwise>
    </c:choose>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
