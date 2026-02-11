# Native Weather App (SwiftUI + Firebase)

iOS weather application built with **SwiftUI**, using **MVVM architecture**, REST API networking and **Firebase Realtime Database**.

Project created for **Native Mobile Development course (Assignments 7 & 8).**

---

# Application Features

## Assignment 7 — Data & Networking

- Search city by name
- Weather data fetched from public API (Open-Meteo)
- Current weather information:
  - temperature
  - humidity
  - wind speed
  - weather condition
- 24-hour forecast
- Offline mode with cached weather data
- Error handling (network errors, city not found)
- Temperature unit settings (Celsius/Fahrenheit)
- MVVM architecture implemented

---

## Assignment 8 — Firebase Integration

- Firebase Realtime Database connected
- Anonymous user authentication
- Favorites system per user
- Notes for favorite cities
- CRUD operations:
  - Add favorite
  - Read favorites
  - Delete favorite
- Real-time data updates
- Firebase security rules configured
- Repository + Service layer architecture

---

# Architecture

The application follows **MVVM + Repository pattern**

### Layers:
- SwiftUI Views (UI)
- ViewModels
- Repository layer
- Networking layer
- Firebase service
- Local cache storage

Clear separation between UI and business logic.

---

# Weather API

Public API used: **Open-Meteo**

- No API key required
- JSON parsing using Codable
- URLSession networking

Endpoints used:
- Geocoding API
- Forecast API

---

# Offline Mode

- Last successful weather request is cached locally
- Data loads when internet connection is unavailable
- Offline state displayed to the user

---

# ☁ Firebase Integration

## Authentication
- Anonymous sign-in
- Each user identified by UID

## Realtime Database Structure

```json
favorites
  uid123
    item1
      id: "UUID"
      city: "Astana"
      note: "Cold weather"
      createdAt: 1700000000
      createdBy: "uid123"
```

--- 

## CRUD Operations
- Create favorite city
- Read favorites
- Delete favorite
- Real-time listener updates UI automatically


```json
{
  "rules": {
    "favorites": {
      "$uid": {
        ".read": "$uid === auth.uid",
        ".write": "$uid === auth.uid"
      }
    }
  }
}
```
Only authenticated users can access their own data.

--- 

## Real-time Updates
- Firebase listeners update UI instantly
- No manual refresh required
- Favorites update automatically

--- 

## How to Run the Project
- Clone repository:
git clone https://github.com/nazerke-se22/native_weatherAPP
- Open project in Xcode
- Add Firebase config file:
- GoogleService-Info.plist
- Run on simulator or real device
