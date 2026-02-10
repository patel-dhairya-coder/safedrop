# 🔒 SafeDrop - Secure LAN File Transfer

A browser-based file transfer application that enables **fast, secure file sharing** over local networks **without internet**. Perfect for college labs, hostels, and offices.

## 🎯 The Problem

- **Slow transfers**: Uploading 2GB files to Google Drive/WhatsApp wastes time and data
- **USB virus risk**: Physical drives can spread malware
- **Limited options**: Need a simple way to share large files on the same Wi-Fi

## ✨ The Solution

SafeDrop creates a local web server on your laptop that allows anyone on the same Wi-Fi network to:
- Upload files to your computer via drag-and-drop
- Download files you've shared
- Transfer at **full Wi-Fi speed** (typically 10-100 MB/s)
- Work **completely offline** - no internet required

## 🛠️ Tech Stack

- **Backend**: Django (Python web framework)
- **Networking**: Python `socket` library for IP detection
- **Frontend**: Vanilla JavaScript with drag-and-drop API
- **File Handling**: Chunked uploads for large files (supports up to 10GB)
- **No Database Required**: Direct filesystem operations

## 📋 Prerequisites

- Python 3.8 or higher
- pip (Python package manager)
- Wi-Fi network (or create a hotspot)

## 🚀 Installation & Setup

### Step 1: Install Django

```bash
pip install django
```

Or if you get permission errors:

```bash
pip install django --user
```

### Step 2: Navigate to Project Directory

```bash
cd safedrop_project
```

### Step 3: Run the Server

```bash
python manage.py runserver 0.0.0.0:8000
```

The `0.0.0.0:8000` allows connections from any device on your network.

### Step 4: Find Your Local IP Address

The application will display your IP address on the homepage, but you can also find it manually:

**On Windows:**
```bash
ipconfig
```
Look for "IPv4 Address" under your Wi-Fi adapter (e.g., `192.168.1.5`)

**On Mac/Linux:**
```bash
ifconfig
```
or
```bash
ip addr show
```
Look for your Wi-Fi interface (e.g., `192.168.1.5`)

### Step 5: Share the URL

Share this URL with others on your network:
```
http://YOUR_IP_ADDRESS:8000
```

Example: `http://192.168.1.5:8000`

They can type this into any browser (phone, laptop, tablet) to access SafeDrop!

## 📱 Usage

### For the Host (You)

1. Start the server using `python manage.py runserver 0.0.0.0:8000`
2. Keep the terminal window open
3. Share your IP address with others
4. Monitor uploads in real-time
5. Files are saved in the `uploads/` directory

### For Clients (Others on Your Network)

1. Open a web browser
2. Enter the host's URL (e.g., `http://192.168.1.5:8000`)
3. Drag and drop files or click to browse
4. Download any files shared by the host
5. Upload speed = your Wi-Fi speed!

## 🎨 Features

### ✅ Implemented

- **Drag-and-drop interface**: Intuitive file uploads
- **Multiple file support**: Upload several files at once
- **Real-time progress**: Visual upload progress bar
- **File management**: View, download, and delete files
- **Duplicate handling**: Auto-renames duplicate filenames
- **Large file support**: Handles files up to 10GB
- **Responsive design**: Works on desktop and mobile
- **Network info display**: Shows your IP and connection details
- **Security**: Path traversal protection

### 🔜 Potential Enhancements

- **Password protection**: Require authentication for uploads
- **QR code sharing**: Generate QR code for easy mobile access
- **Transfer history**: Log all uploads/downloads
- **Folder uploads**: Support directory uploads
- **Preview**: Image/video previews before download
- **Compression**: Optional file compression
- **Encryption**: End-to-end encryption for sensitive files

## 📁 Project Structure

```
safedrop_project/
├── manage.py                 # Django management script
├── settings.py              # Django configuration
├── urls.py                  # Main URL routing
├── wsgi.py                  # WSGI configuration
├── safedrop_app/            # Main application
│   ├── __init__.py
│   ├── views.py            # Request handlers
│   ├── urls.py             # App-specific URLs
│   └── templates/
│       └── index.html      # Main HTML template
├── static/                  # Static files
│   ├── css/
│   │   └── style.css       # Stylesheet
│   └── js/
│       └── main.js         # JavaScript logic
├── uploads/                 # Uploaded files storage
└── shared_files/           # Files to share (optional)
```

## 🔬 How It Works (Technical Details)

### 1. Network Discovery
```python
def get_local_ip():
    s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
    s.connect(("8.8.8.8", 80))  # Connect to external address
    local_ip = s.getsockname()[0]  # Get local IP
    return local_ip
```

### 2. File Upload (Chunked)
```python
# Memory-efficient chunked upload
for chunk in uploaded_file.chunks():
    destination.write(chunk)
```

### 3. HTTP Server
Django's development server binds to `0.0.0.0:8000`, making it accessible to any device on the LAN.

### 4. Client-Server Communication
- **Upload**: POST request with multipart/form-data
- **Download**: GET request, returns FileResponse with streaming
- **File List**: JSON API endpoint
- **Delete**: POST request with CSRF exemption for simplicity

## 🌐 Network Concepts Demonstrated

This project showcases understanding of:

1. **Local Area Networks (LAN)**: Communication between devices on the same network
2. **IP Addressing**: IPv4 addressing and localhost vs. LAN IPs
3. **HTTP Protocol**: Request/response cycle, methods (GET, POST)
4. **Sockets**: Low-level network programming for IP detection
5. **Client-Server Architecture**: Browser-based clients, Python server
6. **Port Binding**: Binding to `0.0.0.0` vs. `127.0.0.1`

## 🔒 Security Considerations

**Current Security Features:**
- Path traversal protection
- File size limits
- Input sanitization

**⚠️ Important Warnings:**
- This is designed for **trusted local networks** only
- Not suitable for public/untrusted networks without modifications
- No authentication by default
- CSRF protection disabled for simplicity

**For Production Use, Add:**
- User authentication
- HTTPS/TLS encryption
- Rate limiting
- File type restrictions
- Virus scanning

## 🐛 Troubleshooting

### "Connection Refused" Error
- Ensure server is running with `0.0.0.0:8000`
- Check firewall isn't blocking port 8000
- Verify you're on the same Wi-Fi network

### Can't Find IP Address
- Run `ipconfig` (Windows) or `ifconfig` (Mac/Linux)
- IP should start with `192.168.x.x` or `10.x.x.x`
- Avoid using `127.0.0.1` (that's localhost only)

### Upload Fails
- Check file size < 10GB
- Ensure sufficient disk space
- Try smaller files first to test

### Firewall Blocking
**Windows:**
```
Windows Defender Firewall > Allow an app > Add Python
```

**Mac:**
```
System Preferences > Security & Privacy > Firewall > Allow Python
```

## 📝 License

This is a student project created for educational purposes.

## 🤝 Contributing

This is a portfolio project, but feel free to fork and enhance!

**Ideas for Enhancement:**
- Add authentication system
- Implement file encryption
- Create mobile app version
- Add peer-to-peer mode
- Support video streaming

---

**⭐ If you found this useful, give it a star and share with your classmates!**
