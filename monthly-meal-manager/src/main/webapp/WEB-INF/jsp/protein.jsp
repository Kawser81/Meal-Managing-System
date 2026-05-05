<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Protein Tracker – ${month.monthName}</title>
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

        /* ── Add form ── */
        .add-form {
            background: white; border-radius: 10px;
            padding: 1.5rem; margin-bottom: 2rem;
            box-shadow: 0 2px 10px rgba(0,0,0,0.07);
        }
        .add-form h3 { margin-bottom: 1rem; color: #2d3748; font-size: 1rem; }
        .form-row { display: flex; gap: 0.75rem; flex-wrap: wrap; align-items: flex-end; }
        .form-group { display: flex; flex-direction: column; gap: 0.3rem; }
        .form-group label { font-size: 0.8rem; font-weight: 600; color: #4a5568; }
        .form-group input, .form-group select {
            padding: 0.55rem 0.8rem; border: 1px solid #cbd5e0;
            border-radius: 7px; font-size: 0.9rem; outline: none; background: white;
        }
        .form-group input:focus, .form-group select:focus { border-color: #4f8ef7; }
        .btn-add {
            padding: 0.55rem 1.4rem; background: #48bb78;
            color: white; border: none; border-radius: 7px;
            font-size: 0.9rem; font-weight: 600; cursor: pointer;
        }
        .btn-add:hover { background: #38a169; }

        /* ── Stock cards grid ── */
        .stock-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
            gap: 1.25rem;
            margin-bottom: 2.5rem;
        }

        .stock-card {
            background: white; border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.07);
            overflow: hidden;
        }

        .card-header {
            padding: 0.85rem 1.1rem;
            display: flex; justify-content: space-between; align-items: center;
            color: white;
        }
        .card-header.chicken { background: linear-gradient(135deg, #c05621, #dd6b20); }
        .card-header.fish    { background: linear-gradient(135deg, #2b6cb0, #3182ce); }
        .card-header.custom  { background: linear-gradient(135deg, #553c9a, #6b46c1); }

        .card-header .item-name { font-weight: 700; font-size: 1rem; }
        .card-header .qty-badge {
            background: rgba(255,255,255,0.25);
            border-radius: 20px; padding: 0.2rem 0.8rem;
            font-size: 0.85rem; font-weight: 700;
        }

        .card-body { padding: 1rem 1.1rem; }

        .info-row {
            display: flex; justify-content: space-between;
            font-size: 0.85rem; color: #4a5568; margin-bottom: 0.5rem;
        }
        .info-row span:first-child { color: #718096; }
        .info-row span:last-child  { font-weight: 600; color: #2d3748; }

        .note-text {
            font-size: 0.8rem; color: #718096;
            background: #f7fafc; border-radius: 6px;
            padding: 0.4rem 0.7rem; margin-top: 0.5rem;
        }

        .card-actions {
            display: flex; gap: 0.5rem;
            padding: 0.75rem 1.1rem;
            border-top: 1px solid #f0f4f8;
        }

        .btn-edit {
            flex: 1; padding: 0.45rem;
            background: #ebf8ff; color: #2b6cb0;
            border: none; border-radius: 7px;
            font-size: 0.8rem; font-weight: 600; cursor: pointer;
        }
        .btn-edit:hover { background: #bee3f8; }

        .btn-del {
            flex: 1; padding: 0.45rem;
            background: #fed7d7; color: #9b2c2c;
            border: none; border-radius: 7px;
            font-size: 0.8rem; font-weight: 600; cursor: pointer;
        }
        .btn-del:hover { background: #fc8181; }

        .empty-state {
            grid-column: 1 / -1;
            text-align: center; padding: 3rem;
            color: #a0aec0; font-size: 0.95rem;
            background: white; border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.07);
        }

        /* ── Summary table ── */
        .table-wrapper {
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.07);
            overflow: hidden;
        }

        .summary-table {
            width: 100%; border-collapse: collapse;
            background: white; font-size: 0.9rem;
        }
        .summary-table thead { background: #2d3748; color: white; }
        .summary-table thead th { padding: 0.85rem 1.2rem; text-align: left; font-weight: 600; }
        .summary-table tbody tr:nth-child(even) { background: #f7fafc; }
        .summary-table tbody tr:hover { background: #ebf4ff; }
        .summary-table td { padding: 0.75rem 1.2rem; border-bottom: 1px solid #e2e8f0; color: #2d3748; }
        .summary-table tfoot td {
            padding: 0.85rem 1.2rem; background: #edf2f7;
            font-weight: 700; border-top: 2px solid #cbd5e0; color: #1a202c;
        }

        .qty-cell { font-weight: 700; color: #276749; }
        .item-chip {
            display: inline-block; padding: 0.15rem 0.6rem;
            border-radius: 12px; font-size: 0.78rem; font-weight: 600; color: white;
        }
        .chip-chicken { background: #dd6b20; }
        .chip-fish    { background: #3182ce; }
        .chip-custom  { background: #6b46c1; }

        /* ── Edit modal ── */
        .modal-overlay {
            display: none; position: fixed; inset: 0;
            background: rgba(0,0,0,0.45); z-index: 100;
            align-items: center; justify-content: center;
        }
        .modal-overlay.open { display: flex; }

        .modal {
            background: white; border-radius: 12px;
            padding: 1.75rem; width: 100%; max-width: 420px;
            box-shadow: 0 10px 40px rgba(0,0,0,0.2);
        }
        .modal h3 { margin-bottom: 1.25rem; color: #2d3748; }
        .modal .form-group { margin-bottom: 0.9rem; }
        .modal .form-group label { display: block; margin-bottom: 0.3rem; }
        .modal .form-group input {
            width: 100%; padding: 0.55rem 0.8rem;
            border: 1px solid #cbd5e0; border-radius: 7px; font-size: 0.9rem;
        }
        .modal-actions { display: flex; gap: 0.75rem; margin-top: 1.25rem; }
        .btn-save {
            flex: 1; padding: 0.6rem;
            background: #4f8ef7; color: white;
            border: none; border-radius: 7px;
            font-weight: 600; cursor: pointer; font-size: 0.9rem;
        }
        .btn-save:hover { background: #3b7de8; }
        .btn-cancel {
            flex: 1; padding: 0.6rem;
            background: #edf2f7; color: #4a5568;
            border: none; border-radius: 7px;
            font-weight: 600; cursor: pointer; font-size: 0.9rem;
        }
        .btn-cancel:hover { background: #e2e8f0; }
    </style>
</head>
<body>

<nav>
    <h1>🍗 Protein Tracker – <c:out value="${month.monthName}"/></h1>
    <div>
        <a href="/chat">Chat</a>
        <a href="/dashboard">Dashboard</a>
        <a href="/meal">Meal Count</a>
        <a href="/deposit">Deposits</a>
        <a href="/meal-cost">Meal Cost</a>
        <a href="/combined-cost">Combined Cost</a>
        <a href="/summary">Summary</a>
        <a href="/logout">Logout</a>
    </div>
</nav>

<div class="container">

    <h2>Protein Stock</h2>

    <c:if test="${not empty error}">
        <div class="error-box">${error}</div>
    </c:if>

    <%-- ── Add form (manager only) ── --%>
    <c:if test="${isManager}">
        <div class="add-form">
            <h3>➕ Add / Update Stock Item</h3>
            <form action="/protein/add" method="post">
                <div class="form-row">

                    <div class="form-group">
                        <label>Item Name</label>
                        <input type="text" name="itemName" placeholder="e.g. Chicken, Fish, Egg"
                               list="item-suggestions" required style="width: 160px"/>
                        <datalist id="item-suggestions">
                            <option value="Chicken"/>
                            <option value="Fish"/>
                            <option value="Egg"/>
                            <option value="Beef"/>
                            <option value="Mutton"/>
                        </datalist>
                    </div>

                    <div class="form-group">
                        <label>Quantity</label>
                        <input type="number" name="quantity" min="0" placeholder="e.g. 30"
                               required style="width: 100px"/>
                    </div>

                    <div class="form-group">
                        <label>Unit</label>
                        <input type="text" name="unit" placeholder="piece / kg"
                               list="unit-suggestions" style="width: 110px"/>
                        <datalist id="unit-suggestions">
                            <option value="piece"/>
                            <option value="kg"/>
                            <option value="dozen"/>
                        </datalist>
                    </div>

                    <div class="form-group">
                        <label>Note (optional)</label>
                        <input type="text" name="note" placeholder="e.g. bought today"
                               style="width: 180px"/>
                    </div>

                    <button type="submit" class="btn-add">Add</button>
                </div>
            </form>
        </div>
    </c:if>

    <%-- ── Stock cards ── --%>
    <div class="stock-grid">
        <c:choose>
            <c:when test="${empty stocks}">
                <div class="empty-state">
                    🥩 No stock items added yet for <strong>${month.monthName}</strong>.
                    <c:if test="${isManager}"><br/>Use the form above to add items.</c:if>
                </div>
            </c:when>
            <c:otherwise>
                <c:forEach var="stock" items="${stocks}">
                    <c:set var="lname" value="${stock.itemName.toLowerCase()}"/>
                    <c:set var="colorClass" value="${lname == 'chicken' ? 'chicken' : (lname == 'fish' ? 'fish' : 'custom')}"/>
                    <c:set var="chipClass"  value="${lname == 'chicken' ? 'chip-chicken' : (lname == 'fish' ? 'chip-fish' : 'chip-custom')}"/>
                    <c:set var="icon"       value="${lname == 'chicken' ? '🍗' : (lname == 'fish' ? '🐟' : '🥩')}"/>

                    <div class="stock-card">
                        <div class="card-header ${colorClass}">
                            <span class="item-name">${icon} ${stock.itemName}</span>
                            <span class="qty-badge">${stock.quantity} ${stock.unit}</span>
                        </div>

                        <div class="card-body">
                            <div class="info-row">
                                <span>Last updated</span>
                                <span>${stock.updatedAt.toString().replace('T',' ').substring(0,16)}</span>
                            </div>
                            <div class="info-row">
                                <span>Added</span>
                                <span>${stock.createdAt.toString().replace('T',' ').substring(0,16)}</span>
                            </div>
                            <c:if test="${not empty stock.note}">
                                <div class="note-text">📝 ${stock.note}</div>
                            </c:if>
                        </div>

                        <c:if test="${isManager}">
                            <div class="card-actions">
                                <button class="btn-edit"
                                        onclick="openEdit(${stock.id}, '${stock.itemName}', ${stock.quantity}, '${stock.unit}', '${stock.note}')">
                                    ✏️ Edit
                                </button>
                                <form action="/protein/delete" method="post"
                                      onsubmit="return confirm('Delete ${stock.itemName} stock?')">
                                    <input type="hidden" name="stockId" value="${stock.id}"/>
                                    <button type="submit" class="btn-del">🗑 Delete</button>
                                </form>
                            </div>
                        </c:if>
                    </div>
                </c:forEach>
            </c:otherwise>
        </c:choose>
    </div>

    <%-- ── Summary table ── --%>
    <h2 style="margin-bottom: 1rem;">Stock Summary</h2>
    <div class="table-wrapper">
        <table class="summary-table">
            <thead>
                <tr>
                    <th>#</th>
                    <th>Item</th>
                    <th>Quantity</th>
                    <th>Unit</th>
                    <th>Note</th>
                    <th>Last Updated</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="stock" items="${stocks}" varStatus="status">
                    <c:set var="lname" value="${stock.itemName.toLowerCase()}"/>
                    <c:set var="chipClass" value="${lname == 'chicken' ? 'chip-chicken' : (lname == 'fish' ? 'chip-fish' : 'chip-custom')}"/>
                    <tr>
                        <td>${status.index + 1}</td>
                        <td><span class="item-chip ${chipClass}">${stock.itemName}</span></td>
                        <td class="qty-cell">${stock.quantity}</td>
                        <td>${stock.unit}</td>
                        <td style="color:#718096; font-size:0.82rem">
                            <c:choose>
                                <c:when test="${not empty stock.note}">${stock.note}</c:when>
                                <c:otherwise>—</c:otherwise>
                            </c:choose>
                        </td>
                        <td style="font-size:0.82rem; color:#718096">
                            ${stock.updatedAt.toString().replace('T',' ').substring(0,16)}
                        </td>
                    </tr>
                </c:forEach>
            </tbody>
            <tfoot>
                <tr>
                    <td colspan="5">Total Items Tracked</td>
                    <td>${stocks.size()}</td>
                </tr>
            </tfoot>
        </table>
    </div>

</div> <%-- end container --%>

<%-- ── Edit Modal ── --%>
<div class="modal-overlay" id="editModal">
    <div class="modal">
        <h3>✏️ Edit Stock Item</h3>
        <form action="/protein/update" method="post">
            <input type="hidden" name="stockId" id="edit-id"/>

            <div class="form-group">
                <label>Item Name</label>
                <input type="text" id="edit-name" disabled
                       style="background:#f7fafc; color:#718096"/>
            </div>

            <div class="form-group">
                <label>Quantity</label>
                <input type="number" name="quantity" id="edit-qty" min="0" required/>
            </div>

            <div class="form-group">
                <label>Unit</label>
                <input type="text" name="unit" id="edit-unit" list="unit-suggestions"/>
            </div>

            <div class="form-group">
                <label>Note (optional)</label>
                <input type="text" name="note" id="edit-note"/>
            </div>

            <div class="modal-actions">
                <button type="submit" class="btn-save">💾 Save</button>
                <button type="button" class="btn-cancel" onclick="closeEdit()">Cancel</button>
            </div>
        </form>
    </div>
</div>

<script>
    function openEdit(id, name, qty, unit, note) {
        document.getElementById('edit-id').value   = id;
        document.getElementById('edit-name').value = name;
        document.getElementById('edit-qty').value  = qty;
        document.getElementById('edit-unit').value = unit;
        document.getElementById('edit-note').value = note !== 'null' ? note : '';
        document.getElementById('editModal').classList.add('open');
    }
    function closeEdit() {
        document.getElementById('editModal').classList.remove('open');
    }
    // Close on overlay click
    document.getElementById('editModal').addEventListener('click', function(e) {
        if (e.target === this) closeEdit();
    });
</script>

</body>
</html>