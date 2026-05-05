<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.mealmanager.model.ChatMessage" %>
<%@ page import="com.mealmanager.model.User" %>
<%@ page import="java.util.List" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Chat</title>
    <style>
        * { box-sizing: border-box; margin: 0; padding: 0; }
        body { font-family: 'Segoe UI', sans-serif; background: #f0f4f8; display: flex; flex-direction: column; height: 100vh; overflow: hidden; }

        /* Nav */
        nav {
            background: #1a202c; color: white; padding: 1rem 2rem;
            display: flex; justify-content: space-between; align-items: center;
            flex-shrink: 0;
        }
        nav h1 { font-size: 1.2rem; }
        nav a { color: #90cdf4; text-decoration: none; font-size: 0.875rem; margin-left: 1rem; }
        nav a:hover { color: #bee3f8; }

        /* Main layout */
        .chat-wrapper {
            flex: 1; display: flex; flex-direction: column;
            max-width: 700px; width: 100%; margin: 2rem auto;
            padding: 0 1rem; min-height: 0;
        }

        h2 { color: #1a202c; margin-bottom: 1.5rem; font-size: 1.4rem; }

        /* Messages box */
        .messages-box {
            flex: 1; background: white; border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.07);
            overflow-y: auto; padding: 1.5rem;
            display: flex; flex-direction: column; gap: 0.75rem;
            min-height: 0;
        }
        .messages-box::-webkit-scrollbar { width: 5px; }
        .messages-box::-webkit-scrollbar-thumb { background: #cbd5e0; border-radius: 4px; }

        /* Bubbles */
        .msg-row { display: flex; align-items: flex-end; gap: 0.5rem; }
        .msg-row.mine { flex-direction: row-reverse; }

        .avatar {
            width: 32px; height: 32px; border-radius: 50%;
            background: #e9d8fd; color: #553c9a;
            display: grid; place-items: center;
            font-size: 13px; font-weight: 700;
            flex-shrink: 0; text-transform: uppercase;
        }
        .msg-row.mine .avatar { background: #bee3f8; color: #2b6cb0; }

        .bubble {
            max-width: 68%; padding: 0.6rem 0.9rem;
            border-radius: 12px; word-break: break-word;
        }
        .msg-row:not(.mine) .bubble {
            background: #f3e8ff; border: 1px solid #e9d8fd;
            border-bottom-left-radius: 3px;
        }
        .msg-row.mine .bubble {
            background: #ebf8ff; border: 1px solid #bee3f8;
            border-bottom-right-radius: 3px;
        }
        .bubble-sender {
            font-size: 0.72rem; font-weight: 700;
            color: #553c9a; margin-bottom: 2px;
        }
        .msg-row.mine .bubble-sender { color: #2b6cb0; text-align: right; }
        .bubble-text { font-size: 0.9rem; color: #2d3748; }
        .bubble-time { font-size: 0.7rem; color: #a0aec0; margin-top: 3px; text-align: right; }

        /* Empty state */
        .empty-state {
            flex: 1; display: flex; flex-direction: column;
            align-items: center; justify-content: center;
            color: #a0aec0; font-size: 0.9rem; gap: 0.5rem;
        }
        .empty-state span:first-child { font-size: 2rem; }

        /* Input area */
        .input-area {
            background: white; border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.07);
            padding: 1rem; margin-top: 1rem; flex-shrink: 0;
        }
        .input-row {
            display: flex; gap: 0.75rem; align-items: center;
        }
        #msg-input {
            flex: 1; padding: 0.55rem 0.8rem;
            border: 1px solid #cbd5e0; border-radius: 7px;
            font-size: 0.9rem; outline: none;
            font-family: 'Segoe UI', sans-serif;
        }
        #msg-input:focus { border-color: #9f7aea; }
        #send-btn {
            padding: 0.55rem 1.4rem; background: #9f7aea; color: white;
            border: none; border-radius: 7px; font-size: 0.9rem;
            font-weight: 600; cursor: pointer; white-space: nowrap;
        }
        #send-btn:hover { background: #805ad5; }
        #send-btn:disabled { background: #d6bcfa; cursor: default; }

        /* Toast */
        #toast {
            position: fixed; bottom: 80px; left: 50%;
            transform: translateX(-50%) translateY(10px);
            background: #fff5f5; border: 1px solid #fc8181; color: #c53030;
            padding: 0.5rem 1.2rem; border-radius: 8px; font-size: 0.85rem;
            opacity: 0; pointer-events: none;
            transition: opacity .25s, transform .25s; z-index: 99;
        }
        #toast.show { opacity: 1; transform: translateX(-50%) translateY(0); }
    </style>
</head>
<body>

<nav>
    <h1>&#128172; Chat</h1>
    <div>
        <a href="/dashboard">Dashboard</a>
        <a href="/meal">Meal Count</a>
        <a href="/deposit">Deposits</a>
        <a href="/meal-cost">Meal Cost</a>
        <a href="/protein">Protein Tracker</a>
        <a href="/summary">Summary</a>
        <a href="/logout">Logout</a>
    </div>
</nav>

<%
    User currentUser = (User) request.getAttribute("currentUser");
    List<ChatMessage> messages = (List<ChatMessage>) request.getAttribute("messages");
%>

<div class="chat-wrapper">
    <h2>Community Chat</h2>

    <div class="messages-box" id="messages-container">
    <%
        if (messages == null || messages.isEmpty()) {
    %>
        <div class="empty-state" id="empty-state">
            <span>&#128172;</span>
            <span>No messages yet &mdash; say hello!</span>
        </div>
    <%
        } else {
            for (ChatMessage msg : messages) {
                boolean isMine  = currentUser != null && msg.getUser().getId().equals(currentUser.getId());
                String initial  = (msg.getUser().getName() != null && !msg.getUser().getName().isEmpty())
                                  ? msg.getUser().getName().substring(0, 1).toUpperCase() : "?";
                String sender   = org.springframework.web.util.HtmlUtils.htmlEscape(msg.getUser().getName());
                String msgText  = org.springframework.web.util.HtmlUtils.htmlEscape(msg.getMessage());
                String sentAt   = msg.getSentAt().toString().replace("T", " ").substring(0, 16);
                String rowCls   = isMine ? "msg-row mine" : "msg-row";
                String dispName = isMine ? "You" : sender;
    %>
        <div class="<%= rowCls %>" data-id="<%= msg.getId() %>">
            <div class="avatar"><%= initial %></div>
            <div class="bubble">
                <div class="bubble-sender"><%= dispName %></div>
                <div class="bubble-text"><%= msgText %></div>
                <div class="bubble-time"><%= sentAt %></div>
            </div>
        </div>
    <%
            }
        }
    %>
    </div>

    <div class="input-area">
        <div class="input-row">
            <input id="msg-input" type="text" placeholder="Write a message&#8230;"
                   maxlength="1000" autocomplete="off"/>
            <button id="send-btn">Send &#10148;</button>
        </div>
    </div>
</div>

<div id="toast"></div>

<script>
    (() => {
        const container = document.getElementById('messages-container');
        const input     = document.getElementById('msg-input');
        const sendBtn   = document.getElementById('send-btn');
        const toast     = document.getElementById('toast');

        const scrollBottom = () =>
            container.scrollTo({ top: container.scrollHeight, behavior: 'smooth' });

        let toastTimer;
        function showToast(msg) {
            toast.textContent = msg;
            toast.classList.add('show');
            clearTimeout(toastTimer);
            toastTimer = setTimeout(() => toast.classList.remove('show'), 3000);
        }

        function escHtml(s) {
            return String(s).replace(/&/g,'&amp;').replace(/</g,'&lt;')
                            .replace(/>/g,'&gt;').replace(/"/g,'&quot;');
        }

        function renderBubble(data) {
            const empty = document.getElementById('empty-state');
            if (empty) empty.remove();

            const initial = (data.sender || '?').charAt(0).toUpperCase();
            const row     = document.createElement('div');
            row.className  = 'msg-row' + (data.isMine ? ' mine' : '');
            row.dataset.id = data.id;
            row.innerHTML  =
                '<div class="avatar">' + initial + '</div>' +
                '<div class="bubble">' +
                  '<div class="bubble-sender">' + (data.isMine ? 'You' : escHtml(data.sender)) + '</div>' +
                  '<div class="bubble-text">'   + escHtml(data.message) + '</div>' +
                  '<div class="bubble-time">'   + escHtml(data.sentAt)  + '</div>' +
                '</div>';
            container.appendChild(row);
            scrollBottom();
        }

        function getLastId() {
            const rows = container.querySelectorAll('.msg-row[data-id]');
            if (!rows.length) return 0;
            return parseInt(rows[rows.length - 1].dataset.id) || 0;
        }

        async function sendMessage() {
            const text = input.value.trim();
            if (!text) return;
            sendBtn.disabled = true;
            input.value = '';
            try {
                const res = await fetch('${pageContext.request.contextPath}/chat/send', {
                    method:  'POST',
                    headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                    body:    'message=' + encodeURIComponent(text)
                });
                if (!res.ok) throw new Error(await res.text());
                renderBubble(await res.json());
            } catch (e) {
                showToast('Failed to send. Please try again.');
                input.value = text;
            } finally {
                sendBtn.disabled = false;
                input.focus();
            }
        }

        let pollActive = true;
        async function poll() {
            try {
                const res = await fetch(
                    '${pageContext.request.contextPath}/chat/poll?lastId=' + getLastId()
                );
                if (res.ok) {
                    (await res.json()).forEach(m => {
                        if (!container.querySelector('.msg-row[data-id="' + m.id + '"]'))
                            renderBubble(m);
                    });
                }
            } catch (_) {}
            if (pollActive) setTimeout(poll, 3000);
        }

        sendBtn.addEventListener('click', sendMessage);
        input.addEventListener('keydown', e => {
            if (e.key === 'Enter' && !e.shiftKey) { e.preventDefault(); sendMessage(); }
        });
        window.addEventListener('beforeunload', () => { pollActive = false; });

        scrollBottom();
        setTimeout(poll, 3000);
    })();
</script>
</body>
</html>
