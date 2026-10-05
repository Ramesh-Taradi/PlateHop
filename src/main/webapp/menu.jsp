<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="com.project.platehop.model.Menu" %>
<%@ page import="com.project.platehop.model.Restaurant" %>
<%@ page import="com.project.platehop.model.User" %>
<%
    User loggedInUser = (User) session.getAttribute("loggedInUser");
    List<Menu> menuList = (List<Menu>) request.getAttribute("menuList");
    Restaurant restaurant = (Restaurant) request.getAttribute("restaurant");
    if (restaurant == null) {
        String restIdParam = request.getParameter("restaurantId");
        if (restIdParam != null && !restIdParam.trim().isEmpty()) {
            try {
                int rId = Integer.parseInt(restIdParam.trim());
                org.springframework.web.context.WebApplicationContext ctx = 
                    org.springframework.web.context.support.WebApplicationContextUtils.getWebApplicationContext(application);
                if (ctx != null) {
                    com.project.platehop.service.RestaurantService rs = ctx.getBean(com.project.platehop.service.RestaurantService.class);
                    com.project.platehop.service.MenuService ms = ctx.getBean(com.project.platehop.service.MenuService.class);
                    restaurant = rs.getRestaurantById(rId);
                    menuList = ms.getMenusByRestaurant(rId);
                }
            } catch (Exception ignored) {}
        }
    }
    if (restaurant == null) {
        response.sendRedirect("restaurants");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><%= restaurant.getName() %> - Menu | PlateHop</title>
    <meta name="description" content="Browse the full menu of <%= restaurant.getName() %> on PlateHop and order your favourites.">
    <!-- Google Fonts: Poppins & Font Awesome -->
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700;800;900&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        *, *::before, *::after { margin: 0; padding: 0; box-sizing: border-box; }
        :root {
            --bg: #0a0a0a;
            --surface: #111115;
            --surface2: #16161c;
            --surface3: #1e1e24;
            --orange: #ff5e00;
            --orange-hover: #e05300;
            --orange-glow: rgba(255,94,0,0.14);
            --white: #ffffff;
            --text: #e0e0e0;
            --muted: #888888;
            --border: rgba(255,255,255,0.08);
            --font: 'Poppins', sans-serif;
        }
        body {
            background: var(--bg);
            font-family: var(--font);
            color: var(--text);
            min-height: 100vh;
            overflow-x: hidden;
            display: flex;
            flex-direction: column;
        }

        /* ── NAVBAR ── */
        .navbar {
            position: fixed;
            top: 0; left: 0; right: 0;
            z-index: 999;
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding: 1.5rem 4rem;
            background: rgba(10, 10, 10, 0.92);
            backdrop-filter: blur(20px);
            -webkit-backdrop-filter: blur(20px);
            border-bottom: 1px solid var(--border);
        }
        .logo {
            display: flex;
            align-items: center;
            gap: 0.8rem;
            text-decoration: none;
            color: var(--white);
            font-size: 1.8rem;
            font-weight: 800;
        }
        .logo span { color: var(--orange); }
        .nav-links {
            display: flex;
            gap: 2rem;
            align-items: center;
        }
        .nav-links a {
            text-decoration: none;
            color: #ddd;
            font-weight: 500;
            font-size: 0.95rem;
            transition: color 0.3s;
        }
        .nav-links a:hover { color: var(--white); }
        .nav-links a.active {
            background: rgba(255, 94, 0, 0.2);
            color: var(--orange);
            padding: 0.5rem 1.2rem;
            border-radius: 50px;
        }

        .nav-actions {
            display: flex;
            align-items: center;
            gap: 1.5rem;
        }
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
        .btn-signup:hover { background: var(--orange-hover); }
        .cart-icon {
            position: relative;
            color: var(--white);
            font-size: 1.25rem;
            text-decoration: none;
            display: flex;
            align-items: center;
        }
        .cart-badge {
            position: absolute;
            top: -8px; right: -10px;
            background: var(--orange);
            color: white;
            font-size: 0.65rem;
            font-weight: bold;
            width: 18px; height: 18px;
            border-radius: 50%;
            display: flex; align-items: center; justify-content: center;
        }

        /* ── RESTAURANT HEADER BANNER ── */
        .rest-banner {
            padding: 7.5rem 4rem 2rem;
            width: 100%;
            background: linear-gradient(180deg, #131215 0%, #0a0a0a 100%);
            border-bottom: 1px solid var(--border);
        }
        .back-link {
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            color: #aaa;
            text-decoration: none;
            font-size: 0.9rem;
            font-weight: 600;
            margin-bottom: 1.2rem;
            transition: color 0.2s, transform 0.2s;
        }
        .back-link:hover {
            color: var(--orange);
            transform: translateX(-4px);
        }
        .rest-banner-inner {
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 2rem;
        }
        .rest-banner-info {
            flex: 1;
        }
        .rest-tag {
            display: inline-block;
            background: rgba(255, 94, 0, 0.15);
            border: 1px solid rgba(255, 94, 0, 0.35);
            color: var(--orange);
            font-size: 0.78rem;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 1px;
            padding: 0.35rem 0.9rem;
            border-radius: 50px;
            margin-bottom: 0.8rem;
        }
        .rest-title {
            font-size: clamp(2.2rem, 4vw, 3.2rem);
            font-weight: 900;
            color: #fff;
            letter-spacing: -1px;
            line-height: 1.1;
            margin-bottom: 0.5rem;
        }
        .rest-address {
            color: #888;
            font-size: 0.95rem;
            margin-bottom: 1.2rem;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }
        .rest-badges-row {
            display: flex;
            gap: 0.8rem;
            flex-wrap: wrap;
        }
        .rest-badge {
            display: inline-flex;
            align-items: center;
            gap: 0.45rem;
            background: rgba(255, 255, 255, 0.05);
            border: 1px solid rgba(255, 255, 255, 0.1);
            padding: 0.45rem 1rem;
            border-radius: 50px;
            color: #fff;
            font-size: 0.82rem;
            font-weight: 600;
        }
        .rest-badge.star {
            color: #ffb703;
            background: rgba(255, 183, 3, 0.1);
            border-color: rgba(255, 183, 3, 0.3);
        }
        .rest-badge.offer {
            color: var(--orange);
            background: rgba(255, 94, 0, 0.15);
            border-color: rgba(255, 94, 0, 0.35);
        }
        .rest-banner-img {
            width: 220px;
            height: 145px;
            border-radius: 18px;
            overflow: hidden;
            flex-shrink: 0;
            border: 1px solid rgba(255, 255, 255, 0.1);
            box-shadow: 0 16px 36px rgba(0, 0, 0, 0.6);
        }
        .rest-banner-img img {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }

        /* ── MENU LAYOUT ── */
        .menu-layout {
            display: flex;
            gap: 2.5rem;
            width: 100%;
            padding: 2rem 4rem 4rem;
            margin: 0;
            flex: 1;
        }

        /* ── SIDEBAR ── */
        .sidebar {
            width: 280px;
            flex-shrink: 0;
            background: var(--surface);
            border-radius: 20px;
            padding: 1.8rem;
            height: fit-content;
            border: 1px solid var(--border);
            position: sticky;
            top: 6.5rem;
        }
        .sidebar-title {
            font-size: 1.05rem;
            font-weight: 800;
            color: #fff;
            margin-bottom: 1rem;
            letter-spacing: -0.3px;
        }
        .cat-list {
            display: flex;
            flex-direction: column;
            gap: 0.4rem;
        }
        .cat-item {
            display: flex;
            align-items: center;
            gap: 0.8rem;
            width: 100%;
            padding: 0.75rem 1rem;
            background: transparent;
            border: none;
            color: #aaa;
            font-size: 0.92rem;
            font-weight: 600;
            text-align: left;
            border-radius: 12px;
            cursor: pointer;
            transition: all 0.2s;
            font-family: var(--font);
        }
        .cat-item:hover {
            background: rgba(255, 255, 255, 0.05);
            color: #fff;
        }
        .cat-item.active {
            background: var(--orange);
            color: #fff;
            box-shadow: 0 4px 14px rgba(255, 94, 0, 0.35);
        }
        .cat-item i {
            font-size: 1.05rem;
            width: 20px;
            text-align: center;
        }
        .filter-section {
            margin-bottom: 1.5rem;
        }
        .filter-label {
            display: block;
            font-size: 0.85rem;
            font-weight: 600;
            color: var(--muted);
            margin-bottom: 0.8rem;
        }
        .range-slider {
            width: 100%;
            -webkit-appearance: none;
            appearance: none;
            height: 5px;
            border-radius: 3px;
            background: #252530;
            outline: none;
            margin-bottom: 0.8rem;
        }
        .range-slider::-webkit-slider-thumb {
            -webkit-appearance: none;
            appearance: none;
            width: 18px;
            height: 18px;
            border-radius: 50%;
            background: var(--orange);
            cursor: pointer;
            border: 2px solid #fff;
            box-shadow: 0 0 8px rgba(255, 94, 0, 0.5);
        }
        .range-labels {
            display: flex;
            justify-content: space-between;
            color: var(--text);
            font-size: 0.85rem;
            font-weight: 600;
        }
        .sort-select {
            width: 100%;
            background: var(--surface2);
            border: 1px solid var(--border);
            color: #fff;
            padding: 0.75rem 1rem;
            border-radius: 10px;
            font-size: 0.88rem;
            font-family: var(--font);
            outline: none;
            cursor: pointer;
        }
        .btn-clear {
            width: 100%;
            background: transparent;
            border: 1px solid var(--orange);
            color: var(--orange);
            padding: 0.75rem;
            border-radius: 50px;
            font-size: 0.88rem;
            font-weight: 700;
            cursor: pointer;
            transition: all 0.2s;
            font-family: var(--font);
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 0.5rem;
        }
        .btn-clear:hover {
            background: var(--orange);
            color: #fff;
        }

        /* ── MAIN CONTENT ── */
        .main-content {
            flex: 1;
            min-width: 0;
        }
        .main-header {
            display: flex;
            justify-content: space-between;
            align-items: flex-end;
            margin-bottom: 1.5rem;
            border-bottom: 1px solid var(--border);
            padding-bottom: 1.2rem;
        }
        .page-title {
            font-size: 1.85rem;
            font-weight: 800;
            color: #fff;
            margin-bottom: 0.25rem;
            letter-spacing: -0.5px;
        }
        .item-count {
            color: var(--muted);
            font-size: 0.88rem;
            font-weight: 500;
        }
        .header-actions {
            display: flex;
            align-items: center;
            gap: 1.2rem;
        }
        .sort-label {
            color: var(--muted);
            font-size: 0.85rem;
        }
        .header-sort {
            background: var(--surface);
            border: 1px solid var(--border);
            color: #fff;
            padding: 0.5rem 1.8rem 0.5rem 1rem;
            border-radius: 8px;
            font-size: 0.85rem;
            font-family: var(--font);
            cursor: pointer;
            outline: none;
        }

        /* ── MENU GRID ── */
        .menu-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
            gap: 1.8rem;
            width: 100%;
        }

        /* ── MENU CARD ── */
        .menu-card {
            background: var(--surface);
            border-radius: 18px;
            overflow: hidden;
            border: 1px solid var(--border);
            transition: all 0.3s cubic-bezier(0.2,0.8,0.2,1);
            display: flex;
            flex-direction: column;
            height: 100%;
        }
        .menu-card:hover {
            border-color: rgba(255, 94, 0, 0.35);
            box-shadow: 0 14px 30px rgba(0,0,0,0.6), 0 0 16px rgba(255,94,0,0.12);
            transform: translateY(-5px);
        }
        .card-img-wrap {
            position: relative;
            height: 175px;
            width: 100%;
            background: #18181e;
            overflow: hidden;
        }
        .card-img-wrap img {
            width: 100%;
            height: 100%;
            object-fit: cover;
            transition: transform 0.5s ease;
        }
        .menu-card:hover .card-img-wrap img {
            transform: scale(1.08);
        }
        .btn-heart {
            position: absolute;
            top: 10px;
            right: 10px;
            background: rgba(0,0,0,0.55);
            backdrop-filter: blur(8px);
            border: 1px solid rgba(255,255,255,0.2);
            width: 32px;
            height: 32px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            color: #fff;
            font-size: 0.95rem;
            cursor: pointer;
            transition: all 0.2s;
        }
        .btn-heart:hover, .btn-heart.active {
            background: var(--orange);
            border-color: var(--orange);
            color: #fff;
        }

        .card-body {
            padding: 1.2rem;
            display: flex;
            flex-direction: column;
            flex: 1;
        }
        .card-cat-badge {
            color: var(--orange);
            font-size: 0.7rem;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            margin-bottom: 0.4rem;
            background: rgba(255, 94, 0, 0.12);
            padding: 0.2rem 0.6rem;
            border-radius: 50px;
            width: max-content;
        }
        .card-name {
            font-size: 1.15rem;
            font-weight: 700;
            color: #fff;
            margin-bottom: 0.25rem;
            letter-spacing: -0.3px;
        }
        .card-price {
            font-size: 1.15rem;
            font-weight: 800;
            color: #fff;
            margin-bottom: 0.6rem;
        }
        .card-desc {
            color: #777;
            font-size: 0.82rem;
            line-height: 1.45;
            margin-bottom: 1.2rem;
            flex: 1;
        }

        .card-footer {
            display: flex;
            align-items: center;
            justify-content: space-between;
            margin-top: auto;
            padding-top: 0.8rem;
            border-top: 1px solid rgba(255, 255, 255, 0.05);
        }
        .add-form {
            display: flex;
            align-items: center;
            justify-content: space-between;
            width: 100%;
            gap: 0.8rem;
            margin: 0;
        }
        .qty-controls {
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }
        .btn-qty {
            background: transparent;
            border: 1px solid rgba(255, 255, 255, 0.15);
            color: #fff;
            width: 28px;
            height: 28px;
            border-radius: 50%;
            font-size: 1rem;
            cursor: pointer;
            display: flex;
            align-items: center;
            justify-content: center;
            transition: all 0.2s;
        }
        .btn-qty:hover {
            border-color: var(--orange);
            color: var(--orange);
        }
        .qty-input {
            width: 24px;
            text-align: center;
            background: transparent;
            border: none;
            color: #fff;
            font-size: 0.95rem;
            font-weight: 700;
            font-family: var(--font);
            outline: none;
        }
        .btn-add {
            background: var(--orange);
            color: #fff;
            border: none;
            padding: 0.5rem 1.2rem;
            border-radius: 50px;
            font-size: 0.85rem;
            font-weight: 700;
            cursor: pointer;
            transition: all 0.25s;
            display: inline-flex;
            align-items: center;
            gap: 0.35rem;
        }
        .btn-add:hover {
            background: var(--orange-hover);
            box-shadow: 0 4px 14px rgba(255, 94, 0, 0.4);
            transform: scale(1.03);
        }
        .btn-add.oos {
            background: #252530;
            color: #666;
            cursor: not-allowed;
            box-shadow: none;
            transform: none;
        }

        /* ── FOOTER ── */
        .site-footer {
            background: #060608;
            border-top: 1px solid rgba(255, 255, 255, 0.08);
            padding: 4.5rem 4rem 2rem;
            width: 100%;
            margin-top: auto;
        }
        .footer-top {
            display: grid;
            grid-template-columns: 1.5fr 1fr 1fr 1fr 1.6fr;
            gap: 3rem;
            width: 100%;
            margin-bottom: 2.5rem;
        }
        .footer-brand .f-logo {
            display: inline-flex;
            align-items: center;
            gap: 0.6rem;
            text-decoration: none;
            color: #fff;
            font-size: 1.45rem;
            font-weight: 900;
            margin-bottom: 0.9rem;
        }
        .footer-brand .f-logo span { color: var(--orange); }
        .f-tagline {
            color: #888;
            font-size: 0.84rem;
            line-height: 1.5;
            margin-bottom: 1.2rem;
            max-width: 260px;
        }
        .f-socials { display: flex; gap: 0.6rem; }
        .f-social-btn {
            width: 34px; height: 34px; border-radius: 50%;
            background: rgba(255, 255, 255, 0.05);
            border: 1px solid rgba(255, 255, 255, 0.1);
            color: #aaa; display: flex; align-items: center; justify-content: center;
            text-decoration: none; font-size: 0.85rem; transition: all 0.25s;
        }
        .f-social-btn:hover { background: var(--orange); border-color: var(--orange); color: #fff; transform: translateY(-2px); }
        .footer-col h5 { color: #fff; font-size: 0.95rem; font-weight: 700; margin-bottom: 1rem; }
        .footer-links { list-style: none; display: flex; flex-direction: column; gap: 0.6rem; }
        .footer-links a { color: #888; text-decoration: none; font-size: 0.84rem; transition: color 0.2s, transform 0.2s; display: inline-block; }
        .footer-links a:hover { color: var(--orange); transform: translateX(3px); }
        .newsletter-desc { color: #888; font-size: 0.82rem; line-height: 1.4; margin-bottom: 0.9rem; }
        .newsletter-form { display: flex; position: relative; max-width: 300px; }
        .newsletter-input {
            width: 100%; padding: 0.75rem 3rem 0.75rem 1rem;
            background: rgba(20, 20, 25, 0.9); border: 1px solid rgba(255, 255, 255, 0.12);
            border-radius: 50px; color: #fff; font-size: 0.82rem; outline: none;
        }
        .newsletter-input:focus { border-color: var(--orange); }
        .newsletter-btn {
            position: absolute; right: 4px; top: 4px; bottom: 4px;
            width: 32px; height: 32px; border-radius: 50%;
            background: var(--orange); color: #fff; border: none;
            display: flex; align-items: center; justify-content: center; cursor: pointer;
        }
        .footer-bottom {
            border-top: 1px solid rgba(255, 255, 255, 0.05);
            padding-top: 1.5rem; display: flex; justify-content: space-between; align-items: center;
            width: 100%; font-size: 0.82rem; color: #666;
        }
        .footer-bottom-links { display: flex; gap: 1.5rem; }
        .footer-bottom-links a { color: #666; text-decoration: none; }
        .footer-bottom-links a:hover { color: #aaa; }

        /* ── TOAST ── */
        .toast {
            position: fixed; bottom: 2rem; right: 2rem; z-index: 9999;
            background: #1a1a22; border: 1px solid rgba(255, 94, 0, 0.4);
            color: #fff; padding: 0.8rem 1.4rem; border-radius: 12px;
            font-size: 0.88rem; font-weight: 600; display: none;
            align-items: center; gap: 0.6rem; box-shadow: 0 10px 30px rgba(0,0,0,0.5);
            animation: slideInRight 0.3s ease;
        }
        .toast.show { display: flex; }
        @keyframes slideInRight { from { opacity: 0; transform: translateX(40px); } to { opacity: 1; transform: translateX(0); } }

        @media (max-width: 1100px) {
            .navbar { padding: 1.2rem 2rem; }
            .rest-banner { padding: 6.5rem 2rem 1.5rem; }
            .menu-layout { padding: 1.5rem 2rem 3rem; gap: 1.5rem; }
            .sidebar { width: 240px; }
            .site-footer { padding: 3rem 2rem 1.8rem; }
            .footer-top { grid-template-columns: 1fr 1fr; }
        }
        @media (max-width: 768px) {
            .navbar { padding: 1rem 1.2rem; }
            .rest-banner { padding: 6rem 1.2rem 1.5rem; }
            .rest-banner-inner { flex-direction: column; align-items: flex-start; }
            .rest-banner-img { width: 100%; height: 180px; }
            .menu-layout { flex-direction: column; padding: 1rem 1.2rem 2.5rem; }
            .sidebar { width: 100%; position: static; }
            .menu-grid { grid-template-columns: 1fr; }
            .nav-links a:not(.active), .nav-actions a:not(.cart-icon):not(.profile-menu) { display: none; }
            .footer-top { grid-template-columns: 1fr; }
            .footer-bottom { flex-direction: column; gap: 0.8rem; text-align: center; }
            .site-footer { padding: 2.5rem 1.2rem 1.5rem; }
        }
    </style>
</head>
<body>
    <!-- NAVBAR -->
    <nav class="navbar">
        <a href="index.jsp" class="logo">
            <svg width="35" height="45" viewBox="0 0 50 50" fill="none" xmlns="http://www.w3.org/2000/svg">
                <path d="M25 0 C12 0 4 9 4 22 C4 34 25 42 25 42 C25 42 46 34 46 22 C46 9 38 0 25 0 Z" fill="var(--orange)"/>
                <path d="M16 10 V17 C16 18.5 17 20 18.5 21 V29 H20.5 V21 C22 20 23 18.5 23 17 V10 H21.5 V15 H20.5 V10 H19.5 V15 H18.5 V10 H17.5 V15 H16 Z" fill="#060608"/>
                <path d="M31 10 C28 10 26 12 26 16 C26 19.5 28.5 21 31 21 C33.5 21 36 19.5 36 16 C36 12 34 10 31 10 Z M30 21 V29 H32 V21 Z" fill="#060608"/>
                <rect x="2" y="44" width="46" height="2" rx="1" fill="var(--white)"/>
                <path d="M 5 48 Q 20 56 40 46 C 30 52 15 50 8 46 Z" fill="var(--white)"/>
            </svg> <div>Plate<span>Hop</span></div>
        </a>

        <div class="nav-links">
            <a href="index.jsp">Home</a>
            <a href="restaurants" class="active">Restaurants</a>
            <a href="restaurants">Categories</a>
            <a href="index.jsp#offers">Offers</a>
            <a href="index.jsp#reviews">Reviews</a>
        </div>

        <div class="nav-actions">
            <% if(loggedInUser == null){ %>
                <a href="login.jsp" class="btn-login">Login</a>
                <a href="register.jsp" class="btn-signup">Sign Up</a>
                <a href="cart.jsp" class="cart-icon" style="margin-left: 0.5rem;" title="Cart">
                    <i class="fa-solid fa-cart-shopping"></i>
                </a>
            <% } else { %>
                <a href="cart.jsp" class="cart-icon" title="Cart">
                    <i class="fa-solid fa-cart-shopping"></i>
                    <div class="cart-badge">3</div>
                </a>
                <a href="profile.jsp" title="My Profile" style="display:flex; align-items:center; justify-content:center; width:38px; height:38px; border-radius:50%; background:#f2f2f7; color:#1c1c1e; text-decoration:none; margin-left:8px; border: 1px solid #e8e8e8;">
                    <i class="fa-solid fa-user"></i>
                </a>
            <% } %>
        </div>
    </nav>

    <!-- RESTAURANT HEADER BANNER -->
    <div class="rest-banner">
        <a href="restaurants" class="back-link"><i class="fa-solid fa-arrow-left"></i> Back to Restaurants</a>
        <div class="rest-banner-inner">
            <div class="rest-banner-info">
                <span class="rest-tag"><%= restaurant.getCuisineType() %></span>
                <h1 class="rest-title"><%= restaurant.getName() %></h1>
                <p class="rest-address"><i class="fa-solid fa-location-dot" style="color:var(--orange);"></i> <%= restaurant.getAddress() %></p>
                <div class="rest-badges-row">
                    <span class="rest-badge star"><i class="fa-solid fa-star"></i> <%= restaurant.getRating() %> Rating</span>
                    <span class="rest-badge"><i class="fa-regular fa-clock"></i> <%= restaurant.getDeliveryTime() %> mins delivery</span>
                    <span class="rest-badge offer"><i class="fa-solid fa-tag"></i> 50% OFF UPTO ₹100</span>
                </div>
            </div>
            <% if(restaurant.getImagePath() != null && !restaurant.getImagePath().isEmpty()){ %>
            <div class="rest-banner-img">
                <img src="<%= restaurant.getImagePath() %>" alt="<%= restaurant.getName() %>">
            </div>
            <% } %>
        </div>
    </div>

    <!-- MENU LAYOUT -->
    <div class="menu-layout">
        <!-- SIDEBAR -->
        <aside class="sidebar">
            <h3 class="sidebar-title">Categories</h3>
            <div class="cat-list">
                <button class="cat-item active" onclick="filterCategory('all', this)">
                    <i class="fa-solid fa-border-all"></i> All Items
                </button>
                <button class="cat-item" onclick="filterCategory('mains', this)">
                    <i class="fa-solid fa-utensils"></i> Mains
                </button>
                <button class="cat-item" onclick="filterCategory('starters', this)">
                    <i class="fa-solid fa-bowl-food"></i> Starters
                </button>
                <button class="cat-item" onclick="filterCategory('sides', this)">
                    <i class="fa-solid fa-french-fries" style="font-size:0.9rem;">🍟</i> Sides
                </button>
                <button class="cat-item" onclick="filterCategory('desserts', this)">
                    <i class="fa-solid fa-cake-candles"></i> Desserts
                </button>
                <button class="cat-item" onclick="filterCategory('beverages', this)">
                    <i class="fa-solid fa-mug-hot"></i> Beverages
                </button>
            </div>

            <h3 class="sidebar-title" style="margin-top: 2rem;">Filters</h3>
            <div class="filter-section">
                <label class="filter-label">Price Range</label>
                <input type="range" class="range-slider" min="0" max="1000" value="1000" oninput="updatePriceFilter(this.value)">
                <div class="range-labels">
                    <span>₹0</span>
                    <span id="maxPriceVal">₹1000</span>
                </div>
            </div>
            
            <div class="filter-section">
                <label class="filter-label">Sort By</label>
                <select class="sort-select" onchange="handleSortChange(this.value)">
                    <option value="Popularity">Popularity</option>
                    <option value="Price: Low to High">Price: Low to High</option>
                    <option value="Price: High to Low">Price: High to Low</option>
                </select>
            </div>

            <button class="btn-clear" onclick="clearFilters()"><i class="fa-solid fa-rotate-left"></i> Clear Filters</button>
        </aside>

        <!-- MAIN CONTENT -->
        <main class="main-content">
            <div class="main-header">
                <div>
                    <h2 class="page-title">All Items</h2>
                    <% 
                        int itemCount = 0;
                        if(menuList != null) itemCount = menuList.size();
                    %>
                    <p class="item-count">Showing <%= itemCount %> items</p>
                </div>
                <div class="header-actions">
                    <span class="sort-label">Sort by:</span>
                    <select class="header-sort" onchange="handleSortChange(this.value)">
                        <option value="Popularity">Popularity</option>
                        <option value="Price: Low to High">Price: Low to High</option>
                        <option value="Price: High to Low">Price: High to Low</option>
                    </select>
                </div>
            </div>

            <div class="menu-grid" id="menu-grid">
                <%
                    if (menuList != null && !menuList.isEmpty()) {
                        for (Menu m : menuList) {
                            String cat = (m.getCategory() != null && !m.getCategory().isEmpty()) ? m.getCategory() : "Mains";
                            String defaultImg = "https://images.unsplash.com/photo-1567620905732-2d1ec7ab7445?auto=format&fit=crop&w=500&q=80";
                            String imgUrl = (m.getImagePath() != null && !m.getImagePath().trim().isEmpty()) ? m.getImagePath() : defaultImg;
                %>
                <div class="menu-card <%= m.getIsAvailable() == 0 ? "unavailable" : "" %>" data-category="<%= cat.toLowerCase() %>" data-price="<%= m.getPrice() %>">
                    <div class="card-img-wrap">
                        <img src="<%= imgUrl %>" alt="<%= m.getItemName() %>" loading="lazy">
                        <button class="btn-heart" onclick="toggleFav(this)"><i class="fa-regular fa-heart"></i></button>
                    </div>
                    <div class="card-body">
                        <span class="card-cat-badge"><%= cat %></span>
                        <h3 class="card-name"><%= m.getItemName() %></h3>
                        <div class="card-price">&#8377;<%= m.getPrice() %></div>
                        <p class="card-desc"><%= (m.getDescription() != null && !m.getDescription().isEmpty()) ? m.getDescription() : "Freshly prepared with authentic ingredients and rich flavours." %></p>
                        
                        <div class="card-footer">
                            <% if (m.getIsAvailable() == 1) { %>
                                <form action="CartServlet" method="post" class="add-form" onsubmit="handleAddToCart(event, this)">
                                    <input type="hidden" name="action" value="add">
                                    <input type="hidden" name="menuId" value="<%= m.getMenuId() %>">
                                    <input type="hidden" name="restaurantId" value="<%= restaurant.getRestaurantId() %>">
                                    <div class="qty-controls">
                                        <button type="button" class="btn-qty" onclick="changeQty(this, -1)">-</button>
                                        <input type="text" name="quantity" value="1" class="qty-input" readonly>
                                        <button type="button" class="btn-qty" onclick="changeQty(this, 1)">+</button>
                                    </div>
                                    <button type="submit" class="btn-add">Add <i class="fa-solid fa-plus"></i></button>
                                </form>
                            <% } else { %>
                                <span class="btn-add oos">Sold Out</span>
                            <% } %>
                        </div>
                    </div>
                </div>
                <%
                        }
                    } else {
                %>
                <div style="grid-column: 1/-1; text-align: center; padding: 4rem 2rem; color: #888;">
                    <i class="fa-solid fa-bowl-food" style="font-size: 3rem; color: var(--orange); margin-bottom: 1rem; display: block;"></i>
                    <h3 style="color: #fff; font-size: 1.3rem; margin-bottom: 0.5rem;">No items found</h3>
                    <p>There are no dishes listed for this restaurant yet.</p>
                </div>
                <% } %>
            </div>
        </main>
    </div>

    <!-- FOOTER -->
    <footer class="site-footer">
        <div class="footer-top">
            <div class="footer-brand">
                <a href="index.jsp" class="f-logo">
                    <svg width="30" height="38" viewBox="0 0 50 50" fill="none" xmlns="http://www.w3.org/2000/svg">
                        <path d="M25 0 C12 0 4 9 4 22 C4 34 25 42 25 42 C25 42 46 34 46 22 C46 9 38 0 25 0 Z" fill="var(--orange)"/>
                        <path d="M16 10 V17 C16 18.5 17 20 18.5 21 V29 H20.5 V21 C22 20 23 18.5 23 17 V10 H21.5 V15 H20.5 V10 H19.5 V15 H18.5 V10 H17.5 V15 H16 Z" fill="#060608"/>
                        <path d="M31 10 C28 10 26 12 26 16 C26 19.5 28.5 21 31 21 C33.5 21 36 19.5 36 16 C36 12 34 10 31 10 Z M30 21 V29 H32 V21 Z" fill="#060608"/>
                    </svg>
                    Plate<span>Hop</span>
                </a>
                <p class="f-tagline">Good food. Great mood. Delivered to your doorstep.</p>
                <div class="f-socials">
                    <a href="#" class="f-social-btn" title="Instagram"><i class="fa-brands fa-instagram"></i></a>
                    <a href="#" class="f-social-btn" title="Facebook"><i class="fa-brands fa-facebook-f"></i></a>
                    <a href="#" class="f-social-btn" title="Twitter"><i class="fa-brands fa-twitter"></i></a>
                    <a href="#" class="f-social-btn" title="YouTube"><i class="fa-brands fa-youtube"></i></a>
                </div>
            </div>

            <div class="footer-col">
                <h5>Quick Links</h5>
                <ul class="footer-links">
                    <li><a href="index.jsp">Home</a></li>
                    <li><a href="restaurants">Menu</a></li>
                    <li><a href="restaurants">Categories</a></li>
                    <li><a href="index.jsp#offers">Offers</a></li>
                </ul>
            </div>

            <div class="footer-col">
                <h5>Company</h5>
                <ul class="footer-links">
                    <li><a href="#">About Us</a></li>
                    <li><a href="#">Careers</a></li>
                    <li><a href="index.jsp#reviews">Reviews</a></li>
                    <li><a href="#">Contact</a></li>
                </ul>
            </div>

            <div class="footer-col">
                <h5>Support</h5>
                <ul class="footer-links">
                    <li><a href="#">Help Center</a></li>
                    <li><a href="#">FAQs</a></li>
                    <li><a href="#">Privacy Policy</a></li>
                    <li><a href="#">Terms & Conditions</a></li>
                </ul>
            </div>

            <div class="footer-col">
                <h5>Subscribe to our Newsletter</h5>
                <p class="newsletter-desc">Get the latest offers and updates.</p>
                <form class="newsletter-form" onsubmit="event.preventDefault(); showToast('Subscribed successfully!'); this.reset();">
                    <input type="email" placeholder="Enter your email" class="newsletter-input" required>
                    <button type="submit" class="newsletter-btn"><i class="fa-solid fa-arrow-right"></i></button>
                </form>
            </div>
        </div>

        <div class="footer-bottom">
            <div>&copy; 2026 PlateHop. All rights reserved.</div>
            <div class="footer-bottom-links">
                <a href="#">Privacy</a>
                <a href="#">Terms</a>
                <a href="#">Sitemap</a>
            </div>
        </div>
    </footer>

    <!-- Toast Notification -->
    <div id="toast" class="toast">
        <i class="fa-solid fa-circle-check" style="color:var(--orange);"></i>
        <span id="toast-msg">Item added to cart!</span>
    </div>

    <!-- Scripts -->
    <script>
        function toggleFav(btn) {
            btn.classList.toggle('active');
            const icon = btn.querySelector('i');
            if (btn.classList.contains('active')) {
                icon.classList.remove('fa-regular');
                icon.classList.add('fa-solid');
                showToast('Saved to your favorites!');
            } else {
                icon.classList.remove('fa-solid');
                icon.classList.add('fa-regular');
            }
        }

        function changeQty(btn, delta) {
            const input = btn.parentElement.querySelector('.qty-input');
            let val = parseInt(input.value) || 1;
            val += delta;
            if (val < 1) val = 1;
            input.value = val;
        }

        function handleAddToCart(e, form) {
            e.preventDefault();
            const formData = new URLSearchParams(new FormData(form));

            fetch('CartServlet', {
                method: 'POST',
                headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                body: formData
            }).then(() => {
                showToast('Added to cart successfully!');
                const badges = document.querySelectorAll('.cart-badge');
                badges.forEach(b => {
                    let count = parseInt(b.textContent) || 0;
                    b.textContent = count + 1;
                });
            }).catch(() => {
                showToast('Added to cart successfully!');
            });
        }

        function showToast(msg) {
            const toast = document.getElementById('toast');
            document.getElementById('toast-msg').textContent = msg;
            toast.classList.add('show');
            setTimeout(() => {
                toast.classList.remove('show');
            }, 2600);
        }

        let currentCategory = 'all';
        let maxPrice = 1000;
        let currentSort = 'Popularity';

        function filterCategory(cat, btn) {
            document.querySelectorAll('.cat-item').forEach(el => el.classList.remove('active'));
            btn.classList.add('active');
            currentCategory = cat.toLowerCase();
            document.querySelector('.page-title').textContent = btn.innerText.trim();
            applyFilters();
        }

        function updatePriceFilter(value) {
            document.getElementById('maxPriceVal').textContent = '₹' + value;
            maxPrice = parseFloat(value);
            applyFilters();
        }

        function handleSortChange(value) {
            currentSort = value;
            document.querySelectorAll('.sort-select, .header-sort').forEach(select => {
                select.value = value;
            });
            applyFilters();
        }

        function clearFilters() {
            document.querySelectorAll('.cat-item').forEach(el => el.classList.remove('active'));
            document.querySelector('.cat-item').classList.add('active');
            currentCategory = 'all';
            document.querySelector('.page-title').textContent = 'All Items';
            
            const slider = document.querySelector('.range-slider');
            slider.value = 1000;
            maxPrice = 1000;
            document.getElementById('maxPriceVal').textContent = '₹1000';
            
            currentSort = 'Popularity';
            document.querySelectorAll('.sort-select, .header-sort').forEach(select => {
                select.value = 'Popularity';
            });
            
            applyFilters();
        }

        function applyFilters() {
            const grid = document.getElementById('menu-grid');
            let cards = Array.from(document.querySelectorAll('.menu-card'));
            let visibleCount = 0;
            
            cards.forEach(card => {
                const cat = card.dataset.category || '';
                const price = parseFloat(card.dataset.price) || 0;
                
                let matchesCat = (currentCategory === 'all' || cat.includes(currentCategory));
                let matchesPrice = (price <= maxPrice);
                
                if (matchesCat && matchesPrice) {
                    card.style.display = 'flex';
                    visibleCount++;
                } else {
                    card.style.display = 'none';
                }
            });
            
            document.querySelector('.item-count').textContent = 'Showing ' + visibleCount + ' items';

            if (currentSort === 'Price: Low to High') {
                cards.sort((a, b) => parseFloat(a.dataset.price) - parseFloat(b.dataset.price));
            } else if (currentSort === 'Price: High to Low') {
                cards.sort((a, b) => parseFloat(b.dataset.price) - parseFloat(a.dataset.price));
            }
            
            cards.forEach(card => {
                grid.appendChild(card);
            });
        }
    </script>
</body>
</html>
