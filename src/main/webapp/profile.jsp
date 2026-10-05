<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.project.platehop.model.User" %>
<%@ page import="com.project.platehop.model.Order" %>
<%@ page import="com.project.platehop.service.OrderService" %>
<%@ page import="com.project.platehop.util.SpringContextHelper" %>
<%@ page import="java.util.List" %>
<%
    User loggedInUser = (User) session.getAttribute("loggedInUser");
    if (loggedInUser == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    @SuppressWarnings("unchecked")
    List<Order> userOrders = (List<Order>) request.getAttribute("userOrders");
    if (userOrders == null) {
        OrderService orderService = SpringContextHelper.getBean(OrderService.class);
        if (orderService != null) {
            userOrders = orderService.getOrdersByUserId(loggedInUser.getId());
        }
    }
    if (userOrders == null) {
        userOrders = new java.util.ArrayList<>();
    }

    int totalOrders   = userOrders.size();
    double totalSpent = 0;
    int deliveredCount = 0;
    int pendingCount   = 0;
    for (Order o : userOrders) {
        totalSpent += o.getTotalAmount();
        if ("delivered".equalsIgnoreCase(o.getStatus()))   deliveredCount++;
        if ("pending".equalsIgnoreCase(o.getStatus()) ||
            "confirmed".equalsIgnoreCase(o.getStatus()) ||
            "preparing".equalsIgnoreCase(o.getStatus()) ||
            "out_for_delivery".equalsIgnoreCase(o.getStatus())) pendingCount++;
    }

    String userName  = loggedInUser.getUserName()  != null ? loggedInUser.getUserName()  : "User";
    String email     = loggedInUser.getEmail()      != null ? loggedInUser.getEmail()     : "—";
    String role      = loggedInUser.getRole()       != null ? loggedInUser.getRole()      : "Customer";
    String address   = loggedInUser.getAddress()    != null && !loggedInUser.getAddress().trim().isEmpty()
                       ? loggedInUser.getAddress() : "No address saved";

    String initials  = userName.substring(0, 1).toUpperCase();
    if (userName.contains(" ")) {
        String[] parts = userName.trim().split("\\s+");
        if (parts.length > 1) initials = ("" + parts[0].charAt(0) + parts[parts.length-1].charAt(0)).toUpperCase();
    }

    String memberSince = "—";
    if (loggedInUser.getCreatedDate() != null) {
        java.time.LocalDateTime ldt = loggedInUser.getCreatedDate().toLocalDateTime();
        memberSince = ldt.getDayOfMonth() + " "
            + ldt.getMonth().getDisplayName(java.time.format.TextStyle.SHORT, java.util.Locale.ENGLISH)
            + " " + ldt.getYear();
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Account – PlateHop</title>
    <meta name="description" content="Manage your PlateHop account, orders, and saved address.">
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;500;600;700;800;900&display=swap" rel="stylesheet">
    <style>
        *, *::before, *::after { margin: 0; padding: 0; box-sizing: border-box; }

        :root {
            --orange:  #ff5e00;
            --orange2: #e05300;
            --bg:      #0a0a0a;
            --surface: #111111;
            --surface2:#181818;
            --surface3:#222222;
            --white:   #ffffff;
            --text:    #e0e0e0;
            --sub:     #888888;
            --border:  #2a2a2a;
            --font:    'Outfit', sans-serif;
            --radius:  12px;
        }

        body {
            font-family: var(--font);
            background: var(--bg);
            color: var(--text);
            min-height: 100vh;
            -webkit-font-smoothing: antialiased;
        }

        /* ════════════════════════════
           TOP NAVBAR
        ════════════════════════════ */
        .navbar {
            position: sticky; top: 0; z-index: 100;
            background: rgba(10,10,10,0.9); backdrop-filter: blur(20px);
            border-bottom: 1px solid var(--border);
            display: flex; align-items: center;
            height: 56px; padding: 0 24px; gap: 14px;
        }
        .nav-back {
            width: 36px; height: 36px; border-radius: 50%;
            background: var(--surface2);
            display: flex; align-items: center; justify-content: center;
            text-decoration: none; color: var(--text); flex-shrink: 0;
            transition: background .2s;
        }
        .nav-back:hover { background: var(--surface3); }
        .nav-title {
            font-size: 1.05rem; font-weight: 700; color: var(--text);
            flex: 1;
        }
        .nav-brand {
            font-size: 0.85rem; font-weight: 700;
            color: var(--orange); letter-spacing: -0.3px;
        }

        /* ════════════════════════════
           LAYOUT
        ════════════════════════════ */
        .page { 
            max-width: 1440px; 
            margin: 0 auto; 
            padding: 24px; 
        }
        .layout-grid {
            display: grid;
            grid-template-columns: 320px 1fr;
            gap: 24px;
            align-items: start;
        }
        @media (max-width: 1023px) {
            .layout-grid { grid-template-columns: 1fr; }
        }

        .left-col { display: flex; flex-direction: column; gap: 24px; }
        .right-col { display: flex; flex-direction: column; gap: 24px; min-width: 0; }

        /* ════════════════════════════
           LEFT COL: HERO & MENU
        ════════════════════════════ */
        .hero-card {
            height: 240px;
            background: var(--surface2);
            border: 1px solid var(--border);
            border-radius: var(--radius);
            display: flex; flex-direction: column; align-items: center; justify-content: center;
            padding: 20px;
        }
        .avatar-wrap { position: relative; margin-bottom: 16px; }
        .avatar {
            width: 80px; height: 80px; border-radius: 50%;
            background: linear-gradient(135deg, #fc8019, #ff2d55);
            display: flex; align-items: center; justify-content: center;
            font-size: 2rem; font-weight: 800; color: #fff;
            box-shadow: 0 4px 14px rgba(252,128,25,0.4);
        }
        .avatar-edit {
            position: absolute; bottom: 0; right: -4px;
            width: 28px; height: 28px; border-radius: 50%;
            background: var(--surface3); border: 2px solid var(--surface2);
            display: flex; align-items: center; justify-content: center;
            color: var(--sub); cursor: pointer;
        }
        .user-name { font-size: 1.3rem; font-weight: 700; color: #fff; }
        .user-email { font-size: 0.85rem; color: var(--sub); margin-bottom: 12px; margin-top: 2px; }
        .user-role {
            background: rgba(255,94,0,0.1); color: var(--orange);
            padding: 4px 12px; border-radius: 20px; font-size: 0.7rem; font-weight: 700;
            text-transform: uppercase; letter-spacing: 0.5px;
            display: inline-flex; align-items: center; gap: 4px;
        }

        .menu-card {
            background: var(--surface2);
            border: 1px solid var(--border);
            border-radius: var(--radius);
            padding: 12px 0;
            display: flex; flex-direction: column;
        }
        .menu-item {
            display: flex; align-items: center; padding: 14px 20px; gap: 16px;
            text-decoration: none; color: var(--text); border-bottom: 1px solid rgba(255,255,255,0.03);
            transition: background 0.2s;
        }
        .menu-item:last-of-type { border-bottom: none; }
        .menu-item:hover { background: var(--surface3); }
        .menu-icon {
            width: 36px; height: 36px; border-radius: 10px;
            display: flex; align-items: center; justify-content: center; flex-shrink: 0;
        }
        .menu-icon.orange { background: rgba(255,165,0,0.1); color: orange; }
        .menu-icon.green  { background: rgba(27,166,114,0.1); color: #1ba672; }
        .menu-icon.blue   { background: rgba(61,108,244,0.1); color: #3d6cf4; }
        .menu-icon.gray   { background: rgba(255,255,255,0.05); color: #ccc; }
        .menu-icon.red    { background: rgba(224,32,32,0.1); color: #e02020; }
        
        .menu-text { flex: 1; }
        .menu-title { font-size: 0.95rem; font-weight: 600; color: #fff; }
        .menu-sub { font-size: 0.75rem; color: var(--sub); margin-top: 3px; }
        .menu-arrow { color: #555; }
        
        .menu-item.logout .menu-title, .menu-item.logout .menu-sub { color: #e02020; }
        .menu-item.logout .menu-sub { opacity: 0.8; }
        
        .menu-footer {
            padding: 20px 20px 8px;
            font-size: 0.8rem; color: var(--sub);
            border-top: 1px solid var(--border);
            margin-top: 8px;
        }
        .menu-footer span { color: var(--orange); font-weight: 500; }

        /* ════════════════════════════
           RIGHT COL: STATS ROW
        ════════════════════════════ */
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 24px;
        }
        @media (max-width: 768px) { .stats-grid { grid-template-columns: repeat(2, 1fr); } }
        
        .stat-card {
            background: var(--surface2); border: 1px solid var(--border);
            border-radius: var(--radius); height: 100px;
            display: flex; align-items: center; padding: 20px; gap: 16px;
        }
        .stat-icon {
            width: 44px; height: 44px; border-radius: 10px;
            display: flex; align-items: center; justify-content: center; flex-shrink: 0;
        }
        .stat-info { display: flex; flex-direction: column; }
        .stat-val { font-size: 1.5rem; font-weight: 700; color: #fff; line-height: 1.1; }
        .stat-key { font-size: 0.7rem; color: var(--sub); text-transform: uppercase; font-weight: 600; margin-top: 4px; letter-spacing: 0.5px; }

        /* ════════════════════════════
           RIGHT COL: MIDDLE ROW
        ════════════════════════════ */
        .middle-row {
            display: grid;
            grid-template-columns: 55.55% 1fr;
            gap: 24px;
        }
        @media (max-width: 1200px) { .middle-row { grid-template-columns: 1fr; } }
        
        .base-card {
            background: var(--surface2); border: 1px solid var(--border);
            border-radius: var(--radius); padding: 24px;
            display: flex; flex-direction: column;
        }
        .card-header {
            display: flex; justify-content: space-between; align-items: center; margin-bottom: 24px;
        }
        .card-title { font-size: 1.1rem; font-weight: 700; color: #fff; }
        
        /* Account Profile List */
        .account-card { min-height: 320px; height: auto; }
        .profile-list { display: flex; flex-direction: column; gap: 20px; }
        .profile-item { display: flex; align-items: center; gap: 16px; border-bottom: 1px solid rgba(255,255,255,0.03); padding-bottom: 20px; }
        .profile-item:last-child { border-bottom: none; padding-bottom: 0; }
        .p-icon {
            width: 40px; height: 40px; border-radius: 10px; flex-shrink: 0;
            display: flex; align-items: center; justify-content: center; background: var(--surface3);
        }
        .p-text { flex: 1; }
        .p-sub { font-size: 0.75rem; color: var(--sub); margin-bottom: 4px; }
        .p-val { font-size: 0.95rem; font-weight: 600; color: #fff; }
        
        /* Right Stack */
        .right-stack { display: flex; flex-direction: column; gap: 24px; }
        .address-card { min-height: 180px; height: auto; }
        .activity-card { min-height: 140px; height: auto; }
        
        .badge-saved {
            background: rgba(27,166,114,0.15); color: #1ba672;
            padding: 4px 10px; border-radius: 20px; font-size: 0.7rem; font-weight: 700;
        }
        .view-all-btn {
            background: rgba(255,255,255,0.05); color: #ccc;
            padding: 6px 12px; border-radius: 6px; font-size: 0.75rem; font-weight: 600; text-decoration: none;
            transition: background 0.2s;
        }
        .view-all-btn:hover { background: rgba(255,255,255,0.1); }
        
        /* Inner boxes */
        .inner-box {
            background: var(--surface); border: 1px solid rgba(255,255,255,0.05);
            border-radius: 10px; padding: 16px;
            display: flex; align-items: center; gap: 16px;
        }
        .ib-icon {
            width: 40px; height: 40px; border-radius: 50%;
            display: flex; align-items: center; justify-content: center; flex-shrink: 0;
        }
        .ib-text { flex: 1; min-width: 0; }
        .ib-title { font-size: 0.95rem; font-weight: 600; color: #fff; margin-bottom: 4px; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; }
        .ib-desc { font-size: 0.8rem; color: var(--sub); display: flex; align-items: center; gap: 4px; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; }
        .ib-action {
            width: 32px; height: 32px; border-radius: 50%; background: var(--surface3);
            display: flex; align-items: center; justify-content: center; cursor: pointer; flex-shrink: 0; color: #aaa;
        }

        /* ════════════════════════════
           BOTTOM PROMO BANNER
        ════════════════════════════ */
        .promo-banner {
            height: 140px; border-radius: var(--radius);
            background: #1f1105; border: 1px solid #3a1e06;
            display: flex; align-items: center; justify-content: space-between;
            padding: 0 32px 0 0; position: relative; overflow: hidden;
        }
        .promo-bg {
            width: 320px; height: 100%; object-fit: cover;
            mask-image: linear-gradient(to right, rgba(0,0,0,1) 60%, rgba(0,0,0,0) 100%);
            -webkit-mask-image: linear-gradient(to right, rgba(0,0,0,1) 60%, rgba(0,0,0,0) 100%);
        }
        .promo-content { flex: 1; padding-left: 24px; }
        .promo-title { font-size: 1.5rem; font-weight: 700; color: #fff; margin-bottom: 6px; }
        .promo-desc { font-size: 0.95rem; color: #aaa; }
        .promo-btn {
            background: var(--orange); color: #fff; text-decoration: none;
            padding: 12px 24px; border-radius: 8px; font-weight: 600; font-size: 0.95rem;
            display: inline-flex; align-items: center; gap: 8px; transition: 0.2s; white-space: nowrap;
            margin-left: 24px; flex-shrink: 0;
        }
        .promo-btn:hover { background: var(--orange2); }
    </style>
</head>
<body>

<!-- ══ NAVBAR ══ -->
<nav class="navbar">
    <a class="nav-back" href="restaurants" title="Back to restaurants">
        <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round"><path d="M19 12H5M5 12l7 7M5 12l7-7"/></svg>
    </a>
    <span class="nav-title">My Account</span>
    <span class="nav-brand">PlateHop</span>
</nav>

<div class="page">
    <div class="layout-grid">
        
        <!-- ════ LEFT COLUMN ════ -->
        <div class="left-col">
            
            <!-- Hero Card -->
            <div class="hero-card">
                <div class="avatar-wrap">
                    <div class="avatar"><%= initials %></div>
                    <div class="avatar-edit" title="Edit Avatar">
                        <svg width="14" height="14" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" viewBox="0 0 24 24"><path d="M12 20h9"/><path d="M16.5 3.5a2.121 2.121 0 013 3L7 19l-4 1 1-4 12.5-12.5z"/></svg>
                    </div>
                </div>
                <div class="user-name"><%= userName %></div>
                <div class="user-email"><%= email %></div>
                <div class="user-role">
                    <svg width="12" height="12" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" viewBox="0 0 24 24"><path d="M20 21v-2a4 4 0 00-4-4H8a4 4 0 00-4 4v2"/><circle cx="12" cy="7" r="4"/></svg>
                    <%= role %>
                </div>
            </div>

            <!-- Menu Section -->
            <div class="menu-card">
                <a class="menu-item" href="orders.jsp">
                    <div class="menu-icon orange"><svg width="20" height="20" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" viewBox="0 0 24 24"><path d="M6 2L3 6v14a2 2 0 002 2h14a2 2 0 002-2V6l-3-4z"/><line x1="3" y1="6" x2="21" y2="6"/><path d="M16 10a4 4 0 01-8 0"/></svg></div>
                    <div class="menu-text">
                        <div class="menu-title">My Orders</div>
                        <div class="menu-sub">View your complete order history</div>
                    </div>
                    <svg class="menu-arrow" width="16" height="16" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" viewBox="0 0 24 24"><polyline points="9 18 15 12 9 6"/></svg>
                </a>
                
                <a class="menu-item" href="restaurants">
                    <div class="menu-icon green"><svg width="20" height="20" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" viewBox="0 0 24 24"><circle cx="12" cy="12" r="10"/><path d="M12 2a14.5 14.5 0 000 20 14.5 14.5 0 000-20"/><path d="M2 12h20"/></svg></div>
                    <div class="menu-text">
                        <div class="menu-title">Explore Restaurants</div>
                        <div class="menu-sub">Discover food near you</div>
                    </div>
                    <svg class="menu-arrow" width="16" height="16" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" viewBox="0 0 24 24"><polyline points="9 18 15 12 9 6"/></svg>
                </a>

                <a class="menu-item" href="cart.jsp">
                    <div class="menu-icon blue"><svg width="20" height="20" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" viewBox="0 0 24 24"><circle cx="9" cy="21" r="1"/><circle cx="20" cy="21" r="1"/><path d="M1 1h4l2.68 13.39a2 2 0 002 1.61h9.72a2 2 0 002-1.61L23 6H6"/></svg></div>
                    <div class="menu-text">
                        <div class="menu-title">My Cart</div>
                        <div class="menu-sub">Review items in your cart</div>
                    </div>
                    <svg class="menu-arrow" width="16" height="16" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" viewBox="0 0 24 24"><polyline points="9 18 15 12 9 6"/></svg>
                </a>


                <a class="menu-item logout" href="LogoutServlet">
                    <div class="menu-icon red"><svg width="20" height="20" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" viewBox="0 0 24 24"><path d="M9 21H5a2 2 0 01-2-2V5a2 2 0 012-2h4"/><polyline points="16 17 21 12 16 7"/><line x1="21" y1="12" x2="9" y2="12"/></svg></div>
                    <div class="menu-text">
                        <div class="menu-title">Logout</div>
                        <div class="menu-sub">Sign out of your account</div>
                    </div>
                    <svg class="menu-arrow" width="16" height="16" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" viewBox="0 0 24 24"><polyline points="9 18 15 12 9 6"/></svg>
                </a>

                <div class="menu-footer">
                    Logged in as <span><%= email %></span>
                </div>
            </div>

        </div>

        <!-- ════ RIGHT COLUMN ════ -->
        <div class="right-col">
            
            <!-- Stats Grid -->
            <div class="stats-grid">
                <div class="stat-card">
                    <div class="stat-icon orange"><svg width="24" height="24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" viewBox="0 0 24 24"><path d="M6 2L3 6v14a2 2 0 002 2h14a2 2 0 002-2V6l-3-4z"/><line x1="3" y1="6" x2="21" y2="6"/><path d="M16 10a4 4 0 01-8 0"/></svg></div>
                    <div class="stat-info">
                        <div class="stat-val"><%= totalOrders %></div>
                        <div class="stat-key">Orders</div>
                    </div>
                </div>
                <div class="stat-card">
                    <div class="stat-icon green"><svg width="24" height="24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" viewBox="0 0 24 24"><circle cx="7" cy="17" r="2"/><circle cx="17" cy="17" r="2"/><path d="M5 17H3v-3l2-5h9l4 5h3v3h-2"/><path d="M15 12H5"/></svg></div>
                    <div class="stat-info">
                        <div class="stat-val"><%= deliveredCount %></div>
                        <div class="stat-key">Delivered</div>
                    </div>
                </div>
                <div class="stat-card">
                    <div class="stat-icon purple"><svg width="24" height="24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" viewBox="0 0 24 24"><path d="M20 21v-2a4 4 0 00-4-4H8a4 4 0 00-4 4v2"/><circle cx="12" cy="7" r="4"/></svg></div>
                    <div class="stat-info">
                        <div class="stat-val"><%= pendingCount %></div>
                        <div class="stat-key">Active</div>
                    </div>
                </div>
                <div class="stat-card">
                    <div class="stat-icon blue"><svg width="24" height="24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" viewBox="0 0 24 24"><path d="M20 5H4a2 2 0 00-2 2v10a2 2 0 002 2h16a2 2 0 002-2V7a2 2 0 00-2-2z"/><path d="M16 12h-2"/></svg></div>
                    <div class="stat-info">
                        <div class="stat-val">₹<%= String.format("%.0f", totalSpent) %></div>
                        <div class="stat-key">Spent</div>
                    </div>
                </div>
            </div>

            <!-- Middle Row -->
            <div class="middle-row">
                
                <!-- Account Profile -->
                <div class="base-card account-card">
                    <div class="card-header">
                        <div class="card-title">Account Profile</div>
                    </div>
                    <div class="profile-list">
                        <div class="profile-item">
                            <div class="p-icon" style="color:orange;"><svg width="20" height="20" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" viewBox="0 0 24 24"><path d="M20 21v-2a4 4 0 00-4-4H8a4 4 0 00-4 4v2"/><circle cx="12" cy="7" r="4"/></svg></div>
                            <div class="p-text">
                                <div class="p-sub">Full Name</div>
                                <div class="p-val"><%= userName %></div>
                            </div>
                        </div>
                        <div class="profile-item">
                            <div class="p-icon" style="color:#3d6cf4;"><svg width="20" height="20" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" viewBox="0 0 24 24"><path d="M4 4h16c1.1 0 2 .9 2 2v12c0 1.1-.9 2-2 2H4c-1.1 0-2-.9-2-2V6c0-1.1.9-2 2-2z"/><polyline points="22,6 12,13 2,6"/></svg></div>
                            <div class="p-text">
                                <div class="p-sub">Email Address</div>
                                <div class="p-val"><%= email %></div>
                            </div>
                        </div>
                        <div class="profile-item">
                            <div class="p-icon" style="color:#7c4dff;"><svg width="20" height="20" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" viewBox="0 0 24 24"><path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"/></svg></div>
                            <div class="p-text">
                                <div class="p-sub">Account Role</div>
                                <div class="p-val" style="text-transform:lowercase;"><%= role %></div>
                            </div>
                        </div>
                        <div class="profile-item">
                            <div class="p-icon" style="color:#1ba672;"><svg width="20" height="20" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" viewBox="0 0 24 24"><rect x="3" y="4" width="18" height="18" rx="2" ry="2"/><line x1="16" y1="2" x2="16" y2="6"/><line x1="8" y1="2" x2="8" y2="6"/><line x1="3" y1="10" x2="21" y2="10"/></svg></div>
                            <div class="p-text">
                                <div class="p-sub">Member Since</div>
                                <div class="p-val"><%= memberSince %></div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Right Stack (Address & Activity) -->
                <div class="right-stack">
                    
                    <div class="base-card address-card">
                        <div class="card-header">
                            <div class="card-title">Saved Address</div>
                            <% if (!"No address saved".equals(address)) { %>
                                <div class="badge-saved">Saved</div>
                            <% } %>
                        </div>
                        <div class="inner-box">
                            <div class="ib-icon" style="background:rgba(255,165,0,0.1); color:orange;"><svg width="20" height="20" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" viewBox="0 0 24 24"><path d="M21 10c0 7-9 13-9 13S3 17 3 10a9 9 0 0118 0z"/><circle cx="12" cy="10" r="3"/></svg></div>
                            <div class="ib-text">
                                <div class="ib-title">Delivery Address</div>
                                <div class="ib-desc">📍 <%= "No address saved".equals(address) ? "No address saved yet." : address %></div>
                            </div>
                            <div class="ib-action"><svg width="14" height="14" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" viewBox="0 0 24 24"><path d="M12 20h9"/><path d="M16.5 3.5a2.121 2.121 0 013 3L7 19l-4 1 1-4 12.5-12.5z"/></svg></div>
                        </div>
                    </div>

                    <div class="base-card activity-card">
                        <div class="card-header">
                            <div class="card-title">Recent Activity</div>
                            <% if (totalOrders > 0) { %><a href="orders.jsp" class="view-all-btn">View All</a><% } %>
                        </div>
                        <div class="inner-box">
                            <% if (totalOrders == 0) { %>
                                <div class="ib-icon" style="background:rgba(255,255,255,0.05); color:#aaa;"><svg width="20" height="20" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" viewBox="0 0 24 24"><path d="M14 2H6a2 2 0 00-2 2v16a2 2 0 002 2h12a2 2 0 002-2V8z"/><polyline points="14 2 14 8 20 8"/><line x1="16" y1="13" x2="8" y2="13"/><line x1="16" y1="17" x2="8" y2="17"/><polyline points="10 9 9 9 8 9"/></svg></div>
                                <div class="ib-text">
                                    <div class="ib-title">Recent Orders</div>
                                    <div class="ib-desc">You haven't placed any orders yet.</div>
                                </div>
                            <% } else { 
                                Order o = userOrders.get(totalOrders - 1);
                                String dateStr = o.getOrderDate() != null ? o.getOrderDate().toLocalDateTime().toLocalDate().toString() : "—";
                            %>
                                <div class="ib-icon" style="background:rgba(27,166,114,0.1); color:#1ba672;"><svg width="20" height="20" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" viewBox="0 0 24 24"><path d="M14 2H6a2 2 0 00-2 2v16a2 2 0 002 2h12a2 2 0 002-2V8z"/><polyline points="14 2 14 8 20 8"/><line x1="16" y1="13" x2="8" y2="13"/><line x1="16" y1="17" x2="8" y2="17"/><polyline points="10 9 9 9 8 9"/></svg></div>
                                <div class="ib-text">
                                    <div class="ib-title">Order #<%= o.getOrderId() %></div>
                                    <div class="ib-desc" style="text-transform:capitalize;"><%= dateStr %> • ₹<%= String.format("%.0f", o.getTotalAmount()) %> • <%= o.getStatus() %></div>
                                </div>
                            <% } %>
                        </div>
                    </div>

                </div>
            </div>

            <!-- Bottom Banner -->
            <div class="promo-banner">
                <img class="promo-bg" src="https://images.unsplash.com/photo-1504674900247-0877df9cc836?auto=format&fit=crop&q=80&w=400" alt="Food">
                <div class="promo-content">
                    <div class="promo-title">Hungry for more?</div>
                    <div class="promo-desc">Explore top restaurants and delicious meals near you.</div>
                </div>
                <a href="restaurants" class="promo-btn">Explore Restaurants <svg width="18" height="18" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round" viewBox="0 0 24 24"><path d="M9 18l6-6-6-6"/></svg></a>
            </div>

        </div>
    </div>
</div>

</body>
</html>

