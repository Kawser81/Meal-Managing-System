<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login – Meal Manager</title>
    <style>
        * { box-sizing: border-box; margin: 0; padding: 0; }
        body {
            font-family: 'Segoe UI', sans-serif;
            background: #f0f4f8;
            display: flex; justify-content: center; align-items: center;
            min-height: 100vh;
        }
        .card {
            background: #fff; padding: 2.5rem 2rem;
            border-radius: 12px; box-shadow: 0 4px 24px rgba(0,0,0,0.09);
            width: 100%; max-width: 400px;
        }
        .card h2 { text-align: center; margin-bottom: 1.5rem; color: #1a202c; font-size: 1.6rem; }
        .form-group { margin-bottom: 1.2rem; }
        label { display: block; margin-bottom: 0.4rem; font-size: 0.875rem; font-weight: 600; color: #4a5568; }
        input[type="email"], input[type="password"] {
            width: 100%; padding: 0.65rem 0.9rem;
            border: 1px solid #cbd5e0; border-radius: 7px;
            font-size: 0.95rem; outline: none;
        }
        input:focus { border-color: #4f8ef7; box-shadow: 0 0 0 3px rgba(79,142,247,0.15); }
        button[type="submit"] {
            width: 100%; padding: 0.75rem; background: #4f8ef7;
            color: white; font-size: 1rem; font-weight: 600;
            border: none; border-radius: 7px; cursor: pointer; margin-top: 0.5rem;
        }
        button[type="submit"]:hover { background: #3a7be0; }
        .alert { padding: 0.65rem 0.9rem; border-radius: 7px; font-size: 0.875rem; margin-bottom: 1.2rem; }
        .alert-error   { background: #fff5f5; border: 1px solid #fc8181; color: #c53030; }
        .alert-success { background: #f0fff4; border: 1px solid #68d391; color: #276749; }
        .footer-text { text-align: center; margin-top: 1.2rem; font-size: 0.85rem; color: #718096; }
        .footer-text a { color: #4f8ef7; text-decoration: none; }
    </style>
</head>
<body>
<div class="card">
    <h2>🍽 Meal Manager</h2>

    <c:if test="${not empty error}">
        <div class="alert alert-error">⚠ ${error}</div>
    </c:if>
    <c:if test="${param.registered == 'true'}">
        <div class="alert alert-success">✅ Account created! Please sign in.</div>
    </c:if>

    <form action="/login" method="post">
        <div class="form-group">
            <label for="email">Email</label>
            <input type="email" id="email" name="email"
                   placeholder="you@example.com" required autofocus />
        </div>
        <div class="form-group">
            <label for="password">Password</label>
            <input type="password" id="password" name="password"
                   placeholder="••••••••" required />
        </div>
        <button type="submit">Sign In</button>
    </form>

</div>
</body>
</html>