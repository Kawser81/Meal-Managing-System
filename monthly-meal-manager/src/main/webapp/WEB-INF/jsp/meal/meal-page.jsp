<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Meal Manager – ${month.monthName}</title>
    <style>
        * { box-sizing: border-box; margin: 0; padding: 0; }
        body { font-family: 'Segoe UI', sans-serif; background: #f0f4f8; }

        nav {
            background: #1a202c; color: white;
            padding: 1rem 2rem;
            display: flex; justify-content: space-between; align-items: center;
        }
        nav h1 { font-size: 1.2rem; }
        nav .nav-links {
            display: flex; gap: 1.5rem; align-items: center;
        }
        nav a {
            color: #90cdf4; text-decoration: none;
            font-size: 0.875rem;
        }
        nav a:hover { color: #fff; }

        .container { padding: 2rem; max-width: 900px; margin: 0 auto; }
        h2 { color: #1a202c; margin-bottom: 1.5rem; font-size: 1.4rem; }

        .error-box {
            background: #fff5f5; border: 1px solid #fc8181;
            color: #c53030; padding: 1rem; border-radius: 8px; margin-bottom: 1rem;
        }

        .table-wrapper {
            overflow-x: auto; border-radius: 10px;
            box-shadow: 0 2px 12px rgba(0,0,0,0.08);
        }

        table {
            border-collapse: collapse; width: 100%;
            background: white; min-width: 400px;
        }

        thead { background: #2d3748; color: white; }
        thead th {
            padding: 0.75rem 0.6rem; text-align: center;
            font-size: 0.8rem; font-weight: 600; white-space: nowrap;
        }
        thead th:first-child { text-align: left; padding-left: 1rem; }

        tbody tr:nth-child(even) { background: #f7fafc; }
        tbody tr:hover { background: #ebf4ff; }

        td {
            padding: 0.55rem 0.5rem; text-align: center;
            font-size: 0.85rem; border-bottom: 1px solid #e2e8f0;
            vertical-align: middle;
        }
        td:first-child {
            text-align: left; font-weight: 600;
            color: #2d3748; min-width: 90px;
            padding-left: 1rem;
        }

        .day-label {
            display: block; font-size: 0.65rem; font-weight: 400;
            color: #718096; text-transform: uppercase; letter-spacing: 0.05em;
        }

        /* Inline counter widget */
        .meal-cell { display: flex; align-items: center; justify-content: center; gap: 3px; }

        .count-display {
            display: inline-block; min-width: 24px;
            font-weight: 700; font-size: 0.95rem;
            color: #2b6cb0; text-align: center;
        }
        .count-zero { color: #a0aec0; }

        .btn-plus, .btn-minus {
            width: 22px; height: 22px; border-radius: 50%;
            border: none; cursor: pointer;
            font-size: 0.9rem; font-weight: 700;
            display: flex; align-items: center; justify-content: center;
            line-height: 1; transition: background 0.15s;
        }
        .btn-plus  { background: #c6f6d5; color: #276749; }
        .btn-plus:hover  { background: #9ae6b4; }
        .btn-minus { background: #fed7d7; color: #9b2c2c; }
        .btn-minus:hover { background: #fc8181; }

        /* hide manager controls for non-managers */
        .manager-only { display: none; }
        body.is-manager .manager-only { display: flex; }

        tfoot td {
            padding: 0.65rem 0.5rem; font-weight: 700;
            background: #edf2f7; text-align: center;
            font-size: 0.85rem; border-top: 2px solid #cbd5e0;
        }
        tfoot td:first-child { text-align: left; padding-left: 1rem; }

        /* Toast notification */
        #toast {
            position: fixed; bottom: 2rem; right: 2rem;
            background: #48bb78; color: white;
            padding: 0.75rem 1.5rem; border-radius: 8px;
            font-size: 0.875rem; font-weight: 600;
            opacity: 0; transition: opacity 0.3s;
            pointer-events: none; z-index: 999;
        }
        #toast.show { opacity: 1; }
        #toast.error { background: #fc8181; }
    </style>
</head>
<body class="${isManager ? 'is-manager' : ''}">

<nav>
    <h1>🍽 Meal Manager – <c:out value="${month.monthName}"/></h1>
    <div class="nav-links">
        <a href="/chat">Chat</a>
        <a href="/dashboard">Dashboard</a>
        <a href="/deposit">Deposits</a>
        <a href="/meal-cost">Meal Cost</a>
        <a href="/combined-cost">Combined Cost</a>
        <a href="/protein">Protein Tracker</a>
        <a href="/summary">Summary</a>
        <a href="/logout">Logout</a>
    </div>
</nav>

<div class="container">
    <h2>Meal Entry Table</h2>

    <c:if test="${not empty error}">
        <div class="error-box">${error}</div>
    </c:if>

    <c:if test="${not empty dates}">
        <div class="table-wrapper">
            <table>
                <thead>
                    <tr>
                        <th>Date</th>
                        <c:forEach var="user" items="${users}">
                            <th>${user.name}</th>
                        </c:forEach>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="date" items="${dates}">
                        <tr>
                            <td>
                                ${date}
                                <span class="day-label">
                                    <fmt:parseDate value="${date}" pattern="yyyy-MM-dd" var="parsedDate" type="date"/>
                                    <fmt:formatDate value="${parsedDate}" pattern="EEEE"/>
                                </span>
                            </td>
                            <c:forEach var="user" items="${users}">
                                <c:set var="key" value="${user.id}_${date}"/>
                                <c:set var="entry" value="${mealMap[key]}"/>
                                <c:set var="count" value="${not empty entry ? entry.mealCount : 0}"/>
                                <c:set var="entryId" value="${not empty entry ? entry.id : ''}"/>
                                <td>
                                    <div class="meal-cell">
                                        <button class="btn-minus manager-only"
                                                onclick="updateMeal(this, ${user.id}, '${date}', -1)"
                                                title="Decrease">−</button>

                                        <span class="count-display ${count == 0 ? 'count-zero' : ''}"
                                              data-count="${count}"
                                              data-user="${user.id}"
                                              data-date="${date}"
                                              data-id="${entryId}">
                                            ${count}
                                        </span>

                                        <button class="btn-plus manager-only"
                                                onclick="updateMeal(this, ${user.id}, '${date}', 1)"
                                                title="Increase">+</button>
                                    </div>
                                </td>
                            </c:forEach>
                        </tr>
                    </c:forEach>
                </tbody>

                <tfoot>
                    <tr>
                        <td>Total</td>
                        <c:forEach var="user" items="${users}">
                            <td id="total-${user.id}">
                                <c:set var="total" value="0"/>
                                <c:forEach var="date" items="${dates}">
                                    <c:set var="key" value="${user.id}_${date}"/>
                                    <c:set var="entry" value="${mealMap[key]}"/>
                                    <c:if test="${not empty entry}">
                                        <c:set var="total" value="${total + entry.mealCount}"/>
                                    </c:if>
                                </c:forEach>
                                ${total}
                            </td>
                        </c:forEach>
                    </tr>
                </tfoot>
            </table>
        </div>
    </c:if>
</div>

<div id="toast"></div>

<script>
    function updateMeal(btn, userId, date, delta) {
        const cell = btn.closest('.meal-cell');
        const span = cell.querySelector('.count-display');

        let current = parseInt(span.dataset.count) || 0;
        let newCount = current + delta;
        if (newCount < 0) newCount = 0;

        span.textContent = newCount;
        span.dataset.count = newCount;
        span.className = 'count-display' + (newCount === 0 ? ' count-zero' : '');

        updateTotal(userId);

        const params = new URLSearchParams();
        params.append('userId', userId);
        params.append('date', date);
        params.append('mealCount', newCount);

        fetch('/meal/save', {
            method: 'POST',
            headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
            body: params.toString()
        })
        .then(res => {
            if (res.ok || res.redirected) {
                showToast('Saved ✓', false);
            } else {
                showToast('Error saving!', true);
                span.textContent = current;
                span.dataset.count = current;
                updateTotal(userId);
            }
        })
        .catch(() => {
            showToast('Network error!', true);
            span.textContent = current;
            span.dataset.count = current;
            updateTotal(userId);
        });
    }

    function updateTotal(userId) {
        const spans = document.querySelectorAll(`.count-display[data-user="${userId}"]`);
        let sum = 0;
        spans.forEach(s => sum += parseInt(s.dataset.count) || 0);
        const totalCell = document.getElementById('total-' + userId);
        if (totalCell) totalCell.textContent = sum;
    }

    function showToast(msg, isError) {
        const t = document.getElementById('toast');
        t.textContent = msg;
        t.className = 'show' + (isError ? ' error' : '');
        clearTimeout(window._toastTimer);
        window._toastTimer = setTimeout(() => t.className = '', 2000);
    }
</script>

</body>
</html>