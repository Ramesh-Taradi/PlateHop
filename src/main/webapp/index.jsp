<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.project.platehop.model.User" %>
<%
    User loggedInUser = (User) session.getAttribute("loggedInUser");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Home - Platehop</title>
    <!-- Google Fonts: Poppins & Anton -->
    <link href="https://fonts.googleapis.com/css2?family=Anton&family=Poppins:wght@300;400;500;600;700;800;900&display=swap" rel="stylesheet">
    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        *, *::before, *::after { margin: 0; padding: 0; box-sizing: border-box; }
        :root {
            --orange: #ff5e00;
            --orange-hover: #e05300;
            --white: #ffffff;
            --dark: #0a0a0a;
            --font: 'Poppins', sans-serif;
            --font-hero: 'Anton', sans-serif;
        }
        
        body {
            font-family: var(--font);
            color: var(--white);
            background: var(--dark);
            min-height: 100vh;
            overflow-x: hidden;
            display: flex;
            flex-direction: column;
            position: relative;
        }

        /* ── BACKGROUND VIDEO & OVERLAY (HALF-HEIGHT HERO ONLY) ── */
        .hero-video-wrap {
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 52vh;
            min-height: 480px;
            max-height: 580px;
            overflow: hidden;
            z-index: 0;
            pointer-events: none;
        }
        .hero-video {
            width: 100%;
            height: 100%;
            object-fit: cover;
            object-position: center;
            display: block;
        }
        .hero-overlay {
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: linear-gradient(180deg, 
                rgba(10, 10, 10, 0.6) 0%, 
                rgba(10, 10, 10, 0.45) 45%, 
                rgba(10, 10, 10, 0.85) 80%, 
                #0a0a0a 100%);
            z-index: 1;
            pointer-events: none;
        }

        /* ── NAVBAR ── */
        .navbar {
            position: relative;
            z-index: 100;
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding: 1.5rem 4rem;
            width: 100%;
        }

        .logo { 
            display: flex; align-items: center; gap: 0.8rem;
            text-decoration: none; color: var(--white);
            font-size: 1.8rem; font-weight: 800;
        }
        .logo span { color: var(--orange); }
        .logo i { color: var(--orange); font-size: 1.8rem; }

        .nav-links {
            display: flex; gap: 2rem;
            align-items: center;
        }
        .nav-links a {
            text-decoration: none; color: #ddd;
            font-weight: 500; font-size: 0.95rem;
            transition: color 0.3s;
        }
        .nav-links a:hover { color: var(--white); }
        .nav-links a.active {
            background: rgba(255, 94, 0, 0.2);
            color: var(--orange);
            padding: 0.5rem 1.2rem;
            border-radius: 50px;
        }

        /* ── NAVBAR ACTIONS ── */
        .nav-actions {
            display: flex; align-items: center; gap: 1.5rem;
        }
        .search-bar {
            display: flex; align-items: center;
            background: rgba(20, 20, 20, 0.7);
            border: 1px solid rgba(255, 255, 255, 0.1);
            border-radius: 50px;
            padding: 0.5rem 1rem;
            width: 250px;
        }
        .search-bar i { color: #888; margin-right: 0.5rem; }
        .search-bar input {
            background: transparent; border: none; outline: none;
            color: var(--white); width: 100%; font-family: var(--font); font-size: 0.9rem;
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
        .btn-login:hover {
            background: rgba(255, 94, 0, 0.1);
        }
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
        .btn-signup:hover {
            background: var(--orange-hover);
            border-color: var(--orange-hover);
        }
        
        .cart-icon {
            position: relative; color: var(--white); font-size: 1.2rem;
            text-decoration: none;
        }
        .cart-badge {
            position: absolute; top: -8px; right: -10px;
            background: var(--orange); color: white;
            font-size: 0.65rem; font-weight: bold;
            width: 18px; height: 18px; border-radius: 50%;
            display: flex; align-items: center; justify-content: center;
        }

        /* Profile Dropdown */
        .profile-menu {
            position: relative;
            display: flex; align-items: center; gap: 0.5rem; cursor: pointer;
            text-decoration: none; color: var(--white);
        }
        .profile-avatar {
            width: 35px; height: 35px; border-radius: 50%;
            background: var(--orange); display: flex; align-items: center; justify-content: center;
            font-weight: 700; font-size: 1.1rem; color: white;
        }
        .dropdown-content {
            display: none;
            position: absolute;
            top: 45px;
            right: 0;
            background: rgba(15, 15, 15, 0.95);
            min-width: 160px;
            box-shadow: 0 8px 16px rgba(0,0,0,0.4);
            border-radius: 12px;
            border: 1px solid rgba(255, 255, 255, 0.1);
            overflow: hidden;
            z-index: 1000;
            flex-direction: column;
        }
        .dropdown-content a {
            color: var(--white);
            padding: 12px 16px;
            text-decoration: none;
            display: flex;
            align-items: center;
            gap: 10px;
            font-size: 0.9rem;
            transition: background 0.2s;
        }
        .dropdown-content a:hover {
            background: rgba(255, 94, 0, 0.2);
            color: var(--orange);
        }
        .profile-menu:hover .dropdown-content {
            display: flex;
        }

        /* ── HERO SECTION ── */
        .hero {
            position: relative;
            z-index: 2;
            flex: 1;
            display: flex; flex-direction: column;
            justify-content: center;
            padding: 0 4rem;
            margin-top: 4rem;
            max-width: 800px;
        }

        .hot-badge {
            display: inline-flex; align-items: center; gap: 0.5rem;
            background: rgba(255, 94, 0, 0.15);
            border: 1px solid rgba(255, 94, 0, 0.3);
            color: var(--orange);
            padding: 0.4rem 1rem; border-radius: 50px;
            font-size: 0.8rem; font-weight: 600; letter-spacing: 1px;
            margin-bottom: 1.5rem; width: fit-content;
        }

        .hero-title {
            font-family: var(--font-hero);
            font-size: 6rem;
            line-height: 1;
            text-transform: uppercase;
            letter-spacing: 2px;
            margin-bottom: 1.5rem;
            text-shadow: 0 10px 30px rgba(0,0,0,0.8);
        }
        .hero-title .highlight { color: var(--orange); }

        .hero-desc {
            font-size: 1.1rem; color: #ccc;
            max-width: 500px; line-height: 1.6; margin-bottom: 2.5rem;
        }

        .hero-btns { display: flex; gap: 1rem; }
        .btn-primary {
            background: linear-gradient(90deg, #ff6b00, #ff5000);
            color: var(--white); text-decoration: none;
            padding: 1rem 2rem; border-radius: 50px;
            font-weight: 600; font-size: 1rem;
            display: flex; align-items: center; gap: 0.5rem;
            transition: transform 0.3s, box-shadow 0.3s;
        }
        .btn-primary:hover { transform: translateY(-2px); box-shadow: 0 10px 20px rgba(255, 94, 0, 0.4); }
        
        .btn-outline {
            background: rgba(10, 10, 10, 0.6);
            border: 1px solid rgba(255, 94, 0, 0.5);
            color: var(--white); text-decoration: none;
            padding: 1rem 2rem; border-radius: 50px;
            font-weight: 600; font-size: 1rem;
            display: flex; align-items: center; gap: 0.5rem;
            transition: background 0.3s;
        }
        .btn-outline:hover { background: rgba(255, 94, 0, 0.1); }

        /* ── CATEGORIES BAR ── */
        .categories-bar {
            position: relative;
            z-index: 2;
            margin: 2.5rem 4rem 1.5rem;
            background: rgba(15, 15, 15, 0.65);
            backdrop-filter: blur(20px); -webkit-backdrop-filter: blur(20px);
            border: 1px solid rgba(255, 255, 255, 0.06);
            border-radius: 24px;
            padding: 1.5rem 3.5rem;
            display: flex; justify-content: space-between; align-items: center;
        }

        .category-item {
            display: flex; flex-direction: column; align-items: center; gap: 0.6rem;
            text-decoration: none; color: var(--white);
            transition: transform 0.3s;
        }
        .category-item:hover { transform: translateY(-3px); }
        .cat-img-wrap {
            width: 72px; height: 72px;
            border-radius: 50%;
            padding: 3px;
            background: transparent;
            border: 2px solid transparent;
            transition: border-color 0.3s;
        }
        .category-item:hover .cat-img-wrap { border-color: var(--orange); box-shadow: 0 0 12px rgba(255,94,0,0.3); }
        .cat-img-wrap img { width: 100%; height: 100%; border-radius: 50%; object-fit: cover; }
        
        .cat-name { font-weight: 600; font-size: 0.95rem; }
        .cat-count { font-size: 0.78rem; color: var(--orange); }

        .view-all {
            display: flex; flex-direction: column; align-items: center; justify-content: center;
            width: 88px; height: 88px;
            background: rgba(25, 25, 25, 0.8);
            border: 1px solid rgba(255, 255, 255, 0.1);
            border-radius: 18px;
            text-decoration: none; color: var(--white);
            transition: all 0.3s;
        }
        .view-all i { font-size: 1.6rem; color: var(--orange); margin-bottom: 0.4rem; }
        .view-all span { font-size: 0.82rem; font-weight: 600; text-align: center; }
        .view-all:hover { border-color: var(--orange); background: rgba(255,94,0,0.1); }

        /* ── BOTTOM FEATURES ── */
        .features-row {
            position: relative;
            z-index: 2;
            display: flex; justify-content: space-between;
            padding: 0.5rem 4.5rem 2rem;
            width: 100%;
        }
        .feature-box {
            display: flex; align-items: center; gap: 0.9rem;
        }
        .feat-icon {
            width: 48px; height: 48px;
            border-radius: 50%; border: 1px solid rgba(255,94,0,0.4);
            display: flex; align-items: center; justify-content: center;
            color: var(--orange); font-size: 1.15rem;
        }
        .feat-text strong { display: block; font-size: 1.05rem; margin-bottom: 0.15rem; }
        .feat-text span { font-size: 0.78rem; color: #888; }
        
        .feat-divider { width: 1px; background: rgba(255,255,255,0.1); height: 44px; }

        @media (max-width: 1200px) {
            .hero-title { font-size: 4.5rem; }
            .categories-bar { overflow-x: auto; gap: 2rem; justify-content: flex-start; margin: 2rem 2rem 1.5rem; }
            .features-row { flex-wrap: wrap; gap: 2rem; justify-content: center; padding: 0.5rem 2rem 2rem; }
            .feat-divider { display: none; }
        }

        /* ── SECTION WRAPPER & HEADERS ── */
        .home-section {
            padding: 1.8rem 4rem;
            width: 100%;
            position: relative;
            z-index: 2;
        }
        .section-header {
            display: flex;
            justify-content: space-between;
            align-items: flex-end;
            margin-bottom: 1.2rem;
        }
        .section-tag {
            color: var(--orange);
            font-size: 0.76rem;
            font-weight: 700;
            letter-spacing: 1.5px;
            text-transform: uppercase;
            margin-bottom: 0.25rem;
        }
        .section-title {
            font-size: 1.85rem;
            font-weight: 800;
            color: var(--white);
            letter-spacing: -0.5px;
        }
        .section-desc {
            color: #888;
            font-size: 0.88rem;
            margin-top: 0.25rem;
        }
        .view-all-link {
            color: var(--orange);
            text-decoration: none;
            font-weight: 600;
            font-size: 0.88rem;
            display: inline-flex;
            align-items: center;
            gap: 0.4rem;
            transition: gap 0.25s, color 0.25s;
        }
        .view-all-link:hover {
            color: var(--orange-hover);
            gap: 0.6rem;
        }

        /* ── MOST LOVED DISHES GRID ── */
        .dishes-grid {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 1.2rem;
        }
        .dish-card {
            background: #111115;
            border: 1px solid rgba(255, 255, 255, 0.07);
            border-radius: 16px;
            overflow: hidden;
            transition: transform 0.3s cubic-bezier(0.2,0.8,0.2,1), box-shadow 0.3s, border-color 0.3s;
            display: flex;
            flex-direction: column;
        }
        .dish-card:hover {
            transform: translateY(-5px);
            border-color: rgba(255, 94, 0, 0.35);
            box-shadow: 0 12px 28px rgba(0, 0, 0, 0.6), 0 0 16px rgba(255, 94, 0, 0.12);
        }
        .dish-img-wrap {
            position: relative;
            width: 100%;
            height: 155px;
            overflow: hidden;
            background: #18181e;
        }
        .dish-img-wrap img {
            width: 100%;
            height: 100%;
            object-fit: cover;
            transition: transform 0.5s ease;
        }
        .dish-card:hover .dish-img-wrap img {
            transform: scale(1.06);
        }
        .btn-fav {
            position: absolute;
            top: 10px;
            right: 10px;
            width: 30px;
            height: 30px;
            border-radius: 50%;
            background: rgba(0, 0, 0, 0.55);
            backdrop-filter: blur(8px);
            border: 1px solid rgba(255, 255, 255, 0.15);
            color: #fff;
            display: flex;
            align-items: center;
            justify-content: center;
            cursor: pointer;
            font-size: 0.85rem;
            transition: all 0.2s;
        }
        .btn-fav:hover, .btn-fav.active {
            background: var(--orange);
            border-color: var(--orange);
            color: #fff;
            transform: scale(1.08);
        }
        .dish-content {
            padding: 1rem;
            display: flex;
            flex-direction: column;
            flex: 1;
        }
        .dish-title {
            font-size: 1.05rem;
            font-weight: 700;
            color: var(--white);
            margin-bottom: 0.3rem;
        }
        .dish-meta {
            display: flex;
            align-items: center;
            gap: 0.6rem;
            font-size: 0.78rem;
            color: #aaa;
            margin-bottom: 0.45rem;
        }
        .dish-rating {
            color: #ffb703;
            font-weight: 600;
            display: flex;
            align-items: center;
            gap: 0.2rem;
        }
        .dish-rating span {
            color: #777;
            font-weight: 400;
        }
        .dish-desc {
            font-size: 0.8rem;
            color: #777;
            line-height: 1.4;
            margin-bottom: 0.85rem;
            flex: 1;
        }
        .dish-footer {
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding-top: 0.65rem;
            border-top: 1px solid rgba(255, 255, 255, 0.05);
        }
        .dish-price {
            font-size: 1.15rem;
            font-weight: 800;
            color: var(--white);
        }
        .btn-add-dish {
            background: var(--orange);
            color: #fff;
            border: none;
            outline: none;
            padding: 0.45rem 1rem;
            border-radius: 50px;
            font-weight: 700;
            font-size: 0.82rem;
            cursor: pointer;
            transition: all 0.25s;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 0.3rem;
        }
        .btn-add-dish:hover {
            background: var(--orange-hover);
            box-shadow: 0 4px 12px rgba(255, 94, 0, 0.4);
            transform: scale(1.03);
        }

        /* ── PROMO BANNERS SECTION ── */
        .promos-grid {
            display: grid;
            grid-template-columns: 1.2fr 1fr;
            gap: 1.2rem;
            margin: 0.5rem 0 1.2rem;
        }
        .promo-banner {
            position: relative;
            border-radius: 20px;
            padding: 1.5rem 2rem;
            overflow: hidden;
            display: flex;
            align-items: center;
            justify-content: space-between;
            min-height: 165px;
        }
        .promo-left {
            background: linear-gradient(135deg, #a73200 0%, #ff5e00 50%, #e04b00 100%);
            box-shadow: 0 15px 30px rgba(255, 94, 0, 0.2);
        }
        .promo-tag {
            display: inline-block;
            background: rgba(255, 255, 255, 0.2);
            backdrop-filter: blur(8px);
            color: #fff;
            font-size: 0.72rem;
            font-weight: 700;
            padding: 0.25rem 0.75rem;
            border-radius: 50px;
            margin-bottom: 0.6rem;
            letter-spacing: 0.5px;
        }
        .promo-heading {
            font-size: 1.85rem;
            font-weight: 900;
            line-height: 1.1;
            color: #fff;
            margin-bottom: 0.3rem;
            text-transform: uppercase;
        }
        .promo-heading span {
            color: #ffe600;
        }
        .promo-sub {
            font-size: 0.85rem;
            color: rgba(255, 255, 255, 0.9);
            margin-bottom: 1.1rem;
            font-weight: 500;
        }
        .btn-promo-white {
            background: #fff;
            color: #111;
            padding: 0.6rem 1.3rem;
            border-radius: 50px;
            text-decoration: none;
            font-weight: 700;
            font-size: 0.82rem;
            display: inline-flex;
            align-items: center;
            gap: 0.4rem;
            transition: all 0.25s;
            box-shadow: 0 6px 16px rgba(0,0,0,0.2);
        }
        .btn-promo-white:hover {
            background: #f0f0f0;
            transform: translateY(-2px);
            box-shadow: 0 10px 20px rgba(0,0,0,0.3);
        }
        .promo-img-wrap {
            width: 160px;
            height: 135px;
            flex-shrink: 0;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        .promo-img-wrap img {
            width: 100%;
            height: 100%;
            object-fit: contain;
            filter: drop-shadow(0 10px 20px rgba(0,0,0,0.45));
        }
        .promo-right {
            background: #f7f3ee;
            color: #111;
            border: 1px solid rgba(255, 255, 255, 0.1);
            box-shadow: 0 12px 28px rgba(0,0,0,0.35);
        }
        .promo-right .promo-heading {
            color: #111;
            font-size: 1.75rem;
        }
        .promo-right .promo-heading span {
            color: var(--orange);
        }
        .promo-right .promo-sub {
            color: #555;
            font-size: 0.85rem;
            margin-bottom: 1.1rem;
        }
        .btn-promo-orange {
            background: var(--orange);
            color: #fff;
            padding: 0.6rem 1.3rem;
            border-radius: 50px;
            text-decoration: none;
            font-weight: 700;
            font-size: 0.82rem;
            display: inline-flex;
            align-items: center;
            gap: 0.4rem;
            transition: all 0.25s;
            box-shadow: 0 6px 16px rgba(255, 94, 0, 0.3);
        }
        .btn-promo-orange:hover {
            background: var(--orange-hover);
            transform: translateY(-2px);
            box-shadow: 0 10px 20px rgba(255, 94, 0, 0.4);
        }

        /* ── TOP RESTAURANTS CARDS ── */
        .restaurants-compact-grid {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 1.2rem;
        }
        .rest-compact-card {
            background: #111115;
            border: 1px solid rgba(255, 255, 255, 0.07);
            border-radius: 14px;
            padding: 0.8rem;
            display: flex;
            align-items: center;
            gap: 0.85rem;
            text-decoration: none;
            color: var(--white);
            transition: all 0.3s cubic-bezier(0.2,0.8,0.2,1);
        }
        .rest-compact-card:hover {
            transform: translateY(-4px);
            border-color: rgba(255, 94, 0, 0.35);
            background: #16161c;
            box-shadow: 0 10px 22px rgba(0, 0, 0, 0.5);
        }
        .rest-thumb-wrap {
            position: relative;
            width: 64px;
            height: 64px;
            border-radius: 12px;
            overflow: hidden;
            flex-shrink: 0;
            background: #18181e;
        }
        .rest-thumb-wrap img {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }
        .rest-badge-logo {
            position: absolute;
            bottom: -2px;
            right: -2px;
            width: 22px;
            height: 22px;
            border-radius: 50%;
            border: 2px solid #111115;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 0.6rem;
            font-weight: 900;
            color: #fff;
        }
        .rest-compact-info {
            flex: 1;
            min-width: 0;
        }
        .rest-compact-name {
            font-size: 0.98rem;
            font-weight: 700;
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
            margin-bottom: 0.2rem;
        }
        .rest-compact-rating {
            font-size: 0.76rem;
            color: #ffb703;
            font-weight: 700;
            margin-bottom: 0.15rem;
            display: flex;
            align-items: center;
            gap: 0.2rem;
        }
        .rest-compact-cuisine {
            font-size: 0.76rem;
            color: #888;
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
            margin-bottom: 0.15rem;
        }
        .rest-compact-time {
            font-size: 0.74rem;
            color: #666;
            display: flex;
            align-items: center;
            gap: 0.25rem;
        }

        /* ── HOW IT WORKS SECTION ── */
        .how-it-works-grid {
            display: flex;
            align-items: center;
            justify-content: space-between;
            background: #111115;
            border: 1px solid rgba(255, 255, 255, 0.06);
            border-radius: 20px;
            padding: 1.6rem 2.5rem;
            margin-top: 0.6rem;
        }
        .how-step {
            display: flex;
            align-items: center;
            gap: 1rem;
            flex: 1;
        }
        .step-num-badge {
            width: 36px;
            height: 36px;
            border-radius: 50%;
            background: var(--orange);
            color: #fff;
            font-weight: 800;
            font-size: 0.95rem;
            display: flex;
            align-items: center;
            justify-content: center;
            flex-shrink: 0;
            box-shadow: 0 0 12px rgba(255, 94, 0, 0.4);
        }
        .step-icon-wrap {
            color: var(--orange);
            font-size: 1.6rem;
            flex-shrink: 0;
        }
        .step-details h4 {
            font-size: 1.02rem;
            font-weight: 700;
            color: #fff;
            margin-bottom: 0.2rem;
        }
        .step-details p {
            font-size: 0.82rem;
            color: #888;
            line-height: 1.35;
        }
        .step-arrow {
            color: #ff5e00;
            opacity: 0.5;
            font-size: 1.1rem;
            padding: 0 1rem;
        }

        /* ── TESTIMONIALS SECTION ── */
        .reviews-grid {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 1.2rem;
        }
        .review-card {
            background: #111115;
            border: 1px solid rgba(255, 255, 255, 0.07);
            border-radius: 16px;
            padding: 1.1rem 1.25rem;
            display: flex;
            gap: 1rem;
            align-items: flex-start;
            transition: transform 0.3s, border-color 0.3s;
        }
        .review-card:hover {
            transform: translateY(-4px);
            border-color: rgba(255, 94, 0, 0.35);
        }
        .review-avatar {
            width: 48px;
            height: 48px;
            border-radius: 50%;
            object-fit: cover;
            flex-shrink: 0;
            border: 2px solid var(--orange);
        }
        .review-body {
            flex: 1;
        }
        .review-stars {
            color: #ffb703;
            font-size: 0.78rem;
            margin-bottom: 0.4rem;
            display: flex;
            gap: 2px;
        }
        .review-quote {
            font-size: 0.82rem;
            color: #bbb;
            line-height: 1.45;
            margin-bottom: 0.5rem;
            font-style: italic;
        }
        .review-author {
            font-size: 0.8rem;
            font-weight: 700;
            color: var(--white);
        }

        /* ── FOOTER ── */
        .site-footer {
            background: #060608;
            border-top: 1px solid rgba(255, 255, 255, 0.08);
            padding: 3.5rem 4rem 2rem;
            width: 100%;
            margin-top: 1.5rem;
            position: relative;
            z-index: 2;
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
        .f-socials {
            display: flex;
            gap: 0.6rem;
        }
        .f-social-btn {
            width: 34px;
            height: 34px;
            border-radius: 50%;
            background: rgba(255, 255, 255, 0.05);
            border: 1px solid rgba(255, 255, 255, 0.1);
            color: #aaa;
            display: flex;
            align-items: center;
            justify-content: center;
            text-decoration: none;
            font-size: 0.85rem;
            transition: all 0.25s;
        }
        .f-social-btn:hover {
            background: var(--orange);
            border-color: var(--orange);
            color: #fff;
            transform: translateY(-2px);
        }
        .footer-col h5 {
            color: #fff;
            font-size: 0.95rem;
            font-weight: 700;
            margin-bottom: 1rem;
            letter-spacing: -0.2px;
        }
        .footer-links {
            list-style: none;
            display: flex;
            flex-direction: column;
            gap: 0.6rem;
        }
        .footer-links a {
            color: #888;
            text-decoration: none;
            font-size: 0.84rem;
            transition: color 0.2s, transform 0.2s;
            display: inline-block;
        }
        .footer-links a:hover {
            color: var(--orange);
            transform: translateX(3px);
        }
        .newsletter-desc {
            color: #888;
            font-size: 0.82rem;
            line-height: 1.4;
            margin-bottom: 0.9rem;
        }
        .newsletter-form {
            display: flex;
            position: relative;
            max-width: 300px;
        }
        .newsletter-input {
            width: 100%;
            padding: 0.75rem 3rem 0.75rem 1rem;
            background: rgba(20, 20, 25, 0.9);
            border: 1px solid rgba(255, 255, 255, 0.12);
            border-radius: 50px;
            color: #fff;
            font-size: 0.82rem;
            outline: none;
            transition: border-color 0.25s;
        }
        .newsletter-input:focus {
            border-color: var(--orange);
        }
        .newsletter-btn {
            position: absolute;
            right: 4px;
            top: 4px;
            bottom: 4px;
            width: 32px;
            height: 32px;
            border-radius: 50%;
            background: var(--orange);
            color: #fff;
            border: none;
            display: flex;
            align-items: center;
            justify-content: center;
            cursor: pointer;
            font-size: 0.82rem;
            transition: all 0.25s;
        }
        .newsletter-btn:hover {
            background: var(--orange-hover);
            transform: scale(1.06);
        }
        .footer-bottom {
            border-top: 1px solid rgba(255, 255, 255, 0.05);
            padding-top: 1.5rem;
            display: flex;
            justify-content: space-between;
            align-items: center;
            width: 100%;
            font-size: 0.82rem;
            color: #666;
        }
        .footer-bottom-links {
            display: flex;
            gap: 1.5rem;
        }
        .footer-bottom-links a {
            color: #666;
            text-decoration: none;
            transition: color 0.2s;
        }
        .footer-bottom-links a:hover {
            color: #aaa;
        }

        /* ── TOAST NOTIFICATION ── */
        .home-toast {
            position: fixed;
            bottom: 2rem;
            right: 2rem;
            background: #1a1a22;
            border: 1px solid rgba(255, 94, 0, 0.4);
            color: #fff;
            padding: 0.8rem 1.2rem;
            border-radius: 12px;
            font-size: 0.85rem;
            font-weight: 600;
            display: none;
            align-items: center;
            gap: 0.6rem;
            box-shadow: 0 10px 30px rgba(0,0,0,0.5);
            z-index: 9999;
        }
        .home-toast.show {
            display: flex;
            animation: toastIn 0.3s ease;
        }
        @keyframes toastIn {
            from { opacity: 0; transform: translateY(20px); }
            to { opacity: 1; transform: translateY(0); }
        }

        @media (max-width: 1100px) {
            .dishes-grid { grid-template-columns: repeat(2, 1fr); }
            .restaurants-compact-grid { grid-template-columns: repeat(2, 1fr); }
            .promos-grid { grid-template-columns: 1fr; }
            .how-it-works-grid { flex-direction: column; gap: 1.5rem; }
            .step-arrow { transform: rotate(90deg); padding: 0.5rem 0; }
            .reviews-grid { grid-template-columns: 1fr; }
            .footer-top { grid-template-columns: 1fr 1fr; }
        }
        @media (max-width: 650px) {
            .home-section { padding: 1.5rem 1rem; }
            .categories-bar, .features-row { width: calc(100% - 2rem); margin-left: auto; margin-right: auto; }
            .dishes-grid { grid-template-columns: 1fr; }
            .restaurants-compact-grid { grid-template-columns: 1fr; }
            .footer-top { grid-template-columns: 1fr; }
            .footer-bottom { flex-direction: column; gap: 0.8rem; text-align: center; }
            .site-footer { padding: 2.5rem 1.2rem 1.5rem; }
        }
    </style>
</head>
<body>

    <!-- Background Video (Half-Height Hero Only) -->
    <div class="hero-video-wrap">
        <video class="hero-video" autoplay loop muted playsinline>
            <source src="images/istockphoto-606042756-640_adpp_is.mp4" type="video/mp4">
        </video>
        <div class="hero-overlay"></div>
    </div>

    <!-- NAVBAR -->
    <nav class="navbar">
        <a href="index.jsp" class="logo">
            <svg width="35" height="45" viewBox="0 0 50 50" fill="none" xmlns="http://www.w3.org/2000/svg">
                <path d="M25 0 C12 0 4 9 4 22 C4 34 25 42 25 42 C25 42 46 34 46 22 C46 9 38 0 25 0 Z" fill="var(--orange)"/>
                <path d="M16 10 V17 C16 18.5 17 20 18.5 21 V29 H20.5 V21 C22 20 23 18.5 23 17 V10 H21.5 V15 H20.5 V10 H19.5 V15 H18.5 V10 H17.5 V15 H16 Z" fill="var(--dark)"/>
                <path d="M31 10 C28 10 26 12 26 16 C26 19.5 28.5 21 31 21 C33.5 21 36 19.5 36 16 C36 12 34 10 31 10 Z M30 21 V29 H32 V21 Z" fill="var(--dark)"/>
                <rect x="2" y="44" width="46" height="2" rx="1" fill="var(--white)"/>
                <path d="M 5 48 Q 20 56 40 46 C 30 52 15 50 8 46 Z" fill="var(--white)"/>
            </svg> <div>Plate<span>Hop</span></div>
        </a>

        <div class="nav-links">
            <a href="index.jsp" class="active">Home</a>
            <a href="restaurants">Menu</a>
            <a href="#">Categories</a>
            <a href="#">Offers</a>
            <a href="#">Reviews</a>
            <a href="#">Contact</a>
        </div>

        <div class="nav-actions">
            <div class="search-bar">
                <i class="fa-solid fa-magnifying-glass"></i>
                <input type="text" placeholder="Search for food...">
            </div>
            
            <% if(loggedInUser == null){ %>
                <a href="login.jsp" class="btn-login">Login</a>
                <a href="register.jsp" class="btn-signup">Sign Up</a>
                <a href="cart.jsp" class="cart-icon" style="margin-left: 0.5rem;">
                    <i class="fa-solid fa-cart-shopping"></i>
                </a>
            <% } else { %>
                <a href="cart.jsp" class="cart-icon">
                    <i class="fa-solid fa-cart-shopping"></i>
                    <div class="cart-badge">3</div>
                </a>
                <a href="profile.jsp" title="My Profile" style="display:flex; align-items:center; justify-content:center; width:38px; height:38px; border-radius:50%; background:#f2f2f7; color:#1c1c1e; text-decoration:none; margin-left:8px; border: 1px solid #e8e8e8;">
                    <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M20 21v-2a4 4 0 00-4-4H8a4 4 0 00-4 4v2"/><circle cx="12" cy="7" r="4"/></svg>
                </a>
            <% } %>
        </div>
    </nav>

    <!-- HERO -->
    <section class="hero">
        <div class="hot-badge">
            <i class="fa-solid fa-fire"></i> HOT & FRESH
        </div>
        
        <h1 class="hero-title">
            FOOD <span class="highlight">MADE</span><br>
            TO CRAVE
        </h1>

        <p class="hero-desc">
            Crispy. Cheesy. Delicious. Food that hits different, delivered hot to your door.
        </p>
        
        <div class="hero-btns">
            <a href="restaurants" class="btn-primary">Order Now <i class="fa-solid fa-arrow-right"></i></a>
            <a href="restaurants" class="btn-outline">Explore Menu <i class="fa-solid fa-arrow-trend-up"></i></a>
        </div>
    </section>

    <!-- CATEGORIES BAR -->
    <div class="categories-bar">
        <a href="restaurants?category=pizza" class="category-item">
            <div class="cat-img-wrap"><img src="images/pizza.png" alt="Pizza"></div>
            <div class="cat-name">Pizza</div>
            <div class="cat-count">24 Items</div>
        </a>
        <a href="restaurants?category=burger" class="category-item">
            <div class="cat-img-wrap"><img src="images/burger.png" alt="Burgers"></div>
            <div class="cat-name">Burgers</div>
            <div class="cat-count">18 Items</div>
        </a>
        <a href="restaurants?category=pasta" class="category-item">
            <div class="cat-img-wrap"><img src="images/pasta.png" alt="Pasta"></div>
            <div class="cat-name">Pasta</div>
            <div class="cat-count">20 Items</div>
        </a>
        <a href="restaurants?category=salad" class="category-item">
            <div class="cat-img-wrap"><img src="images/salad.png" alt="Salads"></div>
            <div class="cat-name">Salads</div>
            <div class="cat-count">16 Items</div>
        </a>
        <a href="restaurants?category=drinks" class="category-item">
            <div class="cat-img-wrap"><img src="images/cafe.png" alt="Drinks"></div>
            <div class="cat-name">Drinks</div>
            <div class="cat-count">15 Items</div>
        </a>
        <a href="restaurants?category=desserts" class="category-item">
            <div class="cat-img-wrap"><img src="images/steak.png" alt="Desserts"></div>
            <div class="cat-name">Desserts</div>
            <div class="cat-count">10 Items</div>
        </a>
        
        <a href="restaurants" class="view-all">
            <i class="fa-solid fa-table-cells-large"></i>
            <span>View All<br>Categories</span>
        </a>
    </div>

    <!-- BOTTOM FEATURES -->
    <div class="features-row">
        <div class="feature-box">
            <div class="feat-icon"><i class="fa-solid fa-motorcycle"></i></div>
            <div class="feat-text">
                <strong>30 Min</strong>
                <span>Fast Delivery</span>
            </div>
        </div>
        <div class="feat-divider"></div>
        <div class="feature-box">
            <div class="feat-icon"><i class="fa-solid fa-award"></i></div>
            <div class="feat-text">
                <strong>500+</strong>
                <span>Top Restaurants</span>
            </div>
        </div>
        <div class="feat-divider"></div>
        <div class="feature-box">
            <div class="feat-icon"><i class="fa-solid fa-shield-halved"></i></div>
            <div class="feat-text">
                <strong>100%</strong>
                <span>Safe & Secure</span>
            </div>
        </div>
        <div class="feat-divider"></div>
        <div class="feature-box">
            <div class="feat-icon"><i class="fa-solid fa-headset"></i></div>
            <div class="feat-text">
                <strong>24/7</strong>
                <span>Customer Support</span>
            </div>
        </div>
    </div>

    <!-- POPULAR DISHES -->
    <section class="home-section" id="popular-dishes">
        <div class="section-header">
            <div>
                <div class="section-tag">POPULAR DISHES</div>
                <h2 class="section-title">Most Loved Dishes</h2>
                <p class="section-desc">Discover our best dishes, freshly prepared and delivered to your door.</p>
            </div>
            <a href="restaurants" class="view-all-link">View All <i class="fa-solid fa-arrow-right"></i></a>
        </div>

        <div class="dishes-grid">
            <!-- Dish 1 -->
            <div class="dish-card">
                <div class="dish-img-wrap">
                    <img src="https://images.unsplash.com/photo-1574071318508-1cdbab80d002?auto=format&fit=crop&w=500&q=80" alt="Margherita Pizza">
                    <button class="btn-fav" onclick="toggleFav(this)" title="Save to Favorites"><i class="fa-regular fa-heart"></i></button>
                </div>
                <div class="dish-content">
                    <h3 class="dish-title">Margherita Pizza</h3>
                    <div class="dish-meta">
                        <span class="dish-rating"><i class="fa-solid fa-star"></i> 4.8 <span>(120)</span></span>
                        <span>•</span>
                        <span><i class="fa-regular fa-clock"></i> 25 min</span>
                    </div>
                    <p class="dish-desc">Classic delight with fresh tomatoes and mozzarella.</p>
                    <div class="dish-footer">
                        <div class="dish-price">&#8377;399</div>
                        <button class="btn-add-dish" onclick="quickAddToCart(1, 1, 'Margherita Pizza', 399)">Add <i class="fa-solid fa-plus"></i></button>
                    </div>
                </div>
            </div>

            <!-- Dish 2 -->
            <div class="dish-card">
                <div class="dish-img-wrap">
                    <img src="https://images.unsplash.com/photo-1568901346375-23c9450c58cd?auto=format&fit=crop&w=500&q=80" alt="Chicken Burger">
                    <button class="btn-fav" onclick="toggleFav(this)" title="Save to Favorites"><i class="fa-regular fa-heart"></i></button>
                </div>
                <div class="dish-content">
                    <h3 class="dish-title">Chicken Burger</h3>
                    <div class="dish-meta">
                        <span class="dish-rating"><i class="fa-solid fa-star"></i> 4.7 <span>(95)</span></span>
                        <span>•</span>
                        <span><i class="fa-regular fa-clock"></i> 20 min</span>
                    </div>
                    <p class="dish-desc">Crispy chicken burger with fresh veggies.</p>
                    <div class="dish-footer">
                        <div class="dish-price">&#8377;249</div>
                        <button class="btn-add-dish" onclick="quickAddToCart(4, 1, 'Chicken Burger', 249)">Add <i class="fa-solid fa-plus"></i></button>
                    </div>
                </div>
            </div>

            <!-- Dish 3 -->
            <div class="dish-card">
                <div class="dish-img-wrap">
                    <img src="https://images.unsplash.com/photo-1555949258-eb67b1ef0ceb?auto=format&fit=crop&w=500&q=80" alt="White Sauce Pasta">
                    <button class="btn-fav" onclick="toggleFav(this)" title="Save to Favorites"><i class="fa-regular fa-heart"></i></button>
                </div>
                <div class="dish-content">
                    <h3 class="dish-title">White Sauce Pasta</h3>
                    <div class="dish-meta">
                        <span class="dish-rating"><i class="fa-solid fa-star"></i> 4.6 <span>(88)</span></span>
                        <span>•</span>
                        <span><i class="fa-regular fa-clock"></i> 25 min</span>
                    </div>
                    <p class="dish-desc">Creamy and cheesy pasta with herbs.</p>
                    <div class="dish-footer">
                        <div class="dish-price">&#8377;279</div>
                        <button class="btn-add-dish" onclick="quickAddToCart(9, 1, 'White Sauce Pasta', 279)">Add <i class="fa-solid fa-plus"></i></button>
                    </div>
                </div>
            </div>

            <!-- Dish 4 -->
            <div class="dish-card">
                <div class="dish-img-wrap">
                    <img src="https://images.unsplash.com/photo-1563379091339-03b21ab4a4f8?auto=format&fit=crop&w=500&q=80" alt="Chicken Biryani">
                    <button class="btn-fav" onclick="toggleFav(this)" title="Save to Favorites"><i class="fa-regular fa-heart"></i></button>
                </div>
                <div class="dish-content">
                    <h3 class="dish-title">Chicken Biryani</h3>
                    <div class="dish-meta">
                        <span class="dish-rating"><i class="fa-solid fa-star"></i> 4.8 <span>(110)</span></span>
                        <span>•</span>
                        <span><i class="fa-regular fa-clock"></i> 30 min</span>
                    </div>
                    <p class="dish-desc">Aromatic basmati rice with tender chicken.</p>
                    <div class="dish-footer">
                        <div class="dish-price">&#8377;349</div>
                        <button class="btn-add-dish" onclick="quickAddToCart(5, 1, 'Chicken Biryani', 349)">Add <i class="fa-solid fa-plus"></i></button>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- PROMO OFFERS & COMBOS -->
    <section class="home-section" id="offers">
        <div class="promos-grid">
            <!-- Left Promo Banner -->
            <div class="promo-banner promo-left">
                <div>
                    <span class="promo-tag">Special Offer</span>
                    <h3 class="promo-heading">FLAT <span>30% OFF</span></h3>
                    <p class="promo-sub">On your first order. Use code <strong>PLATE30</strong></p>
                    <a href="restaurants" class="btn-promo-white">Order Now <i class="fa-solid fa-arrow-right"></i></a>
                </div>
                <div class="promo-img-wrap">
                    <img src="images/burger.png" alt="Burger & Fries Offer">
                </div>
            </div>

            <!-- Right Promo Banner -->
            <div class="promo-banner promo-right">
                <div>
                    <h3 class="promo-heading">Delicious <span>Combos</span></h3>
                    <p class="promo-sub">Great taste, Better together.</p>
                    <a href="restaurants" class="btn-promo-orange">Explore Combos <i class="fa-solid fa-arrow-right"></i></a>
                </div>
                <div class="promo-img-wrap">
                    <img src="images/pasta.png" alt="Delicious Combos">
                </div>
            </div>
        </div>
    </section>

    <!-- POPULAR RESTAURANTS -->
    <section class="home-section" id="popular-restaurants">
        <div class="section-header">
            <div>
                <div class="section-tag">POPULAR RESTAURANTS</div>
                <h2 class="section-title">Top Restaurants Near You</h2>
            </div>
            <a href="restaurants" class="view-all-link">View All <i class="fa-solid fa-arrow-right"></i></a>
        </div>

        <div class="restaurants-compact-grid">
            <!-- Rest 1 -->
            <a href="Menu?restaurantId=1" class="rest-compact-card">
                <div class="rest-thumb-wrap">
                    <img src="https://images.unsplash.com/photo-1513104890138-7c749659a591?auto=format&fit=crop&w=300&q=80" alt="Pizza Palace">
                    <div class="rest-badge-logo" style="background:#e02020;">P</div>
                </div>
                <div class="rest-compact-info">
                    <h4 class="rest-compact-name">Pizza Palace</h4>
                    <div class="rest-compact-rating"><i class="fa-solid fa-star"></i> 4.8</div>
                    <div class="rest-compact-cuisine">Italian • Pizza</div>
                    <div class="rest-compact-time"><i class="fa-regular fa-clock"></i> 25-30 min</div>
                </div>
            </a>

            <!-- Rest 2 -->
            <a href="Menu?restaurantId=4" class="rest-compact-card">
                <div class="rest-thumb-wrap">
                    <img src="https://images.unsplash.com/photo-1571091718767-18b5b1457add?auto=format&fit=crop&w=300&q=80" alt="Burger Hub">
                    <div class="rest-badge-logo" style="background:#f39c12;"><i class="fa-solid fa-burger" style="font-size:0.6rem;"></i></div>
                </div>
                <div class="rest-compact-info">
                    <h4 class="rest-compact-name">Burger Hub</h4>
                    <div class="rest-compact-rating"><i class="fa-solid fa-star"></i> 4.6</div>
                    <div class="rest-compact-cuisine">Burgers • Fast Food</div>
                    <div class="rest-compact-time"><i class="fa-regular fa-clock"></i> 20-25 min</div>
                </div>
            </a>

            <!-- Rest 3 -->
            <a href="Menu?restaurantId=9" class="rest-compact-card">
                <div class="rest-thumb-wrap">
                    <img src="https://images.unsplash.com/photo-1585937421612-70a008356fbe?auto=format&fit=crop&w=300&q=80" alt="Spice Villa">
                    <div class="rest-badge-logo" style="background:#c0392b;"><i class="fa-solid fa-pepper-hot" style="font-size:0.6rem;"></i></div>
                </div>
                <div class="rest-compact-info">
                    <h4 class="rest-compact-name">Spice Villa</h4>
                    <div class="rest-compact-rating"><i class="fa-solid fa-star"></i> 4.7</div>
                    <div class="rest-compact-cuisine">Indian • Biryani</div>
                    <div class="rest-compact-time"><i class="fa-regular fa-clock"></i> 25-35 min</div>
                </div>
            </a>

            <!-- Rest 4 -->
            <a href="Menu?restaurantId=6" class="rest-compact-card">
                <div class="rest-thumb-wrap">
                    <img src="https://images.unsplash.com/photo-1569718212165-3a8278d5f624?auto=format&fit=crop&w=300&q=80" alt="Noodle House">
                    <div class="rest-badge-logo" style="background:#27ae60;"><i class="fa-solid fa-bowl-rice" style="font-size:0.6rem;"></i></div>
                </div>
                <div class="rest-compact-info">
                    <h4 class="rest-compact-name">Noodle House</h4>
                    <div class="rest-compact-rating"><i class="fa-solid fa-star"></i> 4.5</div>
                    <div class="rest-compact-cuisine">Chinese • Noodles</div>
                    <div class="rest-compact-time"><i class="fa-regular fa-clock"></i> 20-30 min</div>
                </div>
            </a>
        </div>
    </section>

    <!-- HOW PLATEHOP WORKS -->
    <section class="home-section" id="how-it-works">
        <div class="section-tag" style="text-align: left;">HOW PLATEHOP WORKS</div>
        <h2 class="section-title" style="margin-bottom: 1.5rem;">Food Delivery Made Simple</h2>

        <div class="how-it-works-grid">
            <!-- Step 1 -->
            <div class="how-step">
                <div class="step-num-badge">1</div>
                <div class="step-icon-wrap"><i class="fa-solid fa-magnifying-glass"></i></div>
                <div class="step-details">
                    <h4>Choose Food</h4>
                    <p>Search and find your favorite dishes.</p>
                </div>
            </div>

            <div class="step-arrow"><i class="fa-solid fa-arrow-right"></i></div>

            <!-- Step 2 -->
            <div class="how-step">
                <div class="step-num-badge">2</div>
                <div class="step-icon-wrap"><i class="fa-solid fa-cart-shopping"></i></div>
                <div class="step-details">
                    <h4>Place Order</h4>
                    <p>Add items to your cart and checkout.</p>
                </div>
            </div>

            <div class="step-arrow"><i class="fa-solid fa-arrow-right"></i></div>

            <!-- Step 3 -->
            <div class="how-step">
                <div class="step-num-badge">3</div>
                <div class="step-icon-wrap"><i class="fa-solid fa-motorcycle"></i></div>
                <div class="step-details">
                    <h4>Get It Delivered</h4>
                    <p>Fresh food at your doorstep.</p>
                </div>
            </div>
        </div>
    </section>

    <!-- CUSTOMER REVIEWS -->
    <section class="home-section" id="reviews">
        <div class="section-header">
            <div>
                <div class="section-tag">CUSTOMER REVIEWS</div>
                <h2 class="section-title">What Our Customers Say</h2>
            </div>
            <a href="#" class="view-all-link">View All <i class="fa-solid fa-arrow-right"></i></a>
        </div>

        <div class="reviews-grid">
            <!-- Review 1 -->
            <div class="review-card">
                <img src="https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&w=150&q=80" alt="Anjali S." class="review-avatar">
                <div class="review-body">
                    <div class="review-stars">
                        <i class="fa-solid fa-star"></i><i class="fa-solid fa-star"></i><i class="fa-solid fa-star"></i><i class="fa-solid fa-star"></i><i class="fa-solid fa-star"></i>
                    </div>
                    <p class="review-quote">"Amazing food and super fast delivery. PlateHop is my go-to for weekend cravings!"</p>
                    <div class="review-author">- Anjali S.</div>
                </div>
            </div>

            <!-- Review 2 -->
            <div class="review-card">
                <img src="https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?auto=format&fit=crop&w=150&q=80" alt="Rahul K." class="review-avatar">
                <div class="review-body">
                    <div class="review-stars">
                        <i class="fa-solid fa-star"></i><i class="fa-solid fa-star"></i><i class="fa-solid fa-star"></i><i class="fa-solid fa-star"></i><i class="fa-solid fa-star"></i>
                    </div>
                    <p class="review-quote">"Great variety of restaurants and delicious food. The delivery is always on time!"</p>
                    <div class="review-author">- Rahul K.</div>
                </div>
            </div>

            <!-- Review 3 -->
            <div class="review-card">
                <img src="https://images.unsplash.com/photo-1494790108377-be9c29b29330?auto=format&fit=crop&w=150&q=80" alt="Priya M." class="review-avatar">
                <div class="review-body">
                    <div class="review-stars">
                        <i class="fa-solid fa-star"></i><i class="fa-solid fa-star"></i><i class="fa-solid fa-star"></i><i class="fa-solid fa-star"></i><i class="fa-solid fa-star"></i>
                    </div>
                    <p class="review-quote">"The best food delivery experience. Easy to order and the food is always fresh."</p>
                    <div class="review-author">- Priya M.</div>
                </div>
            </div>
        </div>
    </section>

    <!-- FOOTER -->
    <footer class="site-footer">
        <div class="footer-top">
            <!-- Col 1 -->
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

            <!-- Col 2 -->
            <div class="footer-col">
                <h5>Quick Links</h5>
                <ul class="footer-links">
                    <li><a href="index.jsp">Home</a></li>
                    <li><a href="restaurants">Menu</a></li>
                    <li><a href="restaurants">Categories</a></li>
                    <li><a href="#offers">Offers</a></li>
                </ul>
            </div>

            <!-- Col 3 -->
            <div class="footer-col">
                <h5>Company</h5>
                <ul class="footer-links">
                    <li><a href="#">About Us</a></li>
                    <li><a href="#">Careers</a></li>
                    <li><a href="#reviews">Reviews</a></li>
                    <li><a href="#">Contact</a></li>
                </ul>
            </div>

            <!-- Col 4 -->
            <div class="footer-col">
                <h5>Support</h5>
                <ul class="footer-links">
                    <li><a href="#">Help Center</a></li>
                    <li><a href="#">FAQs</a></li>
                    <li><a href="#">Privacy Policy</a></li>
                    <li><a href="#">Terms & Conditions</a></li>
                </ul>
            </div>

            <!-- Col 5 -->
            <div class="footer-col">
                <h5>Subscribe to our Newsletter</h5>
                <p class="newsletter-desc">Get the latest offers and updates.</p>
                <form class="newsletter-form" onsubmit="handleNewsletter(event)">
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
    <div id="homeToast" class="home-toast">
        <i class="fa-solid fa-circle-check" style="color:var(--orange);"></i>
        <span id="toastMsg">Added to cart!</span>
    </div>

    <!-- Interactive Script -->
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

        function quickAddToCart(menuId, restaurantId, itemName, price) {
            const formData = new URLSearchParams();
            formData.append('action', 'add');
            formData.append('menuId', menuId);
            formData.append('restaurantId', restaurantId);
            formData.append('quantity', '1');

            fetch('CartServlet', {
                method: 'POST',
                headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                body: formData
            }).then(() => {
                showToast(itemName + ' added to cart!');
                const badges = document.querySelectorAll('.cart-badge');
                badges.forEach(b => {
                    let count = parseInt(b.textContent) || 0;
                    b.textContent = count + 1;
                });
            }).catch(() => {
                showToast(itemName + ' added to cart!');
            });
        }

        function handleNewsletter(e) {
            e.preventDefault();
            const input = e.target.querySelector('input');
            if (input && input.value) {
                showToast('Thank you for subscribing to PlateHop!');
                input.value = '';
            }
        }

        function showToast(msg) {
            const toast = document.getElementById('homeToast');
            const toastMsg = document.getElementById('toastMsg');
            if (toast && toastMsg) {
                toastMsg.textContent = msg;
                toast.classList.add('show');
                setTimeout(() => {
                    toast.classList.remove('show');
                }, 2800);
            }
        }
    </script>
</body>
</html>