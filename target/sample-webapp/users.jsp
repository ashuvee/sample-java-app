<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <title>User Management - Sample Webapp</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" type="text/css" href="css/style.css">
    <style>
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
        }
        
        .stat-card {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 25px;
            border-radius: 15px;
            text-align: center;
            box-shadow: 0 8px 20px rgba(102, 126, 234, 0.3);
            animation: slideIn 0.5s ease-out backwards;
        }
        
        .stat-card .number {
            font-size: 3em;
            font-weight: 800;
            margin-bottom: 5px;
        }
        
        .stat-card .label {
            font-size: 1em;
            opacity: 0.9;
            text-transform: uppercase;
            letter-spacing: 1px;
        }
        
        .user-count {
            display: inline-block;
            background: #667eea;
            color: white;
            padding: 5px 15px;
            border-radius: 20px;
            font-size: 0.9em;
            margin-left: 10px;
        }
        
        .empty-state {
            text-align: center;
            padding: 60px 20px;
            color: #718096;
        }
        
        .empty-state .icon {
            font-size: 4em;
            margin-bottom: 20px;
            opacity: 0.5;
        }
        
        td:first-child {
            font-weight: 700;
            color: #667eea;
        }
        
        .back-link {
            margin-top: 30px;
            display: inline-block;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>👥 User Management System</h1>
        <p class="subtitle">Manage your users with ease and style</p>
        
        <div class="stats-grid">
            <div class="stat-card">
                <div class="number">${users.size()}</div>
                <div class="label">Total Users</div>
            </div>
        </div>
        
        <div class="card">
            <h2>➕ Add New User</h2>
            <form action="user" method="post">
                <label for="userName">👤 Full Name:</label>
                <input type="text" id="userName" name="name" placeholder="Enter full name..." required>
                
                <label for="userEmail">📧 Email Address:</label>
                <input type="email" id="userEmail" name="email" placeholder="user@example.com" required>
                
                <button type="submit">✨ Add User</button>
            </form>
        </div>
        
        <div class="card">
            <h2>📋 User Directory <span class="user-count">${users.size()} users</span></h2>
            
            <c:choose>
                <c:when test="${empty users}">
                    <div class="empty-state">
                        <div class="icon">📭</div>
                        <h3>No users yet</h3>
                        <p>Add your first user using the form above!</p>
                    </div>
                </c:when>
                <c:otherwise>
                    <table>
                        <thead>
                            <tr>
                                <th>🆔 ID</th>
                                <th>👤 Name</th>
                                <th>📧 Email</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="user" items="${users}">
                                <tr>
                                    <td>#${user.id}</td>
                                    <td>${user.name}</td>
                                    <td>${user.email}</td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </c:otherwise>
            </c:choose>
        </div>
        
        <a href="index.jsp" class="button back-link">⬅️ Back to Home</a>
        
        <div class="info">
            <p><strong>💡 Tip:</strong> This is a demo application with in-memory storage. Users will be reset when the server restarts.</p>
        </div>
    </div>
</body>
</html>
