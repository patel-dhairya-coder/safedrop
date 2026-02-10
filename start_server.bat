@echo off
echo ========================================
echo SafeDrop - Secure LAN File Transfer
echo ========================================
echo.

REM Check if Django is installed
python -c "import django" 2>nul
if errorlevel 1 (
    echo Django is not installed. Installing now...
    pip install django
    if errorlevel 1 (
        echo Error: Failed to install Django
        echo Please run: pip install django
        pause
        exit /b 1
    )
)

echo Starting SafeDrop server...
echo.
echo Share this URL with others on your Wi-Fi:
echo.

cd safedrop_project
python manage.py runserver 0.0.0.0:8000

pause
