#  Ayul — Traditional Medicine Mobile App

**Ayul** is a Flutter-based mobile application designed to preserve and promote the knowledge of traditional Indian medical systems such as **Siddha**, **Ayurveda**, **Unani**, and **Homeopathy**.  
The app provides an intuitive and bilingual experience (Tamil and English) for users to explore traditional medicines, discover their uses, and find remedies for common diseases.

---

##  Features

###  Explore Traditional Treatments
- Browse different types of traditional systems:
  - Siddha
  - Ayurveda
  - Unani
  - Homeopathy
  - Yoga & Naturopathy
- Each category provides detailed lists of medicines with their scientific names, descriptions, and health benefits.

###  Medicine Details
- Click on any medicine to view:
  - Full description
  - Tamil name
  - Scientific name
  - Diseases it treats
  - Dosage and preparation info (if available)

###  Find My Disease – AI Questionnaire
- Interactive questionnaire (10–20 questions)
- Suggests the most suitable traditional medicine or treatment based on user answers
- Automatically redirects users to the recommended medicine page

###  Download Books
- Access and download traditional medicine books and resources directly within the app

###  Smart Search
- Search bar to find medicines, diseases, or treatments easily in both Tamil and English

###  Firebase Integration
- **Firebase Firestore**: Stores medicines, diseases, and book details
- **Firebase Storage**: Hosts images and book files
- **Firebase Authentication (optional)**: For managing personalized features

###  Bilingual Support
- Complete app available in **English** and **Tamil**
- Language switcher toggle for seamless translation

---

##  Tech Stack

| Technology | Purpose |
|-------------|----------|
| **Flutter** | Cross-platform mobile app development |
| **Dart** | Core programming language |
| **Firebase Firestore** | Real-time database for medicines & diseases |
| **Firebase Storage** | Image and book storage |
| **Firebase Hosting (optional)** | For backend integration |
| **Google Fonts** | UI typography |
| **Provider / Riverpod** | State management |

---

##  Installation Guide

### Prerequisites
- Flutter SDK (>=3.0)
- Android Studio / VS Code with Flutter extension
- Firebase project setup

### Steps
1. Clone the repository:
   ```bash
   git clone https://github.com/yourusername/ayul.git

After cloning the repository, run the following command to install the project dependencies:

```bash
flutter pub get
```

```bash
flutter pub get firebase_core
```

```bash
flutter pub add firebase_core
```
