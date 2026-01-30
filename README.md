# NutriCalc 🍏

![NutriCalc Banner](https://placehold.co/1200x400/6AF2A8/1A2E28?text=NutriCalc&font=inter)

A personalized nutrition calculator and food logging application built with Flutter. NutriCalc revolutionizes health tracking by integrating advanced AI to provide users with actionable, intelligent insights. This app was developed as a Skill Lab Mini Project.

---

## ✨ Features

NutriCalc is built on the philosophy that health tracking should be both data-driven and conversationally intelligent.

### 🤖 AI-Powered Intelligence (Powered by Google Gemini)
The core of NutriCalc's innovation lies in its deep integration with the **Google Gemini API**, transforming a standard logger into a proactive health coach:
- **Calix AI Health Assistant**: More than a chatbot, Calix is an integrated conversational partner. It analyzes your unique profile data to provide real-time, context-aware advice on diet, nutrition, and workout routines.
- **Intelligent 7-Day Diet Generation**: Leveraging the generative power of Gemini, NutriCalc creates full-week Indian meal plans. These aren't generic templates; they are dynamically tailored to your specific caloric and macronutrient targets.
- **AI-Driven Tip of the Day**: Every morning, the dashboard greets you with a unique, AI-generated health tip or motivational insight to keep you engaged with your goals.
- **Smart Persistence & Caching**: To ensure a responsive experience, all AI-generated content (tips and diet plans) is locally cached. This reduces unnecessary API latency and ensures your personalized plans are available even when offline.

### Core Functionality
- **Multi-Profile Management**: Create and manage multiple user profiles, each with unique physical stats and specific health goals (lose, maintain, or gain weight).
- **Personalized Nutrition Science**: Automatically calculates daily targets for calories, macronutrients (protein, carbs, fat), and key micronutrients using the clinically recognized Mifflin-St Jeor equation.
- **Comprehensive Food Search**: Integrates the Edamam API to provide instant access to a massive database of food items for precise logging.
- **Historical Insights**: View detailed charts and weight tracking progress to visualize your journey over time.
- **Privacy-First Storage**: All personal profiles, logs, and settings are saved locally on the device using `SharedPreferences`.

### Polished User Experience
- **Sleek & Animated UI**: Features custom-built animated widgets for BMI gauges, calorie progress, and macro distribution.
- **Adaptive Theme System**: Sophisticated support for both Light and Dark modes.
- **Performance-Oriented UI**: Utilizes Shimmer loading skeletons while the AI is "thinking" and generating your custom plans.
- **Haptic & Visual Feedback**: Seamless page transitions and haptic feedback ensure every interaction feels premium and responsive.
- **Secure Key Management**: A dedicated, password-protected interface for users to manage their own API credentials.

---

## 🛠️ Tech Stack & Packages

- **Framework**: Flutter
- **AI Engine**: Google Gemini API (Generative AI)
- **State Management**: Flutter Riverpod (for scalable, reactive state)
- **Data APIs**: Edamam Food Database API
- **Key Packages**:
  - `http`: For robust API communication.
  - `shared_preferences`: For efficient local data persistence.
  - `fl_chart`: For high-performance data visualization.
  - `shimmer`: For professional AI-content loading states.
  - `flutter_svg`: For crisp, scalable iconography.
  - `intl` & `url_launcher`: For utility and external linking.

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
    NutriCalc requires API keys for both Edamam (Data) and Google Gemini (Intelligence).
    - **Option A (In-App):** Run the app and navigate to `Settings -> Edit API Keys`.
    - **Option B (Hardcoded):** Open `lib/constants/api_constants.dart` and update the constants:

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

This project was envisioned and built by:

- **Varun U Pratap**
  - **LinkedIn**: [https://www.linkedin.com/in/varun-u-pratap-856826340](https://www.linkedin.com/in/varun-u-pratap-856826340)

- **Utsav S R**
  - **LinkedIn**: [https://www.linkedin.com/in/utsav-s-r-633a91379](https://www.linkedin.com/in/utsav-s-r-633a91379)

---

## 📞 Contact Us

For any inquiries, feedback, or collaborations regarding NutriCalc, please reach out to us on LinkedIn.
