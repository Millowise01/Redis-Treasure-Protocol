@echo off
echo ========================================
echo STEP 4: Claiming the Treasure
echo ========================================
echo.

echo First request (should be from MongoDB):
curl http://localhost:7000/treasure
echo.
echo.

echo Second request (should be from Redis Cache):
curl http://localhost:7000/treasure
echo.

echo ========================================
echo Notice the source field difference!
echo First: MongoDB, Second: Redis Cache
echo ========================================
pause
