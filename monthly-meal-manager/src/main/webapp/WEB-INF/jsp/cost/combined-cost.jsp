<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Combined Cost – ${month.monthName}</title>
    <style>
        * { box-sizing: border-box; margin: 0; padding: 0; }
        body { font-family: 'Segoe UI', sans-serif; background: #f0f4f8; }
        nav {
            background: #1a202c; color: white; padding: 1rem 2rem;
            display: flex; justify-content: space-between; align-items: center;
        }
        nav h1 { font-size: 1.2rem; }
        nav a { color: #90cdf4; text-decoration: none; font-size: 0.875rem; margin-left: 1rem; }
        .container { padding: 2rem; max-width: 700px; margin: 0 auto; }
        h2 { color: #1a202c; margin-bottom: 1.5rem; font-size: 1.4rem; }
        .error-box {
            background: #fff5f5; border: 1px solid #fc8181;
            color: #c53030; padding: 1rem; border-radius: 8px; margin-bottom: 1rem;
        }
        .add-form {
            background: white; border-radius: 10px; padding: 1.5rem;
            margin-bottom: 2rem; box-shadow: 0 2px 10px rgba(0,0,0,0.07);
        }
        .add-form h3 { margin-bottom: 1rem; color: #2d3748; font-size: 1rem; }
        .form-row { display: flex; gap: 0.75rem; flex-wrap: wrap; align-items: flex-end; }
        .form-group { display: flex; flex-direction: column; gap: 0.3rem; }
        .form-group label { font-size: 0.8rem; font-weight: 600; color: #4a5568; }
        .form-group input {
            padding: 0.55rem 0.8rem; border: 1px solid #cbd5e0;
            border-radius: 7px; font-size: 0.9rem; outline: none;
        }
        .form-group input:focus { border-color: #4f8ef7; }
        .btn-add {
            padding: 0.55rem 1.4rem; background: #9f7aea; color: white;
            border: none; border-radius: 7px; font-size: 0.9rem;
            font-weight: 600; cursor: pointer;
        }
        .btn-add:hover { background: #805ad5; }
        .table-wrap { border-radius: 10px; box-shadow: 0 2px 10px rgba(0,0,0,0.07); overflow: hidden; }
        table { width: 100%; border-collapse: collapse; background: white; }
        thead { background: #553c9a; color: white; }
        thead th { padding: 0.85rem 1.2rem; text-align: left; font-size: 0.875rem; }
        tbody tr:nth-child(even) { background: #faf5ff; }
        tbody tr:hover { background: #f3e8ff; }
        td { padding: 0.75rem 1.2rem; border-bottom: 1px solid #e2e8f0; font-size: 0.9rem; color: #2d3748; }
        .cost-cell { font-weight: 700; color: #553c9a; }
        tfoot td {
            padding: 0.85rem 1.2rem; background: #faf5ff;
            font-weight: 700; border-top: 2px solid #d6bcfa;
        }
        tfoot .cost-cell { font-size: 1rem; color: #553c9a; }
        .edit-input {
            padding: 0.35rem 0.6rem; border: 1px solid #9f7aea;
            border-radius: 6px; font-size: 0.875rem; width: 100%;
        }
        .btn-save {
            background: #9f7aea; color: white; border: none;
            border-radius: 5px; padding: 0.3rem 0.7rem;
            font-size: 0.78rem; font-weight: 600; cursor: pointer;
        }
        .btn-save:hover { background: #805ad5; }
        .btn-edit {
            background: #f3e8ff; color: #553c9a; border: none;
            border-radius: 5px; padding: 0.3rem 0.7rem;
            font-size: 0.78rem; font-weight: 600; cursor: pointer;
        }
        .btn-edit:hover { background: #e9d8fd; }
        .btn-del {
            background: #fed7d7; color: #9b2c2c; border: none;
            border-radius: 5px; padding: 0.3rem 0.7rem;
            font-size: 0.78rem; font-weight: 600; cursor: pointer;
        }
        .btn-del:hover { background: #fc8181; }
        .btn-cancel {
            background: #e2e8f0; color: #4a5568; border: none;
            border-radius: 5px; padding: 0.3rem 0.7rem;
            font-size: 0.78rem; font-weight: 600; cursor: pointer;
        }
        .action-btns { display: flex; gap: 0.4rem; }
    </style>
</head>
<body>
<nav>
    <h1>🧴 Combined Cost – <c:out value="${month.monthName}"/></h1>
    <div>
        <a href="/chat">Chat</a>
        <a href="/dashboard">Dashboard</a>
        <a href="/meal">Meal Count</a>
        <a href="/deposit">Deposits</a>
        <a href="/meal-cost">Meal Cost</a>
        <a href="/protein">Protein Tracker</a>
        <a href="/summary">Summary</a>
        <a href="/logout">Logout</a>
    </div>
</nav>

<div class="container">
    <h2>Combined Cost Items</h2>

    <c:if test="${not empty error}">
        <div class="error-box">${error}</div>
    </c:if>

    <c:if test="${isManager}">
        <div class="add-form">
            <h3>➕ Add Item</h3>
            <form action="/combined-cost/add" method="post">
                <div class="form-row">
                    <div class="form-group">
                        <label>Item Name</label>
                        <input type="text" name="itemName" placeholder="e.g. Hand Wash" required style="width:180px"/>
                    </div>
                    <div class="form-group">
                        <label>Cost (৳)</label>
                        <input type="number" name="cost" min="1" placeholder="e.g. 200" required style="width:120px"/>
                    </div>
                    <button type="submit" class="btn-add">Add</button>
                </div>
            </form>
        </div>
    </c:if>

    <div class="table-wrap">
        <table>
            <thead>
                <tr>
                    <th>#</th>
                    <th>Item Name</th>
                    <th>Cost (৳)</th>
                    <c:if test="${isManager}"><th>Actions</th></c:if>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="item" items="${items}" varStatus="st">
                    <tr>
                        <td>${st.index + 1}</td>
                        <td>
                            <span class="view-name-${item.id}">${item.itemName}</span>
                            <input class="edit-input edit-name-${item.id}"
                                   style="display:none" value="${item.itemName}"/>
                        </td>
                        <td class="cost-cell">
                            <span class="view-cost-${item.id}">৳ ${item.cost}</span>
                            <input class="edit-input edit-cost-${item.id}" type="number"
                                   style="display:none" value="${item.cost}"/>
                        </td>
                        <c:if test="${isManager}">
                            <td>
                                <div class="action-btns view-btns-${item.id}">
                                    <button class="btn-edit"
                                            onclick="startEdit(${item.id})">Edit</button>
                                    <form action="/combined-cost/delete" method="post"
                                          style="display:inline"
                                          onsubmit="return confirm('Delete this item?')">
                                        <input type="hidden" name="id" value="${item.id}"/>
                                        <button type="submit" class="btn-del">Delete</button>
                                    </form>
                                </div>
                                <div class="action-btns edit-btns-${item.id}" style="display:none">
                                    <button class="btn-save"
                                            onclick="saveEdit(${item.id})">Save</button>
                                    <button class="btn-cancel"
                                            onclick="cancelEdit(${item.id})">Cancel</button>
                                </div>
                                <form id="update-form-${item.id}"
                                      action="/combined-cost/update" method="post" style="display:none">
                                    <input type="hidden" name="id" value="${item.id}"/>
                                    <input type="hidden" id="hidden-name-${item.id}" name="itemName"/>
                                    <input type="hidden" id="hidden-cost-${item.id}" name="cost"/>
                                </form>
                            </td>
                        </c:if>
                    </tr>
                </c:forEach>

                <c:if test="${empty items}">
                    <tr>
                        <td colspan="4" style="text-align:center; color:#a0aec0; padding:2rem;">
                            No items added yet.
                        </td>
                    </tr>
                </c:if>
            </tbody>
            <tfoot>
                <tr>
                    <td colspan="2">Total</td>
                    <td class="cost-cell">৳ ${total}</td>
                    <c:if test="${isManager}"><td></td></c:if>
                </tr>
            </tfoot>
        </table>
    </div>
</div>

<script>
    function startEdit(id) {
        document.querySelector('.view-name-' + id).style.display = 'none';
        document.querySelector('.view-cost-' + id).style.display = 'none';
        document.querySelector('.view-btns-' + id).style.display = 'none';
        document.querySelector('.edit-name-' + id).style.display = 'inline-block';
        document.querySelector('.edit-cost-' + id).style.display = 'inline-block';
        document.querySelector('.edit-btns-' + id).style.display = 'flex';
    }

    function cancelEdit(id) {
        document.querySelector('.view-name-' + id).style.display = 'inline';
        document.querySelector('.view-cost-' + id).style.display = 'inline';
        document.querySelector('.view-btns-' + id).style.display = 'flex';
        document.querySelector('.edit-name-' + id).style.display = 'none';
        document.querySelector('.edit-cost-' + id).style.display = 'none';
        document.querySelector('.edit-btns-' + id).style.display = 'none';
    }

    function saveEdit(id) {
        const name = document.querySelector('.edit-name-' + id).value.trim();
        const cost = document.querySelector('.edit-cost-' + id).value.trim();
        if (!name || !cost) { alert('Both fields are required.'); return; }
        document.getElementById('hidden-name-' + id).value = name;
        document.getElementById('hidden-cost-' + id).value = cost;
        document.getElementById('update-form-' + id).submit();
    }
</script>
</body>
</html>