# TODO List - Media Player App

## 🧩 New Features to Implement

### 1. **Rewrite Now Playing Screen**
- [x] Redesign UI for better player experience.
- [x] Add album art, title, artist name.
- [x] Implement seek bar with live timing.
- [x] Add media controls: play/pause, next, previous.
- [x] Add shuffle and repeat toggle.
- [x] Support swipe gestures to change tracks.
- [x] Ensure all buttons are functional.

### 2. **Queue System**
- [x] Create Up Next screen.
- [x] Enable drag-and-drop for reordering.
- [x] Save queue state using provider or local storage.

### 3. **Search & Filter**
- [x] Add search bar in Library screen.
- [x] Support filtering by name, type (audio/video), and tags.
- [x] Add no results state.

### 4. **Equalizer**
- [x] New page: Equalizer.
- [x] Sliders for Bass, Treble, and custom bands.
- [x] Save equalizer settings locally.

### 5. **Dark Mode / Theme Switcher**
- [x] Enhance `theme_provider.dart`.
- [x] Apply dark mode to all screens.

### 6. **Offline Media Support**
- [x] Use Hive or local database.
- [x] Show offline indicator.

### 7. **Media Notifications**
- [x] Integrate `flutter_local_notifications`.
- [x] Add media actions (play, pause, next).
- [x] Show cover art in notification.

### 8. **Rewrite Library Page**
- [x] Organize layout: grid or list view option.
- [x] Add folder navigation and file grouping.
- [x] Display media metadata (title, duration).
- [x] Enable tap to play media directly.
- [x] Implement long press for multi-select.
- [x] Ensure all options are runnable, test functionalities.

---

## 🎨 UI/UX Improvements

### 1. **Animations**
- [x] Animate screen transitions.
- [x] Add shimmer loaders.
- [x] Implement swipe gestures.

### 2. **Responsive Layout**
- [x] Optimize player screens for different screen sizes.
- [x] Use `LayoutBuilder` where needed.

### 3. **Minimalistic Theme**
- [x] Use consistent colors and fonts.
- [x] Reduce clutter in player interface.

---

## 📁 New Pages to Add

### 1. **Recent Played**
- [x] New page to show last played items.
- [x] Fetch from local storage.

### 2. **Favorites**
- [x] Add favorites functionality.
- [x] Show heart icon on media items.

### 3. **Artist / Album View**
- [x] Group media under artist or album.
- [x] Display album art and metadata.

---

## 🛠️ Tech Enhancements

### 1. **Improve State Management**
- [x] Use Riverpod or Bloc instead of basic providers.
- [x] Lazy load media in lists.

### 2. **Better Error Handling**
- [x] Show user-friendly errors.
- [x] Add error boundary fallbacks.

### 3. **Theme Responsiveness & Localization**
- [x] Ensure all pages and widgets respond to theme changes.
- [x] All texts should use localization (`AppLocalizations`).
- [x] Replace hardcoded strings with `l10n` keys.

---

> ✅ = Done  
> 🚧 = In Progress  
> ⬜ = Not Started
