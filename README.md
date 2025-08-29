# NutriCalc 🍏

![NutriCalc Banner](https://placehold.co/1200x400/6AF2A8/1A2E28?text=NutriCalc&font=inter)

A personalized nutrition calculator and food logging application built with Flutter. NutriCalc helps users track their daily caloric intake, monitor macronutrient goals, and receive AI-powered suggestions to achieve their health objectives. This app was developed as a Skill Lab Mini Project.

---

## ✨ Features

NutriCalc is packed with features designed to provide a seamless and intelligent health tracking experience.

### Core Functionality
- **Multi-Profile Management**: Create and manage multiple user profiles, each with unique physical stats and health goals (lose, maintain, or gain weight).
- **Personalized Nutrition Plan**: Automatically calculates daily targets for calories, macronutrients (protein, carbs, fat), and key micronutrients based on the Mifflin-St Jeor equation.
- **Comprehensive Food Search**: Utilizes the Edamam API to search a massive database of food items.
- **Daily Food Logging**: Easily log meals and track consumption against daily goals.
- **Historical Reports & Weight Tracking**: View historical charts for calorie intake and track weight progress over time.
- **Local Data Persistence**: All profiles, logs, and settings are saved locally on the device using `SharedPreferences`.

### AI-Powered Features (Powered by Google Gemini)
- **Calix Health Assistant**: An integrated conversational AI chatbot that provides personalized diet and workout advice.
- **7-Day Diet Plan Suggestions**: Automatically generates a full week of Indian meal suggestions tailored to the user's nutritional targets.
- **Tip of the Day**: Displays a new, motivational health tip on the dashboard every day.
- **Caching**: AI-generated content (tips and diet plans) is cached locally to reduce API calls and enable offline access.

### Polished User Experience
- **Sleek & Animated UI**: Beautiful, animated widgets for progress tracking (BMI, calories, macros) and staggered list animations create a fluid and responsive feel.
- **Light & Dark Mode**: A custom-designed theme system that supports both light and dark modes.
- **Shimmer Loading Effects**: Professional loading skeletons appear while AI content is being generated.
- **Consistent Page Transitions**: Smooth, custom "slide and fade" animations for all screen navigation.
- **Haptic Feedback**: Subtle vibrations on key interactions to enhance the user experience.
- **Secure API Key Management**: An in-app, password-protected screen allows users to manage their own API keys.

---

## 🛠️ Tech Stack & Packages

- **Framework**: Flutter
- **State Management**: Flutter Riverpod
- **APIs**:
  - Edamam API (Food Database)
  - Google Gemini API (AI Features)
- **Key Packages**:
  - `http`: For making API calls.
  - `shared_preferences`: For local data storage.
  - `fl_chart`: For beautiful charts and graphs.
  - `flutter_svg`: For using SVG assets.
  - `shimmer`: For the loading effect.
  - `url_launcher`: For opening web links.
  - `intl`: For date formatting.
- **Architecture**: A clean, scalable architecture separating UI (Screens/Widgets), business logic (Providers), and data (Models).

---

## 🚀 Getting Started

Follow these instructions to get a local copy up and running for development and testing purposes.

### Prerequisites

- [Flutter SDK](https://flutter.dev/docs/get-started/install) installed.
- An IDE like VS Code or Android Studio.

### Installation & Setup

1.  **Clone the repository:**
    ```sh
    git clone [https://github.com/your-username/nutricalc.git](https://github.com/your-username/nutricalc.git)
    cd nutricalc
    ```

2.  **Install dependencies:**
    ```sh
    flutter pub get
    ```

3.  **Configure API Keys:**
    This project requires API keys from Edamam and Google Gemini to function correctly.
    - **Option A (Recommended):** Run the app and navigate to `Settings -> Edit API Keys`. Enter your keys here to save them securely.
    - **Option B (For initial setup):** Open the `lib/constants/api_constants.dart` file and replace the placeholder values with your actual keys.

    ```dart
    // lib/constants/api_constants.dart

    // Edamam Food Database API
    static String edamamAppId = 'YOUR_EDAMAM_APP_ID';
    static String edamamAppKey = 'YOUR_EDAMAM_APP_KEY';

    // Google Gemini API
    static String geminiApiKey = 'YOUR_GEMINI_API_KEY';
    ```

4.  **Run the application:**
    ```sh
    flutter run
    ```

---

## 🧑‍💻 About the Developers

This app was created by:

- **Varun U Pratap**
  - **LinkedIn**: [https://www.linkedin.com/in/varun-u-pratap-856826340](https://www.linkedin.com/in/varun-u-pratap-856826340)

- **Utsav S R**
  - **LinkedIn**: [https://www.linkedin.com/in/utsav-s-r-633a91379](https://www.linkedin.com/in/utsav-s-r-633a91379)

---

## 📞 Contact Us

For any inquiries or feedback regarding this project, please feel free to reach out to us on LinkedIn.
