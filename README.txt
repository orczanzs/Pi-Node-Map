# **Pi Node Map**

Pi Node Map is a lightweight, real‑time visualization tool that displays all active peer connections of your Pi Node on an interactive world map.  
It automatically detects inbound and outbound TCP connections, retrieves geolocation data for each peer, and renders them as color‑coded markers and connection lines.

This project is designed for Pi Node operators who want a clear, intuitive overview of their node’s global network activity.

---

## **Features**

- 🔍 **Real‑time scanning** of Pi Node ports `31400–31409`  
- 🔄 **INBOUND / OUTBOUND** connection detection  
- 🌍 **Geolocation lookup** for each peer (country, city, coordinates)  
- 🏳️ **Emoji flag support** for My_Node and all peers  
- 🕒 **Accurate peer local time** based on timezone ID  
- 🗺️ **Interactive world map** powered by Leaflet  
- 🎨 Clean UI with legend, auto‑refresh, and optional support section  
- 💻 Runs on Windows using PowerShell — no installation required  

---

## **How It Works**

1. The script scans all active TCP connections on ports `31400–31409`.  
2. Each peer IP is sent to the `ipwho.is` API for geolocation data.  
3. The script generates an HTML file containing:
   - A world map  
   - Markers for My_Node and all peers  
   - Color‑coded connection lines  
   - Popups with detailed peer information  
4. The map opens automatically in your default browser.

---

## **Requirements**

- Windows 10 or later  
- PowerShell 5.1 or PowerShell 7+  
- Internet connection (for geolocation API + map tiles)

---

## **Usage**

1. Download the repository.  
2. Place the script (`PiNodeMap.ps1`) and the `qr.jpg` file in the same folder.  
3. Run PowerShell as Administrator.  
4. Navigate to the script folder:

   ```
   cd "C:\path\to\PiNodeMap"
   ```

5. Execute the script:

   ```
   .\PiNodeMap.ps1
   ```

6. The map will be generated as `PiNodeMap.html` and opened automatically.

---

## **Legend**

- 🟢 **INBOUND** — peers connecting to your node  
- 🔵 **OUTBOUND** — your node connecting to peers  
- 🔴 **My_Node** — your own external IP location  

---

## **Support the Project**

If you enjoy this tool and want to support its development, you can buy me a coffee:

**Revolut:** https://revolut.me/orczanz

Thank you for helping this project grow!

---

## **License**

This project is open‑source and free to use.  
Feel free to modify, improve, or contribute.

---

