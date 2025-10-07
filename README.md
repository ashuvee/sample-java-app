# Sample Java Web Application

A simple Java web application for practicing build and deployment with various application servers.

## Features

- **Servlet-based architecture** with two example servlets
- **JSP pages** with JSTL support
- **User management demo** with in-memory storage
- **Modern CSS styling** with responsive design
- **Maven-based build** for easy dependency management
- **Compatible with multiple servers**: Tomcat, JBoss, GlassFish, and Jetty

## Prerequisites

- Java Development Kit (JDK) 11 or higher
- Apache Maven 3.6 or higher
- One of the following application servers:
  - Apache Tomcat 9.x or 10.x
  - JBoss/WildFly
  - GlassFish 5.x or higher
  - Jetty 9.x or higher

## Project Structure

```
sample-webapp/
├── pom.xml
├── src/
│   ├── main/
│   │   ├── java/
│   │   │   └── com/example/webapp/
│   │   │       ├── HelloServlet.java
│   │   │       ├── UserServlet.java
│   │   │       └── User.java
│   │   └── webapp/
│   │       ├── WEB-INF/
│   │       │   └── web.xml
│   │       ├── css/
│   │       │   └── style.css
│   │       ├── index.jsp
│   │       └── users.jsp
│   └── test/
│       └── java/
│           └── com/example/webapp/
│               └── UserTest.java
└── README.md
```

## Building the Application

### 1. Clean and Build

```bash
mvn clean package
```

This will create a WAR file at `target/sample-webapp.war`

### 2. Run Tests

```bash
mvn test
```

## Deployment Options

### Option 1: Deploy to Apache Tomcat

1. Build the application:
   ```bash
   mvn clean package
   ```

2. Copy the WAR file to Tomcat's webapps directory:
   ```bash
   cp target/sample-webapp.war $CATALINA_HOME/webapps/
   ```

3. Start Tomcat:
   ```bash
   $CATALINA_HOME/bin/startup.sh     # Linux/Mac
   $CATALINA_HOME/bin/startup.bat    # Windows
   ```

4. Access the application at: `http://localhost:8080/sample-webapp/`

### Option 2: Deploy to JBoss/WildFly

1. Build the application:
   ```bash
   mvn clean package
   ```

2. Copy the WAR file to JBoss deployments directory:
   ```bash
   cp target/sample-webapp.war $JBOSS_HOME/standalone/deployments/
   ```

3. Start JBoss:
   ```bash
   $JBOSS_HOME/bin/standalone.sh     # Linux/Mac
   $JBOSS_HOME/bin/standalone.bat    # Windows
   ```

4. Access the application at: `http://localhost:8080/sample-webapp/`

### Option 3: Deploy to GlassFish

1. Build the application:
   ```bash
   mvn clean package
   ```

2. Start GlassFish:
   ```bash
   asadmin start-domain
   ```

3. Deploy using the admin console or command line:
   ```bash
   asadmin deploy target/sample-webapp.war
   ```

4. Access the application at: `http://localhost:8080/sample-webapp/`

### Option 4: Run with Embedded Jetty (Development)

The easiest way for development and testing:

```bash
mvn jetty:run
```

Access the application at: `http://localhost:8080/sample-webapp/`

Press `Ctrl+C` to stop the server.

### Option 5: Run with Embedded Tomcat (Development)

```bash
mvn tomcat7:run
```

Access the application at: `http://localhost:8080/sample-webapp/`

## Application Features

### Home Page (`/`)
- Welcome page with application overview
- Form to test the Hello Servlet
- Links to other pages

### Hello Servlet (`/hello`)
- Demonstrates basic servlet functionality
- Accepts a `name` parameter (optional)
- Displays current server time and server info

Example URLs:
- `http://localhost:8080/sample-webapp/hello`
- `http://localhost:8080/sample-webapp/hello?name=John`

### User Management (`/user`)
- View list of users
- Add new users via form
- Demonstrates servlet forwarding to JSP
- Uses JSTL for rendering

## Customization

### Changing the Port (Development Mode)

For Jetty:
```bash
mvn jetty:run -Djetty.http.port=9090
```

For Tomcat:
```bash
mvn tomcat7:run -Dmaven.tomcat.port=9090
```

### Modifying Context Path

Edit the `pom.xml` file and change the `contextPath` in the respective plugin configuration.

## Troubleshooting

### Port Already in Use
If port 8080 is already in use, either:
- Stop the service using port 8080
- Use a different port (see Customization section)

### Build Failures
- Ensure JDK 11 or higher is installed: `java -version`
- Ensure Maven is installed: `mvn -version`
- Clear Maven cache: `mvn clean`

### Deployment Issues
- Check server logs in the respective server's log directory
- Verify the WAR file is valid: `jar -tf target/sample-webapp.war`
- Ensure no other application is using the same context path

## Maven Commands Reference

```bash
# Clean the project
mvn clean

# Compile the source code
mvn compile

# Run tests
mvn test

# Package as WAR file
mvn package

# Clean and package
mvn clean package

# Run with Jetty
mvn jetty:run

# Run with Tomcat
mvn tomcat7:run

# Skip tests during build
mvn package -DskipTests
```

## Next Steps

- Add database connectivity (JDBC/JPA)
- Implement authentication and authorization
- Add REST API endpoints
- Integrate with frontend frameworks
- Add logging framework (Log4j/SLF4J)
- Implement session management
- Add form validation
- Create additional servlets and filters

## License

This is a sample application for educational purposes.
