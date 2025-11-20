# 🎨 Color Harmony System - Fast Food App

## Color Palette Overview

Your app now uses a **harmonious green/teal color scheme** with **white text** throughout for maximum readability and consistency.

### Primary Colors

| Light Mode  | Dark Mode   | Usage                    |
| ----------- | ----------- | ------------------------ |
| **#103E34** | **#26A69A** | Primary actions, main UI |
| **#1A5A4D** | **#4DB8AA** | Secondary UI elements    |
| **#0A2822** | N/A         | Text/dark accents        |

### Background Colors

| Light Mode  | Dark Mode   | Purpose                 |
| ----------- | ----------- | ----------------------- |
| **#0F3028** | **#0A1F1A** | Main background         |
| **#1A5A4D** | **#142F2A** | Surface (cards, AppBar) |

### Text Colors

| Theme | Color     | Hex         | Usage                 |
| ----- | --------- | ----------- | --------------------- |
| Both  | **White** | **#FFFFFF** | All text (consistent) |
| Light | Hint      | **#B3B3B3** | Disabled, hints       |
| Dark  | Hint      | **#99CCCC** | Disabled, hints       |

---

## How to Use Colors in Your Code

### Option 1: Theme-Aware (Recommended)

```dart
// Text color (auto-adapts to theme)
Text(
  'Hello',
  style: TextStyle(color: Theme.of(context).textTheme.bodyLarge?.color)
)

// Background
Container(
  color: Theme.of(context).scaffoldBackgroundColor
)

// Primary button
Container(
  color: Theme.of(context).primaryColor
)
```

### Option 2: Direct AppColors Reference

```dart
import 'package:fast_food/core/theme/app_colors.dart';

// For light mode
Text('Hello', style: TextStyle(color: AppColors.lightText))

// For dark mode
Text('Hello', style: TextStyle(color: AppColors.darkText))

// Using static primary
Container(color: AppColors.primary)
```

### Option 3: Conditional Colors (if needed)

```dart
final isDark = Theme.of(context).brightness == Brightness.dark;
color: isDark ? AppColors.darkPrimary : AppColors.lightPrimary
```

---

## Available Color Constants

### In `lib/core/theme/app_colors.dart`:

```dart
// Primary & Secondary
AppColors.primary           // #103E34
AppColors.primaryLight      // #1A5A4D
AppColors.primaryDark       // #0A2822
AppColors.accent            // #26A69A
AppColors.accentLight       // #4DB8AA

// Light Mode
AppColors.lightBackground   // #0F3028
AppColors.lightSurface      // #1A5A4D
AppColors.lightText         // #FFFFFF
AppColors.lightHint         // #B3B3B3
AppColors.lightError        // #E53935

// Dark Mode
AppColors.darkBackground    // #0A1F1A
AppColors.darkSurface       // #142F2A
AppColors.darkText          // #FFFFFF
AppColors.darkHint          // #99CCCC
AppColors.darkError         // #EF5350

// Utility
AppColors.white             // #FFFFFF
AppColors.success           // #43A047
AppColors.warning           // #FB8C00
AppColors.info              // #1E88E5
```

---

## Theme Switching

The app automatically switches colors when the user toggles the theme:

1. **Light Mode** (Default) → Green/Teal backgrounds with white text
2. **Dark Mode** → Very dark backgrounds with bright teal accents and white text

Both modes ensure:
✓ White text everywhere for readability
✓ Harmonious green/teal color scheme
✓ Consistent visual hierarchy
✓ Automatic persistence of user preference

---

## Best Practices

✅ **DO:**

- Use `Theme.of(context)` for automatic theme adaptation
- Use `AppColors` constants for consistency
- Ensure sufficient contrast (white text on colors)
- Test both light and dark modes

❌ **DON'T:**

- Hardcode `Colors.black` or `Colors.white` directly
- Mix different color schemes
- Use opacity on white text for better readability

---

## Testing Colors

To verify the color harmony:

1. Run the app: `flutter run`
2. Go to Profile page and tap the sun/moon icon
3. Observe that:
   - All text stays white in both modes
   - Background colors change appropriately
   - Colors feel harmonious and consistent
   - No hardcoded colors stand out
