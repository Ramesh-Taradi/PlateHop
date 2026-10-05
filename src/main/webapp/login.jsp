<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login - PlateHop</title>
    <meta name="description" content="Login to Platehop and order delicious food from top restaurants delivered fast to your door.">
    <!-- Google Fonts: Poppins -->
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700;800;900&display=swap" rel="stylesheet">
    <!-- Font Awesome Icons -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    
    <style>
        *, *::before, *::after { margin: 0; padding: 0; box-sizing: border-box; }

        :root {
            --orange: #ff5e00;
            --orange-hover: #e05300;
            --white: #ffffff;
            --muted: #a0a0a0;
            --border: rgba(255,255,255,0.08);
            --font: 'Poppins', sans-serif;
            --glow: 0 0 20px rgba(255, 94, 0, 0.4);
        }

        body {
            font-family: var(--font);
            min-height: 100vh;
            display: flex;
            overflow: hidden;
            background: #000;
            color: var(--white);
        }

        /* Full-screen Background Image */
        .bg-image {
            position: fixed;
            top: 0; left: 0;
            width: 100vw; height: 100vh;
            object-fit: cover;
            z-index: -2;
            filter: brightness(0.65) saturate(1.2);
        }

        /* Overlay to darken background */
        .overlay {
            position: fixed;
            top: 0; left: 0;
            width: 100vw; height: 100vh;
            background: linear-gradient(90deg, rgba(0,0,0,0.85) 0%, rgba(0,0,0,0.4) 50%, rgba(0,0,0,0.85) 100%);
            z-index: -1;
        }

        /* Layout Container: 60% left, 40% right */
        .container {
            width: 100vw;
            height: 100vh;
            display: flex;
            z-index: 1;
        }

        /* --- Left Side Content (60%) --- */
        .left-content {
            flex: 0 0 60%;
            height: 100%;
            display: flex;
            flex-direction: column;
            justify-content: center;
            padding: 4rem 6rem;
        }

        .logo-wrap {
            display: flex;
            align-items: center;
            gap: 12px;
            margin-bottom: 2rem;
        }

        .logo-text {
            font-size: 2.2rem;
            font-weight: 900;
            letter-spacing: -1px;
        }

        .logo-text span {
            color: var(--orange);
        }

        .hero-title {
            font-size: 4.5rem;
            font-weight: 900;
            line-height: 1.1;
            margin-bottom: 1.5rem;
            letter-spacing: -1.5px;
        }
        
        .hero-title .highlight {
            color: var(--orange);
        }

        .hero-desc {
            font-size: 1.15rem;
            color: #e0e0e0;
            max-width: 480px;
            line-height: 1.6;
            margin-bottom: 2.5rem;
        }

        .delivery-badge {
            display: inline-flex;
            align-items: center;
            gap: 0.6rem;
            background: rgba(10, 10, 10, 0.4);
            border: 1px solid rgba(255, 94, 0, 0.4);
            padding: 0.7rem 1.4rem;
            border-radius: 50px;
            color: var(--orange);
            font-size: 0.95rem;
            font-weight: 600;
            backdrop-filter: blur(8px);
            margin-bottom: 3.5rem;
            box-shadow: var(--glow);
        }

        .stats-row {
            display: flex;
            gap: 4rem;
        }

        .stat-item {
            display: flex;
            flex-direction: column;
            align-items: center;
            gap: 0.8rem;
        }

        .stat-icon {
            font-size: 2rem;
            color: white;
            margin-bottom: 0.2rem;
        }

        .stat-val {
            font-size: 1.8rem;
            font-weight: 800;
            color: var(--orange);
            line-height: 1;
        }

        .stat-lbl {
            font-size: 0.8rem;
            color: #b0b0b0;
            font-weight: 600;
            letter-spacing: 1px;
            text-transform: uppercase;
        }


        /* --- Right Side (40%) --- */
        .right-content {
            flex: 0 0 45%;
            height: 100%;
            display: flex;
            align-items: center;
            justify-content: center;
            padding-right: 6rem;
            padding-left: 2rem;
        }

        /* Glassmorphism Login Card with Orange Glow */
        .glass-card {
            width: 100%;
            max-width: 480px;
            background: rgba(15, 15, 15, 0.7);
            backdrop-filter: blur(16px);
            -webkit-backdrop-filter: blur(16px);
            border: 1px solid rgba(255, 94, 0, 0.4);
            border-radius: 20px;
            padding: 3rem;
            box-shadow: 0 20px 50px rgba(0,0,0,0.8), 0 0 20px rgba(255, 94, 0, 0.15);
        }

        .form-header {
            margin-bottom: 2rem;
        }

        .form-header h2 {
            font-size: 2.2rem;
            font-weight: 700;
            margin-bottom: 0.3rem;
        }

        .form-header h2 i {
            color: #FFD43B; /* Waving hand color */
        }

        .form-header p {
            color: var(--muted);
            font-size: 0.95rem;
        }

        .alert-message {
            display: flex;
            align-items: center;
            gap: 0.8rem;
            background: rgba(255, 94, 0, 0.08);
            border: 1px solid rgba(255, 94, 0, 0.4);
            color: #f2803b;
            padding: 1rem;
            border-radius: 12px;
            font-size: 0.9rem;
            font-weight: 500;
            margin-bottom: 2rem;
        }

        .alert-error {
            background: rgba(220, 38, 38, 0.1);
            border: 1px solid rgba(220, 38, 38, 0.4);
            color: #ef4444;
        }

        .form-group {
            margin-bottom: 1.5rem;
        }

        .form-group label {
            display: block;
            font-size: 0.75rem;
            font-weight: 700;
            color: #e0e0e0;
            margin-bottom: 0.6rem;
            letter-spacing: 0.5px;
            text-transform: uppercase;
        }

        .input-wrapper {
            position: relative;
        }

        .input-icon {
            position: absolute;
            left: 1.2rem;
            top: 50%;
            transform: translateY(-50%);
            color: var(--muted);
            font-size: 1.1rem;
            pointer-events: none;
        }
        
        .input-icon-right {
            left: auto;
            right: 1.2rem;
            cursor: pointer;
            pointer-events: auto;
            color: var(--muted);
        }

        .input-icon-right:hover {
            color: var(--white);
        }

        /* Dark Input Fields */
        .form-group input {
            width: 100%;
            padding: 1rem 1rem 1rem 3.2rem;
            background: rgba(10, 10, 10, 0.8);
            border: 1px solid rgba(255, 255, 255, 0.1);
            border-radius: 12px;
            color: var(--white);
            font-size: 0.95rem;
            font-family: var(--font);
            outline: none;
            transition: all 0.3s;
        }

        /* Fix for Chrome Webkit Autofill white background */
        input:-webkit-autofill,
        input:-webkit-autofill:hover, 
        input:-webkit-autofill:focus, 
        input:-webkit-autofill:active{
            -webkit-box-shadow: 0 0 0 30px #111111 inset !important;
            -webkit-text-fill-color: white !important;
            transition: background-color 5000s ease-in-out 0s;
        }

        .form-group input::placeholder {
            color: #666;
        }

        /* Orange Outline and Shadow on Focus */
        .form-group input:focus {
            border-color: rgba(255, 94, 0, 0.8);
            background: rgba(255, 94, 0, 0.1);
            box-shadow: 0 0 15px rgba(255, 94, 0, 0.2);
        }

        .form-options {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 2rem;
            font-size: 0.9rem;
        }

        .checkbox-label {
            display: flex;
            align-items: center;
            gap: 0.6rem;
            color: #d0d0d0;
            cursor: pointer;
        }

        .checkbox-label input[type="checkbox"] {
            appearance: none;
            width: 16px;
            height: 16px;
            border: 1px solid rgba(255,255,255,0.3);
            border-radius: 4px;
            background: rgba(0,0,0,0.5);
            cursor: pointer;
            position: relative;
            transition: all 0.2s;
        }

        .checkbox-label input[type="checkbox"]:checked {
            background: var(--orange);
            border-color: var(--orange);
            box-shadow: 0 0 10px rgba(255,94,0,0.4);
        }

        .checkbox-label input[type="checkbox"]:checked::after {
            content: '\f00c'; /* FontAwesome check */
            font-family: 'Font Awesome 6 Free';
            font-weight: 900;
            position: absolute;
            color: white;
            font-size: 10px;
            top: 50%; left: 50%;
            transform: translate(-50%, -50%);
        }

        .forgot-link {
            color: var(--orange);
            text-decoration: none;
            transition: opacity 0.2s;
            font-weight: 500;
        }
        
        .forgot-link:hover { opacity: 0.8; text-shadow: 0 0 8px rgba(255,94,0,0.5); }

        /* Animated Button Hover */
        .btn-submit {
            width: 100%;
            padding: 1.1rem;
            background: linear-gradient(90deg, var(--orange), var(--orange-hover));
            color: white;
            border: none;
            border-radius: 12px;
            font-size: 1.05rem;
            font-weight: 600;
            font-family: var(--font);
            cursor: pointer;
            transition: all 0.3s ease;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 0.6rem;
            position: relative;
            overflow: hidden;
        }

        .btn-submit::after {
            content: '';
            position: absolute;
            top: 0; left: -100%;
            width: 50%; height: 100%;
            background: linear-gradient(90deg, transparent, rgba(255,255,255,0.3), transparent);
            transform: skewX(-20deg);
            transition: all 0.5s ease;
        }

        .btn-submit:hover {
            transform: translateY(-3px);
            box-shadow: 0 10px 25px rgba(255, 94, 0, 0.5);
        }

        .btn-submit:hover::after {
            left: 150%;
        }

        .divider {
            display: flex;
            align-items: center;
            margin: 2rem 0;
        }

        .divider hr {
            flex: 1;
            border: none;
            border-top: 1px solid rgba(255,255,255,0.1);
        }

        .divider span {
            padding: 0 1rem;
            color: #777;
            font-size: 0.75rem;
            font-weight: 600;
        }

        .form-footer {
            text-align: center;
            font-size: 0.9rem;
            color: var(--muted);
        }

        .form-footer a {
            color: var(--orange);
            text-decoration: none;
            font-weight: 600;
            margin-left: 0.3rem;
            transition: all 0.2s;
        }
        
        .form-footer a:hover { 
            text-decoration: underline;
            text-shadow: 0 0 10px rgba(255,94,0,0.5);
        }

        /* Responsive Layout */
        @media (max-width: 1200px) {
            .left-content { padding: 4rem 3rem; flex: 0 0 55%; }
            .right-content { padding-right: 3rem; flex: 0 0 45%; }
            .hero-title { font-size: 3.5rem; }
        }

        @media (max-width: 992px) {
            .container { flex-direction: column; justify-content: center; overflow-y: auto; height: auto; min-height: 100vh; }
            .left-content { flex: none; width: 100%; text-align: center; padding: 3rem 2rem 1rem; align-items: center; }
            .right-content { flex: none; width: 100%; padding: 2rem; justify-content: center; padding-right: 2rem; }
            .stats-row { justify-content: center; gap: 2rem; }
            .overlay { background: rgba(0,0,0,0.75); }
            .logo-wrap { justify-content: center; }
            .hero-desc { text-align: center; }
            .glass-card { margin-bottom: 2rem; }
        }
    </style>
</head>
<body>

    <!-- Full-screen Background Image -->
    <img src="${pageContext.request.contextPath}/images/bg-img2.png.png" alt="Background" class="bg-image">
    <div class="overlay"></div>

    <div class="container">
        
        <!-- Left Side Content (60%) -->
        <div class="left-content">
            <div class="logo-wrap">
                <i class="fa-solid fa-location-dot" style="font-size: 2rem; color: #ff5e00;"></i>
                <div class="logo-text">Plate<span>Hop</span></div>
            </div>

            <h1 class="hero-title">
                Food That Hits<br><span class="highlight">Different.</span>
            </h1>

            <p class="hero-desc">
                Crispy layers, bold flavors, and crave-worthy meals delivered to your door in 30 minutes.
            </p>

            <div class="delivery-badge">
                <i class="fa-solid fa-bolt"></i> Deliver in 30 Min • Super Fast Delivery
            </div>

            <div class="stats-row">
                <div class="stat-item">
                    <div class="stat-icon"><i class="fa-solid fa-store"></i></div>
                    <div class="stat-val">50+</div>
                    <div class="stat-lbl">Restaurants</div>
                </div>
                <div class="stat-item">
                    <div class="stat-icon"><i class="fa-regular fa-face-smile"></i></div>
                    <div class="stat-val">1K+</div>
                    <div class="stat-lbl">Happy Users</div>
                </div>
                <div class="stat-item">
                    <div class="stat-icon"><i class="fa-solid fa-motorcycle"></i></div>
                    <div class="stat-val">30m</div>
                    <div class="stat-lbl">Avg. Delivery</div>
                </div>
            </div>
        </div>

        <!-- Right Side (40%) -->
        <div class="right-content">
            <div class="glass-card">
                <div class="form-header">
                    <h2>Welcome Back <i class="fa-solid fa-hand-wave" style="color: #FFD43B;"></i>👋</h2>
                    <p>Login to order your favorite food fast.</p>
                </div>

                <%
                    String errorMsg = (String) request.getAttribute("errorMessage");
                    String successMsg = request.getParameter("success");
                    
                    if (errorMsg != null) {
                %>
                    <div class="alert-message alert-error">
                        <i class="fa-solid fa-circle-exclamation"></i>
                        <%= errorMsg %>
                    </div>
                <% } else if (successMsg != null && successMsg.equals("logout")) { %>
                    <div class="alert-message">
                        <i class="fa-regular fa-circle-check"></i>
                        You have successfully logged out.
                    </div>
                <% } %>

                <form action="LoginServlet" method="post">
                    <div class="form-group">
                        <label for="email">Email Address</label>
                        <div class="input-wrapper">
                            <i class="fa-regular fa-envelope input-icon"></i>
                            <input type="email" id="email" name="email" placeholder="ram@gmail.com" required>
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="password">Password</label>
                        <div class="input-wrapper">
                            <i class="fa-solid fa-lock input-icon"></i>
                            <input type="password" id="password" name="password" placeholder="••••••••" required>
                            <i class="fa-regular fa-eye-slash input-icon-right" title="Toggle Visibility"></i>
                        </div>
                    </div>

                    <div class="form-options">
                        <label class="checkbox-label">
                            <input type="checkbox" name="remember">
                            Remember me
                        </label>
                        <a href="#" class="forgot-link">Forgot password?</a>
                    </div>

                    <button type="submit" class="btn-submit">
                        Login to PlateHop <i class="fa-solid fa-arrow-right"></i>
                    </button>
                </form>

                <div class="divider">
                    <hr><span>OR</span><hr>
                </div>

                <div class="form-footer">
                    Don't have an account? <a href="register.jsp">Create one free <i class="fa-solid fa-arrow-right"></i></a>
                </div>
            </div>
        </div>

    </div>

</body>
</html>
