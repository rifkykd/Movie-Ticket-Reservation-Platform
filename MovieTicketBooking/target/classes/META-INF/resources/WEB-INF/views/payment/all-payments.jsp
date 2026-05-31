<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"  uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>All Payments – CineBook Admin</title>
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
        .nav-link{color:rgba(255,255,255,.5);font-size:.78rem;text-decoration:none;padding:5px 11px;border-radius:6px;transition:color .2s}
        .nav-link:hover,.nav-link.active{color:#f5c518}
        .admin-chip{background:rgba(220,38,38,.15);border:1px solid rgba(220,38,38,.3);color:#fca5a5;font-size:.65rem;font-weight:700;letter-spacing:1px;padding:2px 8px;border-radius:4px;text-transform:uppercase}
        .nav-username{color:#f5c518;font-size:.78rem;font-weight:600}

        .page{max-width:1200px;margin:0 auto;padding:2rem;position:relative;z-index:1}
        .page-title{font-family:'Bebas Neue';font-size:2rem;letter-spacing:2px;color:var(--text);margin-bottom:.25rem}
        .page-sub{color:var(--muted);font-size:.85rem;margin-bottom:2rem}

        /* Stat cards */
        .stat-grid{display:grid;grid-template-columns:repeat(auto-fill,minmax(200px,1fr));gap:1rem;margin-bottom:2rem}
        .stat-card{background:var(--surface);border:1px solid var(--border);border-radius:var(--r);padding:1.25rem;position:relative;overflow:hidden;transition:box-shadow .2s}
        .stat-card:hover{box-shadow:0 4px 16px rgba(0,0,0,.08)}
        .stat-card::before{content:'';position:absolute;inset:0;opacity:.04;background:var(--stat-color,var(--gold))}
        .stat-icon{width:40px;height:40px;border-radius:10px;display:flex;align-items:center;justify-content:center;font-size:1.1rem;margin-bottom:.75rem;background:var(--stat-bg,var(--gold-dim));color:var(--stat-color,var(--gold))}
        .stat-num{font-family:'Bebas Neue';font-size:1.9rem;letter-spacing:1px;color:var(--stat-color,var(--gold));line-height:1}
        .stat-label{color:var(--muted);font-size:.7rem;font-weight:600;text-transform:uppercase;letter-spacing:1px;margin-top:3px}

        /* Table card */
        .table-card{background:var(--surface);border:1px solid var(--border);border-radius:var(--r);overflow:hidden}
        .table-header{padding:1rem 1.5rem;border-bottom:1px solid var(--border);display:flex;align-items:center;justify-content:space-between}
        .table-title{font-weight:600;font-size:.9rem;color:var(--text)}
        .table-count{color:var(--muted);font-size:.78rem}

        table{width:100%;border-collapse:collapse}
        thead th{background:var(--card);color:var(--muted);font-size:.68rem;font-weight:700;text-transform:uppercase;letter-spacing:.8px;padding:.75rem 1rem;border-bottom:1px solid var(--border);text-align:left}
        tbody tr{border-bottom:1px solid var(--border);transition:background .15s}
        tbody tr:hover{background:var(--card)}
        tbody tr:last-child{border:none}
        td{padding:.75rem 1rem;font-size:.84rem;color:var(--text)}
        td code{font-size:.75rem;color:var(--muted);background:var(--card);padding:2px 6px;border-radius:4px}

        .badge-sm{font-size:.65rem;padding:2px 8px;border-radius:4px;font-weight:600}
        .b-ok{background:#f0fdf4;border:1px solid #bbf7d0;color:var(--emerald)}
        .b-ref{background:#f5f3ff;border:1px solid #ddd6fe;color:var(--violet)}
        .b-pend{background:#fffbeb;border:1px solid #fde68a;color:#92400e}
        .b-fail{background:#fef2f2;border:1px solid #fecaca;color:var(--rose)}
        .b-online{background:#eff6ff;border:1px solid #bfdbfe;color:#1e40af}
        .b-counter{background:#fefce8;border:1px solid #fde68a;color:#713f12}
        .b-promo{background:#fefce8;border:1px solid#fde68a;color:#92400e}

        .amount-cell{font-weight:700;color:var(--gold)}
        .btn-icon{width:30px;height:30px;display:inline-flex;align-items:center;justify-content:center;border-radius:6px;text-decoration:none;font-size:.82rem;background:var(--card);border:1px solid var(--border);color:var(--muted);transition:background .15s,color .15s}
        .btn-icon:hover{background:#1c1917;color:#f5c518;border-color:#1c1917}

        .empty-row td{text-align:center;padding:3rem;color:var(--dim);font-size:.88rem}
    </style>
</head>
<body>
<nav class="navbar">
    <a class="nav-brand" href="${pageContext.request.contextPath}/"><i class="bi bi-film"></i> CINEBOOK</a>
    <div style="display:flex;align-items:center;gap:4px">
        <a href="${pageContext.request.contextPath}/" class="nav-link">Gallery</a>
        <a href="${pageContext.request.contextPath}/showtime/scheduler" class="nav-link">Scheduler</a>
        <a href="${pageContext.request.contextPath}/booking/all" class="nav-link">Bookings</a>
        <a href="${pageContext.request.contextPath}/payment/all" class="nav-link active">Payments</a>
        <a href="${pageContext.request.contextPath}/review/admin" class="nav-link">Reviews</a>
        <span class="admin-chip">Admin</span>
        <c:if test="${not empty sessionScope.username}">
            <span class="nav-username">${sessionScope.username}</span>
            <a href="${pageContext.request.contextPath}/user/logout" class="nav-link">Logout</a>
        </c:if>
    </div>
</nav>

<div class="page">
    <div class="page-title"><i class="bi bi-wallet2" style="vertical-align:middle;margin-right:8px"></i>Payment Dashboard</div>
    <div class="page-sub">Complete payment &amp; revenue overview</div>

    <!-- Stats -->
    <div class="stat-grid">
        <div class="stat-card" style="--stat-color:var(--gold);--stat-bg:var(--gold-dim)">
            <div class="stat-icon"><i class="bi bi-receipt"></i></div>
            <div class="stat-num">${fn:length(payments)}</div>
            <div class="stat-label">Total Transactions</div>
        </div>
        <div class="stat-card" style="--stat-color:var(--emerald);--stat-bg:rgba(5,150,105,.1)">
            <div class="stat-icon"><i class="bi bi-graph-up-arrow"></i></div>
            <div class="stat-num" style="font-size:1.3rem">LKR ${totalRevenue}</div>
            <div class="stat-label">Confirmed Revenue</div>
        </div>
        <div class="stat-card" style="--stat-color:var(--violet);--stat-bg:rgba(124,58,237,.08)">
            <div class="stat-icon"><i class="bi bi-arrow-counterclockwise"></i></div>
            <div class="stat-num" style="font-size:1.3rem">LKR ${totalRefunded}</div>
            <div class="stat-label">Total Refunded</div>
        </div>
        <div class="stat-card" style="--stat-color:#1e40af;--stat-bg:#eff6ff">
            <div class="stat-icon"><i class="bi bi-credit-card"></i></div>
            <c:set var="onC" value="0"/>
            <c:forEach var="p" items="${payments}"><c:if test="${p.paymentType=='ONLINE'}"><c:set var="onC" value="${onC+1}"/></c:if></c:forEach>
            <div class="stat-num">${onC}</div>
            <div class="stat-label">Online Payments</div>
        </div>
    </div>

    <!-- Table -->
    <div class="table-card">
        <div class="table-header">
            <span class="table-title">All Transactions</span>
            <span class="table-count">${fn:length(payments)} records</span>
        </div>
        <div style="overflow-x:auto">
            <table>
                <thead><tr>
                    <th>Payment ID</th><th>Booking</th><th>Customer</th>
                    <th>Method</th><th>Promo</th><th>Amount</th>
                    <th>Discount</th><th>Final (LKR)</th><th>Date</th>
                    <th>Status</th><th></th>
                </tr></thead>
                <tbody>
                    <c:choose>
                        <c:when test="${empty payments}">
                            <tr><td colspan="11" class="empty-row">No payments found.</td></tr>
                        </c:when>
                        <c:otherwise>
                            <c:forEach var="p" items="${payments}">
                                <tr>
                                    <td><code>${p.paymentId}</code></td>
                                    <td><code style="color:#1e40af">${p.bookingId}</code></td>
                                    <td style="color:var(--muted)">${p.userId}</td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${p.paymentType=='ONLINE'}"><span class="badge-sm b-online"><i class="bi bi-credit-card"></i> Online</span></c:when>
                                            <c:otherwise><span class="badge-sm b-counter"><i class="bi bi-shop"></i> Counter</span></c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${p.promoCode!='NONE' and not empty p.promoCode}"><span class="badge-sm b-promo">${p.promoCode}</span></c:when>
                                            <c:otherwise><span style="color:var(--dim)">—</span></c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td style="color:var(--muted)">${p.amount}</td>
                                    <td style="color:var(--emerald)"><c:choose><c:when test="${p.discount>0}">−${p.discount}</c:when><c:otherwise><span style="color:var(--dim)">—</span></c:otherwise></c:choose></td>
                                    <td class="amount-cell">${p.finalAmount}</td>
                                    <td style="color:var(--muted);font-size:.78rem">${p.paymentDate}</td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${p.completed}"><span class="badge-sm b-ok">Paid</span></c:when>
                                            <c:when test="${p.refunded}"><span class="badge-sm b-ref">Refunded</span></c:when>
                                            <c:when test="${p.pending}"><span class="badge-sm b-pend">Pending</span></c:when>
                                            <c:otherwise><span class="badge-sm b-fail">Failed</span></c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <a href="${pageContext.request.contextPath}/payment/success/${p.paymentId}" class="btn-icon" title="Receipt"><i class="bi bi-receipt"></i></a>
                                    </td>
                                </tr>
                            </c:forEach>
                        </c:otherwise>
                    </c:choose>
                </tbody>
            </table>
        </div>
    </div>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
