<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Deposits – ${month.monthName}</title>
    <style>
        * { box-sizing: border-box; margin: 0; padding: 0; }
        body { font-family: 'Segoe UI', sans-serif; background: #f0f4f8; }

        nav {
            background: #1a202c; color: white;
            padding: 1rem 2rem;
            display: flex; justify-content: space-between; align-items: center;
        }
        nav h1 { font-size: 1.2rem; }
        nav a { color: #90cdf4; text-decoration: none; font-size: 0.875rem; margin-left: 1rem; }

        .container { padding: 2rem; max-width: 960px; margin: 0 auto; }

        h2 { color: #1a202c; margin-bottom: 1.5rem; font-size: 1.4rem; }

        .error-box {
            background: #fff5f5; border: 1px solid #fc8181;
            color: #c53030; padding: 1rem; border-radius: 8px; margin-bottom: 1rem;
        }

        /* ── Add deposit form (manager only) ── */
        .add-form {
            background: white; border-radius: 10px;
            padding: 1.5rem; margin-bottom: 2rem;
            box-shadow: 0 2px 10px rgba(0,0,0,0.07);
        }
        .add-form h3 { margin-bottom: 1rem; color: #2d3748; font-size: 1rem; }
        .form-row { display: flex; gap: 0.75rem; flex-wrap: wrap; align-items: flex-end; }
        .form-group { display: flex; flex-direction: column; gap: 0.3rem; }
        .form-group label { font-size: 0.8rem; font-weight: 600; color: #4a5568; }
        .form-group select,
        .form-group input {
            padding: 0.55rem 0.8rem; border: 1px solid #cbd5e0;
            border-radius: 7px; font-size: 0.9rem; outline: none;
            background: white;
        }
        .form-group select:focus,
        .form-group input:focus { border-color: #4f8ef7; }
        .btn-add {
            padding: 0.55rem 1.4rem; background: #48bb78;
            color: white; border: none; border-radius: 7px;
            font-size: 0.9rem; font-weight: 600; cursor: pointer;
        }
        .btn-add:hover { background: #38a169; }

        /* ── User deposit cards ── */
        .user-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
            gap: 1.25rem;
        }

        .user-card {
            background: white; border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.07);
            overflow: hidden;
        }

        .card-header {
            background: #2d3748; color: white;
            padding: 0.85rem 1.1rem;
            display: flex; justify-content: space-between; align-items: center;
        }
        .card-header .uname { font-weight: 700; font-size: 0.95rem; }
        .card-header .total-badge {
            background: #48bb78; color: white;
            border-radius: 20px; padding: 0.2rem 0.75rem;
            font-size: 0.8rem; font-weight: 700;
        }

        .installments { padding: 0.75rem 1.1rem; }

        .installment-row {
            display: flex; justify-content: space-between; align-items: center;
            padding: 0.5rem 0; border-bottom: 1px solid #f0f4f8;
            font-size: 0.875rem;
        }
        .installment-row:last-child { border-bottom: none; }

        .inst-left { display: flex; flex-direction: column; gap: 2px; }
        .inst-amount { font-weight: 700; color: #276749; }
        .inst-note { font-size: 0.75rem; color: #718096; }
        .inst-time { font-size: 0.72rem; color: #a0aec0; }

        .inst-num {
            background: #ebf8ff; color: #2b6cb0;
            border-radius: 50%; width: 22px; height: 22px;
            display: flex; align-items: center; justify-content: center;
            font-size: 0.7rem; font-weight: 700; flex-shrink: 0;
            margin-right: 0.5rem;
        }

        .inst-right { display: flex; align-items: center; gap: 0.5rem; }

        .btn-del {
            background: #fed7d7; color: #9b2c2c;
            border: none; border-radius: 5px;
            padding: 0.25rem 0.5rem; font-size: 0.72rem;
            font-weight: 600; cursor: pointer;
        }
        .btn-del:hover { background: #fc8181; }

        .no-deposit {
            padding: 0.75rem 1.1rem;
            color: #a0aec0; font-size: 0.85rem; text-align: center;
        }

        .summary-count {
            padding: 0.5rem 1.1rem 0.75rem;
            font-size: 0.75rem; color: #718096;
            border-top: 1px solid #f0f4f8;
        }

        .table-wrapper {
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.07);
            overflow: hidden;
        }

        .summary-table {
            width: 100%;
            border-collapse: collapse;
            background: white;
            font-size: 0.9rem;
        }

        .summary-table thead {
            background: #2d3748;
            color: white;
        }

        .summary-table thead th {
            padding: 0.85rem 1.2rem;
            text-align: left;
            font-weight: 600;
        }

        .summary-table tbody tr:nth-child(even) { background: #f7fafc; }
        .summary-table tbody tr:hover { background: #ebf4ff; }

        .summary-table td {
            padding: 0.75rem 1.2rem;
            border-bottom: 1px solid #e2e8f0;
            color: #2d3748;
        }

        .amount-cell {
            font-weight: 700;
            color: #276749;
        }

        .inst-cell {
            color: #718096;
            font-size: 0.82rem;
        }

        .summary-table tfoot td {
            padding: 0.85rem 1.2rem;
            background: #edf2f7;
            font-weight: 700;
            border-top: 2px solid #cbd5e0;
            color: #1a202c;
        }

        .summary-table tfoot .amount-cell {
            color: #276749;
            font-size: 1rem;
        }
    </style>
</head>
<body>

<nav>
    <h1>💰 Deposits – <c:out value="${month.monthName}"/></h1>
    <div>
        <a href="/chat">Chat</a>
        <a href="/dashboard">Dashboard</a>
        <a href="/meal">Meal Count</a>
        <a href="/meal-cost">Meal Cost</a>
        <a href="/combined-cost">Combined Cost</a>
        <a href="/protein">Protein Tracker</a>
        <a href="/summary">Summary</a>
        <a href="/logout">Logout</a>
    </div>
</nav>

<div class="container">

    <h2>Deposit Management</h2>

    <c:if test="${not empty error}">
        <div class="error-box">${error}</div>
    </c:if>

    <%-- ── Add deposit form (manager only) ── --%>
    <c:if test="${isManager}">
        <div class="add-form">
            <h3>➕ Add Deposit</h3>
            <form action="/deposit/add" method="post">
                <div class="form-row">

                    <div class="form-group">
                        <label>User</label>
                        <select name="userId" required>
                            <c:forEach var="user" items="${users}">
                                <option value="${user.id}">${user.name}</option>
                            </c:forEach>
                        </select>
                    </div>

                    <div class="form-group">
                        <label>Amount (৳)</label>
                        <input type="number" name="amount" min="1" placeholder="e.g. 500" required style="width:120px"/>
                    </div>

                    <div class="form-group">
                        <label>Note (optional)</label>
                        <input type="text" name="note" placeholder="e.g. first installment" style="width:180px"/>
                    </div>

                    <button type="submit" class="btn-add">Add</button>
                </div>
            </form>
        </div>
    </c:if>

    <%-- ── User deposit cards ── --%>
    <div class="user-grid">
        <c:forEach var="user" items="${users}">
            <c:set var="deposits" value="${depositMap[user.id]}"/>
            <c:set var="total"    value="${totalMap[user.id] != null ? totalMap[user.id] : 0}"/>

            <div class="user-card">

                <%-- Card header: name + total --%>
                <div class="card-header">
                    <span class="uname">👤 ${user.name}</span>
                    <span class="total-badge">৳ ${total}</span>
                </div>

                <%-- Installment list --%>
                <c:choose>
                    <c:when test="${not empty deposits}">
                        <div class="installments">
                            <c:forEach var="dep" items="${deposits}" varStatus="status">
                                <div class="installment-row">
                                    <div class="inst-right">
                                        <span class="inst-num">${status.index + 1}</span>
                                        <div class="inst-left">
                                            <span class="inst-amount">৳ ${dep.amount}</span>
                                            <c:if test="${not empty dep.note}">
                                                <span class="inst-note">${dep.note}</span>
                                            </c:if>
                                            <span class="inst-time">
                                                ${dep.createdAt.toString().replace('T', ' ').substring(0, 16)}
                                            </span>
                                        </div>
                                    </div>

                                    <c:if test="${isManager}">
                                        <form action="/deposit/delete" method="post"
                                              onsubmit="return confirm('Delete this deposit?')">
                                            <input type="hidden" name="depositId" value="${dep.id}"/>
                                            <button type="submit" class="btn-del">✕</button>
                                        </form>
                                    </c:if>
                                </div>
                            </c:forEach>
                        </div>

                        <%-- e.g. "Total ৳1000 in 2 installments" --%>
                        <div class="summary-count">
                            Total ৳${total} in
                            <c:choose>
                                <c:when test="${deposits.size() == 1}">1 payment</c:when>
                                <c:otherwise>${deposits.size()} installments</c:otherwise>
                            </c:choose>
                        </div>
                    </c:when>

                    <c:otherwise>
                        <div class="no-deposit">No deposits yet</div>
                    </c:otherwise>
                </c:choose>

            </div>
        </c:forEach>
    </div>

    <%-- ── Summary Table ── --%>
    <h2 style="margin-top: 2.5rem; margin-bottom: 1rem;">Deposit Summary</h2>
    <div class="table-wrapper">
        <table class="summary-table">
            <thead>
                <tr>
                    <th>#</th>
                    <th>Name</th>
                    <th>Total Deposit (৳)</th>
                    <th>Installments</th>
                </tr>
            </thead>
            <tbody>
                <c:set var="grandTotal" value="0"/>
                <c:forEach var="user" items="${users}" varStatus="status">
                    <c:set var="total"    value="${totalMap[user.id] != null ? totalMap[user.id] : 0}"/>
                    <c:set var="deposits" value="${depositMap[user.id]}"/>
                    <c:set var="grandTotal" value="${grandTotal + total}"/>
                    <tr>
                        <td>${status.index + 1}</td>
                        <td>${user.name}</td>
                        <td class="amount-cell">৳ ${total}</td>
                        <td class="inst-cell">
                            <c:choose>
                                <c:when test="${empty deposits}">—</c:when>
                                <c:when test="${deposits.size() == 1}">1 payment</c:when>
                                <c:otherwise>${deposits.size()} installments</c:otherwise>
                            </c:choose>
                        </td>
                    </tr>
                </c:forEach>
            </tbody>
            <tfoot>
                <tr>
                    <td colspan="2">Grand Total</td>
                    <td class="amount-cell">৳ ${grandTotal}</td>
                    <td></td>
                </tr>
            </tfoot>
        </table>
    </div>

</div> <%-- end container --%>

</body>
</html>