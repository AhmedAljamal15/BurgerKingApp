# 🍔 Burger King – Fast Food Ordering App

A modern **Flutter** fast food app inspired by Burger King’s experience.  
It provides a smooth, visually appealing, and responsive ordering flow with support for dark/light themes, animations, and clean architecture.

> ⚠️ Disclaimer: This app is a **non-official demo/learning project** and is **not affiliated** with Burger King Corporation.

---

## 📚 Table of Contents

- [Overview](#-overview)
- [Features](#-features)
- [Architecture](#-architecture)

## 📝 Overview

**Burger King App** is a Flutter-based fast food ordering application that focuses on:

- Fast and intuitive **browsing** of meals and offers  
- A smooth **shopping experience** with cart and checkout  
- Aesthetic **glassmorphism UI** and animations  
- A robust **Bloc-based architecture** that is scalable and maintainable  
- Full support for **dark & light mode**

This project is ideal as:

- A portfolio piece for Flutter developers  
- A base template for food ordering apps  
- A playground to practice **Bloc, theming, and clean architecture**

---

## ✅ Features

### 🔐 Authentication
- Email/password login & signup (or mock auth)
- Optional **guest mode** for quick access
- Basic validation and error handling

### 🏠 Home & Product Discovery
- Featured products & offers
- Categories (e.g. Burgers, Sides, Drinks, Desserts)
- Search and filter support (if implemented)

### 🛍️ Shopping Experience
- Product details with:
  - Image
  - Name, description
  - Price
  - Add-ons / options (e.g. extra cheese, bigger size)
- Optional **3D previews** or animations (placeholder section if not implemented yet)

### 🛒 Cart Management
- Add / remove items
- Update quantities
- Show subtotal, tax, and total
- Clear cart

### 💳 Checkout & Order Tracking
- Order summary screen
- Simple checkout flow (mock or real API)
- Order status/tracking placeholder

### 🎨 UI & Animations
- **Glassmorphism** elements (blurred cards, overlay panels)
- Smooth page transitions & micro animations
- Animated icons (e.g., theme toggle, cart, favorites)
## 🧱 Architecture

The app follows a **Clean Architecture + Bloc pattern**, split into 3 main layers:

1. **Presentation**
   - Flutter UI (screens, widgets)
   - Bloc/Cubit for state management

2. **Repo**
   - Business logic
   - Entities and use cases

3. **Data**
   - API / local data sources


