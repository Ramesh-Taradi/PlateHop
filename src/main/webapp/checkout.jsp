<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.project.platehop.model.Cart" %>
<%@ page import="com.project.platehop.model.CartItem" %>
<%@ page import="com.project.platehop.model.User" %>
<%
    User loggedInUser = (User) session.getAttribute("loggedInUser");
    if (loggedInUser == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    @SuppressWarnings("unchecked")
    Cart cart = (Cart) session.getAttribute("cart");

    if (cart == null || cart.getItems().isEmpty()) {
        response.sendRedirect("cart.jsp");
        return;
    }

    double total = 0.0;
    for (CartItem item : cart.getItems().values()) {
        total += item.getSubtotal();
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Checkout - Platehop</title>
    <meta name="description" content="Complete your Platehop order with fast secure checkout.">
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;500;600;700;800;900&display=swap" rel="stylesheet">
    <style>
        *, *::before, *::after { margin: 0; padding: 0; box-sizing: border-box; }
        :root {
            --bg: #0a0a0a; --surface: #111; --surface2: #181818; --surface3: #1e1e1e;
            --orange: #ff5e00; --orange2: #e05300; --orange-glow: rgba(255,94,0,0.12);
            --white: #fff; --text: #e0e0e0; --muted: #666; --border: rgba(255,255,255,0.07);
            --green: #22c55e; --font: 'Outfit', sans-serif;
        }
        body { background: var(--bg); font-family: var(--font); color: var(--text); min-height: 100vh; }

        /* NAVBAR */
        .navbar {
            position: fixed; top: 0; left: 0; right: 0; z-index: 999;
            display: flex; align-items: center; justify-content: space-between;
            padding: 1rem 3rem;
            background: rgba(10,10,10,0.9); backdrop-filter: blur(20px);
            border-bottom: 1px solid var(--border);
        }
        .logo { font-size: 1.6rem; font-weight: 900; color: #fff; text-decoration: none; letter-spacing: -0.5px; display: flex; align-items: center; gap: 0.5rem; }
        .img-brand-logo { height: 40px; width: auto; filter: invert(1) hue-rotate(180deg) brightness(1.2); mix-blend-mode: screen; }
        .logo span { color: var(--orange); }
        .nav-links { display: flex; align-items: center; gap: 2rem; }
        .nav-links a { text-decoration: none; color: var(--muted); font-weight: 500; font-size: 0.95rem; transition: color 0.2s; }
        .nav-links a:hover { color: #fff; }
        .nav-actions { display: flex; align-items: center; gap: 1.5rem; }
        .btn-login {
            background: transparent;
            border: 1px solid var(--orange);
            color: var(--white);
            padding: 0.5rem 1.2rem;
            border-radius: 50px;
            text-decoration: none;
            font-weight: 600;
            font-size: 0.95rem;
            transition: all 0.3s;
        }
        .btn-login:hover { background: rgba(255, 94, 0, 0.1); }
        .btn-signup {
            background: var(--orange);
            border: 1px solid var(--orange);
            color: var(--white);
            padding: 0.5rem 1.2rem;
            border-radius: 50px;
            text-decoration: none;
            font-weight: 600;
            font-size: 0.95rem;
            transition: all 0.3s;
        }
        .btn-signup:hover { background: var(--orange-hover); border-color: var(--orange-hover); }
        .cart-icon { position: relative; color: var(--white); font-size: 1.2rem; text-decoration: none; }
        .cart-badge {
            position: absolute; top: -8px; right: -10px; background: var(--orange); color: white;
            font-size: 0.65rem; font-weight: bold; width: 18px; height: 18px; border-radius: 50%;
            display: flex; align-items: center; justify-content: center;
        }
        .profile-menu { position: relative; display: flex; align-items: center; gap: 0.5rem; cursor: pointer; text-decoration: none; color: var(--white); }
        .profile-avatar {
            width: 35px; height: 35px; border-radius: 50%; background: var(--orange);
            display: flex; align-items: center; justify-content: center; font-weight: 700; font-size: 1.1rem; color: white;
        }
        .dropdown-content {
            display: none; position: absolute; top: 45px; right: 0; background: rgba(15, 15, 15, 0.95);
            min-width: 160px; box-shadow: 0 8px 16px rgba(0,0,0,0.4); border-radius: 12px;
            border: 1px solid rgba(255, 255, 255, 0.1); overflow: hidden; z-index: 1000; flex-direction: column;
        }
        .dropdown-content a { color: var(--white); padding: 12px 16px; text-decoration: none; display: flex; align-items: center; gap: 10px; font-size: 0.9rem; transition: background 0.2s; }
        .dropdown-content a:hover { background: rgba(255, 94, 0, 0.2); color: var(--orange); }
        .profile-menu:hover .dropdown-content { display: flex; }

        /* PAGE */
        .page { max-width: 1100px; margin: 0 auto; padding: 8rem 3rem 4rem; }
        .page-head { margin-bottom: 2.5rem; }
        .page-tag {
            display: inline-block; background: var(--orange-glow);
            border: 1px solid rgba(255,106,0,0.2); color: var(--orange2);
            padding: 0.35rem 1rem; border-radius: 50px; font-size: 0.78rem;
            font-weight: 700; text-transform: uppercase; letter-spacing: 1px; margin-bottom: 1rem;
        }
        .page-title { font-size: clamp(2rem, 4vw, 3rem); font-weight: 900; color: #fff; letter-spacing: -1.5px; }
        .page-title span { color: var(--orange); }

        /* PROGRESS STEPS */
        .steps-bar { display: flex; align-items: center; gap: 0; margin-bottom: 2.5rem; max-width: 500px; }
        .step-item { display: flex; align-items: center; gap: 0.6rem; flex: 1; }
        .step-circle {
            width: 36px; height: 36px; border-radius: 50%; display: flex; align-items: center; justify-content: center;
            font-size: 0.8rem; font-weight: 800; flex-shrink: 0;
        }
        .step-circle.done { background: var(--green); color: white; }
        .step-circle.active { background: linear-gradient(135deg, var(--orange), var(--orange2)); color: white; }
        .step-circle.pending { background: var(--surface3); border: 1.5px solid var(--border); color: var(--muted); }
        .step-label { font-size: 0.8rem; font-weight: 600; }
        .step-label.active { color: var(--white); }
        .step-label.done { color: var(--green); }
        .step-label.pending { color: var(--muted); }
        .step-line { flex: 1; height: 2px; background: var(--border); margin: 0 0.5rem; }
        .step-line.done { background: var(--green); }

        /* LAYOUT */
        .checkout-layout { display: grid; grid-template-columns: 1fr 380px; gap: 2rem; align-items: start; }

        /* FORM PANEL */
        .form-panel {
            background: var(--surface2); border: 1px solid var(--border);
            border-radius: 20px; overflow: hidden;
        }
        .panel-section { padding: 2rem; border-bottom: 1px solid var(--border); }
        .panel-section:last-child { border-bottom: none; }
        .section-head { display: flex; align-items: center; gap: 0.8rem; margin-bottom: 1.5rem; }
        .section-num {
            width: 32px; height: 32px; border-radius: 50%; flex-shrink: 0;
            background: linear-gradient(135deg, var(--orange), var(--orange2));
            display: flex; align-items: center; justify-content: center;
            font-size: 0.82rem; font-weight: 800; color: white;
        }
        .section-title { font-size: 1.1rem; font-weight: 800; color: #fff; }

        .form-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 1rem; }
        .form-full { grid-column: 1 / -1; }
        .form-group { display: flex; flex-direction: column; gap: 0.5rem; }
        .form-group label { color: rgba(255,255,255,0.6); font-size: 0.75rem; font-weight: 700; text-transform: uppercase; letter-spacing: 0.8px; }
        .form-group input, .form-group select {
            padding: 0.85rem 1rem; background: var(--surface3);
            border: 1.5px solid var(--border); border-radius: 12px;
            color: #fff; font-size: 0.93rem; font-family: var(--font); outline: none; transition: all 0.3s;
        }
        .form-group input::placeholder { color: #3a3a3a; }
        .form-group input:focus, .form-group select:focus {
            border-color: var(--orange); background: rgba(255,106,0,0.05);
            box-shadow: 0 0 0 4px rgba(255,106,0,0.1);
        }
        .form-group input[readonly] { cursor: not-allowed; opacity: 0.5; }
        .form-group select { cursor: pointer; }
        .form-group select option { background: var(--surface2); }

        /* PAYMENT OPTIONS */
        .pay-options { display: grid; grid-template-columns: 1fr 1fr; gap: 0.8rem; }
        .pay-option { position: relative; }
        .pay-option input[type="radio"] { position: absolute; opacity: 0; }
        .pay-option label {
            display: flex; align-items: center; gap: 0.8rem;
            background: var(--surface3); border: 2px solid var(--border);
            border-radius: 14px; padding: 1rem 1.2rem; cursor: pointer; transition: all 0.3s;
            color: var(--text); font-size: 0.9rem; font-weight: 600;
            text-transform: none; letter-spacing: 0; text-align: left;
        }
        .pay-option input[type="radio"]:checked + label {
            border-color: var(--orange); background: var(--orange-glow); color: var(--white);
        }
        .pay-icon { font-size: 1.5rem; }

        /* ORDER SUMMARY PANEL */
        .summary-panel {
            background: var(--surface2); border: 1px solid var(--border);
            border-radius: 20px; overflow: hidden; position: sticky; top: 6rem;
        }
        .summary-header { padding: 1.5rem 2rem; border-bottom: 1px solid var(--border); }
        .summary-title { font-size: 1.1rem; font-weight: 800; color: #fff; }
        .summary-body { padding: 1.5rem 2rem; }

        .order-item { display: flex; justify-content: space-between; align-items: center; padding: 0.75rem 0; border-bottom: 1px solid rgba(255,255,255,0.04); }
        .order-item:last-of-type { border-bottom: none; }
        .order-item-name { color: var(--text); font-size: 0.9rem; font-weight: 600; }
        .order-item-qty { color: var(--muted); font-size: 0.8rem; background: var(--surface3); padding: 0.15rem 0.5rem; border-radius: 50px; margin-left: 0.4rem; }
        .order-item-price { color: var(--orange2); font-size: 0.9rem; font-weight: 700; }

        .summary-footer { padding: 1.5rem 2rem; border-top: 1px solid var(--border); }
        .summary-row { display: flex; justify-content: space-between; margin-bottom: 0.8rem; }
        .summary-lbl { color: var(--muted); font-size: 0.88rem; }
        .summary-val { color: var(--text); font-size: 0.88rem; font-weight: 600; }
        .total-row { display: flex; justify-content: space-between; padding-top: 1rem; margin-top: 0.5rem; border-top: 1px solid var(--border); }
        .total-lbl { color: #fff; font-size: 1rem; font-weight: 800; }
        .total-val { color: var(--orange2); font-size: 1.4rem; font-weight: 900; }

        /* PLACE ORDER BUTTON */
        .btn-place {
            display: block; width: 100%; padding: 1rem; margin-top: 1.5rem;
            background: linear-gradient(135deg, var(--orange), var(--orange2));
            color: white; border: none; border-radius: 14px;
            font-size: 1rem; font-weight: 700; font-family: var(--font); cursor: pointer;
            transition: all 0.3s; box-shadow: 0 8px 30px rgba(255,106,0,0.3);
            position: relative; overflow: hidden;
        }
        .btn-place::before {
            content: ''; position: absolute; top: 0; left: -100%;
            width: 100%; height: 100%;
            background: linear-gradient(90deg, transparent, rgba(255,255,255,0.15), transparent);
            transition: left 0.5s;
        }
        .btn-place:hover::before { left: 100%; }
        .btn-place:hover { transform: translateY(-2px); box-shadow: 0 16px 40px rgba(255,106,0,0.5); }

        .secure-note { display: flex; align-items: center; justify-content: center; gap: 0.4rem; color: var(--muted); font-size: 0.78rem; margin-top: 1rem; }

        @media (max-width: 900px) {
            .checkout-layout { grid-template-columns: 1fr; }
            .summary-panel { position: static; }
        }
        @media (max-width: 768px) {
            .navbar { padding: 1rem 1.5rem; }
            .page { padding: 7rem 1.5rem 3rem; }
            .form-grid { grid-template-columns: 1fr; }
            .pay-options { grid-template-columns: 1fr; }
            .nav-links a, .nav-actions a:not(.cart-icon):not(.profile-menu) { display: none; }
        }
    </style>
</head>
<body>
    <nav class="navbar">
        <a href="index.jsp" class="logo">
            <div style="display:flex; align-items:center; gap:8px;">
                <svg viewBox="0 0 100 100" style="height:35px; width:35px;" xmlns="http://www.w3.org/2000/svg">
                    <defs>
                        <linearGradient id="pinGrad" x1="0%" y1="0%" x2="100%" y2="0%">
                            <stop offset="50%" stop-color="#ff7700"/>
                            <stop offset="50%" stop-color="#dd4500"/>
                        </linearGradient>
                    </defs>
                    <path d="M50 5 C35 5 25 17 25 31 C25 50 50 75 50 75 C50 75 75 50 75 31 C75 17 65 5 50 5 Z" fill="url(#pinGrad)"/>
                    <path d="M38 18 V28 C38 31 41 33 41 33 V45 H44 V33 C44 33 47 31 47 28 V18 H45 V25 H43 V18 H41 V25 H39 V18 Z" fill="#111316"/>
                    <path d="M53 18 C50 18 50 25 53 28 V45 H56 V28 C59 25 59 18 56 18 Z" fill="#111316"/>
                    <rect x="20" y="80" width="60" height="4" rx="2" fill="#ffffff"/>
                    <path d="M30 84 C30 84 45 98 65 86 L70 82 C70 82 65 96 45 100 C30 96 25 90 25 90 Z" fill="#ffffff"/>
                </svg>
                <span style="font-size:1.6rem; font-weight:900; color:#fff; letter-spacing:-1px;">Plate<span style="color:#ff5e00;">Hop</span></span>
            </div>
        </a>
        <div class="nav-links">
            <a href="index.jsp">Home</a>
            <a href="restaurants">Restaurants</a>
        </div>
        <div class="nav-actions">
            <% if(loggedInUser == null){ %>
                <a href="login.jsp" class="btn-login">Login</a>
                <a href="register.jsp" class="btn-signup">Sign Up</a>
                <a href="cart.jsp" class="cart-icon" style="margin-left: 0.5rem;">
                    🛒
                </a>
            <% } else { %>
                <a href="cart.jsp" class="cart-icon">
                    🛒
                  <div class="cart-badge"><%= cart != null ? cart.getItems().size() : 0 %></div>
                </a>
                <a href="profile.jsp" title="My Profile" style="display:flex; align-items:center; justify-content:center; width:38px; height:38px; border-radius:50%; background:#f2f2f7; color:#1c1c1e; text-decoration:none; margin-left:8px; border: 1px solid #e8e8e8;">
                    <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M20 21v-2a4 4 0 00-4-4H8a4 4 0 00-4 4v2"/><circle cx="12" cy="7" r="4"/></svg>
                </a>
            <% } %>
        </div>
    </nav>

    <div class="page">
        <div class="page-head">
            <div class="page-tag">💳 Secure Checkout</div>
            <h1 class="page-title">Complete Your <span>Order</span></h1>
        </div>

        <!-- Progress -->
        <div class="steps-bar">
            <div class="step-item">
                <div class="step-circle done">✓</div>
                <span class="step-label done">Cart</span>
            </div>
            <div class="step-line done"></div>
            <div class="step-item">
                <div class="step-circle active">2</div>
                <span class="step-label active">Checkout</span>
            </div>
            <div class="step-line"></div>
            <div class="step-item">
                <div class="step-circle pending">3</div>
                <span class="step-label pending">Confirmed</span>
            </div>
        </div>

        <div class="checkout-layout">
            <!-- FORM -->
            <form action="CheckoutServlet" method="post" id="checkoutForm">
                <div class="form-panel">
                    <!-- Delivery Info -->
                    <div class="panel-section">
                        <div class="section-head">
                            <div class="section-num">1</div>
                            <div class="section-title">Delivery Information</div>
                        </div>
                        <div class="form-grid">
							<div class="form-group form-full">
								<label>Full Name</label> <input type="text"
									value="<%=loggedInUser.getUserName()%>" readonly>
							</div>

							<div class="form-group form-full">
								<label>Email Address</label> <input type="email"
									value="<%=loggedInUser.getEmail()%>" readonly>
							</div>

							<div class="form-group">
								<label>Phone Number</label> <input type="tel" name="phone"
									placeholder="+91 98765 43210" pattern="[6-9]{1}[0-9]{9}"
									maxlength="10" required>
							</div>
							<div class="form-group form-full">
                                <label>Delivery Address</label>
                                <input type="text" name="deliveryAddress" value="<%= loggedInUser.getAddress() %>" placeholder="Enter delivery address" required>
                            </div>
							
                        </div>
                    </div>

                    <!-- Payment -->
                    <div class="panel-section">
                        <div class="section-head">
                            <div class="section-num">2</div>
                            <div class="section-title">Payment Method</div>
                        </div>
                        <div class="pay-options">
                            <div class="pay-option">
                                <input type="radio" name="paymentMethod" id="pay-card" value="card" checked>
                                <label for="pay-card">
                                    <span class="pay-icon">💳</span>
                                    <span>Card on Delivery</span>
                                </label>
                            </div>
                            <div class="pay-option">
                                <input type="radio" name="paymentMethod" id="pay-cash" value="cash">
                                <label for="pay-cash">
                                    <span class="pay-icon">💵</span>
                                    <span>Cash on Delivery</span>
                                </label>
                            </div>
                        </div>
                    </div>
                </div>
                <input type="hidden" name="totalAmount" value="<%= total %>">
            </form>

            <!-- ORDER SUMMARY -->
            <div class="summary-panel">
                <div class="summary-header">
                    <div class="summary-title">Order Summary</div>
                </div>
                <div class="summary-body">
					<div class="order-item"
						style="font-weight: bold; color: #ffffff; border-bottom: 1px solid rgba(255, 255, 255, 0.15);">
						<span style="flex: 2;">Item</span> <span
							style="flex: 0.5; text-align: center;">Qty</span> <span
							style="flex: 1; text-align: right;">Price</span>
					</div>
					<% for (CartItem item : cart.getItems().values()) { %>
					<div class="order-item">
						<span class="order-item-name" style="flex: 2;"> <%=item.getName()%>
						</span> <span
							style="flex: 0.5; text-align: center; color: #fff; font-weight: 600;">
							<%=item.getQuantity()%>
						</span> <span class="order-item-price"
							style="flex: 1; text-align: right;"> ₹<%=String.format("%.2f", item.getSubtotal())%>
						</span>
					</div>
					<%
					}
					%>
                </div>
                <div class="summary-footer">
                    <div class="summary-row">
                        <span class="summary-lbl">Subtotal</span>
                        <span class="summary-val">₹ <%= String.format("%.2f", total) %></span>
                    </div>
                    <div class="summary-row">
                        <span class="summary-lbl">Delivery Fee</span>
                        <span class="summary-val" style="color:var(--green)">Free 🎉</span>
                    </div>
                    <div class="summary-row">
                        <span class="summary-lbl">Estimated Time</span>
                        <span class="summary-val">⚡ 30 mins</span>
                    </div>
                    <div class="total-row">
                        <span class="total-lbl">GrandTotal</span>
                        <span class="total-val">₹ <%= String.format("%.2f", total) %></span>
                    </div>
                    <button type="button" class="btn-place" onclick="document.getElementById('checkoutForm').submit();">
                          Place Order Now
                    </button>
                    <div class="secure-note">🔒 Secured by 256-bit SSL encryption</div>
                </div>
            </div>
        </div>
    </div>
</body>
</html>
