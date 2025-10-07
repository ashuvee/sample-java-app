@echo off
REM Simple deployment script for sample-webapp (Windows)
REM Usage: deploy.bat [tomcat|jetty|run|build|clean|test]

echo =========================================
echo Sample Java Web Application - Deployment
echo =========================================
echo.

REM Check if Maven is installed
where mvn >nul 2>nul
if %ERRORLEVEL% NEQ 0 (
    echo Error: Maven is not installed or not in PATH
    exit /b 1
)

REM Parse command line arguments
set ACTION=%1
if "%ACTION%"=="" set ACTION=build

if "%ACTION%"=="tomcat" goto tomcat
if "%ACTION%"=="jetty" goto jetty
if "%ACTION%"=="run" goto jetty
if "%ACTION%"=="build" goto build
if "%ACTION%"=="clean" goto clean
if "%ACTION%"=="test" goto test
goto usage

:tomcat
echo Building and deploying to Tomcat...
call mvn clean package
if %ERRORLEVEL% NEQ 0 exit /b %ERRORLEVEL%

if "%CATALINA_HOME%"=="" (
    echo Warning: CATALINA_HOME is not set
    echo Please set CATALINA_HOME or manually copy target\sample-webapp.war to Tomcat's webapps directory
) else (
    echo Copying WAR to %CATALINA_HOME%\webapps\
    copy target\sample-webapp.war %CATALINA_HOME%\webapps\
    echo Deployed successfully!
    echo Start Tomcat and access: http://localhost:8080/sample-webapp/
)
goto end

:jetty
echo Running with embedded Jetty...
call mvn clean jetty:run
goto end

:build
echo Building WAR file...
call mvn clean package
if %ERRORLEVEL% NEQ 0 exit /b %ERRORLEVEL%
echo.
echo Build successful! WAR file created at: target\sample-webapp.war
echo.
echo Deployment options:
echo   1. Copy to Tomcat:      copy target\sample-webapp.war %%CATALINA_HOME%%\webapps\
echo   2. Copy to JBoss:       copy target\sample-webapp.war %%JBOSS_HOME%%\standalone\deployments\
echo   3. Deploy to GlassFish: asadmin deploy target\sample-webapp.war
echo   4. Run with Jetty:      deploy.bat jetty
goto end

:clean
echo Cleaning build artifacts...
call mvn clean
echo Clean completed!
goto end

:test
echo Running tests...
call mvn test
goto end

:usage
echo Usage: %0 [build^|tomcat^|jetty^|run^|clean^|test]
echo.
echo Commands:
echo   build   - Build the WAR file (default)
echo   tomcat  - Build and deploy to Tomcat (requires CATALINA_HOME)
echo   jetty   - Run with embedded Jetty server
echo   run     - Same as jetty
echo   clean   - Clean build artifacts
echo   test    - Run tests
exit /b 1

:end
