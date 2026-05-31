<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Checkout – CineBook</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Bebas+Neue&family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <style>
        /* Light warm payment theme */
        :root{--bg:#f5f0e8;--surface:#fff;--card:#fdfaf6;--border:#e8e0d0;--border-md:#d4c8b8;--gold:#c9960a;--gold-light:#f5c518;--gold-dim:rgba(201,150,10,.1);--violet:#7c3aed;--violet-dim:rgba(124,58,237,.08);--emerald:#059669;--rose:#dc2626;--text:#1c1917;--muted:#78716c;--dim:#a8a29e;--r:12px}
        *{box-sizing:border-box;margin:0;padding:0}
        body{background:var(--bg);color:var(--text);font-family:'Poppins',sans-serif;min-height:100vh}
        body::before{content:'';position:fixed;inset:0;background:radial-gradient(ellipse 80% 60% at 50% -20%,rgba(201,150,10,.07),transparent 60%);pointer-events:none}

        /* Navbar — dark strip for contrast */
        .navbar{background:#1c1917;border-bottom:none;padding:0 2rem;height:60px;display:flex;align-items:center;justify-content:space-between}
        .nav-brand{font-family:'Bebas Neue';font-size:1.6rem;letter-spacing:4px;color:#f5c518;text-decoration:none;display:flex;align-items:center;gap:7px}
        .nav-link{color:rgba(255,255,255,.5);font-size:.82rem;text-decoration:none;padding:5px 12px;border-radius:6px;transition:color .2s}
        .nav-link:hover{color:rgba(255,255,255,.9)}
        .nav-username{color:#f5c518;font-size:.82rem;font-weight:600}

        .page{max-width:960px;margin:0 auto;padding:2rem}

        /* Steps */
        .steps{display:flex;gap:0;margin-bottom:2rem;border-radius:var(--r);overflow:hidden;border:1px solid var(--border)}
        .step{flex:1;text-align:center;padding:.6rem;font-size:.72rem;font-weight:600;letter-spacing:.8px;text-transform:uppercase;background:var(--surface);color:var(--dim);border-right:1px solid var(--border);transition:background .2s}
        .step:last-child{border-right:none}
        .step.done{background:#f0fdf4;color:var(--emerald)}
        .step.active{background:#fefce8;color:var(--gold)}

        .flash-err{background:#fef2f2;border:1px solid #fecaca;color:var(--rose);border-radius:var(--r);padding:.65rem 1rem;font-size:.82rem;margin-bottom:1.25rem}

        /* Layout */
        .layout{display:grid;grid-template-columns:1fr 420px;gap:1.5rem;align-items:start}
        @media(max-width:768px){.layout{grid-template-columns:1fr}}

        /* Cards */
        .panel{background:var(--surface);border:1px solid var(--border);border-radius:var(--r);padding:1.5rem;margin-bottom:1rem}
        .panel-title{font-size:.72rem;font-weight:700;text-transform:uppercase;letter-spacing:1.2px;color:var(--muted);margin-bottom:1.1rem;display:flex;align-items:center;gap:7px;padding-bottom:.75rem;border-bottom:1px solid var(--border)}
        .panel-title i{color:var(--gold)}

        /* Order summary */
        .sum-row{display:flex;justify-content:space-between;padding:.45rem 0;border-bottom:1px solid var(--border);font-size:.88rem;color:var(--muted)}
        .sum-row span:last-child{color:var(--text);font-weight:500}
        .sum-row:last-child{border:none}
        .seat-chip{background:#fefce8;border:1px solid #fde68a;color:var(--gold);font-size:.7rem;padding:2px 7px;border-radius:4px;margin:2px;display:inline-block}
        .price-final{display:flex;justify-content:space-between;padding:.75rem 0 0;font-size:1.1rem;font-weight:700;color:var(--text);border-top:2px solid var(--border-md);margin-top:.5rem}
        .price-final span:last-child{color:var(--gold)}

        /* Promo codes hint */
        .promo-hint{background:#fefce8;border:1px solid #fde68a;border-radius:8px;padding:.75rem 1rem;margin-top:1rem}
        .promo-hint-title{font-size:.7rem;font-weight:700;text-transform:uppercase;letter-spacing:1px;color:var(--gold);margin-bottom:.4rem}
        .promo-code-row{display:flex;justify-content:space-between;font-size:.78rem;color:var(--muted);padding:2px 0}
        .promo-code-row code{color:#92400e;font-weight:600;background:rgba(0,0,0,.04);padding:1px 6px;border-radius:3px}

        /* Method tabs */
        .method-tabs{display:flex;gap:0;border:1px solid var(--border);border-radius:var(--r);overflow:hidden;margin-bottom:1.25rem}
        .method-tab{flex:1;text-align:center;padding:.75rem;font-size:.85rem;font-weight:600;color:var(--muted);background:var(--card);cursor:pointer;border:none;border-right:1px solid var(--border);transition:background .15s,color .15s;font-family:'Poppins'}
        .method-tab:last-child{border-right:none}
        .method-tab.active{background:#fefce8;color:var(--gold)}
        .method-tab:hover:not(.active){background:var(--bg)}

        /* Inputs */
        .field-label{color:var(--muted);font-size:.75rem;font-weight:500;margin-bottom:5px;display:block}
        .input-wrap{display:flex;align-items:center;background:var(--card);border:1px solid var(--border);border-radius:9px;overflow:hidden;transition:border-color .2s,box-shadow .2s}
        .input-wrap:focus-within{border-color:var(--gold);box-shadow:0 0 0 3px var(--gold-dim)}
        .input-icon{width:40px;display:flex;align-items:center;justify-content:center;color:var(--dim);font-size:.9rem;flex-shrink:0}
        .input-wrap input,.input-wrap select{flex:1;background:transparent;border:none;outline:none;color:var(--text);font-family:'Poppins';font-size:.88rem;padding:.65rem .5rem .65rem 0}
        .input-wrap input::placeholder{color:var(--dim)}
        .input-wrap select option{background:var(--surface)}

        /* Card icons */
        .card-icons{display:flex;gap:8px;margin-bottom:1rem}
        .card-icon-btn{padding:6px 14px;border-radius:7px;font-size:.72rem;font-weight:700;cursor:pointer;border:2px solid transparent;background:var(--card);color:var(--muted);transition:all .15s;font-family:'Poppins'}
        .card-icon-btn.selected{border-color:var(--gold);background:#fefce8;color:var(--gold)}

        /* Promo input */
        .promo-row{display:flex;gap:8px;margin-bottom:.5rem}
        .promo-row .input-wrap{flex:1}
        .btn-apply{background:var(--gold-dim);color:var(--gold);border:1px solid rgba(201,150,10,.3);padding:0 16px;border-radius:8px;font-size:.82rem;font-weight:600;cursor:pointer;white-space:nowrap;font-family:'Poppins';transition:background .15s}
        .btn-apply:hover{background:rgba(201,150,10,.2)}
        .promo-ok{color:var(--emerald);font-size:.75rem;margin-top:3px}
        .promo-fail{color:var(--rose);font-size:.75rem;margin-top:3px}

        /* Counter box */
        .counter-box{background:var(--card);border:1px solid var(--border);border-radius:var(--r);padding:1.5rem;text-align:center}
        .counter-icon{font-size:2.5rem;color:var(--emerald);margin-bottom:.75rem;display:block}

        /* Pay button */
        .btn-pay{width:100%;padding:.85rem;background:#1c1917;color:#f5c518;font-weight:700;font-size:1rem;border:none;border-radius:var(--r);cursor:pointer;display:flex;align-items:center;justify-content:center;gap:8px;margin-top:1.25rem;transition:background .15s,transform .1s;font-family:'Poppins'}
        .btn-pay:hover{background:#292524;transform:translateY(-1px)}
        .secure-note{text-align:center;font-size:.7rem;color:var(--dim);margin-top:.6rem;display:flex;align-items:center;justify-content:center;gap:4px}
    </style>
</head>
<body>
<nav class="navbar">
    <a class="nav-brand" href="${pageContext.request.contextPath}/"><i class="bi bi-film"></i> CINEBOOK</a>
    <div style="display:flex;align-items:center;gap:6px">
        <a href="${pageContext.request.contextPath}/" class="nav-link">Gallery</a>
        <a href="${pageContext.request.contextPath}/booking/my-bookings" class="nav-link">My Tickets</a>
        <c:if test="${not empty sessionScope.username}">
            <span class="nav-username">${sessionScope.username}</span>
            <a href="${pageContext.request.contextPath}/user/logout" class="nav-link">Logout</a>
        </c:if>
    </div>
</nav>

<div class="page">
    <div class="steps">
        <div class="step done"><i class="bi bi-check-circle-fill"></i> Select Seats</div>
        <div class="step done"><i class="bi bi-check-circle-fill"></i> Confirm</div>
        <div class="step active"><i class="bi bi-credit-card"></i> Payment</div>
        <div class="step">Receipt</div>
    </div>

    <c:if test="${not empty errorMsg}"><div class="flash-err"><i class="bi bi-exclamation-triangle-fill"></i> ${errorMsg}</div></c:if>

    <div class="layout">
        <!-- Left: payment form -->
        <div>
            <div class="panel">
                <div class="panel-title"><i class="bi bi-credit-card-2-front"></i> Payment Method</div>

                <!-- Method tabs -->
                <div class="method-tabs">
                    <button class="method-tab active" id="tabOnline" onclick="switchMethod('ONLINE')"><i class="bi bi-credit-card"></i> Card Payment</button>
                    <button class="method-tab" id="tabCounter" onclick="switchMethod('COUNTER')"><i class="bi bi-shop"></i> Pay at Counter</button>
                </div>

                <form action="${pageContext.request.contextPath}/payment/process" method="post" id="payForm">
                    <input type="hidden" name="bookingId"    value="${booking.bookingId}">
                    <input type="hidden" name="paymentType"  id="ptInput"  value="ONLINE">
                    <input type="hidden" name="cardType"     id="ctInput"  value="VISA">
                    <input type="hidden" name="promoCode"    id="pcInput"  value="">

                    <!-- ONLINE -->
                    <div id="onlineSection">
                        <div class="mb-3">
                            <label class="field-label">Card Type</label>
                            <div class="card-icons">
                                <button type="button" class="card-icon-btn selected" id="btnVisa" onclick="selectCard('VISA')">VISA</button>
                                <button type="button" class="card-icon-btn" id="btnMC"   onclick="selectCard('MASTERCARD')">MC</button>
                                <button type="button" class="card-icon-btn" id="btnAmex" onclick="selectCard('AMEX')">AMEX</button>
                            </div>
                        </div>
                        <div class="mb-3">
                            <label class="field-label">Card Number</label>
                            <div class="input-wrap">
                                <span class="input-icon"><i class="bi bi-credit-card"></i></span>
                                <input type="text" id="cardNum" placeholder="1234 5678 9012 3456" maxlength="19" oninput="fmtCard(this)">
                            </div>
                            <div style="font-size:.68rem;color:var(--dim);margin-top:3px">Only the last 4 digits are stored securely.</div>
                        </div>
                        <div class="row g-2 mb-3">
                            <div class="col-6">
                                <label class="field-label">Expiry</label>
                                <div class="input-wrap"><span class="input-icon"><i class="bi bi-calendar3"></i></span><input type="text" placeholder="MM / YY" maxlength="7" oninput="fmtExp(this)"></div>
                            </div>
                            <div class="col-6">
                                <label class="field-label">CVV</label>
                                <div class="input-wrap"><span class="input-icon"><i class="bi bi-shield-lock"></i></span><input type="password" placeholder="•••" maxlength="4"></div>
                            </div>
                        </div>
                    </div>

                    <!-- COUNTER -->
                    <div id="counterSection" style="display:none">
                        <div class="counter-box">
                            <span class="counter-icon"><i class="bi bi-shop"></i></span>
                            <p style="font-weight:600;color:var(--text);margin-bottom:.5rem">Pay at the Cinema Counter</p>
                            <p style="font-size:.82rem;color:var(--muted)">Present your Booking ID <strong style="color:var(--text)">${booking.bookingId}</strong> at the counter and pay in cash. Seats are held until you pay.</p>
                        </div>
                    </div>

                    <!-- Promo code -->
                    <div class="mt-3">
                        <label class="field-label">Promo Code (optional)</label>
                        <div class="promo-row">
                            <div class="input-wrap"><span class="input-icon"><i class="bi bi-tag"></i></span><input type="text" id="promoField" placeholder="e.g. CINEBOOK10" style="text-transform:uppercase"></div>
                            <button type="button" class="btn-apply" onclick="applyPromo()">Apply</button>
                        </div>
                        <div id="promoMsg"></div>
                    </div>

                    <button type="submit" class="btn-pay" id="payBtn" onclick="return validatePay()">
                        <i class="bi bi-lock-fill"></i> <span id="payBtnText">Pay LKR ${booking.totalPrice}</span>
                    </button>
                    <div class="secure-note"><i class="bi bi-shield-check"></i> Secured checkout. Booking already confirmed.</div>
                </form>
            </div>
        </div>

        <!-- Right: order summary -->
        <div>
            <div class="panel">
                <div class="panel-title"><i class="bi bi-receipt"></i> Order Summary</div>
                <div class="sum-row"><span>Movie</span><span style="text-align:right;max-width:200px">${booking.movieTitle}</span></div>
                <div class="sum-row"><span>Hall</span><span>${booking.hallName}</span></div>
                <div class="sum-row"><span>Date</span><span>${booking.showDate}</span></div>
                <div class="sum-row"><span>Time</span><span>${booking.showTime}</span></div>
                <div class="sum-row"><span>Show Type</span><span>${booking.showTypeLabel}</span></div>
                <div class="sum-row" style="align-items:flex-start">
                    <span>Seats (${booking.seatCount})</span>
                    <span style="text-align:right">
                        <c:forTokens var="s" items="${booking.seats}" delims=",">
                            <span class="seat-chip">${s}</span>
                        </c:forTokens>
                    </span>
                </div>
                <div style="border-top:1px solid var(--border);margin-top:.75rem;padding-top:.75rem">
                    <div class="sum-row"><span>Subtotal</span><span>LKR <span id="sumBase">${booking.totalPrice}</span></span></div>
                    <div class="sum-row" id="sumDiscount" style="display:none;color:var(--emerald)"><span>Discount</span><span style="color:var(--emerald)">- LKR <span id="sumDiscAmt">0</span></span></div>
                    <div class="price-final"><span>Total</span><span>LKR <span id="sumFinal">${booking.totalPrice}</span></span></div>
                </div>
            </div>

            <div class="promo-hint">
                <div class="promo-hint-title"><i class="bi bi-tag-fill"></i> Available Promo Codes</div>
                <c:forEach var="entry" items="${promoCodes}">
                    <div class="promo-code-row"><code>${entry.key}</code><span>${entry.value}</span></div>
                </c:forEach>
            </div>
        </div>
    </div>
</div>

<script>
const BASE=parseFloat('${booking.totalPrice}');
let disc=0,promoCode='';
const PROMOS={'CINEBOOK10':.10,'FIRSTSHOW':.15,'WEEKEND20':.20};

function switchMethod(t){
    document.getElementById('ptInput').value=t;
    document.getElementById('onlineSection').style.display=t==='ONLINE'?'':'none';
    document.getElementById('counterSection').style.display=t==='COUNTER'?'':'none';
    document.getElementById('tabOnline').classList.toggle('active',t==='ONLINE');
    document.getElementById('tabCounter').classList.toggle('active',t==='COUNTER');
    updateBtn();
}
function selectCard(t){
    document.getElementById('ctInput').value=t;
    ['btnVisa','btnMC','btnAmex'].forEach(id=>document.getElementById(id).classList.remove('selected'));
    const map={VISA:'btnVisa',MASTERCARD:'btnMC',AMEX:'btnAmex'};
    if(map[t])document.getElementById(map[t]).classList.add('selected');
}
function fmtCard(el){el.value=el.value.replace(/\D/g,'').substring(0,16).replace(/(.{4})/g,'$1 ').trim()}
function fmtExp(el){let v=el.value.replace(/\D/g,'').substring(0,4);if(v.length>2)v=v.substring(0,2)+' / '+v.substring(2);el.value=v}
function applyPromo(){
    const code=document.getElementById('promoField').value.trim().toUpperCase();
    const msg=document.getElementById('promoMsg');
    const rate=PROMOS[code];
    if(rate){
        disc=parseFloat((BASE*rate).toFixed(2));promoCode=code;
        document.getElementById('pcInput').value=code;
        document.getElementById('sumDiscount').style.display='';
        document.getElementById('sumDiscAmt').textContent=disc.toFixed(2);
        document.getElementById('sumFinal').textContent=(BASE-disc).toFixed(2);
        updateBtn();
        msg.innerHTML='<div class="promo-ok"><i class="bi bi-check-circle-fill"></i> '+(rate*100)+'% off applied! Saving LKR '+disc.toFixed(2)+'</div>';
    }else{
        disc=0;promoCode='';document.getElementById('pcInput').value='';
        document.getElementById('sumDiscount').style.display='none';
        document.getElementById('sumFinal').textContent=BASE.toFixed(2);
        updateBtn();
        msg.innerHTML='<div class="promo-fail"><i class="bi bi-x-circle-fill"></i> Invalid promo code.</div>';
    }
}
function updateBtn(){
    const t=document.getElementById('ptInput').value;
    document.getElementById('payBtnText').textContent=(t==='COUNTER'?'Confirm Counter Payment – ':'Pay ')+'LKR '+(BASE-disc).toFixed(2);
}
function validatePay(){
    if(document.getElementById('ptInput').value==='ONLINE'){
        const n=document.getElementById('cardNum').value.replace(/\s/g,'');
        if(n.length<16){alert('Please enter a valid 16-digit card number.');return false;}
        const h=document.createElement('input');h.type='hidden';h.name='cardNumber';h.value=document.getElementById('cardNum').value;
        document.getElementById('payForm').appendChild(h);
    }
    return true;
}
</script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
