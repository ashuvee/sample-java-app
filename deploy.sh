#!/bin/bash

# Simple deployment script for sample-webapp
# Usage: ./deploy.sh [tomcat|jetty|run]

set -e

echo "========================================="
echo "Sample Java Web Application - Deployment"
echo "========================================="

# Check if Maven is installed
if ! command -v mvn &> /dev/null; then
    echo "Error: Maven is not installed or not in PATH"
    exit 1
fi

# Parse command line arguments
ACTION=${1:-"build"}

case $ACTION in
    tomcat)
        echo "Building and deploying to Tomcat..."
        mvn clean package
        
        if [ -z "$CATALINA_HOME" ]; then
            echo "Warning: CATALINA_HOME is not set"
            echo "Please set CATALINA_HOME or manually copy target/sample-webapp.war to Tomcat's webapps directory"
        else
            echo "Copying WAR to $CATALINA_HOME/webapps/"
            cp target/sample-webapp.war $CATALINA_HOME/webapps/
            echo "Deployed successfully!"
            echo "Start Tomcat and access: http://localhost:8080/sample-webapp/"
        fi
        ;;
        
    jetty)
        echo "Running with embedded Jetty..."
        mvn clean jetty:run
        ;;
        
    run)
        echo "Running with embedded Jetty (default)..."
        mvn clean jetty:run
        ;;
        
    build)
        echo "Building WAR file..."
        mvn clean package
        echo ""
        echo "Build successful! WAR file created at: target/sample-webapp.war"
        echo ""
        echo "Deployment options:"
        echo "  1. Copy to Tomcat:   cp target/sample-webapp.war \$CATALINA_HOME/webapps/"
        echo "  2. Copy to JBoss:    cp target/sample-webapp.war \$JBOSS_HOME/standalone/deployments/"
        echo "  3. Deploy to GlassFish: asadmin deploy target/sample-webapp.war"
        echo "  4. Run with Jetty:   ./deploy.sh jetty"
        ;;
        
    clean)
        echo "Cleaning build artifacts..."
        mvn clean
        echo "Clean completed!"
        ;;
        
    test)
        echo "Running tests..."
        mvn test
        ;;
        
    *)
        echo "Usage: $0 [build|tomcat|jetty|run|clean|test]"
        echo ""
        echo "Commands:"
        echo "  build   - Build the WAR file (default)"
        echo "  tomcat  - Build and deploy to Tomcat (requires CATALINA_HOME)"
        echo "  jetty   - Run with embedded Jetty server"
        echo "  run     - Same as jetty"
        echo "  clean   - Clean build artifacts"
        echo "  test    - Run tests"
        exit 1
        ;;
esac
