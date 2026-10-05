<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.project.platehop.model.User" %>
<%
    User loggedInUser = (User) session.getAttribute("loggedInUser");
    Integer orderId = (Integer) request.getAttribute("orderId");
    if (loggedInUser == null || orderId == null) {
        response.sendRedirect("index.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Order Confirmed - Platehop</title>
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;500;600;700;800;900&display=swap" rel="stylesheet">
    <style>
        *, *::before, *::after { margin: 0; padding: 0; box-sizing: border-box; }
        :root {
            --bg: #0a0a0a; --surface: #111; --surface2: #181818;
            --orange: #ff6a00; --orange2: #ff9a3c; --orange-glow: rgba(255,106,0,0.12);
            --white: #fff; --text: #e0e0e0; --muted: #666; --border: rgba(255,255,255,0.07);
            --green: #22c55e; --font: 'Outfit', sans-serif;
        }
        body {
            background: var(--bg); font-family: var(--font); color: var(--text);
            min-height: 100vh; display: flex; align-items: center; justify-content: center;
            padding: 2rem; position: relative; overflow: hidden;
        }
        body::before {
            content: ''; position: absolute; inset: 0;
            background: radial-gradient(ellipse at 50% 40%, rgba(34,197,94,0.12) 0%, transparent 60%),
                        radial-gradient(ellipse at 80% 80%, rgba(255,106,0,0.08) 0%, transparent 50%);
        }

        .confirm-card {
            background: var(--surface2); border: 1px solid var(--border);
            border-radius: 28px; padding: 3.5rem 3rem;
            text-align: center; max-width: 520px; width: 100%;
            position: relative; z-index: 1; overflow: hidden;
        }
        .confirm-card::before {
            content: ''; position: absolute; top: 0; left: 0; right: 0; height: 4px;
            background: linear-gradient(90deg, var(--green), #4ade80);
        }

        /* Animated checkmark */
        .check-wrap {
            width: 100px; height: 100px; border-radius: 50%;
            background: rgba(34,197,94,0.12); border: 2px solid rgba(34,197,94,0.3);
            display: flex; align-items: center; justify-content: center;
            margin: 0 auto 2rem; font-size: 3rem;
            animation: popIn 0.6s cubic-bezier(0.175, 0.885, 0.32, 1.275) both;
        }
        @keyframes popIn {
            0% { transform: scale(0); opacity: 0; }
            100% { transform: scale(1); opacity: 1; }
        }

        .confirm-title {
            font-size: 2.2rem; font-weight: 900; color: #fff;
            letter-spacing: -1px; margin-bottom: 0.8rem;
            animation: fadeUp 0.5s ease 0.2s both;
        }
        .confirm-desc {
            color: var(--muted); font-size: 1rem; line-height: 1.6;
            margin-bottom: 2rem; animation: fadeUp 0.5s ease 0.3s both;
        }
        .confirm-desc strong { color: var(--white); }

        .order-id-box {
            background: var(--bg); border: 1.5px dashed rgba(255,106,0,0.3);
            border-radius: 14px; padding: 1.2rem 2rem;
            margin-bottom: 2rem; animation: fadeUp 0.5s ease 0.4s both;
        }
        .order-id-lbl { color: var(--muted); font-size: 0.75rem; font-weight: 700; text-transform: uppercase; letter-spacing: 1px; margin-bottom: 0.4rem; }
        .order-id-val { color: var(--orange2); font-size: 1.8rem; font-weight: 900; letter-spacing: -0.5px; }

        .eta-box {
            display: flex; align-items: center; justify-content: center; gap: 1rem;
            background: rgba(34,197,94,0.07); border: 1px solid rgba(34,197,94,0.2);
            border-radius: 14px; padding: 1rem 1.5rem; margin-bottom: 2rem;
            animation: fadeUp 0.5s ease 0.45s both;
        }
        .eta-icon { font-size: 1.5rem; }
        .eta-text { text-align: left; }
        .eta-label { color: var(--muted); font-size: 0.78rem; font-weight: 600; text-transform: uppercase; letter-spacing: 0.8px; }
        .eta-val { color: var(--green); font-size: 1.2rem; font-weight: 800; }

        .action-btns { display: flex; gap: 0.8rem; animation: fadeUp 0.5s ease 0.5s both; }
        .btn-primary {
            flex: 1; display: inline-flex; align-items: center; justify-content: center; gap: 0.4rem;
            background: linear-gradient(135deg, var(--orange), var(--orange2));
            color: white; padding: 1rem; border-radius: 14px;
            font-size: 0.95rem; font-weight: 700; text-decoration: none;
            transition: all 0.3s; box-shadow: 0 8px 25px rgba(255,106,0,0.3);
        }
        .btn-primary:hover { transform: translateY(-2px); box-shadow: 0 14px 35px rgba(255,106,0,0.5); }
        .btn-secondary {
            flex: 1; display: inline-flex; align-items: center; justify-content: center;
            background: var(--bg); color: var(--text);
            padding: 1rem; border-radius: 14px; border: 1px solid var(--border);
            font-size: 0.95rem; font-weight: 600; text-decoration: none; transition: all 0.3s;
        }
        .btn-secondary:hover { border-color: rgba(255,255,255,0.2); color: #fff; }

        @keyframes fadeUp {
            from { opacity: 0; transform: translateY(20px); }
            to { opacity: 1; transform: translateY(0); }
        }
    </style>
</head>
<body>
    <div class="confirm-card">
        <div class="check-wrap">✅</div>
        <h1 class="confirm-title">Order Placed!</h1>
        <p class="confirm-desc">
            Thank you, <strong><%= loggedInUser.getUserName() %></strong>!<br>
            Your order is being prepared and will be delivered soon.
        </p>

        <div class="order-id-box">
            <div class="order-id-lbl">Order Reference</div>
            <div class="order-id-val">#<%= orderId %></div>
        </div>

        <div class="eta-box">
            <span class="eta-icon">⚡</span>
            <div class="eta-text">
                <div class="eta-label">Estimated Delivery</div>
                <div class="eta-val">30 minutes</div>
            </div>
        </div>

        <div class="action-btns">
            <a href="restaurants" class="btn-primary">🍔 Order Again</a>
            <a href="index.jsp" class="btn-secondary">🏠 Home</a>
        </div>
    </div>
</body>
</html>
