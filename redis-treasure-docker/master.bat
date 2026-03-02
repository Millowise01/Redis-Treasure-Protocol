@echo off
title Redis Treasure Protocol - Master Script
color 0A

:MENU
cls
echo ========================================
echo   REDIS TREASURE PROTOCOL
echo   Master Execution Script
echo ========================================
echo.
echo Current Time: %time%
echo.
echo [0] Setup - Start Docker Services
echo [1] Step 1 - Rate Limiting Attack
echo [2] Step 2 - Get Redis Container Info
echo [3] Step 4 - Claim Treasure
echo [T] Show Timestamp
echo [V] Verify Services
echo [Q] Quit
echo.
echo ========================================
set /p choice="Enter your choice: "

if /i "%choice%"=="0" goto SETUP
if /i "%choice%"=="1" goto STEP1
if /i "%choice%"=="2" goto STEP2
if /i "%choice%"=="3" goto STEP4
if /i "%choice%"=="T" goto TIMESTAMP
if /i "%choice%"=="V" goto VERIFY
if /i "%choice%"=="Q" goto QUIT
goto MENU

:SETUP
cls
echo ========================================
echo STEP 0: Starting Docker Services
echo ========================================
echo.
echo This will start the containers...
echo Press Ctrl+C to stop when ready.
echo.
pause
docker-compose up --build
goto MENU

:STEP1
cls
echo ========================================
echo STEP 1: Rate Limiting Attack
echo ========================================
echo Timestamp: %date% %time%
echo.
echo Sending 6 rapid requests...
echo.
curl http://localhost:7000/clue/1
echo.
echo ---
curl http://localhost:7000/clue/1
echo.
echo ---
curl http://localhost:7000/clue/1
echo.
echo ---
curl http://localhost:7000/clue/1
echo.
echo ---
curl http://localhost:7000/clue/1
echo.
echo ---
curl http://localhost:7000/clue/1
echo.
echo ========================================
echo SCREENSHOT #2: Capture the 429 error above
echo ========================================
pause
goto MENU

:STEP2
cls
echo ========================================
echo STEP 2: Redis Container Info
echo ========================================
echo.
docker ps
echo.
echo ========================================
echo NEXT STEPS (Manual):
echo.
echo 1. Find the redis container ID above
echo 2. Run: docker exec -it [ID] redis-cli
echo 3. In redis-cli: SETEX temp_key 10 unlock
echo 4. IMMEDIATELY run: curl http://localhost:7000/clue/2
echo.
echo Or use step2.bat for the curl command
echo ========================================
pause
goto MENU

:STEP4
cls
echo ========================================
echo STEP 4: Claiming the Treasure
echo ========================================
echo Timestamp: %date% %time%
echo.
echo First request (from MongoDB):
curl http://localhost:7000/treasure
echo.
echo.
echo Second request (from Redis Cache):
curl http://localhost:7000/treasure
echo.
echo ========================================
echo SCREENSHOT #5: Capture both responses
echo Notice: Caching in action!
echo ========================================
pause
goto MENU

:TIMESTAMP
cls
echo ========================================
echo CURRENT TIMESTAMP
echo ========================================
echo.
echo Date: %date%
echo Time: %time%
echo.
echo ========================================
pause
goto MENU

:VERIFY
cls
echo ========================================
echo Verifying Services
echo ========================================
echo.
echo Checking Docker containers...
docker ps
echo.
echo Testing API connection...
curl http://localhost:7000/clue/1
echo.
echo ========================================
pause
goto MENU

:QUIT
cls
echo ========================================
echo Thank you for using the master script!
echo Good luck with your treasure hunt!
echo ========================================
exit
