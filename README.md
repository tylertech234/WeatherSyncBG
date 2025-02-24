# 🌤️ WeatherSyncBG

**WeatherSyncBG** dynamically updates your desktop wallpaper based on real-time weather conditions and seasonal changes. It works cross-platform on **Windows, macOS, and Linux** using OpenWeatherMap's API.

---

## 🌍 Features
✅ **Real-time Weather-Based Wallpapers** – Changes your desktop wallpaper based on weather conditions like sunny, cloudy, rainy, snow, thunderstorms, and more.  
✅ **Severe Weather Alerts** – Overrides wallpaper for tornadoes, winter storms, and floods.  
✅ **Seasonal Backgrounds** – Defaults to seasonal wallpapers when no severe weather is detected.  
✅ **Cross-Platform Support** – Works on **Windows, macOS, and Linux**.  
✅ **Automated Updates** – Can be scheduled to update every hour.  

---

## 🔧 Installation

### **1️⃣ Install PowerShell Core (if not installed)**
- **Windows:** Already installed on Windows 11 or install from [PowerShell GitHub](https://github.com/PowerShell/PowerShell)
- **macOS (Homebrew):**
  ```sh
  brew install --cask powershell
  ```
- **Linux (Debian/Ubuntu):**
  ```sh
  sudo apt install -y powershell
  ```
- **Linux (Fedora):**
  ```sh
  sudo dnf install -y powershell
  ```

---

### **2️⃣ Clone the Repository**
```sh
git clone https://github.com/YOUR_USERNAME/WeatherSyncBG.git
cd WeatherSyncBG
```

---

### **3️⃣ Configure Your API Key & Location**
- Open `config.json` in a text editor:
  ```sh
  nano config.json  # or use VS Code, Vim, Notepad, etc.
  ```
- Replace `"YOUR_OPENWEATHERMAP_API_KEY"` with your **OpenWeatherMap API key**.
- Set your **ZIP code** for location-based weather updates.

#### **Example `config.json`**
```json
{
    "apiKey": "YOUR_OPENWEATHERMAP_API_KEY",
    "zipCode": "37301",
    "country": "US"
}
```
- Save and exit.

---

## 🚀 Usage

### **Run the Script Manually**
```sh
pwsh Set-WeatherWallpaper.ps1
```
This will:
- Fetch the **current weather** based on your ZIP code.
- Choose the **matching wallpaper**.
- Update the **desktop background** accordingly.

---

## 🔄 Automate Weather Updates

### **Windows:**
To schedule the script to run **every hour**:
```sh
pwsh Setup-TaskScheduler.ps1
```
This will create a scheduled task that runs the wallpaper update **every hour when logged in**.

### **macOS & Linux:**
To set up an hourly cron job:
```sh
chmod +x Setup-CronJob.sh
./Setup-CronJob.sh
```
This will add a cron job that updates the wallpaper **every hour**.

---

## 🎮 How It Works
### **Wallpapers Matching Weather Conditions**
| Weather Condition  | Wallpaper File |
|--------------------|---------------|
| Clear Sky         | `sunny.jpg` |
| Clouds           | `cloudy.jpg` |
| Rain/Drizzle     | `thunderstorm.jpg` |
| Thunderstorm     | `thunderstorm.jpg` |
| Snow            | `winter.jpg` |
| Fog/Mist/Haze    | `cloudy.jpg` |
| Tornado Warning  | `tornado.jpg` |
| Winter Storm Alert | `winterstorm.jpg` |
| Flood Warning    | `flood.jpg` |
| Default (Seasonal) | `spring.jpg`, `summer.jpg`, `autumn.jpg`, `winter.jpg` |

---

## 🌟 Customizing Wallpapers
The provided wallpapers were created using a few simple AI-generated prompts to resemble my **local region with mountains and farmland** in a **16:9 aspect ratio**. Feel free to **replace them with your own custom images** or tweak them to better fit your environment and aesthetic preferences.

---

## ❓ FAQ

### **How do I get an OpenWeatherMap API key?**
1. Sign up at [OpenWeatherMap](https://openweathermap.org/api).
2. Select **One Call API 3.0** (Free plan provides 1,000 requests/day).
3. Copy your **API Key** and paste it into `config.json`.

### **Can I use this on multiple monitors?**
- Windows users can extend the script to support multiple screens via DisplayFusion or `ActiveDesktop`.
- Linux users can modify the script to handle **multi-monitor setups** using `feh` (for lightweight setups) or `nitrogen`.

### **What happens if OpenWeatherMap is down?**
- The script will **default to seasonal wallpapers**.
- Severe weather alerts will not override the wallpaper if API data is unavailable.

---

## 💡 Contributing
If you’d like to improve **WeatherSyncBG**, feel free to **fork** the repo and submit a **pull request**!

---

## 📜 License
This project is licensed under the **MIT License**. See `LICENSE` for details.

---

Enjoy a **weather-synced desktop** with **WeatherSyncBG**! 🌤️🌩️🌨️🌪️

