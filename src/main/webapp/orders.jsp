<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.project.platehop.model.User" %>
<%@ page import="com.project.platehop.model.Order" %>
<%@ page import="com.project.platehop.model.Restaurant" %>
<%@ page import="com.project.platehop.model.Cart" %>
<%@ page import="com.project.platehop.service.OrderService" %>
<%@ page import="com.project.platehop.service.RestaurantService" %>
<%@ page import="com.project.platehop.util.SpringContextHelper" %>
<%@ page import="java.util.List" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%
    User loggedInUser = (User) session.getAttribute("loggedInUser");
    if (loggedInUser == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    
    // For cart count in navbar
    Cart cart = (Cart) session.getAttribute("cart");
    
    // Fetch orders via request attribute or Spring bean
    @SuppressWarnings("unchecked")
    List<Order> orders = (List<Order>) request.getAttribute("orders");
    OrderService orderService = SpringContextHelper.getBean(OrderService.class);
    RestaurantService restaurantService = SpringContextHelper.getBean(RestaurantService.class);
    if (orders == null && orderService != null) {
        orders = orderService.getOrdersByUserId(loggedInUser.getId());
    }
    
    SimpleDateFormat sdf = new SimpleDateFormat("MMM dd, yyyy 'at' hh:mm a");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>My Orders - PlateHop</title>
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;500;600;700;800;900&display=swap" rel="stylesheet">
    <style>
        :root {
            --orange: #ff5e00;
            --orange-hover: #e05300;
            --bg: #0a0a0a;
            --surface: #111111;
            --surface2: #181818;
            --surface3: #222222;
            --white: #ffffff;
            --text: #e0e0e0;
            --muted: #888888;
            --border: #2a2a2a;
            --shadow: 0 4px 20px rgba(0,0,0,0.5);
            --border-radius: 12px;
            --success: #1ba672;
            --warning: #fdcb6e;
            --danger: #e02020;
        }

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: 'Outfit', sans-serif;
        }

        body {
            background-color: var(--bg);
            color: var(--text);
            min-height: 100vh;
        }

        /* Modern Navbar Styles */
        .navbar {
            background: var(--surface);
            padding: 1rem 5%;
            display: flex;
            justify-content: space-between;
            align-items: center;
            border-bottom: 1px solid var(--border);
            position: sticky;
            top: 0;
            z-index: 1000;
        }

        .logo-container {
            display: flex;
            align-items: center;
            gap: 0.5rem;
            text-decoration: none;
        }

        .logo-icon {
            font-size: 1.8rem;
        }

        .logo-text {
            font-size: 1.5rem;
            font-weight: 700;
            color: var(--white);
        }

        .logo-text span {
            color: var(--orange);
        }

        .search-container {
            flex: 1;
            max-width: 400px;
            margin: 0 2rem;
            position: relative;
        }

        .search-container input {
            width: 100%;
            padding: 0.8rem 1.2rem;
            padding-left: 2.8rem;
            border: 1px solid var(--border);
            border-radius: 8px;
            font-size: 0.95rem;
            transition: all 0.3s;
            background: var(--surface2);
            color: var(--white);
        }

        .search-container input:focus {
            outline: none;
            border-color: var(--orange);
            background: var(--surface);
        }

        .search-icon {
            position: absolute;
            left: 1rem;
            top: 50%;
            transform: translateY(-50%);
            color: var(--muted);
        }

        .nav-actions {
            display: flex;
            align-items: center;
            gap: 1.5rem;
        }

        .nav-link {
            text-decoration: none;
            color: var(--text);
            font-weight: 500;
            display: flex;
            align-items: center;
            gap: 0.5rem;
            transition: color 0.2s;
            position: relative;
        }

        .nav-link:hover {
            color: var(--orange);
        }

        .cart-badge {
            background: var(--orange);
            color: var(--white);
            font-size: 0.75rem;
            font-weight: 700;
            width: 20px;
            height: 20px;
            display: flex;
            align-items: center;
            justify-content: center;
            border-radius: 50%;
            position: absolute;
            top: -8px;
            right: -12px;
        }

        /* Orders Layout */
        .container {
            max-width: 1000px;
            margin: 3rem auto;
            padding: 0 2rem;
        }

        .page-header {
            margin-bottom: 2rem;
            display: flex;
            justify-content: space-between;
            align-items: flex-end;
        }

        .page-title {
            font-size: 2rem;
            color: var(--white);
        }
        
        .order-count {
            color: var(--muted);
            font-weight: 500;
        }

        .orders-list {
            display: flex;
            flex-direction: column;
            gap: 1.5rem;
        }

        .order-card {
            background: var(--surface2);
            border: 1px solid var(--border);
            border-radius: var(--border-radius);
            padding: 1.5rem 2rem;
            display: flex;
            justify-content: space-between;
            align-items: center;
            border-left: 4px solid transparent;
            transition: transform 0.2s, box-shadow 0.2s;
        }
        
        .order-card:hover {
            transform: translateY(-2px);
            box-shadow: var(--shadow);
            border-color: var(--surface3);
        }

        .order-card.status-Delivered {
            border-left-color: var(--success);
        }

        .order-card.status-Pending {
            border-left-color: var(--warning);
        }

        .order-card.status-Cancelled {
            border-left-color: var(--danger);
        }

        .order-info {
            display: flex;
            flex-direction: column;
            gap: 0.5rem;
        }

        .order-header {
            display: flex;
            align-items: center;
            gap: 1rem;
        }

        .restaurant-name {
            font-size: 1.2rem;
            font-weight: 700;
            color: var(--white);
        }

        .order-id {
            background: var(--surface3);
            padding: 0.2rem 0.6rem;
            border-radius: 4px;
            font-size: 0.8rem;
            color: var(--muted);
            font-weight: 600;
        }

        .order-meta {
            color: var(--muted);
            font-size: 0.9rem;
            display: flex;
            gap: 1.5rem;
        }
        
        .order-meta span {
            display: flex;
            align-items: center;
            gap: 0.4rem;
        }

        .order-actions {
            display: flex;
            flex-direction: column;
            align-items: flex-end;
            gap: 1rem;
        }

        .order-total {
            font-size: 1.3rem;
            font-weight: 700;
            color: var(--white);
        }

        .status-badge {
            padding: 0.4rem 1rem;
            border-radius: 20px;
            font-size: 0.85rem;
            font-weight: 600;
        }

        .status-badge.status-Delivered {
            background: rgba(27, 166, 114, 0.15);
            color: var(--success);
        }

        .status-badge.status-Pending {
            background: rgba(253, 203, 110, 0.15);
            color: var(--warning);
        }
        
        .status-badge.status-Cancelled {
            background: rgba(224, 32, 32, 0.15);
            color: var(--danger);
        }

        .btn-reorder {
            background: transparent;
            color: var(--orange);
            border: 1px solid var(--orange);
            padding: 0.5rem 1.2rem;
            border-radius: 6px;
            font-weight: 600;
            text-decoration: none;
            font-size: 0.9rem;
            transition: all 0.2s;
            cursor: pointer;
        }

        .btn-reorder:hover {
            background: var(--orange);
            color: var(--white);
        }

        .empty-state {
            text-align: center;
            padding: 4rem 2rem;
            background: var(--surface2);
            border-radius: var(--border-radius);
            border: 1px solid var(--border);
        }

        .empty-icon {
            font-size: 4rem;
            margin-bottom: 1rem;
        }

        .empty-title {
            font-size: 1.5rem;
            font-weight: 600;
            margin-bottom: 0.5rem;
            color: var(--white);
        }

        .empty-text {
            color: var(--muted);
            margin-bottom: 2rem;
        }

        .btn-primary {
            background: var(--orange);
            color: var(--white);
            text-decoration: none;
            padding: 0.8rem 2rem;
            border-radius: 8px;
            font-weight: 600;
            transition: background 0.2s;
            display: inline-block;
        }

        .btn-primary:hover {
            background: var(--orange-hover);
        }
    </style>
</head>
<body>

    <!-- Modern Navbar -->
    <nav class="navbar">
        <a href="index.jsp" class="logo-container">
            <span class="logo-icon">🍽️</span>
            <div class="logo-text">Plate<span>Hop</span></div>
        </a>

        <div class="search-container">
            <span class="search-icon">🔍</span>
            <input type="text" placeholder="Search for restaurants, cuisines, or dishes...">
        </div>

        <div class="nav-actions">
            <a href="cart.jsp" class="nav-link">
                🛒 Cart
                <div class="cart-badge"><%= cart != null && cart.getItems() != null ? cart.getItems().size() : 0 %></div>
            </a>
            <a href="#" class="nav-link">🔔</a>
            
            <a href="profile.jsp" title="My Profile" style="display:flex; align-items:center; justify-content:center; width:38px; height:38px; border-radius:50%; background:var(--surface3); color:var(--text); text-decoration:none; margin-left:8px; border: 1px solid var(--border);">
                <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M20 21v-2a4 4 0 00-4-4H8a4 4 0 00-4 4v2"/><circle cx="12" cy="7" r="4"/></svg>
            </a>
        </div>
    </nav>

    <div class="container">
        <div class="page-header">
            <h1 class="page-title">My Orders</h1>
            <% if (orders != null && !orders.isEmpty()) { %>
                <div class="order-count"><%= orders.size() %> orders placed</div>
            <% } %>
        </div>

        <% if (orders == null || orders.isEmpty()) { %>
            <div class="empty-state">
                <div class="empty-icon">🧾</div>
                <h2 class="empty-title">No orders yet</h2>
                <p class="empty-text">Looks like you haven't placed any orders yet. Discover great food around you!</p>
                <a href="index.jsp" class="btn-primary">Explore Restaurants</a>
            </div>
        <% } else { %>
            <div class="orders-list">
                <% 
                    for (Order order : orders) { 
                        Restaurant rest = restaurantService != null ? restaurantService.getRestaurantById(order.getRestaurantId()) : null;
                        String restName = rest != null ? rest.getName() : "Unknown Restaurant";
                        String status = order.getStatus() != null ? order.getStatus() : "Pending";
                %>
                    <div class="order-card status-<%= status %>">
                        <div class="order-info">
                            <div class="order-header">
                                <div class="restaurant-name"><%= restName %></div>
                                <div class="order-id">#ORDER-<%= String.format("%05d", order.getOrderId()) %></div>
                            </div>
                            <div class="order-meta">
                                <span>📅 <%= order.getOrderDate() != null ? sdf.format(order.getOrderDate()) : "Recently" %></span>
                                <span>💳 <%= order.getPaymentMethod() != null ? order.getPaymentMethod() : "Card" %></span>
                            </div>
                        </div>
                        
                        <div class="order-actions">
                            <div class="order-total">₹<%= String.format("%.2f", order.getTotalAmount()) %></div>
                            <div class="status-badge status-<%= status %>"><%= status %></div>
                            <button class="btn-reorder" onclick="window.location.href='Menu?restaurantId=<%= order.getRestaurantId() %>'">Reorder</button>
                        </div>
                    </div>
                <% } %>
            </div>
        <% } %>
    </div>

</body>
</html>
