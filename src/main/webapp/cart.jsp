<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.Map" %>
<%@ page import="com.project.platehop.model.CartItem" %>
<%@ page import="com.project.platehop.model.User" %>
<%@ page import="com.project.platehop.model.Cart" %>
<%
    User loggedInUser = (User) session.getAttribute("loggedInUser");
    if (loggedInUser == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    @SuppressWarnings("unchecked")
    Cart cart = (Cart) session.getAttribute("cart");

    double grandTotal = 0.0;

    Integer currentRestaurantId =
            (Integer) session.getAttribute("restaurantId");

    if (cart != null && !cart.getItems().isEmpty()) {

        for (CartItem item : cart.getItems().values()) {
            grandTotal += item.getSubtotal();
        }
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Your Cart - PlateHop</title>
    <meta name="description" content="Review your cart and proceed to checkout on PlateHop.">
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;500;600;700;800;900&display=swap" rel="stylesheet">
    <style>
        *, *::before, *::after { margin: 0; padding: 0; box-sizing: border-box; }
        :root {
            --bg: #0d1117;
            --surface: #161b22;
            --surface2: #1c2230;
            --surface3: #222d3a;
            --orange: #ff5e00;
            --orange2: #e05300;
            --orange-glow: rgba(255, 94, 0, 0.12);
            --white: #ffffff;
            --text: #c9d1d9;
            --muted: #8b949e;
            --border: rgba(255, 255, 255, 0.08);
            --font: 'Outfit', sans-serif;
        }
        body { background: var(--bg); font-family: var(--font); color: var(--text); min-height: 100vh; }

        /* NAVBAR */
        .navbar {
            position: fixed; top: 0; left: 0; right: 0; z-index: 999;
            display: flex; align-items: center; justify-content: space-between;
            padding: 1rem 3rem;
            background: rgba(13, 17, 23, 0.92); backdrop-filter: blur(20px);
            border-bottom: 1px solid var(--border);
        }
        .logo { font-size: 1.6rem; font-weight: 900; color: #fff; text-decoration: none; display: flex; align-items: center; gap: 8px; letter-spacing: -0.5px; }
        .logo span { color: var(--orange); }
        .nav-links { display: flex; align-items: center; gap: 2rem; }
        .nav-links a { text-decoration: none; color: var(--muted); font-weight: 500; font-size: 0.95rem; transition: color 0.2s; }
        .nav-links a:hover { color: #fff; }
        .nav-actions { display: flex; align-items: center; gap: 1.5rem; }
        .btn-login { background: transparent; border: 1px solid var(--orange); color: var(--white); padding: 0.5rem 1.2rem; border-radius: 50px; text-decoration: none; font-weight: 600; font-size: 0.9rem; transition: all 0.3s; }
        .btn-login:hover { background: var(--orange-glow); }
        .btn-signup { background: var(--orange); border: 1px solid var(--orange); color: var(--white); padding: 0.5rem 1.2rem; border-radius: 50px; text-decoration: none; font-weight: 600; font-size: 0.9rem; transition: all 0.3s; }
        .btn-signup:hover { background: var(--orange2); }
        .cart-icon { position: relative; color: var(--white); font-size: 1.2rem; text-decoration: none; }
        .cart-badge { position: absolute; top: -8px; right: -10px; background: var(--orange); color: white; font-size: 0.65rem; font-weight: bold; width: 18px; height: 18px; border-radius: 50%; display: flex; align-items: center; justify-content: center; }
        .profile-menu { position: relative; display: flex; align-items: center; gap: 0.5rem; cursor: pointer; text-decoration: none; color: var(--white); }
        .profile-avatar { width: 35px; height: 35px; border-radius: 50%; background: var(--orange); display: flex; align-items: center; justify-content: center; font-weight: 700; font-size: 1.1rem; color: white; }
        .dropdown-content { display: none; position: absolute; top: 45px; right: 0; background: rgba(22, 27, 34, 0.98); min-width: 160px; box-shadow: 0 8px 16px rgba(0,0,0,0.5); border-radius: 12px; border: 1px solid var(--border); overflow: hidden; z-index: 1000; flex-direction: column; }
        .dropdown-content a { color: var(--white); padding: 12px 16px; text-decoration: none; display: flex; align-items: center; gap: 10px; font-size: 0.9rem; transition: background 0.2s; }
        .dropdown-content a:hover { background: var(--orange-glow); color: var(--orange); }
        .profile-menu:hover .dropdown-content { display: flex; }

        /* PAGE */
        .page { max-width: 1100px; margin: 0 auto; padding: 6.5rem 2rem 4rem; }
        .page-head { margin-bottom: 2rem; }
        .page-title { font-size: 1.8rem; font-weight: 800; color: #fff; }
        .page-sub { color: var(--muted); font-size: 0.9rem; margin-top: 0.3rem; }

        /* EMPTY CART */
        .empty-card {
            background: var(--surface2); border: 1px solid var(--border);
            border-radius: 16px; padding: 4rem 2rem;
            text-align: center; margin-top: 1rem;
        }
        .empty-title { font-size: 1.3rem; font-weight: 700; color: #fff; margin-bottom: 0.6rem; }
        .empty-desc { color: var(--muted); font-size: 0.9rem; margin-bottom: 1.8rem; }
        .btn-browse-empty {
            display: inline-block;
            background: transparent; border: 1.5px solid var(--orange);
            color: var(--orange); padding: 0.65rem 1.6rem; border-radius: 50px;
            font-size: 0.9rem; font-weight: 600; text-decoration: none; font-family: var(--font);
            transition: all 0.2s;
        }
        .btn-browse-empty:hover { background: var(--orange-glow); }

        /* CART TABLE */
        .cart-card {
            background: var(--surface2); border: 1px solid var(--border);
            border-radius: 16px; overflow: hidden;
        }
        table { width: 100%; border-collapse: collapse; }
        thead tr { border-bottom: 1px solid var(--border); }
        th { padding: 0.9rem 1.4rem; text-align: left; color: var(--muted); font-size: 0.8rem; font-weight: 600; text-transform: uppercase; letter-spacing: 0.8px; }
        td { padding: 1rem 1.4rem; border-bottom: 1px solid var(--border); vertical-align: middle; font-size: 0.95rem; }
        tbody tr:last-child td { border-bottom: none; }

        .item-name { font-weight: 700; color: #fff; }
        .item-price { color: var(--text); }
        .item-total { color: var(--text); }

        /* QUANTITY CONTROLS - pure form based, no JS */
        .qty-controls { display: flex; align-items: center; gap: 0.5rem; }
        .qty-btn-form { display: inline; }
        .qty-circle-btn {
            width: 28px; height: 28px; border-radius: 50%;
            background: var(--surface3); border: 1px solid var(--border);
            color: #fff; font-size: 1rem; font-weight: 600; cursor: pointer;
            font-family: var(--font); display: inline-flex; align-items: center; justify-content: center;
            transition: all 0.2s; line-height: 1;
        }
        .qty-circle-btn:hover { background: var(--orange); border-color: var(--orange); }
        .qty-num { min-width: 24px; text-align: center; color: #fff; font-weight: 600; font-size: 0.95rem; }

        /* REMOVE BUTTON */
        .btn-remove-form { display: inline; }
        .btn-remove {
            background: transparent; border: 1px solid #555;
            color: var(--text); padding: 0.35rem 0.9rem;
            border-radius: 50px; font-size: 0.8rem; font-weight: 600;
            cursor: pointer; font-family: var(--font); transition: all 0.2s;
        }
        .btn-remove:hover { border-color: #ef4444; color: #ef4444; }

        /* GRAND TOTAL ROW */
        .grand-total-row td { border-top: 1px solid var(--border); padding-top: 1.1rem; padding-bottom: 1.1rem; }
        .grand-total-label { font-size: 1rem; font-weight: 800; color: #fff; }
        .grand-total-value { font-size: 1rem; font-weight: 800; color: var(--orange); }

        /* BOTTOM ACTIONS */
        .cart-actions { display: flex; justify-content: space-between; align-items: center; margin-top: 1.5rem; }
        .btn-add-more {
            display: inline-block; background: transparent;
            border: 1.5px solid var(--orange); color: var(--orange);
            padding: 0.6rem 1.4rem; border-radius: 50px;
            font-size: 0.88rem; font-weight: 600; text-decoration: none;
            font-family: var(--font); transition: all 0.2s;
        }
        .btn-add-more:hover { background: var(--orange-glow); }
        .btn-checkout {
            display: inline-block;
            background: linear-gradient(135deg, var(--orange), var(--orange2));
            color: white; border: none; padding: 0.7rem 2rem;
            border-radius: 50px; font-size: 0.92rem; font-weight: 700;
            text-decoration: none; font-family: var(--font); cursor: pointer;
            transition: all 0.3s; box-shadow: 0 6px 20px rgba(255, 94, 0, 0.3);
        }
        .btn-checkout:hover { box-shadow: 0 10px 30px rgba(255, 94, 0, 0.5); transform: translateY(-1px); }

        @media (max-width: 768px) {
            .navbar { padding: 1rem 1.2rem; }
            .nav-links { display: none; }
            .page { padding: 6rem 1rem 3rem; }
            th:nth-child(2), td:nth-child(2) { display: none; }
            .cart-actions { flex-direction: column; gap: 1rem; }
        }
    </style>
</head>
<body>
    <nav class="navbar">
        <a href="index.jsp" class="logo">
            <svg viewBox="0 0 100 100" style="height:32px;width:32px;" xmlns="http://www.w3.org/2000/svg">
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
            Plate<span>Hop</span>
        </a>
        <div class="nav-links">
            <a href="index.jsp">Home</a>
            <a href="restaurants">Restaurants</a>
        </div>
        <div class="nav-actions">
            <% if (loggedInUser == null) { %>
                <a href="login.jsp" class="btn-login">Login</a>
                <a href="register.jsp" class="btn-signup">Sign Up</a>
                <a href="cart.jsp" class="cart-icon">🛒</a>
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
            <h1 class="page-title">Your Cart</h1>
            <p class="page-sub">Review your selected food items</p>
        </div>

        <% if (cart == null || cart.getItems().isEmpty()) { %>
            <div class="empty-card">
                <div class="empty-title">Your cart is empty</div>
                <p class="empty-desc">Please add some food items from the menu</p>
                <a href="restaurants" class="btn-browse-empty">Browse Restaurants</a>
            </div>
        <% } else { %>
            <div class="cart-card">
                <table>
                    <thead>
                        <tr>
                            <th>Item</th>
                            <th>Price</th>
                            <th>Total</th>
                            <th>Quantity</th>
                            <th>Action</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% for (CartItem item : cart.getItems().values()) { %>
                        <tr>
                            <td><span class="item-name"><%= item.getName() %></span></td>
                            <td><span class="item-price">&#8377;<%= item.getPrice() %></span></td>
                            <td><span class="item-total">&#8377;<%= item.getSubtotal() %></span></td>
                            <td>
                                <div class="qty-controls">
                                    <!-- Decrease button -->
                                    <form action="CartServlet" method="post" class="qty-btn-form">
                                        <input type="hidden" name="action" value="update">
                                        <input type="hidden" name="menuId" value="<%= item.getMenuId() %>">
                                        <input type="hidden" name="restaurantId" value="<%= item.getRestaurantId() %>">
                                        <input type="hidden" name="quantity" value="<%= item.getQuantity() - 1 %>">
                                        <button type="submit" class="qty-circle-btn">−</button>
                                    </form>
                                    <span class="qty-num"><%= item.getQuantity() %></span>
                                    <!-- Increase button -->
                                    <form action="CartServlet" method="post" class="qty-btn-form">
                                        <input type="hidden" name="action" value="update">
                                        <input type="hidden" name="menuId" value="<%= item.getMenuId() %>">
                                        <input type="hidden" name="restaurantId" value="<%= item.getRestaurantId() %>">
                                        <input type="hidden" name="quantity" value="<%= item.getQuantity() + 1 %>">
                                        <button type="submit" class="qty-circle-btn">+</button>
                                    </form>
                                </div>
                            </td>
                            <td>
                                <form action="CartServlet" method="post" class="btn-remove-form">
                                    <input type="hidden" name="action" value="delete">
                                    <input type="hidden" name="menuId" value="<%= item.getMenuId() %>">
                                    <input type="hidden" name="restaurantId" value="<%= item.getRestaurantId() %>">
                                    <button type="submit" class="btn-remove">Remove</button>
                                </form>
                            </td>
                        </tr>
                        <% } %>
                        <!-- Grand Total Row -->
                        <tr class="grand-total-row">
                            <td class="grand-total-label">Grand Total</td>
                            <td></td>
                            <td></td>
                            <td></td>
                            <td class="grand-total-value">&#8377;<%= grandTotal %></td>
                        </tr>
                    </tbody>
                </table>
            </div>

            <div class="cart-actions">
                <% if (currentRestaurantId != null) { %>
                    <a href="Menu?restaurantId=<%= currentRestaurantId %>" class="btn-add-more">Add More Items</a>
                <% } else { %>
                    <a href="restaurants" class="btn-add-more">Add More Items</a>
                <% } %>

                <% if (loggedInUser != null) { %>
                    <a href="checkout.jsp" class="btn-checkout">Proceed to Checkout</a>
                <% } else { %>
                    <a href="login.jsp" class="btn-checkout">Login to Checkout</a>
                <% } %>
            </div>
        <% } %>
    </div>
</body>
</html>
