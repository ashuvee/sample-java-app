<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Sample Java Web Application</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" type="text/css" href="css/style.css">
    <style>
        .hero-section {
            text-align: center;
            margin-bottom: 40px;
        }
        
        .tech-stack {
            display: flex;
            justify-content: center;
            flex-wrap: wrap;
            gap: 10px;
            margin-top: 20px;
        }
        
        .icon-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(150px, 1fr));
            gap: 20px;
            margin-top: 20px;
        }
        
        .icon-card {
            background: white;
            padding: 20px;
            border-radius: 12px;
            text-align: center;
            transition: all 0.3s ease;
            border: 2px solid #e2e8f0;
        }
        
        .icon-card:hover {
            transform: translateY(-5px);
            border-color: #667eea;
            box-shadow: 0 8px 20px rgba(102, 126, 234, 0.2);
        }
        
        .icon-card .icon {
            font-size: 2.5em;
            margin-bottom: 10px;
        }
        
        .icon-card .label {
            color: #4a5568;
            font-weight: 600;
            font-size: 0.9em;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="hero-section">
            <h1>🚀 Welcome to Sample Java Web Application</h1>
            <p class="subtitle">A modern, stylish web app for practicing build and deployment</p>
            <div class="tech-stack">
                <span class="badge">☕ Java 11+</span>
                <span class="badge">📦 Maven</span>
                <span class="badge">🌐 Servlet API</span>
                <span class="badge">📄 JSP + JSTL</span>
            </div>
        </div>
        
        <div class="card">
            <h2>✨ Features</h2>
            <ul>
                <li>Modern responsive design with smooth animations</li>
                <li>RESTful Servlet examples with real-time data</li>
                <li>JSP pages with JSTL template support</li>
                <li>Interactive user management system</li>
                <li>Ready for deployment on multiple servers</li>
            </ul>
        </div>
        
        <div class="card">
            <h2>👋 Try It Out</h2>
            <form action="hello" method="get">
                <label for="name">Enter your name:</label>
                <input type="text" id="name" name="name" placeholder="Your name here..." required>
                <button type="submit">✨ Say Hello</button>
            </form>
        </div>
        
        <div class="card">
            <h2>🎯 Quick Links</h2>
            <div class="links">
                <a href="hello?name=Developer" class="button">👋 Hello Servlet</a>
                <a href="user" class="button">👥 User Management</a>
            </div>
        </div>
        
        <div class="card">
            <h2>🛠️ Compatible Servers</h2>
            <div class="icon-grid">
                <div class="icon-card">
                    <div class="icon">🐱</div>
                    <div class="label">Apache Tomcat</div>
                </div>
                <div class="icon-card">
                    <div class="icon">🦅</div>
                    <div class="label">JBoss/WildFly</div>
                </div>
                <div class="icon-card">
                    <div class="icon">🐠</div>
                    <div class="label">GlassFish</div>
                </div>
                <div class="icon-card">
                    <div class="icon">⚡</div>
                    <div class="label">Jetty</div>
                </div>
            </div>
        </div>
        
        <div class="info">
            <p><strong>🖥️ Server Info:</strong> <%= application.getServerInfo() %></p>
            <p><strong>📍 Context Path:</strong> <%= request.getContextPath() %></p>
            <p><strong>⏰ Current Time:</strong> <%= new java.util.Date() %></p>
        </div>
    </div>
</body>
</html>
