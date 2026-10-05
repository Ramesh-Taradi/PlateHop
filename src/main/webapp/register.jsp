<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Sign Up - PlateHop</title>
    <meta name="description" content="Create your PlateHop account and start ordering from the best restaurants near you.">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;500;600;700;800;900&display=swap" rel="stylesheet">
    <style>
        *, *::before, *::after { margin: 0; padding: 0; box-sizing: border-box; }

        :root {
            --bg: #070707;
            --surface: #0e0e0e;
            --surface2: #161616;
            --orange: #ff5e00;
            --orange2: #ff8a1f;
            --white: #ffffff;
            --muted: #9a9a9a;
            --border: rgba(255,255,255,0.08);
            --border-warm: rgba(255,94,0,0.22);
            --font: 'Outfit', sans-serif;
            --grad: linear-gradient(100deg, #ff8a1f 0%, #ff5e00 45%, #ff3d00 100%);
            --shadow-lg: 0 30px 70px -20px rgba(0,0,0,0.75);
            --shadow-glow: 0 18px 45px -12px rgba(255,94,0,0.45);
            --ease: cubic-bezier(0.22, 1, 0.36, 1);
        }

        html { -webkit-text-size-adjust: 100%; }
        body {
            background: var(--bg); font-family: var(--font);
            min-height: 100vh; display: flex; overflow: hidden;
            color: var(--white); -webkit-font-smoothing: antialiased;
        }

        ::selection { background: var(--orange); color: #fff; }

        /* ---------- Background ---------- */
        .page-bg-img {
            position: fixed; inset: 0; width: 100%; height: 100%; object-fit: cover;
            opacity: 1; filter: saturate(1.15) contrast(1.05) brightness(0.9);
            z-index: 0; transform: scale(1.04);
            animation: bgDrift 26s var(--ease) infinite alternate;
        }
        @keyframes bgDrift {
            from { transform: scale(1.04) translate3d(0,0,0); }
            to   { transform: scale(1.12) translate3d(-1.5%, -1%, 0); }
        }
        .page-overlay {
            position: fixed; inset: 0; z-index: 1;
            background:
                radial-gradient(900px 620px at 12% 22%, rgba(255,94,0,0.18), transparent 62%),
                linear-gradient(90deg, rgba(0,0,0,0.30) 0%, rgba(0,0,0,0.78) 52%, rgba(7,7,7,0.97) 100%);
        }
        .page-overlay::after {
            content: ''; position: absolute; inset: 0;
            background-image: radial-gradient(rgba(255,255,255,0.05) 1px, transparent 1px);
            background-size: 4px 4px; opacity: 0.35; mix-blend-mode: overlay;
        }

        /* ---------- Left panel ---------- */
        .left-panel {
            flex: 1; position: relative; height: 100vh;
            display: flex; align-items: center; justify-content: center;
            padding: 2.5rem 1rem; overflow: hidden; z-index: 2;
        }
        .left-content {
            position: relative; z-index: 2; text-align: center;
            padding: 0 3rem; max-width: 620px; margin: 0 auto;
            display: flex; flex-direction: column; align-items: center;
        }
        .left-content > * { opacity: 0; transform: translateY(22px); animation: rise 0.85s var(--ease) forwards; }
        .left-content > *:nth-child(1) { animation-delay: 0.05s; }
        .left-content > *:nth-child(2) { animation-delay: 0.14s; }
        .left-content > *:nth-child(3) { animation-delay: 0.23s; }
        .left-content > *:nth-child(4) { animation-delay: 0.32s; }
        .left-content > *:nth-child(5) { animation-delay: 0.41s; }
        @keyframes rise { to { opacity: 1; transform: none; } }

        .brand-logo-container {
            display: inline-flex; align-items: center; gap: 12px;
            margin-bottom: 2.2rem; justify-content: center;
            padding: 0.55rem 1.15rem 0.55rem 0.7rem; border-radius: 999px;
            background: rgba(255,255,255,0.04);
            border: 1px solid var(--border);
            backdrop-filter: blur(14px);
        }
        .brand-logo-container svg { height: 42px; width: 42px; filter: drop-shadow(0 6px 16px rgba(255,94,0,0.45)); }
        .brand-text { font-size: 1.65rem; font-weight: 800; color: #fff; letter-spacing: -0.6px; }
        .brand-text span { color: var(--orange); }

        .big-text {
            font-size: clamp(2.6rem, 4.4vw, 4rem); font-weight: 900; line-height: 1.02;
            color: #fff; letter-spacing: -2.2px; margin-bottom: 1.1rem;
        }
        .big-text .orange-text {
            color: var(--orange); position: relative; display: inline-block;
            background: var(--grad); -webkit-background-clip: text; background-clip: text;
            -webkit-text-fill-color: transparent;
        }
        .big-text .orange-text::after {
            content: ''; position: absolute; left: 0; bottom: 6px; width: 100%; height: 8px;
            background: var(--grad); border-radius: 6px; z-index: -1; opacity: 0.35;
            transform: rotate(-1.6deg); filter: blur(0.4px);
        }
        .big-text-line { display: block; }
        .sparkle { position: absolute; right: -40px; top: -10px; font-size: 2rem; color: var(--orange); font-weight: normal; font-family: sans-serif; }

        .sub-text {
            color: #c9c9c9; font-size: 1.05rem; line-height: 1.7;
            max-width: 420px; margin-bottom: 1.8rem; font-weight: 400;
        }

        .pill-badge {
            display: inline-flex; align-items: center; justify-content: center; gap: 0.7rem;
            border: 1px solid var(--border-warm);
            padding: 0.75rem 1.4rem; border-radius: 999px;
            color: #ffb37a; font-size: 0.92rem; font-weight: 600;
            margin-bottom: 1.8rem;
            background: linear-gradient(180deg, rgba(255,94,0,0.12), rgba(255,94,0,0.04));
            backdrop-filter: blur(14px);
            box-shadow: inset 0 1px 0 rgba(255,255,255,0.06);
        }
        .pill-badge .ico { display: inline-flex; color: var(--orange); }

        .features { display: flex; flex-direction: column; gap: 0.85rem; align-items: center; width: 100%; }
        .feature-item {
            display: flex; align-items: center; gap: 1.1rem;
            background: linear-gradient(180deg, rgba(255,255,255,0.055), rgba(255,255,255,0.02));
            border: 1px solid var(--border);
            padding: 1.05rem 1.35rem; border-radius: 18px;
            backdrop-filter: blur(16px);
            width: 100%; max-width: 460px; text-align: left;
            transition: transform 0.45s var(--ease), border-color 0.35s ease, box-shadow 0.45s var(--ease);
        }
        .feature-item:hover {
            transform: translateY(-4px);
            border-color: var(--border-warm);
            box-shadow: 0 20px 40px -22px rgba(255,94,0,0.55);
        }
        .feature-icon-wrap {
            color: var(--orange); font-size: 1.4rem;
            display: flex; align-items: center; justify-content: center;
            width: 44px; height: 44px; flex: 0 0 44px; border-radius: 13px;
            background: rgba(255,94,0,0.12); border: 1px solid var(--border-warm);
        }
        .feature-text-wrap { display: flex; flex-direction: column; gap: 0.25rem; }
        .feature-title { color: #fff; font-size: 0.98rem; font-weight: 700; letter-spacing: -0.2px; }
        .feature-desc { color: var(--muted); font-size: 0.84rem; font-weight: 400; }

        /* ---------- Right panel ---------- */
        .right-panel {
            width: 560px; height: 100vh; background: transparent;
            display: flex; align-items: center; justify-content: center;
            padding: 1.5rem 2rem; position: relative; z-index: 2;
            overflow-y: auto; scrollbar-width: thin;
            scrollbar-color: rgba(255,94,0,0.4) transparent;
        }
        .right-panel::-webkit-scrollbar { width: 6px; }
        .right-panel::-webkit-scrollbar-thumb { background: rgba(255,94,0,0.35); border-radius: 999px; }

        .form-wrap {
            width: 100%; max-width: 450px;
            background: linear-gradient(180deg, rgba(20,20,20,0.72), rgba(10,10,10,0.62));
            backdrop-filter: blur(26px);
            border: 1px solid var(--border);
            border-radius: 26px;
            padding: 2.1rem 2.2rem;
            margin: auto 0;
            box-shadow: var(--shadow-lg), inset 0 1px 0 rgba(255,255,255,0.07);
            position: relative;
            opacity: 0; transform: translateY(26px) scale(0.985);
            animation: rise 0.8s var(--ease) 0.12s forwards;
        }
        .form-wrap::before {
            content: ''; position: absolute; inset: -1px; border-radius: 27px; pointer-events: none;
            background: linear-gradient(160deg, rgba(255,94,0,0.5), transparent 42%, transparent 68%, rgba(255,94,0,0.22));
            -webkit-mask: linear-gradient(#000 0 0) content-box, linear-gradient(#000 0 0);
            -webkit-mask-composite: xor; mask-composite: exclude; padding: 1px;
        }

        .form-head { margin-bottom: 1.4rem; }
        .form-head h1 {
            font-size: 1.85rem; font-weight: 800; color: #fff;
            letter-spacing: -0.9px; margin-bottom: 0.35rem;
            display: flex; align-items: center; gap: 8px;
        }
        .form-head p { color: var(--muted); font-size: 0.88rem; }

        .form-group { margin-bottom: 0.9rem; }
        .form-group label {
            display: block; color: #a9a9a9; font-size: 0.66rem;
            font-weight: 700; text-transform: uppercase; letter-spacing: 1.4px; margin-bottom: 0.45rem;
        }
        .input-wrap { position: relative; }
        .input-wrap .ico-left {
            position: absolute; left: 0.95rem; top: 50%; transform: translateY(-50%);
            color: var(--orange); font-size: 0.95rem; display: inline-flex; align-items: center;
            pointer-events: none; transition: transform 0.3s var(--ease);
        }
        .input-wrap .ico-right {
            position: absolute; right: 1rem; top: 50%; transform: translateY(-50%);
            color: #6b6b6b; font-size: 0.95rem; cursor: pointer; transition: color 0.25s ease;
        }
        .input-wrap .ico-right:hover { color: var(--orange); }
        .form-group input, .form-group select {
            width: 100%; padding: 0.85rem 2.6rem 0.85rem 2.6rem;
            background: rgba(255,255,255,0.03);
            border: 1px solid var(--border);
            border-radius: 13px; color: #fff; font-size: 0.92rem;
            font-family: var(--font); outline: none;
            transition: border-color 0.3s ease, box-shadow 0.3s ease, background 0.3s ease;
            appearance: none; -webkit-appearance: none;
        }
        .form-group input::placeholder { color: #5c5c5c; }
        .form-group select { color: #fff; cursor: pointer; }
        .form-group select option { background: #141414; color: #fff; }
        .form-group select option:disabled { color: #666; }
        .form-group input:hover, .form-group select:hover { border-color: rgba(255,255,255,0.16); }
        .form-group input:focus, .form-group select:focus {
            border-color: var(--orange);
            background: rgba(255,94,0,0.06);
            box-shadow: 0 0 0 4px rgba(255,94,0,0.14);
        }
        .input-wrap:focus-within .ico-left { transform: translateY(-50%) scale(1.12); }
        .select-arrow {
            position: absolute; right: 1.05rem; top: 50%; transform: translateY(-50%);
            color: var(--orange); font-size: 0.7rem; pointer-events: none;
        }
        .form-group input:-webkit-autofill,
        .form-group input:-webkit-autofill:hover,
        .form-group input:-webkit-autofill:focus,
        .form-group input:-webkit-autofill:active {
            -webkit-box-shadow: 0 0 0 30px #141414 inset !important;
            -webkit-text-fill-color: #fff !important;
            caret-color: #fff;
            transition: background-color 5000s ease-in-out 0s;
        }

        .btn-sub {
            width: 100%; padding: 0.95rem; margin-top: 1.1rem;
            background: var(--grad);
            color: #fff; border: none; border-radius: 13px;
            font-size: 1rem; font-weight: 700; font-family: var(--font);
            letter-spacing: 0.2px; cursor: pointer;
            display: flex; align-items: center; justify-content: center; gap: 9px;
            position: relative; overflow: hidden;
            box-shadow: var(--shadow-glow);
            transition: transform 0.4s var(--ease), box-shadow 0.4s var(--ease), filter 0.3s ease;
        }
        .btn-sub::after {
            content: ''; position: absolute; top: 0; left: -120%; width: 60%; height: 100%;
            background: linear-gradient(90deg, transparent, rgba(255,255,255,0.35), transparent);
            transform: skewX(-20deg); transition: left 0.7s var(--ease);
        }
        .btn-sub:hover { transform: translateY(-3px); box-shadow: 0 24px 55px -14px rgba(255,94,0,0.6); filter: saturate(1.08); }
        .btn-sub:hover::after { left: 130%; }
        .btn-sub:active { transform: translateY(-1px) scale(0.995); }

        .divider {
            display: flex; align-items: center; text-align: center; margin: 1.15rem 0;
            color: #5f5f5f; font-size: 0.72rem; font-weight: 700; letter-spacing: 1.6px;
        }
        .divider::before, .divider::after { content: ''; flex: 1; border-bottom: 1px solid var(--border); }
        .divider::before { margin-right: .85em; }
        .divider::after { margin-left: .85em; }

        .btn-google {
            width: 100%; padding: 0.82rem;
            background: #fff; color: #111; border: 1px solid rgba(0,0,0,0.06); border-radius: 13px;
            font-size: 0.92rem; font-weight: 700; font-family: var(--font);
            cursor: pointer;
            display: flex; align-items: center; justify-content: center; gap: 9px;
            transition: transform 0.35s var(--ease), box-shadow 0.35s var(--ease), background 0.25s ease;
        }
        .btn-google:hover { background: #f4f4f4; transform: translateY(-2px); box-shadow: 0 16px 34px -16px rgba(255,255,255,0.35); }
        .btn-google img { width: 18px; height: 18px; }

        .rating-section {
            margin-top: 1.3rem; display: flex; align-items: center; justify-content: center; gap: 0.85rem;
            padding: 0.85rem 1rem; border-radius: 16px;
            background: rgba(255,255,255,0.03); border: 1px solid var(--border);
        }
        .avatars { display: flex; }
        .avatars img {
            width: 30px; height: 30px; border-radius: 50%;
            border: 2px solid #141414; margin-left: -10px; object-fit: cover;
            transition: transform 0.35s var(--ease);
        }
        .avatars img:first-child { margin-left: 0; }
        .avatars img:hover { transform: translateY(-3px) scale(1.08); z-index: 2; }
        .rating-info { display: flex; flex-direction: column; gap: 3px; }
        .stars { color: var(--orange); font-size: 0.8rem; letter-spacing: 2px; display: flex; align-items: center; gap: 4px; }
        .rating-text-bold { color: #fff; font-size: 0.8rem; font-weight: 700; margin-left: 8px; letter-spacing: 0; }
        .rating-text-sub { color: var(--muted); font-size: 0.74rem; }

        .form-foot { text-align: center; margin-top: 1.15rem; color: var(--muted); font-size: 0.86rem; }
        .form-foot a {
            color: var(--orange); text-decoration: none; font-weight: 700; margin-left: 5px;
            transition: color 0.25s ease;
        }
        .form-foot a:hover { color: var(--orange2); text-decoration: underline; text-underline-offset: 3px; }

        .success-msg {
            background: linear-gradient(180deg, rgba(34,197,94,0.16), rgba(34,197,94,0.07));
            border: 1px solid rgba(34,197,94,0.32);
            color: #6ee7a0; padding: 0.85rem 1rem; border-radius: 13px;
            margin-bottom: 1.1rem; font-size: 0.88rem; text-align: center; font-weight: 600;
            animation: rise 0.5s var(--ease) forwards;
        }

        /* ---------- Responsive ---------- */
        @media (max-width: 1100px) {
            .left-content { padding: 0 1.5rem; }
            .right-panel { width: 500px; }
        }
        @media (max-width: 900px) {
            body { overflow-y: auto; height: auto; }
            .left-panel { display: none; }
            .right-panel { width: 100%; height: auto; min-height: 100vh; padding: 2rem 1.25rem; }
        }
        @media (max-width: 480px) {
            .right-panel { padding: 1.5rem 1rem; }
            .form-wrap { padding: 1.6rem 1.25rem; border-radius: 22px; }
            .form-head h1 { font-size: 1.55rem; }
            .rating-section { flex-direction: column; gap: 0.5rem; text-align: center; }
        }

        @media (prefers-reduced-motion: reduce) {
            *, *::before, *::after { animation: none !important; transition: none !important; }
            .left-content > *, .form-wrap { opacity: 1 !important; transform: none !important; }
        }
    </style>
</head>
<body>
    <img class="page-bg-img" src="images/signup_bg.png" alt="Food Background">
    <div class="page-overlay"></div>

    <div class="left-panel">
        <div class="left-content">
            <div class="brand-logo-container">
                <svg viewBox="0 0 100 100" xmlns="http://www.w3.org/2000/svg">
                    <defs>
                        <linearGradient id="pinGrad" x1="0%" y1="0%" x2="100%" y2="0%">
                            <stop offset="0%" stop-color="#ff4500"/>
                            <stop offset="100%" stop-color="#ff7700"/>
                        </linearGradient>
                    </defs>
                    <path d="M50 5 C35 5 25 17 25 31 C25 50 50 75 50 75 C50 75 75 50 75 31 C75 17 65 5 50 5 Z" fill="url(#pinGrad)"/>
                    <path d="M38 18 V28 C38 31 41 33 41 33 V45 H44 V33 C44 33 47 31 47 28 V18 H45 V25 H43 V18 H41 V25 H39 V18 Z" fill="#111111"/>
                    <path d="M53 18 C50 18 50 25 53 28 V45 H56 V28 C59 25 59 18 56 18 Z" fill="#111111"/>
                    <rect x="25" y="82" width="50" height="4" rx="2" fill="#ffffff"/>
                    <path d="M32 86 C32 86 45 96 68 86 L71 82 C71 82 65 92 45 96 C32 94 28 88 28 88 Z" fill="#ffffff"/>
                </svg>
                <span class="brand-text">Plate<span>Hop</span></span>
            </div>

            <h1 class="big-text">
                <span class="big-text-line">Delicious food,</span>
                <span class="big-text-line">
                    <span class="orange-text">Delivered</span> fast.
                </span>
            </h1>
            <p class="sub-text">Thousands of dishes from top restaurants delivered hot, fresh, and fast to your door.</p>

            <div class="pill-badge">
                <span class="ico"><svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round"><rect x="1" y="3" width="15" height="13"></rect><polygon points="16 8 20 8 23 11 23 16 16 16 16 8"></polygon><circle cx="5.5" cy="18.5" r="2.5"></circle><circle cx="18.5" cy="18.5" r="2.5"></circle></svg></span> Free delivery on your first order!
            </div>

            <div class="features">
                <div class="feature-item">
                    <div class="feature-icon-wrap">
                        <svg width="24" height="24" viewBox="0 0 24 24" fill="currentColor"><path d="M13 2L3 14h9l-1 8 10-12h-9l1-8z"/></svg>
                    </div>
                    <div class="feature-text-wrap">
                        <span class="feature-title">30-minute delivery guarantee</span>
                        <span class="feature-desc">Super fast delivery at your doorstep.</span>
                    </div>
                </div>
                <div class="feature-item">
                    <div class="feature-icon-wrap">
                        <svg width="24" height="24" viewBox="0 0 24 24" fill="currentColor"><path d="M21.2 9.6C20 6.3 16.3 4 12 4S4 6.3 2.8 9.6C2.6 10.1 3 10.5 3.5 10.5H20.5C21 10.5 21.4 10.1 21.2 9.6zM3 13.5C3 14.3 3.7 15 4.5 15H19.5C20.3 15 21 14.3 21 13.5C21 12.7 20.3 12 19.5 12H4.5C3.7 12 3 12.7 3 13.5zM19 16H5C3.9 16 3 16.9 3 18C3 19.1 3.9 20 5 20H19C20.1 20 21 19.1 21 18C21 16.9 20.1 16 19 16z"/></svg>
                    </div>
                    <div class="feature-text-wrap">
                        <span class="feature-title">500+ menu items to choose from</span>
                        <span class="feature-desc">A wide variety of cuisines &amp; dishes.</span>
                    </div>
                </div>
                <div class="feature-item">
                    <div class="feature-icon-wrap">
                        <svg width="24" height="24" viewBox="0 0 24 24" fill="currentColor"><path d="M18 8h-1V6c0-2.76-2.24-5-5-5S7 3.24 7 6v2H6c-1.1 0-2 .9-2 2v10c0 1.1.9 2 2 2h12c1.1 0 2-.9 2-2V10c0-1.1-.9-2-2-2zm-6 9c-1.1 0-2-.9-2-2s.9-2 2-2 2 .9 2 2-.9 2-2 2zM9 8V6c0-1.66 1.34-3 3-3s3 1.34 3 3v2H9z"/></svg>
                    </div>
                    <div class="feature-text-wrap">
                        <span class="feature-title">Secure &amp; hassle-free checkout</span>
                        <span class="feature-desc">100% safe payments and data protection.</span>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div class="right-panel">
        <div class="form-wrap">
            <div class="form-head">
                <h1>Create Account <span style="color:var(--orange);">✨</span></h1>
                <p>Fill in your details to get started.</p>
            </div>

            <%
                String successMsg = (String) request.getAttribute("successMessage");
                if (successMsg != null) {
            %>
            <div class="success-msg">✅ <%= successMsg %></div>
            <% } %>

            <form action="RegisterServlet" method="post" autocomplete="off">
                <div class="form-group">
                    <label for="userName">FULL NAME</label>
                    <div class="input-wrap">
                        <span class="ico-left">👤</span>
                        <input type="text" id="userName" name="userName" placeholder="John Doe" autocomplete="off" required>
                    </div>
                </div>
                <div class="form-group">
                    <label for="email">EMAIL ADDRESS</label>
                    <div class="input-wrap">
                        <span class="ico-left">✉</span>
                        <input type="email" id="email" name="email" placeholder="ram@gmail.com" autocomplete="off" required>
                    </div>
                </div>
                <div class="form-group">
                    <label for="password">PASSWORD</label>
                    <div class="input-wrap">
                        <span class="ico-left">🔒</span>
                        <input type="password" id="password" name="password" placeholder="••••••••••••" autocomplete="new-password" required>
                        <span class="ico-right">👁‍🗨</span> <!-- Eye-slash icon equivalent using standard emoji or text -->
                    </div>
                </div>
                <div class="form-group">
                    <label for="address">DELIVERY ADDRESS</label>
                    <div class="input-wrap">
                        <span class="ico-left"><svg width="16" height="16" viewBox="0 0 24 24" fill="currentColor"><path d="M12 2C8.13 2 5 5.13 5 9c0 5.25 7 13 7 13s7-7.75 7-13c0-3.87-3.13-7-7-7zm0 9.5c-1.38 0-2.5-1.12-2.5-2.5s1.12-2.5 2.5-2.5 2.5 1.12 2.5 2.5-1.12 2.5-2.5 2.5z"/></svg></span>
                        <input type="text" id="address" name="address" placeholder="Your full delivery address" autocomplete="off" required>
                    </div>
                </div>
                <div class="form-group">
                    <label for="role">ROLE</label>
                    <div class="input-wrap">
                        <span class="ico-left">🛡️</span>
                        <select id="role" name="role" required>
                            <option value="" disabled selected>Select your role</option>
                            <option value="Customer">🍽️ Customer</option>
                            <option value="Restaurant Owner">🏪 Restaurant Owner</option>
                        </select>
                        <span class="select-arrow">▼</span>
                    </div>
                </div>
                <button type="submit" class="btn-sub">Create My Account &rarr;</button>
            </form>

            <div class="divider">OR</div>

            <button type="button" class="btn-google">
                <!-- Inline SVG for Google Logo -->
                <svg viewBox="0 0 24 24" width="20" height="20" xmlns="http://www.w3.org/2000/svg">
                    <path d="M22.56 12.25c0-.78-.07-1.53-.2-2.25H12v4.26h5.92c-.26 1.37-1.04 2.53-2.21 3.31v2.77h3.57c2.08-1.92 3.28-4.74 3.28-8.09z" fill="#4285F4"/>
                    <path d="M12 23c2.97 0 5.46-.98 7.28-2.66l-3.57-2.77c-.98.66-2.23 1.06-3.71 1.06-2.86 0-5.29-1.93-6.16-4.53H2.18v2.84C3.99 20.53 7.7 23 12 23z" fill="#34A853"/>
                    <path d="M5.84 14.09c-.22-.66-.35-1.36-.35-2.09s.13-1.43.35-2.09V7.07H2.18C1.43 8.55 1 10.22 1 12s.43 3.45 1.18 4.93l2.85-2.22.81-.62z" fill="#FBBC05"/>
                    <path d="M12 5.38c1.62 0 3.06.56 4.21 1.64l3.15-3.15C17.45 2.09 14.97 1 12 1 7.7 1 3.99 3.47 2.18 7.07l3.66 2.84c.87-2.6 3.3-4.53 6.16-4.53z" fill="#EA4335"/>
                </svg>
                Sign up with Google
            </button>

            <div class="rating-section">
                <div class="avatars">
                    <img src="https://i.pravatar.cc/100?img=11" alt="user1">
                    <img src="https://i.pravatar.cc/100?img=12" alt="user2">
                    <img src="https://i.pravatar.cc/100?img=13" alt="user3">
                </div>
                <div class="rating-info">
                    <div class="stars">
                        ★ ★ ★ ★ ★ <span class="rating-text-bold">4.9 Rating</span>
                    </div>
                    <div class="rating-text-sub">Trusted by 100,000+ food lovers</div>
                </div>
            </div>

            <div class="form-foot">
                Already have an account? <a href="login.jsp">Login here &rarr;</a>
            </div>
        </div>
    </div>
</body>
</html>
