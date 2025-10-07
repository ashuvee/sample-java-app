package com.example.webapp;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

public class UserServlet extends HttpServlet {
    
    private List<User> users = new ArrayList<>();
    
    @Override
    public void init() throws ServletException {
        users.add(new User(1, "John Doe", "john@example.com"));
        users.add(new User(2, "Jane Smith", "jane@example.com"));
        users.add(new User(3, "Bob Johnson", "bob@example.com"));
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        request.setAttribute("users", users);
        request.getRequestDispatcher("/users.jsp").forward(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String name = request.getParameter("name");
        String email = request.getParameter("email");
        
        if (name != null && !name.trim().isEmpty() && email != null && !email.trim().isEmpty()) {
            int id = users.size() + 1;
            users.add(new User(id, name, email));
        }
        
        response.sendRedirect("user");
    }
}
