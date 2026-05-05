<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Dashboard – Meal Manager</title>
    <style>
        * { box-sizing: border-box; margin: 0; padding: 0; }
        body { font-family: 'Segoe UI', sans-serif; background: #f0f4f8; min-height: 100vh; }

        nav {
            background: #1a202c; color: white;
            padding: 1rem 2rem;
            display: flex; justify-content: space-between; align-items: center;
        }
        nav h1 { font-size: 1.2rem; }
        nav .nav-links { display: flex; gap: 1.5rem; align-items: center; }
        nav a { color: #90cdf4; text-decoration: none; font-size: 0.875rem; }
        nav a:hover { color: #fff; }

        .container { padding: 2rem; max-width: 960px; margin: 0 auto; }

        /* ── Welcome banner ── */
        .welcome-banner {
            background: linear-gradient(135deg, #1a202c, #2d3748);
            border-radius: 12px;
            padding: 2rem 2.5rem;
            color: white;
            display: flex; justify-content: space-between; align-items: center;
            box-shadow: 0 4px 15px rgba(0,0,0,0.15);
            margin-bottom: 2rem;
        }
        .welcome-banner .welcome-text h2 {
            font-size: 1.6rem; font-weight: 800; margin-bottom: 0.3rem;
        }
        .welcome-banner .welcome-text p { color: #a0aec0; font-size: 0.9rem; }
        .welcome-banner .role-badge {
            background: rgba(255,255,255,0.1);
            border-radius: 20px; padding: 0.4rem 1.2rem;
            font-size: 0.85rem; font-weight: 600; color: #90cdf4;
        }

        /* ── Quick nav cards ── */
        .nav-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(200px, 1fr));
            gap: 1rem;
            margin-bottom: 2rem;
        }
        .nav-card {
            background: white; border-radius: 10px;
            padding: 1.25rem 1.5rem;
            box-shadow: 0 2px 10px rgba(0,0,0,0.07);
            text-decoration: none; color: #2d3748;
            display: flex; align-items: center; gap: 0.85rem;
            transition: transform 0.15s, box-shadow 0.15s;
        }
        .nav-card:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(0,0,0,0.1);
        }
        .nav-card .icon {
            font-size: 1.5rem; width: 42px; height: 42px;
            border-radius: 10px;
            display: flex; align-items: center; justify-content: center;
        }
        .icon-meal     { background: #ebf8ff; }
        .icon-deposit  { background: #f0fff4; }
        .icon-mealcost { background: #fffaf0; }
        .icon-combined { background: #faf5ff; }
        .icon-protein  { background: #fff5f5; }
        .icon-summary  { background: #e6fffa; }
        .nav-card .card-label { font-weight: 600; font-size: 0.9rem; }
        .nav-card .card-sub   { font-size: 0.75rem; color: #718096; margin-top: 0.1rem; }

        /* ── Manager panel ── */
        .panel {
            background: white; border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.07);
            overflow: hidden; margin-bottom: 2rem;
        }
        .panel-header {
            background: #2d3748; color: white;
            padding: 0.85rem 1.25rem;
            font-weight: 700; font-size: 0.95rem;
        }
        .panel-body { padding: 1.25rem; }

        .manager-table {
            width: 100%; border-collapse: collapse; font-size: 0.875rem;
        }
        .manager-table thead th {
            background: #edf2f7; color: #4a5568;
            padding: 0.65rem 1rem; text-align: left;
            font-size: 0.78rem; font-weight: 600;
            text-transform: uppercase; letter-spacing: 0.04em;
            border-bottom: 2px solid #e2e8f0;
        }
        .manager-table tbody tr:hover { background: #f7fafc; }
        .manager-table td {
            padding: 0.65rem 1rem;
            border-bottom: 1px solid #e2e8f0; color: #2d3748;
        }

        .role-chip {
            display: inline-block; padding: 0.15rem 0.65rem;
            border-radius: 12px; font-size: 0.75rem; font-weight: 700;
        }
        .chip-manager { background: #fefcbf; color: #744210; }
        .chip-viewer  { background: #e2e8f0; color: #4a5568; }

        .btn-role {
            padding: 0.3rem 0.85rem;
            border: none; border-radius: 6px;
            font-size: 0.78rem; font-weight: 600; cursor: pointer;
        }
        .btn-make-manager { background: #fefcbf; color: #744210; }
        .btn-make-manager:hover { background: #faf089; }
        .btn-make-viewer  { background: #e2e8f0; color: #4a5568; }
        .btn-make-viewer:hover  { background: #cbd5e0; }

        .self-tag {
            font-size: 0.72rem; color: #a0aec0;
            margin-left: 0.4rem;
        }
    </style>
</head>
<body>

<nav>
    <h1>🍽 Meal Manager</h1>
    <div class="nav-links">
        <a href="/chat">Chat</a>
        <a href="/meal">Meal Count</a>
        <a href="/deposit">Deposits</a>
        <a href="/meal-cost">Meal Cost</a>
        <a href="/combined-cost">Combined Cost</a>
        <a href="/protein">Protein Tracker</a>
        <a href="/summary">Summary</a>
        <a href="/logout">Logout</a>
    </div>
</nav>

<div class="container">

    <%-- ── Welcome banner ── --%>
    <div class="welcome-banner">
        <div class="welcome-text">
            <h2>Welcome, ${name}! 👋</h2>
            <p>
                <c:choose>
                    <c:when test="${not empty month}">Active month: <strong>${month.monthName}</strong></c:when>
                    <c:otherwise>No active month at the moment.</c:otherwise>
                </c:choose>
            </p>
        </div>
        <span class="role-badge">
            <c:choose>
                <c:when test="${isAdmin}">⚙️ Admin</c:when>
                <c:when test="${isManager}">🔑 Manager</c:when>
                <c:otherwise>👁 Viewer</c:otherwise>
            </c:choose>
        </span>
    </div>

    <%-- ── Quick nav ── --%>
    <div class="nav-grid">
        <a href="/meal" class="nav-card">
            <div class="icon icon-meal">🍽</div>
            <div><div class="card-label">Meal Count</div><div class="card-sub">Daily entries</div></div>
        </a>
        <a href="/deposit" class="nav-card">
            <div class="icon icon-deposit">💰</div>
            <div><div class="card-label">Deposits</div><div class="card-sub">Fund tracking</div></div>
        </a>
        <a href="/meal-cost" class="nav-card">
            <div class="icon icon-mealcost">🧾</div>
            <div><div class="card-label">Meal Cost</div><div class="card-sub">Per meal expenses</div></div>
        </a>
        <a href="/combined-cost" class="nav-card">
            <div class="icon icon-combined">🏠</div>
            <div><div class="card-label">Combined Cost</div><div class="card-sub">Shared expenses</div></div>
        </a>
        <a href="/protein" class="nav-card">
            <div class="icon icon-protein">🍗</div>
            <div><div class="card-label">Protein Tracker</div><div class="card-sub">Stock management</div></div>
        </a>
        <a href="/summary" class="nav-card">
            <div class="icon icon-summary">📊</div>
            <div><div class="card-label">Summary</div><div class="card-sub">Full breakdown</div></div>
        </a>
    </div>

    <%-- ── Manager Role Panel (admin only) ── --%>
    <c:if test="${isAdmin}">
        <div class="panel">
            <div class="panel-header">⚙️ Manage Roles — ${month.monthName}</div>
            <div class="panel-body">
                <c:if test="${not empty error}">
                    <div style="background:#fff5f5;border:1px solid #fc8181;color:#c53030;
                                padding:0.75rem 1rem;border-radius:8px;margin-bottom:1rem;font-size:0.875rem;">
                        ${error}
                    </div>
                </c:if>
                <table class="manager-table">
                    <thead>
                        <tr>
                            <th>#</th>
                            <th>Name</th>
                            <th>Email</th>
                            <th>Current Role</th>
                            <th>Action</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="entry" items="${userRoles}" varStatus="st">
                            <tr>
                                <td>${st.index + 1}</td>
                                <td>
                                    ${entry.user.name}
                                    <c:if test="${entry.user.id == currentUserId}">
                                        <span class="self-tag">(you)</span>
                                    </c:if>
                                </td>
                                <td style="color:#718096">${entry.user.email}</td>
                                <td>
                                    <c:choose>
                                        <c:when test="${entry.role == 'MANAGER'}">
                                            <span class="role-chip chip-manager">🔑 Manager</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="role-chip chip-viewer">👁 Viewer</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <c:choose>
                                        <c:when test="${entry.role == 'MANAGER'}">
                                            <form action="/dashboard/role/update" method="post" style="display:inline">
                                                <input type="hidden" name="userId"  value="${entry.user.id}"/>
                                                <input type="hidden" name="newRole" value="VIEWER"/>
                                                <button type="submit" class="btn-role btn-make-viewer"
                                                        onclick="return confirm('Demote ${entry.user.name} to Viewer?')">
                                                    → Make Viewer
                                                </button>
                                            </form>
                                        </c:when>
                                        <c:otherwise>
                                            <form action="/dashboard/role/update" method="post" style="display:inline">
                                                <input type="hidden" name="userId"  value="${entry.user.id}"/>
                                                <input type="hidden" name="newRole" value="MANAGER"/>
                                                <button type="submit" class="btn-role btn-make-manager"
                                                        onclick="return confirm('Promote ${entry.user.name} to Manager?')">
                                                    → Make Manager
                                                </button>
                                            </form>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
        </div>
    </c:if>

</div>
</body>
</html>