#!/bin/bash

echo "=============================================="
echo " Starting FastAPI app on Render..."
echo "=============================================="

# ================= CREATE & ACTIVATE VENV (if local) =================
if [ ! -d "venv" ]; then
    echo "Creating virtual environment..."
    python3 -m venv venv
fi
source venv/bin/activate

# ================= INSTALL REQUIREMENTS =================
if [ ! -f ".deps_installed" ]; then
    echo "Installing dependencies from requirements.txt..."
    pip install --no-cache-dir -r requirements.txt
    touch .deps_installed
else
    echo "Dependencies already installed. Skipping pip install."
fi

# ================= DETECT APP FILE =================
if [ -f "main.py" ]; then
    APP_TARGET="main:app"
elif [ -f "app.py" ]; then
    APP_TARGET="app:app"
else
    echo "Could not detect FastAPI entry file. Please enter module:variable (e.g., app:app)"
    read -p "Module:Variable => " APP_TARGET
fi

# ================= START UVICORN =================
echo "Starting uvicorn server on port ${PORT:-8000}..."
uvicorn $APP_TARGET --host 0.0.0.0 --port ${PORT:-8000}
