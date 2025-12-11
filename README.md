# 💵 DailyTips

A simple and modern **tip calculator** built with SwiftUI and MVVM architecture.  
This is my first iOS project developed on macOS to learn **Xcode**, **SwiftUI**, and **Combine** step by step.

---

## 📱 Features
- Input the total bill amount.
- Choose a tip percentage.
- Select the number of people.
- Option to round up the total.
- Automatically calculates total and per-person amount.

---

## 🧠 Tech Stack
- **Language:** Swift 5.10  
- **Frameworks:** SwiftUI, Combine  
- **Architecture:** MVVM  
- **Storage:** SwiftData (local, no iCloud)  
- **IDE:** Xcode 16  
- **Deployment Target:** iOS 18.0

---

## 🧩 Project Structure
DailyTips/
├── DailyTipsApp.swift # Entry point
├── ContentView.swift # Main UI
├── TipViewModel.swift # Logic and data binding
├── Assets.xcassets # App assets
└── README.md


---

## 🗺️ Roadmap
| Phase | Goal | Status |
|-------|------|--------|
| **1. Base UI + Logic** | Build a functional calculator using SwiftUI + Combine. | ✅ Completed |
| **2. Improved UX** | Add tip presets (10%, 15%, 20%) and haptic feedback. | ✅ Completed |
| **3. Data Persistence** | Save last tip settings with `AppStorage`. | ✅ Completed |
| **4. Visual Polish** | Add custom colors, icons, and adaptive layout. | ✅ Completed |
| **5. Testing & Refactor** | Write unit tests for ViewModel and improve architecture. | ⚠️ Optional (Skipped) |
| **6. App Store Demo** | Package the app for TestFlight or personal distribution. | ⏩ Skipped (not needed) |

---

## 🧩 Next Steps
- [x] Add presets for tip percentages  
- [x] Implement haptic feedback when rounding total  
- [x] Store last used values using `AppStorage`  
- [x] Improve color scheme and typography  
- [ ] Write snapshot/UI tests

---

## Author
Adrián Félix

Software Engineering

Passionate about Android Developer, Full Stack and iOS development and clean architecture.

GitHub: @Elmamis69
Email: guerofelix234@gmail.com

**License**
This project is licensed under the MIT License.

## Getting Started
1. Clone the repository:
   ```bash
   https://github.com/Elmamis69/DailyTips.git

