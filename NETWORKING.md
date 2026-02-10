# 🌐 Networking Concepts in SafeDrop

This document explains the Computer Networks concepts demonstrated in this project.

## 1. Local Area Network (LAN)

### What is a LAN?

A Local Area Network connects devices in a limited geographic area (home, office, college lab) using Ethernet or Wi-Fi.

**Key Characteristics:**
- High speed (typically 100 Mbps - 10 Gbps)
- Low latency (< 1ms)
- Limited range (typically < 100 meters for Wi-Fi)
- No internet required
- Shared bandwidth among devices

### How SafeDrop Uses LAN

SafeDrop creates a file server on one device (the host) that other devices on the same LAN can access. This is fundamentally different from cloud storage:

**Cloud Storage Flow:**
```
Your Laptop → Internet → Cloud Server → Internet → Friend's Phone
(Slow: limited by upload speed)
```

**SafeDrop Flow:**
```
Your Laptop ←→ Wi-Fi Router ←→ Friend's Phone
(Fast: limited only by Wi-Fi speed)
```

### Code Implementation

```python
# views.py - get_local_ip()
def get_local_ip():
    """Get the local IP address of this machine"""
    s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
    s.connect(("8.8.8.8", 80))  # Connect to external address
    local_ip = s.getsockname()[0]  # Get local endpoint
    s.close()
    return local_ip
```

**Why this works:**
- Creates a UDP socket (no actual data sent)
- "Connects" to Google DNS (8.8.8.8)
- OS selects appropriate network interface
- `getsockname()` returns our local IP on that interface

## 2. IP Addressing

### IPv4 Address Structure

An IPv4 address is 32 bits, written as four octets:
```
192.168.1.5
│   │   │ │
│   │   │ └── Host (1-254)
│   │   └──── Subnet (0-255)
│   └──────── Network (0-255)
└──────────── Class (192.168 = Private Class C)
```

### Private IP Ranges (RFC 1918)

SafeDrop uses private IPs that aren't routable on the internet:

| Class | Range | Usage |
|-------|-------|-------|
| A | 10.0.0.0 - 10.255.255.255 | Large networks |
| B | 172.16.0.0 - 172.31.255.255 | Medium networks |
| C | 192.168.0.0 - 192.168.255.255 | Home/small office |

**Most common for home Wi-Fi:**
- `192.168.0.x` or `192.168.1.x`

### Special IP Addresses in SafeDrop

**127.0.0.1 (Localhost):**
- Loopback address
- Only accessible from the same machine
- Used for testing

**0.0.0.0 (All Interfaces):**
- Means "bind to all network interfaces"
- Allows connections from any network
- Used in: `runserver 0.0.0.0:8000`

**192.168.1.5 (Example LAN IP):**
- Actual IP on the local network
- Other devices use this to connect
- Changes based on DHCP assignment

## 3. Sockets and Ports

### What is a Socket?

A socket is an endpoint for network communication. Think of it as a "phone line" for programs.

**Socket Components:**
- IP Address (which computer)
- Port Number (which program/service)
- Protocol (TCP or UDP)

### Port Numbers

```
IP Address : Port
192.168.1.5:8000
│           │
│           └── Port 8000 (our server)
└── Host machine
```

**Common Ports:**
- 80: HTTP (web traffic)
- 443: HTTPS (secure web)
- 8000: Development servers (Django default)
- 22: SSH
- 21: FTP

### How SafeDrop Uses Sockets

```python
# Django binds to a socket when you run:
python manage.py runserver 0.0.0.0:8000

# This creates a TCP socket that:
# 1. Listens on all interfaces (0.0.0.0)
# 2. Uses port 8000
# 3. Accepts incoming HTTP connections
# 4. Handles requests via Django views
```

## 4. HTTP Protocol

### Request-Response Cycle

SafeDrop uses HTTP for client-server communication:

```
┌─────────┐                           ┌─────────┐
│ Browser │                           │  Django │
│ Client  │                           │  Server │
└────┬────┘                           └────┬────┘
     │                                     │
     │ GET / HTTP/1.1                      │
     │ Host: 192.168.1.5:8000              │
     │────────────────────────────────────>│
     │                                     │
     │                    HTTP/1.1 200 OK  │
     │         Content-Type: text/html     │
     │              <html>...</html>       │
     │<────────────────────────────────────│
     │                                     │
```

### HTTP Methods Used

**GET** - Retrieve data
```python
# Download file
def download_file(request, filename):
    file_path = settings.MEDIA_ROOT / filename
    return FileResponse(open(file_path, 'rb'))
```

**POST** - Upload data
```python
# Upload file
@csrf_exempt
def upload_file(request):
    uploaded_file = request.FILES['file']
    # Process upload...
```

### File Upload (Multipart Form Data)

Large files are uploaded in "multipart/form-data" format:

```http
POST /upload/ HTTP/1.1
Host: 192.168.1.5:8000
Content-Type: multipart/form-data; boundary=----WebKitFormBoundary

------WebKitFormBoundary
Content-Disposition: form-data; name="file"; filename="movie.mp4"
Content-Type: video/mp4

[Binary file data here...]
------WebKitFormBoundary--
```

Django handles this automatically with `request.FILES`.

## 5. Client-Server Architecture

### Architecture Diagram

```
┌──────────────────────────────────────────┐
│              Client Layer                 │
│  ┌────────┐  ┌────────┐  ┌────────┐      │
│  │Browser │  │ Phone  │  │ Tablet │      │
│  │   A    │  │Browser │  │Browser │      │
│  └───┬────┘  └───┬────┘  └───┬────┘      │
│      │           │            │           │
└──────┼───────────┼────────────┼───────────┘
       │           │            │
       │    HTTP Requests       │
       │           │            │
┌──────▼───────────▼────────────▼───────────┐
│         Wi-Fi Router (Switch)             │
│              192.168.1.1                  │
└───────────────────┬───────────────────────┘
                    │
┌───────────────────▼───────────────────────┐
│             Server Layer                  │
│  ┌────────────────────────────────┐       │
│  │      Django Application        │       │
│  │                                │       │
│  │  ┌──────────┐   ┌──────────┐  │       │
│  │  │  Views   │   │Templates │  │       │
│  │  │ (Logic)  │   │   (UI)   │  │       │
│  │  └──────────┘   └──────────┘  │       │
│  │                                │       │
│  │  ┌──────────────────────────┐ │       │
│  │  │   File System            │ │       │
│  │  │   /uploads/              │ │       │
│  │  └──────────────────────────┘ │       │
│  │                                │       │
│  │       192.168.1.5:8000         │       │
│  └────────────────────────────────┘       │
└────────────────────────────────────────────┘
```

### Request Flow

1. **Client** sends HTTP request to server IP
2. **Router** forwards packet to server
3. **Django** receives request on port 8000
4. **View** processes request (upload/download)
5. **Response** sent back to client
6. **Client** receives response

## 6. Network Layers (OSI Model)

SafeDrop operates at multiple layers:

| Layer | Protocol/Tech | Role in SafeDrop |
|-------|---------------|------------------|
| 7. Application | HTTP | Request/response |
| 6. Presentation | HTML/JSON | Data formatting |
| 5. Session | TCP | Connection management |
| 4. Transport | TCP | Reliable delivery |
| 3. Network | IP | Routing (192.168.1.x) |
| 2. Data Link | Wi-Fi/Ethernet | Physical transmission |
| 1. Physical | Radio/Cable | Actual bits |

## 7. DNS (Not Used in SafeDrop)

**Why SafeDrop doesn't use DNS:**
- DNS maps domain names to IPs (e.g., google.com → 142.250.80.46)
- SafeDrop uses direct IP addressing
- No need for domain name resolution on LAN

**How it could be added:**
- Setup local DNS server (dnsmasq)
- Map `safedrop.local` → `192.168.1.5`
- Clients use friendly URL instead of IP

## 8. Network Security Concepts

### Current Security in SafeDrop

**Path Traversal Protection:**
```python
def download_file(request, filename):
    file_path = settings.MEDIA_ROOT / filename
    
    # Security check: ensure file is within MEDIA_ROOT
    try:
        file_path.resolve().relative_to(settings.MEDIA_ROOT.resolve())
    except ValueError:
        return HttpResponse('Invalid file path', status=403)
```

This prevents attacks like:
```
/download/../../etc/passwd
```

### Missing Security (For Production)

**Should add for real-world use:**

1. **Authentication:**
```python
@login_required
def upload_file(request):
    # Only authenticated users can upload
```

2. **Encryption (HTTPS):**
```python
# Use SSL/TLS certificate
SECURE_SSL_REDIRECT = True
```

3. **Rate Limiting:**
```python
# Prevent abuse
@ratelimit(key='ip', rate='5/m')
def upload_file(request):
```

4. **File Type Validation:**
```python
ALLOWED_EXTENSIONS = {'pdf', 'png', 'jpg', 'mp4'}
if not filename.endswith(tuple(ALLOWED_EXTENSIONS)):
    return JsonResponse({'error': 'Invalid file type'})
```

## 9. Performance Optimization

### Chunked File Uploads

```python
# Memory-efficient upload (handles 10GB files)
for chunk in uploaded_file.chunks():
    destination.write(chunk)
```

**Why this matters:**
- Small chunk size (64KB default)
- Doesn't load entire file into memory
- Allows progress tracking
- Prevents memory overflow

### Network Throughput

**Typical transfer speeds:**

```
Wi-Fi 5 (802.11ac): 300-900 Mbps theoretical
                    30-100 MB/s real-world

Wi-Fi 6 (802.11ax): 600-9600 Mbps theoretical
                    80-200 MB/s real-world

Gigabit Ethernet:   1000 Mbps
                    100-120 MB/s real-world
```

**SafeDrop achieves close to theoretical maximum** because:
- No internet bottleneck
- Direct LAN transfer
- Efficient chunked uploads
- Minimal processing overhead

## 10. Troubleshooting with Network Tools

### Useful Commands

**Check if server is listening:**
```bash
# Windows
netstat -an | findstr :8000

# Linux/Mac
netstat -an | grep 8000
lsof -i :8000
```

**Test connectivity:**
```bash
# Ping the server
ping 192.168.1.5

# Test port connectivity
telnet 192.168.1.5 8000
nc -zv 192.168.1.5 8000  # netcat
```

**Check routing:**
```bash
# Windows
tracert 192.168.1.5

# Linux/Mac
traceroute 192.168.1.5
```

**View ARP table (IP to MAC mapping):**
```bash
arp -a
```

## Summary: Why This Matters for Interviews

When discussing SafeDrop in interviews, emphasize:

1. **Practical Application**: Solved real problem with networking knowledge
2. **Multiple Concepts**: HTTP, sockets, IP addressing, LAN architecture
3. **System Design**: Client-server model, request-response cycle
4. **Security Awareness**: Path traversal protection, discussed production security
5. **Performance**: Chunked uploads, efficient file handling
6. **Troubleshooting**: Understanding of network debugging tools

**Sample Interview Answer:**
> "I built SafeDrop to solve slow file transfers in my college lab. Instead of uploading to the cloud, I used Python's socket library to detect the local IP, then ran a Django server bound to 0.0.0.0:8000 so other devices on the LAN could connect directly. Files transfer at Wi-Fi speed—about 50MB/s—which is 10-20x faster than our internet upload. The project demonstrates HTTP, IP addressing, client-server architecture, and secure file handling with chunked uploads."

This shows you understand networking at both theoretical and practical levels! 🎯
