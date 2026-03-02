@echo off
echo ========================================
echo Redis Treasure Protocol - Automated Runner
echo ========================================
echo.

echo STEP 1: Breaking the Gatekeeper (Rate Limiting)
echo Sending 6 rapid requests to trigger rate limit...
echo.

curl http://localhost:7000/clue/1
echo.
curl http://localhost:7000/clue/1
echo.
curl http://localhost:7000/clue/1
echo.
curl http://localhost:7000/clue/1
echo.
curl http://localhost:7000/clue/1
echo.
curl http://localhost:7000/clue/1
echo.

echo ========================================
echo You should see a 429 error above.
echo.
echo NEXT STEPS (Manual):
echo 1. Get Redis container ID: docker ps
echo 2. Connect to Redis: docker exec -it [container_id] redis-cli
echo 3. Run: SETEX temp_key 10 unlock
echo 4. Run step2.bat IMMEDIATELY (within 10 seconds)
echo ========================================
pause
