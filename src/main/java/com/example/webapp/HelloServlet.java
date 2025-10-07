package com.example.webapp;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

public class HelloServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        response.setContentType("text/html");
        PrintWriter out = response.getWriter();
        
        String name = request.getParameter("name");
        if (name == null || name.trim().isEmpty()) {
            name = "Guest";
        }
        
        LocalDateTime now = LocalDateTime.now();
        DateTimeFormatter dateFormatter = DateTimeFormatter.ofPattern("MMMM dd, yyyy");
        DateTimeFormatter timeFormatter = DateTimeFormatter.ofPattern("HH:mm:ss");
        
        String greeting = getGreeting(now.getHour());
        
        out.println("<!DOCTYPE html>");
        out.println("<html>");
        out.println("<head>");
        out.println("<title>Hello Servlet - Sample Webapp</title>");
        out.println("<meta name='viewport' content='width=device-width, initial-scale=1.0'>");
        out.println("<link rel='stylesheet' type='text/css' href='css/style.css'>");
        out.println("<style>");
        out.println(".greeting-card { text-align: center; padding: 40px; }");
        out.println(".greeting-card h1 { font-size: 3.5em; margin-bottom: 20px; }");
        out.println(".greeting-icon { font-size: 5em; margin-bottom: 20px; animation: bounce 2s infinite; }");
        out.println("@keyframes bounce { 0%, 100% { transform: translateY(0); } 50% { transform: translateY(-20px); } }");
        out.println(".info-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(250px, 1fr)); gap: 20px; margin-top: 30px; }");
        out.println(".info-box { background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); color: white; padding: 25px; border-radius: 15px; text-align: center; }");
        out.println(".info-box .icon { font-size: 2.5em; margin-bottom: 10px; }");
        out.println(".info-box .value { font-size: 1.3em; font-weight: 600; margin-bottom: 5px; }");
        out.println(".info-box .label { font-size: 0.9em; opacity: 0.9; text-transform: uppercase; letter-spacing: 1px; }");
        out.println("</style>");
        out.println("</head>");
        out.println("<body>");
        out.println("<div class='container'>");
        
        out.println("<div class='card greeting-card'>");
        out.println("<div class='greeting-icon'>👋</div>");
        out.println("<h1>" + greeting + ", " + escapeHtml(name) + "!</h1>");
        out.println("<p class='subtitle'>Welcome to the Sample Java Web Application</p>");
        out.println("</div>");
        
        out.println("<div class='info-grid'>");
        
        out.println("<div class='info-box'>");
        out.println("<div class='icon'>📅</div>");
        out.println("<div class='value'>" + now.format(dateFormatter) + "</div>");
        out.println("<div class='label'>Today's Date</div>");
        out.println("</div>");
        
        out.println("<div class='info-box'>");
        out.println("<div class='icon'>⏰</div>");
        out.println("<div class='value'>" + now.format(timeFormatter) + "</div>");
        out.println("<div class='label'>Current Time</div>");
        out.println("</div>");
        
        out.println("<div class='info-box'>");
        out.println("<div class='icon'>🖥️</div>");
        out.println("<div class='value'>" + getServletContext().getServerInfo().split("/")[0] + "</div>");
        out.println("<div class='label'>Server</div>");
        out.println("</div>");
        
        out.println("</div>");
        
        out.println("<div class='card'>");
        out.println("<h2>✅ Request Information</h2>");
        out.println("<table>");
        out.println("<tr><td><strong>Remote Host:</strong></td><td>" + request.getRemoteHost() + "</td></tr>");
        out.println("<tr><td><strong>Request Method:</strong></td><td>" + request.getMethod() + "</td></tr>");
        out.println("<tr><td><strong>Request URI:</strong></td><td>" + request.getRequestURI() + "</td></tr>");
        out.println("<tr><td><strong>Session ID:</strong></td><td>" + request.getSession().getId() + "</td></tr>");
        out.println("</table>");
        out.println("</div>");
        
        out.println("<div class='card'>");
        out.println("<h2>🎯 Try Different Names</h2>");
        out.println("<form action='hello' method='get'>");
        out.println("<label for='name'>Enter a name:</label>");
        out.println("<input type='text' id='name' name='name' placeholder='Try another name...' value='" + escapeHtml(name) + "'>");
        out.println("<button type='submit'>✨ Say Hello</button>");
        out.println("</form>");
        out.println("</div>");
        
        out.println("<div style='text-align: center; margin-top: 30px;'>");
        out.println("<a href='index.jsp' class='button'>⬅️ Back to Home</a>");
        out.println("<a href='user' class='button' style='margin-left: 15px;'>👥 View Users</a>");
        out.println("</div>");
        
        out.println("</div>");
        out.println("</body>");
        out.println("</html>");
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
    
    private String getGreeting(int hour) {
        if (hour < 12) {
            return "Good Morning";
        } else if (hour < 18) {
            return "Good Afternoon";
        } else {
            return "Good Evening";
        }
    }
    
    private String escapeHtml(String text) {
        if (text == null) return "";
        return text.replace("&", "&amp;")
                   .replace("<", "&lt;")
                   .replace(">", "&gt;")
                   .replace("\"", "&quot;")
                   .replace("'", "&#39;");
    }
}
