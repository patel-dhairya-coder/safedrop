# 🚀 QUICKSTART GUIDE

## For Windows Users

1. **Double-click** `start_server.bat`
2. The script will:
   - Check for Django (install if needed)
   - Start the server
   - Display your connection URL
3. **Share the URL** with others on your Wi-Fi
4. **Keep the window open** while transferring files

## For Mac/Linux Users

1. **Open Terminal** in this directory
2. **Run**: `./start_server.sh`
   (or `bash start_server.sh`)
3. The script will:
   - Check for Django (install if needed)
   - Start the server
   - Display your connection URL
4. **Share the URL** with others on your Wi-Fi
5. **Keep the terminal open** while transferring files

## Manual Setup (All Platforms)

```bash
# Install Django
pip install django

# Navigate to project
cd safedrop_project

# Start server
python manage.py runserver 0.0.0.0:8000
```

## Finding Your IP Address

### Windows
```
ipconfig
```
Look for "IPv4 Address" (e.g., 192.168.1.5)

### Mac/Linux
```
ifconfig
```
or
```
ip addr
```
Look for your Wi-Fi IP (e.g., 192.168.1.5)

## Access Points

- **On your computer**: http://localhost:8000
- **From other devices**: http://YOUR_IP:8000

Example: `http://192.168.1.5:8000`

## First Time Usage

1. Open the URL in your browser
2. You'll see your IP address at the top
3. Click the "Copy" button to copy the full URL
4. Send this URL to others via chat/message
5. They can now upload/download files!

## Stopping the Server

- **Windows**: Press `Ctrl + C` in the command window
- **Mac/Linux**: Press `Ctrl + C` in the terminal

## Need Help?

Check the full README.md for:
- Troubleshooting
- Security considerations
- Technical details
- Feature enhancements

## Common Issues

**"Port already in use"**
- Another program is using port 8000
- Change the port: `python manage.py runserver 0.0.0.0:8001`

**"Connection refused"**
- Check firewall settings
- Make sure you're on the same Wi-Fi network
- Verify the server is running

**"ModuleNotFoundError: No module named 'django'"**
- Django isn't installed
- Run: `pip install django`

---

**Enjoy fast, secure file transfers! 🚀**
