# Deen Focus - Deen Focus

<p align="center">
  <img src="assets/images/star_decoration.png" width="120" alt="Deen Focus Logo">
</p>

<p align="center">
  <b>تطبيق التركيز والانضباط الإسلامي</b><br>
  Islamic Discipline & Focus App
</p>

---

## Overview

**Deen Focus** is a premium Flutter application designed to help Muslims stay disciplined and focused on their daily worship (عبادات) and spiritual tasks. It combines Islamic prayer times, task management, focus mode sessions, and progress tracking with a beautiful dark UI featuring gold accents.

## Features

### 1. Prayer Times (أوقات الصلاة)
- Daily prayer times calculation using the `adhan` package
- Live countdown to the next prayer
- Islamic Hijri date display
- Prayer reminders via local notifications
- Qibla direction indicator

### 2. Islamic Tasks System (نظام المهام)
- Create daily Islamic tasks: Quran reading, Dhikr, Qiyam al-Layl, Fasting, etc.
- Task categories with custom icons and colors
- Repeat options: Once, Daily, Weekly, Monday-Friday, Weekends
- Streak counter for each task
- Reward points system

### 3. Commitment Mode (وضع الالتزام)
- Pre-focus commitment dialog with motivational Islamic quotes
- Custom duration selection (15, 25, 45, 60 minutes)
- Pledge to complete worship before starting

### 4. Focus Mode (وضع التركيز)
- Full-screen focus timer with circular progress indicator
- Pause and resume functionality
- Periodic motivational reminders
- Confetti celebration on completion
- Background notification reminders

### 5. Statistics & Progress (الإحصائيات)
- Daily, weekly, and overall progress tracking
- Bar charts for weekly points visualization
- Streak counter (current and longest)
- Total points, focus minutes, and completed tasks

### 6. Home Dashboard (الشاشة الرئيسية)
- Personalized greeting with user's name
- Live prayer countdown
- Daily progress summary
- Quick action buttons (Focus Mode, Add Task)
- Upcoming tasks list

### 7. Notifications (الإشعارات)
- Prayer time reminders (15 minutes before)
- Task reminders at scheduled times
- Focus session reminders
- Evening reminder for incomplete tasks

### 8. Settings (الإعدادات)
- User profile customization
- Notification preferences
- Reminder time configuration
- Location settings for prayer times
- Data reset option

## Design System

### Color Palette
| Color | Hex | Usage |
|-------|-----|-------|
| Carbon Black | `#0D0D0D` | Primary background |
| Deep Charcoal | `#1C1C1E` | Cards, nav bar |
| Surface Gray | `#2C2C2E` | Inputs, buttons |
| Islamic Gold | `#D4AF37` | Primary accent, CTAs |
| Deep Emerald | `#2E8B57` | Success, focus mode |
| Primary Blue | `#007AFF` | Secondary actions |
| Alert Red | `#FF3B30` | Cancel, delete |

### Typography
- **Display**: Playfair Display (English headers)
- **Body/Arabic**: Noto Sans Arabic
- **Scale**: 40px display / 24px headlines / 18px body / 13px captions

## Project Structure

```
lib/
├── main.dart                    # App entry point
├── models/
│   ├── prayer_time.dart         # Prayer time model
│   ├── islamic_task.dart        # Task model with enums
│   ├── focus_session.dart       # Focus session state model
│   └── user_stats.dart          # Statistics & streak model
├── services/
│   ├── storage_service.dart     # SharedPreferences persistence
│   ├── prayer_service.dart      # Adhan calculation service
│   └── notification_service.dart # Local notifications
├── providers/
│   ├── prayer_provider.dart     # Prayer time state management
│   ├── task_provider.dart       # Task CRUD operations
│   ├── focus_provider.dart      # Focus timer logic
│   ├── stats_provider.dart      # Statistics aggregation
│   └── settings_provider.dart   # User preferences
├── screens/
│   ├── splash_screen.dart       # Animated splash
│   ├── app_shell.dart           # Main navigation shell
│   ├── home_screen.dart         # Dashboard
│   ├── focus_screen.dart        # Focus mode launcher
│   ├── focus_session_screen.dart # Active focus session
│   ├── statistics_screen.dart   # Stats & charts
│   ├── settings_screen.dart     # App settings
│   ├── prayer_times_screen.dart # Full prayer times
│   ├── task_detail_screen.dart  # Task detail view
│   └── add_task_screen.dart     # Create new task
├── widgets/
│   ├── prayer_countdown_card.dart
│   ├── task_card.dart
│   └── gold_button.dart
└── themes/
    └── app_theme.dart           # Design system constants
```

## Dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter
  provider: ^6.1.1              # State management
  adhan: ^2.0.0+1               # Prayer times calculation
  intl: ^0.18.1                 # Internationalization
  hijri: ^3.0.0                 # Hijri date conversion
  shared_preferences: ^2.2.2    # Local storage
  hive: ^2.2.3                  # NoSQL database
  fl_chart: ^0.66.0             # Charts & graphs
  flutter_local_notifications: ^16.3.2  # Push notifications
  timezone: ^0.9.2              # Timezone handling
  geolocator: ^10.1.0           # GPS location
  percent_indicator: ^4.2.3     # Circular progress
  confetti: ^0.7.0              # Celebration effects
  google_fonts: ^6.1.0          # Custom fonts
  flutter_svg: ^2.0.9           # SVG support
  shimmer: ^3.0.0               # Loading skeletons
  http: ^1.1.0                  # HTTP requests
  equatable: ^2.0.5             # Value equality
  uuid: ^4.2.1                  # Unique IDs
  path_provider: ^2.1.1         # File system access
```

## Getting Started

### Prerequisites
- Flutter SDK >= 3.0.0
- Dart SDK >= 3.0.0
- Android SDK (for Android builds)

### Installation

1. **Clone the repository:**
```bash
git clone https://github.com/yourusername/deen_focus.git
cd deen_focus
```

2. **Install dependencies:**
```bash
flutter pub get
```

3. **Generate code (if needed):**
```bash
flutter pub run build_runner build
```

4. **Run the app:**
```bash
flutter run
```

### Build for Release

```bash
# Android APK
flutter build apk --release

# Android App Bundle
flutter build appbundle --release
```

## Permissions

The app requires the following Android permissions:
- **Location**: For accurate prayer time calculation
- **Notifications**: For prayer and task reminders
- **Exact Alarms**: For precise prayer time notifications
- **Accessibility Service**: For app blocking during focus mode (future feature)

## Architecture

The app follows **Clean Architecture** principles with:
- **Models**: Data classes with JSON serialization
- **Services**: Business logic and external API interactions
- **Providers**: State management using Provider pattern
- **Screens**: UI components following Material Design 3
- **Widgets**: Reusable UI components

## Future Features

- [ ] App blocking via Accessibility Service
- [ ] AI motivational messages
- [ ] Community challenges
- [ ] Quran tracker with daily reading goals
- [ ] Dhikr counter with tasbih
- [ ] Cloud sync across devices
- [ ] Widget support for home screen
- [ ] Dark/Light theme toggle

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is licensed under the MIT License.

---

<p align="center">
  Made with for the Ummah
</p>
