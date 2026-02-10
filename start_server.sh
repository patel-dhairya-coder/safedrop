#!/bin/bash

echo "========================================"
echo "SafeDrop - Secure LAN File Transfer"
echo "========================================"
echo ""

# Check if Django is installed
python3 -c "import django" 2>/dev/null
if [ $? -ne 0 ]; then
    echo "Django is not installed. Installing now..."
    pip3 install django
    if [ $? -ne 0 ]; then
        echo "Error: Failed to install Django"
        echo "Please run: pip3 install django"
        exit 1
    fi
fi

echo "Starting SafeDrop server..."
echo ""
echo "Share this URL with others on your Wi-Fi:"
echo ""

cd safedrop_project
python3 manage.py runserver 0.0.0.0:8000
