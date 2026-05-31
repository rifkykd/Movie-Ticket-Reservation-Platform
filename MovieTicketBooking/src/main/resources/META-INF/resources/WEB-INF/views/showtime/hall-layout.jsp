<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%-- Pull model attributes into Java variables using scriptlets.
     This avoids JSP EL conflicts with JavaScript ${} expressions entirely. --%>
<%
    com.CompleteProject.completeproject.bean.ShowTime showtime =
        (com.CompleteProject.completeproject.bean.ShowTime) request.getAttribute("showtime");
    com.CompleteProject.completeproject.bean.TheaterHall hall =
        (com.CompleteProject.completeproject.bean.TheaterHall) request.getAttribute("hall");

    int    totalSeats     = (Integer) request.getAttribute("totalSeats");
    int    bookedSeats    = (Integer) request.getAttribute("bookedSeats");
    int    availableSeats = (Integer) request.getAttribute("availableSeats");
    double finalPrice     = (Double)  request.getAttribute("finalPrice");
    int    rows           = hall.getRows();
    int    columns        = hall.getColumns();

    // Booked seat labels set — passed from controller for exact seat matching
    String bookedSeatsStr = (String) request.getAttribute("bookedSeatsStr");
    java.util.Set<String> bookedSet = new java.util.HashSet<>();
    if (bookedSeatsStr != null && !bookedSeatsStr.isEmpty()) {
        for (String s : bookedSeatsStr.split(",")) {
            bookedSet.add(s.trim().toUpperCase());
        }
    }

    String contextPath = request.getContextPath();
    String showtimeId  = showtime.getShowtimeId();
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Select Seats – CineBook</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Bebas+Neue&family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <style>
        :root{--bg:#07080d;--surface:#0d1117;--card:#0f1520;--border:#1a2035;--border-md:#252f45;
              --gold:#f5c518;--gold-dim:rgba(245,197,24,.12);--emerald:#10b981;
              --text:#e8edf5;--muted:#8892a4;--dim:#3d4557;--r:12px}
        *{box-sizing:border-box;margin:0;padding:0}
        body{background:var(--bg);color:var(--text);font-family:'Poppins',sans-serif;min-height:100vh}
        body::before{content:'';position:fixed;inset:0;
            background:radial-gradient(ellipse 60% 50% at 50% -10%,rgba(245,197,24,.04),transparent 55%);
            pointer-events:none}

        .navbar{position:sticky;top:0;z-index:100;background:rgba(7,8,13,.85);
                backdrop-filter:blur(20px);border-bottom:1px solid var(--border);
                padding:0 2rem;height:64px;display:flex;align-items:center;justify-content:space-between}
        .nav-brand{font-family:'Bebas Neue';font-size:1.75rem;letter-spacing:4px;
                   color:var(--gold);text-decoration:none;display:flex;align-items:center;gap:8px}
        .nav-link{color:var(--muted);font-size:.82rem;text-decoration:none;
                  padding:6px 12px;border-radius:8px;transition:color .2s,background .2s}
        .nav-link:hover{color:var(--text);background:rgba(255,255,255,.05)}
        .nav-username{color:var(--gold);font-size:.82rem;font-weight:600}

        .page{position:relative;z-index:1;max-width:960px;margin:0 auto;padding:2rem}

        /* Show banner */
        .show-banner{background:var(--surface);border:1px solid var(--border);border-radius:var(--r);
                     padding:1.25rem 1.5rem;margin-bottom:1.5rem;display:flex;
                     justify-content:space-between;align-items:center;flex-wrap:wrap;gap:1rem}
        .show-title{font-family:'Bebas Neue';font-size:1.6rem;letter-spacing:1.5px;color:#fff}
        .show-meta{color:var(--muted);font-size:.82rem;margin-top:3px;display:flex;gap:14px;flex-wrap:wrap}
        .price-value{color:var(--gold);font-family:'Bebas Neue';font-size:2rem;letter-spacing:1px;line-height:1}
        .price-label{color:var(--dim);font-size:.7rem;margin-top:2px}

        /* Stats */
        .stat-row{display:grid;grid-template-columns:repeat(3,1fr);gap:.75rem;margin-bottom:1.25rem}
        .stat-card{background:var(--surface);border:1px solid var(--border);border-radius:var(--r);padding:.9rem;text-align:center}
        .stat-num{font-family:'Bebas Neue';font-size:2rem;line-height:1}
        .stat-label{color:var(--dim);font-size:.68rem;font-weight:600;text-transform:uppercase;letter-spacing:1px;margin-top:2px}

        /* VIP notice */
        .vip-notice{background:rgba(245,197,24,.06);border:1px solid rgba(245,197,24,.2);
                    border-radius:var(--r);padding:.7rem 1rem;margin-bottom:1.5rem;
                    font-size:.8rem;color:rgba(245,197,24,.85);display:flex;align-items:center;gap:8px}

        /* Screen */
        .screen-wrap{text-align:center;margin-bottom:2.5rem}
        .screen-bar{width:60%;margin:0 auto 6px;height:4px;
                    background:linear-gradient(to right,transparent,rgba(255,255,255,.3),transparent);border-radius:2px}
        .screen-label{color:var(--dim);font-size:.7rem;letter-spacing:4px;text-transform:uppercase}

        /* Seat grid */
        .seat-grid{display:flex;flex-direction:column;align-items:center;gap:7px;margin-bottom:2rem}
        .seat-row{display:flex;align-items:center;gap:5px}
        .row-label{width:22px;text-align:right;font-size:.7rem;font-weight:600;flex-shrink:0}

        .seat{width:34px;height:30px;border-radius:5px 5px 2px 2px;cursor:pointer;
              border:none;font-size:.55rem;font-weight:700;display:flex;align-items:center;
              justify-content:center;transition:transform .1s,box-shadow .1s}
        .seat:hover{transform:scale(1.15)}
        .seat.available{background:rgba(16,185,129,.2);color:#34d399;border:1px solid rgba(16,185,129,.35)}
        .seat.available:hover{background:rgba(16,185,129,.35);box-shadow:0 0 8px rgba(16,185,129,.3)}
        .seat.vip-available{background:rgba(245,197,24,.15);color:var(--gold);border:1px solid rgba(245,197,24,.35)}
        .seat.vip-available:hover{background:rgba(245,197,24,.28);box-shadow:0 0 8px rgba(245,197,24,.3)}
        .seat.booked{background:rgba(255,255,255,.04);color:rgba(255,255,255,.12);
                     cursor:not-allowed;border:1px solid var(--border)}
        .seat.selected{background:var(--gold);color:#000;border:none;box-shadow:0 0 12px rgba(245,197,24,.4)}

        /* Legend */
        .legend{display:flex;gap:1.5rem;justify-content:center;margin-bottom:2rem;flex-wrap:wrap}
        .legend-item{display:flex;align-items:center;gap:7px;font-size:.75rem;color:var(--muted)}
        .legend-box{width:24px;height:20px;border-radius:4px 4px 2px 2px}

        /* Summary panel */
        .summary-panel{background:var(--surface);border:1px solid var(--border-md);
                       border-radius:var(--r);padding:1.1rem 1.4rem;display:none}
        .summary-panel.active{display:block;border-color:var(--gold)}
        .summary-inner{display:flex;align-items:center;gap:1.25rem;flex-wrap:wrap}
        .selected-label{color:var(--dim);font-size:.68rem;text-transform:uppercase;
                        letter-spacing:1px;margin-bottom:5px}
        .seat-chips{display:flex;flex-wrap:wrap;gap:5px}
        .chip-vip{background:rgba(245,197,24,.12);border:1px solid rgba(245,197,24,.3);
                  color:var(--gold);font-size:.7rem;padding:2px 8px;border-radius:4px}
        .chip-std{background:rgba(16,185,129,.1);border:1px solid rgba(16,185,129,.3);
                  color:#34d399;font-size:.7rem;padding:2px 8px;border-radius:4px}
        .summary-total{color:var(--gold);font-family:'Bebas Neue';font-size:1.6rem;
                       white-space:nowrap;line-height:1}
        .summary-breakdown{color:var(--dim);font-size:.68rem;margin-top:1px}
        .btn-book{background:var(--gold);color:#000;font-weight:700;font-size:.9rem;
                  padding:10px 24px;border-radius:10px;border:none;cursor:pointer;
                  display:inline-flex;align-items:center;gap:6px;
                  transition:background .15s,transform .1s;margin-left:auto;white-space:nowrap;
                  text-decoration:none}
        .btn-book:hover{background:#e0b000;transform:translateY(-1px);color:#000}
        .placeholder-panel{background:var(--surface);border:1px solid var(--border);
                            border-radius:var(--r);padding:1.1rem 1.4rem;
                            color:var(--dim);font-size:.82rem;text-align:center}
    </style>
</head>
<body>
<nav class="navbar">
    <a class="nav-brand" href="<%= contextPath %>/"><i class="bi bi-film"></i> CINEBOOK</a>
    <div style="display:flex;align-items:center;gap:6px">
        <a href="javascript:history.back()" class="nav-link">&#8592; Back</a>
        <a href="<%= contextPath %>/" class="nav-link">Gallery</a>
        <a href="<%= contextPath %>/booking/my-bookings" class="nav-link">My Tickets</a>
        <c:if test="${not empty sessionScope.username}">
            <span class="nav-username">${sessionScope.username}</span>
            <a href="<%= contextPath %>/user/logout" class="nav-link">Logout</a>
        </c:if>
    </div>
</nav>

<div class="page">

    <!-- Show banner -->
    <div class="show-banner">
        <div>
            <div class="show-title"><%= showtime.getMovieTitle() %></div>
            <div class="show-meta">
                <span><i class="bi bi-building"></i> <%= showtime.getHallName() %></span>
                <span><i class="bi bi-calendar3"></i> <%= showtime.getShowDate() %></span>
                <span><i class="bi bi-clock"></i> <%= showtime.getShowTime() %></span>
                <span style="color:#a78bfa"><i class="bi bi-camera-reels"></i> <%= showtime.getShowType().getLabel() %></span>
            </div>
        </div>
        <div style="text-align:right">
            <div class="price-value">LKR <%= String.format("%.2f", finalPrice) %></div>
            <div class="price-label">base price / seat</div>
        </div>
    </div>

    <!-- Stats -->
    <div class="stat-row">
        <div class="stat-card"><div class="stat-num" style="color:#34d399"><%= availableSeats %></div><div class="stat-label">Available</div></div>
        <div class="stat-card"><div class="stat-num" style="color:var(--muted)"><%= bookedSeats %></div><div class="stat-label">Booked</div></div>
        <div class="stat-card"><div class="stat-num" style="color:var(--gold)"><%= totalSeats %></div><div class="stat-label">Total</div></div>
    </div>

    <!-- VIP notice -->
    <div class="vip-notice">
        <i class="bi bi-star-fill"></i>
        <span><strong>Rows A &amp; B are VIP seats</strong> — priced at 1.5× base. All other rows are Standard (1.0×).</span>
    </div>

    <!-- Screen -->
    <div class="screen-wrap">
        <div class="screen-bar"></div>
        <div class="screen-label">Screen</div>
    </div>

    <!-- Seat grid — built with JSP scriptlets to avoid EL/JS conflicts -->
    <div class="seat-grid">
    <%
        for (int rowNum = 1; rowNum <= rows; rowNum++) {
            char rowLetter = (char)(64 + rowNum);
            boolean isVipRow = (rowLetter == 'A' || rowLetter == 'B');
    %>
        <div class="seat-row">
            <span class="row-label" style="color:<%= isVipRow ? "var(--gold)" : "var(--dim)" %>">
                <%= rowLetter %>
            </span>
    <%
            for (int colNum = 1; colNum <= columns; colNum++) {
                String seatId = rowLetter + "" + colNum;
                boolean isBooked = bookedSet.contains(seatId.toUpperCase());
                String seatClass = isBooked ? "booked" : (isVipRow ? "vip-available" : "available");
                String title = seatId + (isBooked ? " – Booked" : (isVipRow ? " – VIP (×1.5)" : " – Standard"));
    %>
            <%
                if (isBooked) {
            %>
                <button class="seat booked" disabled title="<%= title %>">
                    <i class="bi bi-x" style="font-size:.75rem"></i>
                </button>
            <%
                } else {
            %>
                <button class="seat <%= seatClass %>"
                        onclick="toggleSeat(this, '<%= seatId %>', <%= isVipRow %>)"
                        title="<%= title %>">
                    <%= seatId %>
                </button>
            <%
                }
            %>
    <%
            } // end column loop
    %>
        </div>
    <%
        } // end row loop
    %>
    </div>

    <!-- Legend -->
    <div class="legend">
        <div class="legend-item">
            <div class="legend-box" style="background:rgba(245,197,24,.15);border:1px solid rgba(245,197,24,.35)"></div>VIP (A–B)
        </div>
        <div class="legend-item">
            <div class="legend-box" style="background:rgba(16,185,129,.2);border:1px solid rgba(16,185,129,.35)"></div>Standard
        </div>
        <div class="legend-item">
            <div class="legend-box" style="background:var(--gold)"></div>Selected
        </div>
        <div class="legend-item">
            <div class="legend-box" style="background:rgba(255,255,255,.04);border:1px solid var(--border)"></div>Booked
        </div>
    </div>

    <!-- Summary panel -->
    <div class="placeholder-panel" id="placeholder">Select seats above to see your booking summary</div>
    <div class="summary-panel" id="summaryPanel">
        <div class="summary-inner">
            <div>
                <div class="selected-label">Selected (<span id="selCount">0</span>)</div>
                <div class="seat-chips" id="seatChips"></div>
            </div>
            <div>
                <div class="summary-total">LKR <span id="totalPrice">0.00</span></div>
                <div class="summary-breakdown" id="breakdown"></div>
            </div>
            <a id="bookBtn" href="#" class="btn-book">
                <i class="bi bi-ticket-perforated"></i> Book Now
            </a>
        </div>
    </div>

</div>

<script>
    // All values come from JSP scriptlets — no EL expressions in JS
    var BASE_PRICE  = <%= finalPrice %>;
    var VIP_MULT    = 1.5;
    var CONTEXT     = '<%= contextPath %>';
    var SHOWTIME_ID = '<%= showtimeId %>';
    var selectedSeats = [];  // [{id, vip}]

    function toggleSeat(btn, seatId, isVip) {
        var idx = selectedSeats.findIndex(function(s){ return s.id === seatId; });
        if (idx === -1) {
            selectedSeats.push({id: seatId, vip: isVip});
            btn.className = 'seat selected';
        } else {
            selectedSeats.splice(idx, 1);
            btn.className = 'seat ' + (isVip ? 'vip-available' : 'available');
        }
        updateSummary();
    }

    function updateSummary() {
        var panel       = document.getElementById('summaryPanel');
        var placeholder = document.getElementById('placeholder');

        if (selectedSeats.length === 0) {
            panel.classList.remove('active');
            placeholder.style.display = '';
            return;
        }

        placeholder.style.display = 'none';
        panel.classList.add('active');

        var total  = 0;
        var vipC   = 0;
        var stdC   = 0;
        var chips  = '';

        selectedSeats.forEach(function(s) {
            if (s.vip) {
                total += BASE_PRICE * VIP_MULT;
                vipC++;
                chips += '<span class="chip-vip">&#9733; ' + s.id + '</span>';
            } else {
                total += BASE_PRICE;
                stdC++;
                chips += '<span class="chip-std">' + s.id + '</span>';
            }
        });

        var parts = [];
        if (stdC > 0) parts.push(stdC + ' Std \u00d7 LKR ' + BASE_PRICE.toFixed(2));
        if (vipC > 0) parts.push(vipC + ' VIP \u00d7 LKR ' + (BASE_PRICE * VIP_MULT).toFixed(2));

        document.getElementById('selCount').textContent    = selectedSeats.length;
        document.getElementById('seatChips').innerHTML     = chips;
        document.getElementById('totalPrice').textContent  = total.toFixed(2);
        document.getElementById('breakdown').textContent   = parts.join(' + ');

        var seatLabels = selectedSeats.map(function(s){ return s.id; }).join(',');
        document.getElementById('bookBtn').href =
            CONTEXT + '/booking/new'
            + '?showtimeId=' + encodeURIComponent(SHOWTIME_ID)
            + '&seats='      + encodeURIComponent(seatLabels)
            + '&count='      + selectedSeats.length;
    }
</script>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
