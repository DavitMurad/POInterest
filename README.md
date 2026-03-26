# POInterest
### AR-Based Spatial Exploration for Mobile Devices

POInterest is an iOS application that enables users to explore nearby points of interest (POIs) through Augmented Reality. Instead of relying on traditional map-based navigation, the system allows users to discover locations by simply pointing their device toward their surroundings.

The application overlays nearby entities — restaurants, stores, and leisure venues — directly within the camera view, allowing users to understand spatial context and direction more naturally.

> Developed as part of a dissertation exploring **exploration-oriented AR interaction**, accessibility considerations, and lightweight mobile navigation interfaces at the University of Glasgow.

---

## Demo Video

[https://github.com/user-attachments/assets/fd165a3b-8a41-4b0f-9e27-510f5b35b086](https://github.com/user-attachments/assets/e1fd3326-28d0-4c9c-99be-b6c2997eaaca)

The demo showcases:
- AR-based spatial exploration
- Category-based POI discovery
- Interactive AR labels
- Detail view and map verification
- Saved places persistence
- Adjustable exploration radius

---

## Screenshots

> _Coming soon_

---

## Key Features

| Feature | Description |
|---|---|
| 📍 AR Exploration | Discover nearby places by pointing the device in a direction |
| 🏷️ Spatial AR Labels | Place name and distance overlaid directly in the real-world view |
| 🗂️ Category Filters | Filter by restaurants, stores, leisure venues, and more |
| ℹ️ Detail View | Access additional information about any selected place |
| 🔖 Saved Places | Bookmark locations and revisit them later |
| 🔭 Adjustable Radius | Control POI density from 50m up to 500m |
| ♿ Accessibility | VoiceOver labels and minimal AR UI to reduce visual overload |

---

## Technology Stack

- **Swift** — Primary language
- **SwiftUI** — UI framework
- **ARKit** — Augmented Reality engine
- **MapKit** — POI retrieval and map verification
- **Firebase**
  - Authentication
  - Firestore database

---

## Getting Started

### Requirements

- macOS
- Xcode 15+
- iOS 17+
- Apple Developer account _(recommended for device testing)_
- Firebase project configured

### Clone the Repository

```bash
git clone https://github.com/yourusername/POInterest.git
cd POInterest
```

### Install Dependencies

The project uses Firebase via Swift Package Manager. Open the project in Xcode and resolve packages automatically:

```
File → Packages → Resolve Package Versions
```

### Firebase Configuration

1. Create a Firebase project at [console.firebase.google.com](https://console.firebase.google.com)
2. Add an iOS application
3. Download the configuration file: `GoogleService-Info.plist`
4. Place it inside the project root
5. Enable:
   - Firebase Authentication
   - Firestore Database

### Run the Application

Open the project in Xcode and run on a **physical device**.

> ⚠️ ARKit features require a real iPhone with AR support — the simulator is not supported.

---

## Architecture Overview

The system follows a modular structure across three layers:

**Business Logic Layer**
- Spatial calculations for distance and bearings
- AR placement logic

**Presentation Layer**
- SwiftUI views
- AR labels and interaction handling

**Data Layer**
- Firebase authentication
- Firestore user data
- MapKit POI retrieval

### Interaction Flow

User navigation and system states are managed through a **finite state machine (FSM)**, enabling clean transitions between exploration, selection, and detail modes.

---

## Research Context

This project explores how Augmented Reality can support **exploration-oriented navigation** rather than traditional route-based navigation.

The system was evaluated through a usability study measuring:

- Task completion rate
- Time-on-task
- Error frequency
- User perception via surveys and interviews

Further details are available in the accompanying dissertation.

---

## Future Work

- Improved AR label occlusion handling
- More advanced POI metadata integration
- Offline caching
- Expanded accessibility features
- Integration with native map navigation systems

---

## Author

**Davit Muradyan**  
University of Glasgow — Computing Science

---

## License

This project is under MIT License.
