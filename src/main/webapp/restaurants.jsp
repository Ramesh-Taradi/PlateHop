<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="com.project.platehop.model.Restaurant" %>
<%@ page import="com.project.platehop.model.User" %>
<%
    User loggedInUser = (User) session.getAttribute("loggedInUser");
    List<Restaurant> allRestaurants = (List<Restaurant>) request.getAttribute("allRestaurants");
    if (allRestaurants == null || allRestaurants.isEmpty()) {
        try {
            org.springframework.web.context.WebApplicationContext ctx = 
                org.springframework.web.context.support.WebApplicationContextUtils.getWebApplicationContext(application);
            if (ctx != null) {
                com.project.platehop.service.RestaurantService rs = ctx.getBean(com.project.platehop.service.RestaurantService.class);
                allRestaurants = rs.getActiveRestaurants();
            }
        } catch (Exception ignored) {}
    }
%>
<!DOCTYPE html>
<html lang="en"> 
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Restaurants - Platehop</title>
    <meta name="description" content="Discover top restaurants near you on Platehop. Order food online with fast delivery.">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700;800;900&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        *, *::before, *::after { margin: 0; padding: 0; box-sizing: border-box; }
        :root {
            --bg: #08080a; --surface: #0e0e11; --surface2: #131317; --surface3: #1a1a20;
            --orange: #ff5e00; --orange2: #ff8a3d; --orange-glow: rgba(255,94,0,0.12);
            --white: #fff; --text: #d9d9e0; --muted: #7a7a86; --dim: #4a4a55;
            --border: rgba(255,255,255,0.07);
            --border-hi: rgba(255,138,61,0.32);
            --grad: linear-gradient(135deg, #ff5e00 0%, #ff8a3d 100%);
            --shadow-lg: 0 32px 70px -24px rgba(0,0,0,0.85);
            --shadow-orange: 0 18px 40px -18px rgba(255,94,0,0.55);
            --font: 'Poppins', sans-serif;
        }
        html { scroll-behavior: smooth; }
        body {
            background: var(--bg); font-family: var(--font); color: var(--text);
            -webkit-font-smoothing: antialiased; overflow-x: hidden;
            min-height: 100vh; display: flex; flex-direction: column;
        }
        ::selection { background: var(--orange); color: #fff; }

        @keyframes rise { from { opacity: 0; transform: translateY(24px); } to { opacity: 1; transform: none; } }
        @keyframes fadeIn { from { opacity: 0; } to { opacity: 1; } }
        @keyframes floatGlow { 0%,100% { transform: translate3d(0,0,0) scale(1); } 50% { transform: translate3d(0,-24px,0) scale(1.06); } }
        .anim { opacity: 0; animation: rise 0.75s cubic-bezier(.16,1,.3,1) forwards; }

        /* NAVBAR */
        .navbar {
            position: fixed; top: 0; left: 0; right: 0; z-index: 999;
            display: flex; align-items: center; justify-content: space-between;
            padding: 1.5rem 4rem;
            background: rgba(8,8,10,0.85);
            -webkit-backdrop-filter: blur(22px) saturate(160%);
            backdrop-filter: blur(22px) saturate(160%);
            border-bottom: 1px solid var(--border);
            animation: fadeIn 0.6s ease both;
        }
        .logo { font-size: 1.6rem; font-weight: 900; color: #fff; text-decoration: none; letter-spacing: -0.5px; display: flex; align-items: center; gap: 0.5rem; }
        .img-brand-logo { height: 40px; width: auto; filter: invert(1) hue-rotate(180deg) brightness(1.2); mix-blend-mode: screen; }
        .logo span { color: var(--orange); }
        .nav-links { display: flex; align-items: center; gap: 0.4rem; }
        .nav-links a {
            text-decoration: none; color: var(--muted); font-weight: 600; font-size: 0.93rem;
            padding: 0.5rem 1rem; border-radius: 50px; transition: color 0.25s, background 0.25s;
        }
        .nav-links a:hover { color: #fff; background: rgba(255,255,255,0.05); }
        .nav-links a.active { color: #fff; background: rgba(255,94,0,0.14); box-shadow: inset 0 0 0 1px rgba(255,94,0,0.25); }
        .nav-actions { display: flex; align-items: center; gap: 0.85rem; }
        .btn-login {
            background: transparent;
            border: 1px solid rgba(255,255,255,0.16);
            color: var(--white);
            padding: 0.55rem 1.3rem;
            border-radius: 50px;
            text-decoration: none;
            font-weight: 600;
            font-size: 0.92rem;
            transition: all 0.3s cubic-bezier(.16,1,.3,1);
        }
        .btn-login:hover { border-color: var(--orange); background: rgba(255,94,0,0.1); transform: translateY(-2px); }
        .btn-signup {
            background: var(--grad);
            border: 1px solid transparent;
            color: var(--white);
            padding: 0.55rem 1.4rem;
            border-radius: 50px;
            text-decoration: none;
            font-weight: 700;
            font-size: 0.92rem;
            box-shadow: var(--shadow-orange);
            transition: all 0.3s cubic-bezier(.16,1,.3,1);
        }
        .btn-signup:hover { transform: translateY(-2px); filter: brightness(1.08); }
        .cart-icon {
            position: relative; color: var(--white); font-size: 1.1rem; text-decoration: none;
            width: 42px; height: 42px; border-radius: 50%;
            display: inline-flex; align-items: center; justify-content: center;
            background: rgba(255,255,255,0.05); border: 1px solid var(--border);
            transition: all 0.3s cubic-bezier(.16,1,.3,1);
        }
        .cart-icon:hover { background: rgba(255,94,0,0.16); border-color: var(--border-hi); transform: translateY(-2px); }
        .cart-badge {
            position: absolute; top: -4px; right: -4px; background: var(--grad); color: white;
            font-size: 0.65rem; font-weight: 800; width: 19px; height: 19px; border-radius: 50%;
            display: flex; align-items: center; justify-content: center;
            box-shadow: 0 0 0 2px var(--bg);
        }
        .profile-menu { position: relative; display: flex; align-items: center; gap: 0.5rem; cursor: pointer; text-decoration: none; color: var(--white); }
        .profile-avatar {
            width: 35px; height: 35px; border-radius: 50%; background: var(--grad);
            display: flex; align-items: center; justify-content: center; font-weight: 700; font-size: 1.1rem; color: white;
        }
        .dropdown-content {
            display: none; position: absolute; top: 48px; right: 0; background: rgba(14,14,17,0.96);
            -webkit-backdrop-filter: blur(18px); backdrop-filter: blur(18px);
            min-width: 170px; box-shadow: var(--shadow-lg); border-radius: 14px;
            border: 1px solid var(--border); overflow: hidden; z-index: 1000; flex-direction: column;
        }
        .dropdown-content a { color: var(--white); padding: 12px 16px; text-decoration: none; display: flex; align-items: center; gap: 10px; font-size: 0.9rem; transition: background 0.2s; }
        .dropdown-content a:hover { background: rgba(255, 94, 0, 0.2); color: var(--orange2); }
        .profile-menu:hover .dropdown-content { display: flex; }

        /* PAGE HEADER */
        .page-header {
            padding: 8rem 4rem 2rem; background: var(--bg);
            position: relative; overflow: hidden; width: 100%;
        }
        .page-header::before {
            content: ''; position: absolute; top: -20%; left: -10%; right: -10%; bottom: -20%;
            background: radial-gradient(ellipse at 18% 55%, rgba(255,94,0,0.16) 0%, transparent 55%),
                        radial-gradient(ellipse at 82% 25%, rgba(255,138,61,0.09) 0%, transparent 45%);
            animation: floatGlow 16s ease-in-out infinite;
        }
        .page-header::after {
            content: ''; position: absolute; left: 0; right: 0; bottom: 0; height: 1px;
            background: linear-gradient(90deg, transparent, rgba(255,255,255,0.09), transparent);
        }
        .page-header-inner { position: relative; z-index: 1; width: 100%; max-width: 100%; }
        .page-tag {
            display: inline-flex; align-items: center; gap: 0.45rem;
            background: var(--orange-glow);
            border: 1px solid rgba(255,94,0,0.24); color: var(--orange2);
            padding: 0.42rem 1.05rem; border-radius: 50px; font-size: 0.74rem;
            font-weight: 800; text-transform: uppercase; letter-spacing: 1.6px; margin-bottom: 1.25rem;
            -webkit-backdrop-filter: blur(10px); backdrop-filter: blur(10px);
        }
        .page-header h1 {
            font-size: clamp(2.6rem, 6vw, 4.4rem); font-weight: 900;
            color: #fff; letter-spacing: -0.045em; line-height: 0.98; margin-bottom: 1.1rem;
        }
        .page-header h1 span {
            background: var(--grad); -webkit-background-clip: text; background-clip: text;
            -webkit-text-fill-color: transparent; color: var(--orange);
        }
        .page-header p { color: var(--muted); font-size: 1.06rem; max-width: 520px; line-height: 1.65; }

        /* SEARCH BAR */
        .search-wrap { margin-top: 2.2rem; position: relative; max-width: 540px; }
        .search-wrap input {
            width: 100%; padding: 1.15rem 1.3rem 1.15rem 3.4rem;
            background: rgba(255,255,255,0.035); border: 1.5px solid var(--border);
            border-radius: 16px; color: #fff; font-size: 0.98rem; font-family: var(--font);
            font-weight: 500; outline: none;
            -webkit-backdrop-filter: blur(12px); backdrop-filter: blur(12px);
            transition: border-color 0.3s, box-shadow 0.3s, background 0.3s;
        }
        .search-wrap input::placeholder { color: var(--dim); font-weight: 400; }
        .search-wrap input:focus {
            border-color: rgba(255,94,0,0.55); background: rgba(255,255,255,0.055);
            box-shadow: 0 0 0 4px rgba(255,94,0,0.12), var(--shadow-lg);
        }
        .search-wrap .s-icon {
            position: absolute; left: 1.2rem; top: 50%; transform: translateY(-50%);
            color: var(--dim); font-size: 1.05rem; pointer-events: none; transition: color 0.3s;
        }
        .search-wrap input:focus ~ .s-icon, .search-wrap:focus-within .s-icon { color: var(--orange2); }

        /* GRID */
        .grid-section { width: 100%; max-width: 100%; padding: 2rem 4rem 4rem; }
        .results-count {
            color: var(--muted); font-size: 0.9rem; margin-bottom: 2rem;
            display: flex; align-items: center; gap: 0.6rem; font-weight: 500;
        }
        .results-count::after { content: ''; flex: 1; height: 1px; background: linear-gradient(90deg, var(--border), transparent); }
        .results-count strong { color: var(--white); font-weight: 800; }
        .rest-grid { display: grid; grid-template-columns: repeat(auto-fill, minmax(280px, 1fr)); gap: 2rem 1.6rem; width: 100%; }

        /* SWIGGY STYLE CARD */
        .rest-card {
            background: transparent; border: none; border-radius: 24px;
            padding: 12px; margin: -12px;
            overflow: visible; text-decoration: none; display: block; color: inherit;
            position: relative; translate: 0 0;
            transition: translate 0.35s cubic-bezier(0.2, 0.8, 0.2, 1), background 0.3s ease;
            animation: rise 0.7s cubic-bezier(.16,1,.3,1) both;
        }
        .rest-card:nth-child(1){animation-delay:.04s} .rest-card:nth-child(2){animation-delay:.09s}
        .rest-card:nth-child(3){animation-delay:.14s} .rest-card:nth-child(4){animation-delay:.19s}
        .rest-card:nth-child(5){animation-delay:.24s} .rest-card:nth-child(6){animation-delay:.29s}
        .rest-card:nth-child(n+7){animation-delay:.34s}

        .rest-card:hover { 
            translate: 0 -8px; 
            background: rgba(255, 255, 255, 0.04);
        }
        .rest-card:hover .card-img-wrap { box-shadow: 0 12px 24px rgba(0,0,0,0.5); }
        .rest-card:hover .card-img-wrap img { transform: scale(1.08); }

        .card-img-wrap { 
            position: relative; overflow: hidden; height: 180px; 
            border-radius: 20px; margin-bottom: 0.8rem;
            box-shadow: 0 4px 10px rgba(0,0,0,0.3);
        }
        .card-img-wrap img {
            width: 100%; height: 100%; object-fit: cover;
            transition: transform 0.5s cubic-bezier(0.2, 0.8, 0.2, 1);
        }
        .card-img-overlay {
            position: absolute; inset: 0;
            background: linear-gradient(to top, rgba(0,0,0,0.95) 0%, rgba(0,0,0,0) 50%);
        }
        .card-offer {
            position: absolute; bottom: 0.8rem; left: 1rem; right: 1rem;
            color: #fff; font-size: 1.25rem; font-weight: 900;
            text-transform: uppercase; letter-spacing: -0.5px;
            text-shadow: 0 2px 4px rgba(0,0,0,0.5);
            line-height: 1.1;
        }

        .card-body { padding: 0 0.5rem; }
        .card-title {
            font-size: 1.15rem; font-weight: 800; color: #fff;
            margin-bottom: 0.2rem; white-space: nowrap; overflow: hidden; text-overflow: ellipsis;
            letter-spacing: -0.3px;
        }
        .card-meta-row { 
            display: flex; align-items: center; gap: 0.4rem; 
            color: var(--text); font-size: 0.95rem; font-weight: 700; 
            margin-bottom: 0.2rem; 
        }
        .card-meta-row svg { flex-shrink: 0; }
        
        .card-desc { 
            color: var(--muted); font-size: 0.95rem; font-weight: 500;
            white-space: nowrap; overflow: hidden; text-overflow: ellipsis; 
            margin-bottom: 0.1rem; 
        }
        .card-address { 
            color: var(--muted); font-size: 0.95rem; font-weight: 500; 
        }
        .btn-view-menu {
            margin-top: 1rem; padding: 0.6rem 0; width: 100%; text-align: center;
            background: rgba(255, 94, 0, 0.1); color: var(--orange); font-weight: 700;
            border-radius: 8px; border: 1px solid rgba(255, 94, 0, 0.3);
            font-size: 0.9rem; transition: all 0.2s;
        }
        .rest-card:hover .btn-view-menu {
            background: var(--orange); color: #fff; border-color: var(--orange);
        }

        /* EMPTY STATE */
        .empty-state {
            text-align: center; padding: 5rem 2rem; grid-column: 1 / -1;
            background: linear-gradient(180deg, var(--surface2), transparent);
            border: 1px dashed var(--border); border-radius: 24px;
        }
        .empty-icon { font-size: 3.4rem; margin-bottom: 1.1rem; opacity: 0.8; }
        .empty-title { color: #fff; font-size: 1.5rem; font-weight: 800; margin-bottom: 0.5rem; letter-spacing: -0.02em; }
        .empty-desc { color: var(--muted); font-size: 0.95rem; }

        /* FOOTER */
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

        @media (max-width: 1024px) {
            .navbar { padding: 1rem 2rem; }
            .page-header { padding: 8.5rem 2rem 3rem; }
            .grid-section { padding: 2.5rem 2rem; }
            .site-footer { padding: 3.5rem 2rem 1.8rem; }
            .footer-top { grid-template-columns: 1fr 1fr; }
        }
        @media (max-width: 768px) {
            html, body { overflow-x: hidden; width: 100%; max-width: 100vw; }
            .navbar { padding: 0.85rem 1rem; width: 100%; }
            .page-header { padding: 6.5rem 1rem 2rem; }
            .grid-section { padding: 1.5rem 1rem; }
            .rest-grid { grid-template-columns: 1fr; gap: 1.2rem; }
            .nav-links a.active, .nav-actions a:not(.cart-icon):not(.profile-menu) { display: none; }
            .nav-links a { padding: 0.4rem 0.85rem; font-size: 0.84rem; background: rgba(255,255,255,0.06); }
            .search-wrap { margin-top: 1.4rem; }
            .footer-top { grid-template-columns: 1fr; gap: 1.8rem; }
            .footer-bottom { flex-direction: column; gap: 0.8rem; text-align: center; }
            .site-footer { padding: 2.5rem 1rem 1.5rem; }
        }
        @media (prefers-reduced-motion: reduce) {
            *, *::before, *::after { animation: none !important; transition-duration: 0.01ms !important; }
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
            <a href="restaurants" class="active">Restaurants</a>
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
                    <div class="cart-badge">3</div>
                </a>
                <a href="profile.jsp" title="My Profile" style="display:flex; align-items:center; justify-content:center; width:42px; height:42px; border-radius:50%; background:rgba(255,255,255,0.05); color:#fff; text-decoration:none; margin-left:2px; border:1px solid rgba(255,255,255,0.07); transition:all .3s;">
                    <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M20 21v-2a4 4 0 00-4-4H8a4 4 0 00-4 4v2"/><circle cx="12" cy="7" r="4"/></svg>
                </a>
            <% } %>
        </div>
    </nav>

    <div class="page-header">
        <div class="page-header-inner">
            <div class="page-tag anim" style="animation-delay:.05s">🍽 All Restaurants</div>
            <h1 class="anim" style="animation-delay:.13s">Discover <span>Top Spots</span></h1>
            <p class="anim" style="animation-delay:.21s">Find the best food in your area and get it delivered fast.</p>
            <div class="search-wrap anim" style="animation-delay:.29s">
                <input type="text" id="search-input" placeholder="Search restaurants, cuisines..." oninput="filterCards(this.value)">
                <span class="s-icon">🔍</span>
            </div>
        </div>
    </div>

    <div class="grid-section">
        <div class="results-count" id="results-count">
            Showing <strong id="count-num">0</strong> restaurants
        </div>
        <div class="rest-grid" id="rest-grid">
            <%
                int count = 0;
                if (allRestaurants != null && !allRestaurants.isEmpty()) {
                    for (Restaurant r : allRestaurants) {
                        if (r.getIsActive() == 1) {
                            count++;
            %>
            <a href="Menu?restaurantId=<%= r.getRestaurantId() %>" class="rest-card" data-name="<%= r.getName().toLowerCase() %>" data-cuisine="<%= r.getCuisineType().toLowerCase() %>">
                <div class="card-img-wrap">
                    <img src="<%= (r.getImagePath() != null && !r.getImagePath().isEmpty()) ? r.getImagePath() : "https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?auto=format&fit=crop&w=600&q=80" %>" alt="<%= r.getName() %>" loading="lazy">
                    <div class="card-img-overlay"></div>
                    <div class="card-offer">50% OFF UPTO ₹100</div>
                </div>
                <div class="card-body">
                    <div class="card-title"><%= r.getName() %></div>
                    <div class="card-meta-row">
                        <svg width="18" height="18" viewBox="0 0 20 20" fill="none" xmlns="http://www.w3.org/2000/svg">
                          <circle cx="10" cy="10" r="10" fill="#24963f"/>
                          <path d="M10 2.5L12.183 7.393L17.5 8.006L13.536 11.607L14.634 16.83L10 14.167L5.366 16.83L6.464 11.607L2.5 8.006L7.817 7.393L10 2.5Z" fill="white"/>
                        </svg>
                        <span><%= r.getRating() %> • <%= r.getDeliveryTime() %> mins</span>
                    </div>
                    <div class="card-desc"><%= r.getCuisineType() %></div>
                    <div class="card-address"><%= r.getAddress() %></div>
                    <div class="btn-view-menu">View Menu</div>
                </div>
            </a>
            <%
                        }
                    }
                }
            %>
            <% if (allRestaurants == null || allRestaurants.isEmpty() || count == 0) { %>
            <div class="empty-state">
                <div class="empty-icon">🍽</div>
                <div class="empty-title">No restaurants found</div>
                <div class="empty-desc">Check back later for amazing food options.</div>
            </div>
            <% } %>
        </div>
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
                <form class="newsletter-form" onsubmit="event.preventDefault(); alert('Subscribed successfully!'); this.reset();">
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

    <script>
        const totalCount = <%= count %>;
        document.getElementById('count-num').textContent = totalCount;

        function filterCards(query) {
            const cards = document.querySelectorAll('.rest-card');
            let visible = 0;
            query = query.toLowerCase().trim();
            cards.forEach(card => {
                const name = card.dataset.name || '';
                const cuisine = card.dataset.cuisine || '';
                if (!query || name.includes(query) || cuisine.includes(query)) {
                    card.style.display = 'block'; visible++;
                } else {
                    card.style.display = 'none';
                }
            });
            document.getElementById('count-num').textContent = visible;
        }
    </script>
</body>
</html>
