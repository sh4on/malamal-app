# Malamal (মলামাল) — Online Hardware Store App

<p align="center">
  <img src="assets/logo.webp" alt="Malamal Logo" width="120" />
</p>

<p align="center">
  <strong>The Best Online Hardware Store in Bangladesh</strong>
</p>

---

## 📖 Project Overview

**Malamal** is a premium, modern e-commerce mobile application built with Flutter, tailored for purchasing hardware, tools, and industrial supplies in Bangladesh. The application is integrated directly with the Malamal backend API to dynamically load categories, brands, hero sections, and product data. It features a complete shopping flow from login to shipping selection (supporting all 64 districts in Bangladesh) and checkout.

The project is structured following clean coding guidelines, utilizing **GetX** for state management, dependency injection, and routing, combined with **Dio** for robust API communications and **ScreenUtil** for fully responsive UI components.

---

## 🚀 Key Features

* 🛍️ **Rich Homepage Experience**: Dynamic hero slider banners, category grids, brand lists, featured sections, and search widgets.
* 📦 **Comprehensive Catalog Browsing**: View all categories and sub-categories, filter products by specific brands, or search for targeted keywords.
* 🏷️ **Dynamic Product Details**: Carousel slider for product images, stock checking, description tabs (Features, Description, Specifications), custom HTML rendering, and embedded YouTube player support.
* 🛒 **Shopping Cart & Checkout**: Interactive cart with quantity adjustment, live subtotal updates, shipping address form with district selection, and payment options.
* 👤 **Account & Authentication**: User login/registration, OTP verification support, account details updates, and password changes.
* 📱 **Modern Aesthetics**: Interactive UI using custom animations, shimmer placeholder loaders, WhatsApp quick support floating action button, and a customizable theme setting (Light/Dark mode capability).

---

## 🛠️ Technology Stack & Packages

The app is built using the following core dependencies:

| Category | Package / Tool | Purpose |
| :--- | :--- | :--- |
| **Framework** | **Flutter SDK** (`>=3.10.4`) | High-performance cross-platform development |
| **State Management & DI** | [GetX](https://pub.dev/packages/get) | Reactive state management, dependency injection, and clean routes |
| **Networking** | [Dio](https://pub.dev/packages/dio) | Advanced HTTP client with interceptors, timeout controls, and request logs |
| **Responsiveness** | [flutter_screenutil](https://pub.dev/packages/flutter_screenutil) | Multi-screen responsiveness based on a design size of 375x812 |
| **Image Caching** | [cached_network_image](https://pub.dev/packages/cached_network_image) | Caching remote images to optimize bandwidth and memory usage |
| **Animations** | [lottie](https://pub.dev/packages/lottie) | JSON-based animations for loaders and transition states |
| **External Media** | [youtube_player_flutter](https://pub.dev/packages/youtube_player_flutter) | Seamless embedding of YouTube videos in product pages |
| **Local Storage** | [shared_preferences](https://pub.dev/packages/shared_preferences) | Persistent local storage for user credentials and preferences |
| **OTA Updates** | [upgrader](https://pub.dev/packages/upgrader) | Auto-checks and alerts users when app updates are available |

---

## 📁 Folder Structure

The project conforms strictly to the modular architectural layout:

```text
lib/
├── core/
│   ├── constants/             # Centralized styles (colors, dimensions, api endpoints, strings)
│   ├── localization/          # App localization files
│   ├── services/              # Global service definitions (e.g., Dio network service)
│   ├── theme/                 # Light/Dark material theme definitions
│   └── utils/                 # Extensible helpers, extensions, and mixins
│
├── data/
│   └── models/                # JSON serialization data models (User, Product, Cart, Orders)
│
├── modules/                   # Feature-oriented independent modules
│   ├── auth/                  # Authentication screens & forms (login, signup, OTP, reset)
│   ├── base/                  # Bottom navigation and primary app shell structure
│   ├── brand/                 # Product display filtered by brand
│   ├── cart/                  # Cart lists, counts, and modifiers
│   ├── categories/            # Main category listing and browsing grid
│   ├── checkout/              # District-based billing and order placement screens
│   ├── home/                  # Brand showcase, hero sliders, and category previews
│   ├── likes/                 # User wishlist page
│   ├── orders/                # Order status and history details
│   ├── product_details/       # Spec tabs, webview descriptions, and video players
│   ├── profile/               # Account credentials, password change screens
│   ├── search/                # Product querying and keyword filtering
│   └── sub_category_products/ # Products of selected nested categories
│
├── routes/
│   ├── app_pages.dart         # GetPage routing configurations and page bindings
│   └── app_routes.dart        # Route path constants
│
├── shared/
│   ├── bindings/              # Initial global controller bindings
│   ├── common_widgets/        # Globally reusable visual widgets
│   └── controllers/           # Shared state controllers (e.g., AppTheme switcher)
│
├── main.dart                  # Application entry point
└── my_app.dart                # Main MaterialApp widget initialization with ScreenUtil
```

---

## 🧑‍💻 Coding Standards & Patterns

### 1. Network & API Service
All network interactions are managed by a customized `NetworkService` using a thread-safe Singleton pattern. Requests are wrapped in a generic `NetworkResult` to standardize success and failure responses:
```dart
class NetworkResult<T> {
  final T? data;
  final int? statusCode;
  final String? message;
  final bool isSuccess;
  // ...
}
```

### 2. State & UI State Management
Dynamic screens manage UI loading states (Loading, Success, Empty, Error) natively using GetX's `RxStatus`. Controllers expose state and update UI using `Obx` builders, which promotes responsive screens without bloated controller classes.

### 3. Style & Layout Guidelines
* Theme values (spacings, radii, font sizes) are strictly referenced from [app_dimensions.dart](lib/core/constants/app_dimensions.dart).
* Colors are defined in [app_colors.dart](lib/core/constants/app_colors.dart), with `Color(0xFFF04F23)` as the primary brand color.
* Widgets scale responsively using `.w` and `.h` multipliers from `flutter_screenutil`.

---

## ⚙️ Getting Started

### Prerequisites
1. Install [Flutter SDK](https://docs.flutter.dev/get-started/install) (version matching the specified environment).
2. Configure a physical device or emulator/simulator.

### Step-by-Step Installation
1. Clone the repository:
   ```bash
   git clone <repository_url>
   cd project_m
   ```
2. Retrieve app packages:
   ```bash
   flutter pub get
   ```
3. Run the application:
   ```bash
   flutter run
   ```

---

## 📄 License

This project is a proprietary application developed for Malamal.
