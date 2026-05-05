<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Summary – ${month.monthName}</title>
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

        .container { padding: 2rem; max-width: 1000px; margin: 0 auto; }

        .error-box {
            background: #fff5f5; border: 1px solid #fc8181;
            color: #c53030; padding: 1rem; border-radius: 8px; margin-bottom: 1.5rem;
        }

        /* ── Section blocks ── */
        .section { margin-bottom: 2.5rem; }

        .section-title {
            font-size: 1rem; font-weight: 700;
            color: #fff; padding: 0.6rem 1.2rem;
            border-radius: 8px 8px 0 0;
            display: flex; align-items: center; gap: 0.5rem;
        }
        .title-blue   { background: #2b6cb0; }
        .title-teal   { background: #2c7a7b; }
        .title-purple { background: #553c9a; }
        .title-red    { background: #9b2c2c; }

        /* ── Tables ── */
        .table-wrapper {
            border-radius: 0 0 10px 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.07);
            overflow: hidden;
        }

        table {
            width: 100%; border-collapse: collapse;
            background: white; font-size: 0.875rem;
        }

        thead th {
            background: #edf2f7; color: #4a5568;
            padding: 0.7rem 1.1rem; text-align: left;
            font-weight: 600; font-size: 0.78rem;
            text-transform: uppercase; letter-spacing: 0.04em;
            border-bottom: 2px solid #e2e8f0;
        }

        tbody tr:hover { background: #f7fafc; }

        tbody td {
            padding: 0.7rem 1.1rem;
            border-bottom: 1px solid #e2e8f0;
            color: #2d3748;
        }

        tfoot td {
            padding: 0.75rem 1.1rem;
            background: #edf2f7; font-weight: 700;
            border-top: 2px solid #cbd5e0; color: #1a202c;
        }

        /* ── Value styling ── */
        .val-green  { font-weight: 700; color: #276749; }
        .val-red    { font-weight: 700; color: #c53030; }
        .val-blue   { font-weight: 700; color: #2b6cb0; }
        .val-normal { font-weight: 600; color: #2d3748; }

        /* ── Due badge ── */
        .badge {
            display: inline-block; padding: 0.18rem 0.65rem;
            border-radius: 12px; font-size: 0.78rem; font-weight: 700;
        }
        .badge-due      { background: #fed7d7; color: #9b2c2c; }
        .badge-overpaid { background: #c6f6d5; color: #276749; }
        .badge-clear    { background: #e2e8f0; color: #4a5568; }

        /* ── Table 2 single-stat cards ── */
        .stat-cards {
            display: grid; grid-template-columns: repeat(3, 1fr); gap: 1rem;
            background: white; padding: 1.25rem;
            border-radius: 0 0 10px 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.07);
        }
        .stat-card {
            background: #f7fafc; border-radius: 8px;
            padding: 1rem 1.25rem; text-align: center;
        }
        .stat-card .stat-label {
            font-size: 0.75rem; color: #718096;
            font-weight: 600; text-transform: uppercase;
            letter-spacing: 0.04em; margin-bottom: 0.4rem;
        }
        .stat-card .stat-value {
            font-size: 1.5rem; font-weight: 800; color: #2d3748;
        }
        .stat-card .stat-sub {
            font-size: 0.75rem; color: #a0aec0; margin-top: 0.2rem;
        }
    </style>
</head>
<body>

<nav>
    <h1>📊 Summary – <c:out value="${month.monthName}"/></h1>
    <div>
        <a href="/chat">Chat</a>
        <a href="/dashboard">Dashboard</a>
        <a href="/meal">Meal Count</a>
        <a href="/deposit">Deposits</a>
        <a href="/meal-cost">Meal Cost</a>
        <a href="/combined-cost">Combined Cost</a>
        <a href="/protein">Protein Tracker</a>
        <a href="/logout">Logout</a>
    </div>
</nav>

<div class="container">

    <c:if test="${not empty error}">
        <div class="error-box">${error}</div>
    </c:if>

    <%-- ════════════════════════════════════════════
         TABLE 1 — Average Combined Cost
         ════════════════════════════════════════════ --%>

    <div class="section">
        <div class="section-title title-blue">
            Average Combined Cost
        </div>
        <div class="table-wrapper">
            <table>
                <thead>
                    <tr>
                        <th>#</th>
                        <th>Name</th>
                        <th>Deposit (৳)</th>
                        <th>Combined Cost Share (৳)</th>
                        <th>Meal Fund (৳)</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="row" items="${rows}" varStatus="st">
                        <tr>
                            <td>${st.index + 1}</td>
                            <td class="val-normal">${row.name}</td>
                            <td class="val-green">৳ ${row.deposit}</td>
                            <td class="val-blue">৳ ${row.combinedCost}</td>
                            <td>
                                <c:choose>
                                    <c:when test="${row.mealFund >= 0}">
                                        <span class="val-green">৳ ${row.mealFund}</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="val-red">৳ ${row.mealFund}</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
                <tfoot>
                    <tr>
                        <td colspan="2">Total</td>
                        <td>৳ ${grandDeposit}</td>
                        <td>৳ ${grandCombinedCost}</td>
                        <td>৳ ${grandMealFund}</td>
                    </tr>
                </tfoot>
            </table>
        </div>
    </div>

    <%-- ════════════════════════════════════════════
         TABLE 2 — Average Per Meal Cost
         ════════════════════════════════════════════ --%>
    <div class="section">
        <div class="section-title title-teal">
            Average Per Meal Cost
        </div>
        <div class="stat-cards">
            <div class="stat-card">
                <div class="stat-label">Total Meal Count</div>
                <div class="stat-value">${mcs.totalMealCount}</div>
                <div class="stat-sub">meals this month</div>
            </div>
            <div class="stat-card">
                <div class="stat-label">Total Meal Cost</div>
                <div class="stat-value">৳ ${mcs.totalMealCost}</div>
                <div class="stat-sub">from meal costs table</div>
            </div>
            <div class="stat-card">
                <div class="stat-label">Per Meal Cost</div>
                <div class="stat-value">
                    ৳ <fmt:formatNumber value="${mcs.perMealCost}" maxFractionDigits="2"/>
                </div>
                <div class="stat-sub">total cost ÷ total meals</div>
            </div>
        </div>
    </div>

    <%-- ════════════════════════════════════════════
         TABLE 3 — Per User Meal Cost
         ════════════════════════════════════════════ --%>
    <div class="section">
        <div class="section-title title-purple">
            Per User Meal Cost
        </div>
        <div class="table-wrapper">
            <table>
                <thead>
                    <tr>
                        <th>#</th>
                        <th>Name</th>
                        <th>Meals Taken</th>
                        <th>Per Meal Cost (৳)</th>
                        <th>Total Meal Cost (৳)</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="row" items="${rows}" varStatus="st">
                        <tr>
                            <td>${st.index + 1}</td>
                            <td class="val-normal">${row.name}</td>
                            <td class="val-blue">${row.totalMeals}</td>
                            <td style="color:#718096">
                                ৳ <fmt:formatNumber value="${mcs.perMealCost}" maxFractionDigits="2"/>
                            </td>
                            <td class="val-green">৳ ${row.perUserMealCost}</td>
                        </tr>
                    </c:forEach>
                </tbody>
                <tfoot>
                    <tr>
                        <td colspan="2">Total</td>
                        <td>${grandMeals}</td>
                        <td>—</td>
                        <td>৳ ${grandMealCost}</td>
                    </tr>
                </tfoot>
            </table>
        </div>
    </div>

    <%-- ════════════════════════════════════════════
         TABLE 4 — Transaction Summary
         ════════════════════════════════════════════ --%>
    <div class="section">
        <div class="section-title title-red">
            Transaction Summary
        </div>
        <div class="table-wrapper">
            <table>
                <thead>
                    <tr>
                        <th>#</th>
                        <th>Name</th>
                        <th>Meal Fund (৳)</th>
                        <th>Meal Cost (৳)</th>
                        <th>Status</th>
                        <th>Amount (৳)</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="row" items="${rows}" varStatus="st">
                        <tr>
                            <td>${st.index + 1}</td>
                            <td class="val-normal">${row.name}</td>
                            <td class="val-green">৳ ${row.mealFund}</td>
                            <td class="val-blue">৳ ${row.perUserMealCost}</td>
                            <td>
                                <c:choose>
                                    <c:when test="${row.due > 0}">
                                        <span class="badge badge-due">Due</span>
                                    </c:when>
                                    <c:when test="${row.due < 0}">
                                        <span class="badge badge-overpaid">Overpaid</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="badge badge-clear">Clear</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td>
                                <c:choose>
                                    <c:when test="${row.due > 0}">
                                        <span class="val-red">৳ ${row.due}</span>
                                    </c:when>
                                    <c:when test="${row.due < 0}">
                                        <span class="val-green">৳ ${-row.due}</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span style="color:#718096">৳ 0</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
                <tfoot>
                    <tr>
                        <td colspan="2">Total</td>
                        <td>৳ ${grandMealFund}</td>
                        <td>৳ ${grandMealCost}</td>
                        <td>—</td>
                        <td>৳ ${grandDue}</td>
                    </tr>
                </tfoot>
            </table>
        </div>
    </div>

    <%-- ── Money in Hand card ── --%>
    <div style="margin-bottom: 2rem;">
        <div style="
            background: linear-gradient(135deg, #1a202c, #2d3748);
            border-radius: 12px;
            padding: 1.5rem 2rem;
            display: flex; justify-content: space-between; align-items: center;
            box-shadow: 0 4px 15px rgba(0,0,0,0.15);
        ">
            <div>
                <div style="color: #a0aec0; font-size: 0.78rem; font-weight: 600;
                            text-transform: uppercase; letter-spacing: 0.05em; margin-bottom: 0.4rem;">
                    💼 Manager's Money in Hand
                </div>
                <div style="color: #a0aec0; font-size: 0.8rem; margin-top: 0.3rem;">
                    Total Deposit − (Meal Cost + Combined Cost)
                </div>
            </div>
            <div style="text-align: right;">
                <div style="
                    font-size: 2rem; font-weight: 800;
                    color: ${moneyInHand >= 0 ? '#68d391' : '#fc8181'};
                ">
                    ৳ ${moneyInHand}
                </div>
                <div style="font-size: 0.75rem; color: #718096; margin-top: 0.2rem;">
                    <c:choose>
                        <c:when test="${moneyInHand >= 0}">Surplus</c:when>
                        <c:otherwise>Deficit</c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>

        <%-- breakdown strip --%>
        <div style="
            background: white; border-radius: 0 0 10px 10px;
            display: grid; grid-template-columns: repeat(3, 1fr);
            box-shadow: 0 2px 10px rgba(0,0,0,0.07);
            overflow: hidden;
        ">
            <div style="padding: 0.85rem 1.25rem; border-right: 1px solid #e2e8f0;">
                <div style="font-size: 0.72rem; color: #718096; font-weight: 600;
                            text-transform: uppercase; letter-spacing: 0.04em;">Total Deposit</div>
                <div style="font-size: 1.1rem; font-weight: 700; color: #276749; margin-top: 0.2rem;">
                    ৳ ${grandDeposit}
                </div>
            </div>
            <div style="padding: 0.85rem 1.25rem; border-right: 1px solid #e2e8f0;">
                <div style="font-size: 0.72rem; color: #718096; font-weight: 600;
                            text-transform: uppercase; letter-spacing: 0.04em;">Meal Cost + Combined</div>
                <div style="font-size: 1.1rem; font-weight: 700; color: #c53030; margin-top: 0.2rem;">
                    ৳ ${mcs.totalMealCost + grandCombinedCost}
                </div>
            </div>
            <div style="padding: 0.85rem 1.25rem;">
                <div style="font-size: 0.72rem; color: #718096; font-weight: 600;
                            text-transform: uppercase; letter-spacing: 0.04em;">Balance</div>
                <div style="font-size: 1.1rem; font-weight: 700;
                            color: ${moneyInHand >= 0 ? '#276749' : '#c53030'}; margin-top: 0.2rem;">
                    ৳ ${moneyInHand}
                </div>
            </div>
        </div>
    </div>

</div>

</body>
</html>