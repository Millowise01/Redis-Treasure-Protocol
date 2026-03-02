@echo off
echo ========================================
echo STEP 2: Accessing Clue 2 (TTL Challenge)
echo ========================================
echo.

curl http://localhost:7000/clue/2
echo.

echo ========================================
echo If successful, you should see clue 2.
echo If failed, the temp_key expired - try again!
echo ========================================
pause
