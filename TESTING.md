# 🧪 Testing & Demo Guide

## Testing on a Single Computer (Localhost)

Before testing on a network, verify everything works locally:

### Step 1: Start the Server
```bash
cd safedrop_project
python manage.py runserver
```

### Step 2: Open in Browser
Visit: `http://localhost:8000` or `http://127.0.0.1:8000`

### Step 3: Test Features

**Upload Test:**
1. Drag a file onto the drop zone
2. Watch the progress bar
3. File should appear in the "Available Files" section

**Download Test:**
1. Click "Download" on any file
2. File should download to your Downloads folder

**Delete Test:**
1. Click "Delete" on a file
2. Confirm the deletion
3. File should disappear from the list

## Testing on Multiple Devices (LAN)

### Setup Network Test

**Requirements:**
- 2+ devices (laptop, phone, tablet, etc.)
- Same Wi-Fi network
- Firewall configured to allow connections

### Test Scenario 1: Mobile to Laptop Transfer

**Host (Laptop):**
```bash
python manage.py runserver 0.0.0.0:8000
```
Note your IP: e.g., `192.168.1.5`

**Client (Mobile):**
1. Open browser (Chrome/Safari)
2. Enter: `http://192.168.1.5:8000`
3. Upload a photo from your phone
4. Verify it appears on the laptop in `uploads/` folder

### Test Scenario 2: Laptop to Laptop Transfer

**Host (Laptop A):**
- Run server
- Place a large file (e.g., 500MB video) in the `uploads/` folder manually

**Client (Laptop B):**
- Connect to host's URL
- Download the file
- Measure transfer speed (should be 10-100 MB/s on good Wi-Fi)

### Test Scenario 3: Multiple Simultaneous Uploads

**Host:**
- Start server

**Clients (3+ devices):**
- All upload different files simultaneously
- Verify all files complete successfully
- Check server terminal for upload logs

## Performance Testing

### Speed Test
```python
# Create a 1GB test file
python -c "with open('test_1gb.bin', 'wb') as f: f.write(b'0' * 1024*1024*1024)"
```

Upload this file and time the transfer:
- **Expected on Wi-Fi 5 (802.11ac)**: 30-80 MB/s
- **Expected on Wi-Fi 6**: 80-150 MB/s
- **Expected on Gigabit Ethernet**: 100-120 MB/s

### Stress Test
Upload multiple large files:
```bash
# Create 5 x 500MB test files
for i in {1..5}; do
    python -c "with open('test_${i}.bin', 'wb') as f: f.write(b'0' * 500*1024*1024)"
done
```

Monitor system resources while uploading all files.

## Demo for Presentations

### Preparation (5 minutes before demo)

1. **Start the server** on your laptop
2. **Connect phone** to same Wi-Fi
3. **Test upload** a small file to verify connection
4. **Prepare test files**: Have a few files ready (image, PDF, video)
5. **Note your IP**: Write it on a slide or whiteboard

### Live Demo Script (5 minutes)

**Introduction (30 seconds):**
> "SafeDrop solves the problem of slow file transfers in college labs. Instead of uploading to the cloud and downloading again, we transfer directly over Wi-Fi."

**Demo 1: Show the Interface (30 seconds):**
- Open the homepage
- Point out the drag-and-drop zone
- Show the network info with IP address

**Demo 2: Upload from Phone (60 seconds):**
- Show your phone screen (via screen mirroring if available)
- Navigate to the URL on your phone
- Drag/select a photo
- Show the upload progress bar
- Photo appears in the file list

**Demo 3: Download to Another Device (60 seconds):**
- Open the app on a second device
- Show the uploaded files
- Click download
- File downloads at Wi-Fi speed (mention speed)

**Demo 4: Technical Explanation (90 seconds):**
- Show the code structure
- Explain socket programming for IP detection
- Mention chunked uploads for large files
- Highlight LAN vs Internet transfer

**Conclusion (30 seconds):**
> "This demonstrates practical Computer Networks concepts: LANs, HTTP, and sockets. Perfect for hostels or labs where internet is limited but Wi-Fi is fast."

## Troubleshooting During Demo

**If connection fails:**
```bash
# Quickly check your IP
ipconfig  # Windows
ifconfig  # Mac/Linux

# Verify server is running on 0.0.0.0:8000
# Check the terminal output
```

**If upload is slow:**
- Mention this could be due to:
  - Wi-Fi congestion (many devices)
  - Distance from router
  - Interference
- Compare to internet upload (which would be slower!)

**If browser can't connect:**
- Check firewall
- Try phone's cellular browser (shouldn't work - proves it's LAN-only)
- Restart server

## Network Diagram for Presentation

```
┌─────────────────────────────────────────────┐
│           Wi-Fi Router (192.168.1.1)        │
│              (Access Point)                  │
└─────────────────┬───────────────────────────┘
                  │
        ┌─────────┴─────────┐
        │                   │
   ┌────▼─────┐      ┌─────▼─────┐
   │  Laptop  │      │   Phone   │
   │ (Host)   │      │ (Client)  │
   │          │      │           │
   │ Django   │◄────►│  Browser  │
   │ Server   │ HTTP │           │
   │          │      │           │
   │192.168.1.5│     │192.168.1.8│
   └──────────┘      └───────────┘
        ▲
        │ HTTP
        │
   ┌────▼──────┐
   │  Laptop2  │
   │ (Client)  │
   │           │
   │  Browser  │
   │           │
   │192.168.1.7│
   └───────────┘
```

## Interview Questions to Prepare

Based on this project, you might be asked:

**Networking:**
1. "How does your app discover the local IP address?"
2. "What's the difference between 127.0.0.1 and 0.0.0.0?"
3. "Why can't this work over the internet?"
4. "How would you secure this for untrusted networks?"

**Web Development:**
1. "How do you handle large file uploads efficiently?"
2. "What happens if two users upload files with the same name?"
3. "How does drag-and-drop work in the browser?"

**System Design:**
1. "How would you scale this for 100 simultaneous users?"
2. "What are the security risks?"
3. "How would you add user authentication?"

## Answers to Have Ready

**"How does it find the IP?"**
> "I use Python's socket library to create a UDP socket and connect to an external address. The socket's local endpoint gives me the LAN IP. This is in the get_local_ip() function."

**"Why 0.0.0.0:8000?"**
> "Binding to 0.0.0.0 means 'accept connections on all network interfaces.' This allows LAN devices to connect. 127.0.0.1 would only allow localhost connections."

**"Security concerns?"**
> "Currently designed for trusted networks only. For production, I'd add authentication, HTTPS, rate limiting, file type restrictions, and virus scanning. The project has path traversal protection built in."

## Success Metrics

Your demo is successful if you can show:
- ✅ File upload from mobile device
- ✅ Download to another device  
- ✅ Transfer speed > internet upload
- ✅ No internet required
- ✅ Clean, professional UI
- ✅ Explain the networking concepts

Good luck with your demo! 🚀
