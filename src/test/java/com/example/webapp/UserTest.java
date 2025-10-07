package com.example.webapp;

import org.junit.Test;
import static org.junit.Assert.*;

public class UserTest {
    
    @Test
    public void testUserCreation() {
        User user = new User(1, "Test User", "test@example.com");
        
        assertEquals(1, user.getId());
        assertEquals("Test User", user.getName());
        assertEquals("test@example.com", user.getEmail());
    }
    
    @Test
    public void testUserSetters() {
        User user = new User(1, "Test User", "test@example.com");
        
        user.setId(2);
        user.setName("Updated User");
        user.setEmail("updated@example.com");
        
        assertEquals(2, user.getId());
        assertEquals("Updated User", user.getName());
        assertEquals("updated@example.com", user.getEmail());
    }
}
