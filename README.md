# ReThread — Give Unused Things Another Life ♻️

A community-driven circular economy platform built with **Flutter, Dart, Material 3, and Firebase**, connecting people who have unused items with neighbors who can reuse, repair, or recycle them.

> **Tagline:** *"Give unused things another life."*  
> **Core Loop:** Reuse → Repair → Donate → Recycle

---

## 🌟 Vision & Key Differences from Traditional E-Commerce

ReThread is **NOT** a marketplace, shopping cart, or classifieds sales board:
- ❌ **No payment gateways or checkout carts**
- ❌ **No product purchasing or sales commissions**
- ❌ **No exact private home addresses exposed publicly**
- ✅ **100% focused on sustainability, community participation, and extending object lifespans**
- ✅ **Coordinated neighborhood handovers and repair discovery**

---

## 📱 Features Implemented

### 1. Splash & Onboarding
- **Animated Splash Screen:** ReThread circular economy emblem, typography, and smooth transitions.
- **3-Step Interactive Onboarding:** Introduces *Step 1: Reuse*, *Step 2: Repair*, and *Step 3: Recycle* with swipeable `PageView`, dot indicators, and skip controls.

### 2. Authentication & User Profile
- **Authentication:** Email & password Login and Sign Up with real-time form validation and password visibility toggle.
- **Neighborhood-First Privacy:** Users specify their `city` and `neighborhood/area` (e.g., *Indiranagar, Bengaluru*). Street addresses and floor numbers are **never** displayed publicly.
- **Sustainability Impact Stats:** Tracks *Items Donated*, *Items Reused*, and estimated *Waste Diverted from Landfill*.
- **Profile Editing:** In-app dialog to update display name, city, and neighborhood.

### 3. Home Dashboard & Community Impact
- Personal greeting with active neighborhood location.
- **Community Impact Card:** Measurable metrics (*1,280+ Items Reused*, *340+ Repairs Made*, *4.2 Tons Waste Diverted*).
- **Category Shortcuts:** Horizontal scroll across all 8 supported categories.
- **Featured Reusable Items:** Horizontal card carousel.
- **Recently Added Listings:** Real-time responsive 2-column grid.

### 4. Explore & Search
- Live search filtering against item titles, descriptions, and neighborhood locations.
- **Category Filter Chips:** *Electronics, Books, Clothing, Furniture, Home Appliances, Toys, School Supplies, Others*.
- **Condition Filter Chips:** *Like new, Good, Fair, Needs repair*.
- **Friendly Empty State:** Reset action when search/filter queries return 0 matches.

### 5. Create & Edit Listings
- Multi-photo upload support via `image_picker` (Gallery / Camera).
- Thumbnail row with remove (`[X]`) capabilities.
- Form fields: Item title, Category dropdown, Condition selector, Listing purpose (*Free donation*, *Community reuse*, *Needs repair / free for parts*), Description, and City/Area.
- Full edit and delete permissions for the listing owner.

### 6. Requests & Safe Handover Workflow
- **"Request This Item" Flow:** Direct modal request with a customized introductory message.
- **Safe Transaction Simulation:** When a donor accepts a request, the item is marked as *Accepted* and reserved, preventing simultaneous conflicting claims.
- **Activity Tracker (3 Tabs):**
  - **My Requests:** Track outgoing claims with real-time status badges (*Requested, Accepted, Handed Over*) and cancel option.
  - **Incoming Requests:** Review neighbor requests on your items with *Accept* and *Decline* controls.
  - **Completed Handovers:** Archive of completed reuses diverting waste from landfills.

### 7. Repair & Recycling Directories
- **Local Repair Directory:** Certified workshops for electronics recabling, laptop battery replacement, mixer grinder motor rewinding, tailor alterations, and furniture care.
- **Recycling Facility Directory:** Directory filterable by materials (*E-Waste, Paper, Plastic, Metal, Clothing, Batteries*) with operating hours and contact details.

### 8. In-App Notifications
- Real-time notification center for request updates, approvals, and completed handovers with a "Mark all read" toggle.

---

## 🏗️ Architecture & Project Structure

The project follows a **feature-first clean architecture**:

```
lib/
├── main.dart                          # App entry point (WidgetsFlutterBinding, ProviderScope)
├── app.dart                           # Root MaterialApp.router & Theme configuration
├── core/
│   ├── constants/
│   │   ├── app_colors.dart            # Forest Green, Sage Green, Warm Off-White palette
│   │   ├── app_strings.dart           # Centralized string constants
│   │   └── app_categories.dart        # 8 official categories & condition lists
│   ├── theme/
│   │   └── app_theme.dart             # Material 3 typography, inputs, buttons, cards
│   ├── router/
│   │   └── app_router.dart            # GoRouter with StatefulShellRoute.indexedStack
│   ├── services/
│   │   └── firebase_service.dart      # Firestore & Storage collection identifiers
│   └── widgets/
│       ├── app_scaffold_shell.dart    # Persistent 5-tab Bottom Navigation Bar
│       ├── custom_badge.dart          # Status & Condition badges
│       ├── item_card.dart             # Reusable listing card
│       └── empty_state.dart           # Search & filter empty state
└── features/
    ├── onboarding/                    # Splash & 3-step Onboarding
    ├── authentication/                # Login, Sign Up, User Model, AuthNotifier
    ├── home/                          # Home Dashboard & Community Impact metrics
    ├── explore/                       # Search, Filters, Sample Data, ItemsNotifier
    ├── item_details/                  # Photo viewer, details, owner actions, request sheet
    ├── create_listing/                # Image picker & multi-field listing creation form
    ├── requests/                      # RequestModel, RequestsNotifier, safe handover logic
    ├── activity/                      # Activity tab (My Requests, Incoming, Handovers)
    ├── repair/                        # Local Repair workshop discovery
    ├── recycling/                     # Certified Recycling facility map & materials
    ├── notifications/                 # In-app notification alerts
    └── profile/                       # User profile, privacy policy, about dialog, logout
```

---

## 🗄️ Database Design (Cloud Firestore Collections)

| Collection | Key Fields | Description |
| :--- | :--- | :--- |
| `users` | `uid`, `displayName`, `email`, `city`, `area`, `createdAt` | Member profiles; exact street addresses never stored. |
| `items` | `itemId`, `ownerId`, `title`, `description`, `category`, `condition`, `listingType`, `imageUrls`, `city`, `area`, `status`, `createdAt` | Community listings for reuse, donation, or repair. |
| `requests` | `requestId`, `itemId`, `ownerId`, `requesterId`, `message`, `status`, `createdAt` | Reusable handover requests. |
| `notifications` | `notificationId`, `recipientId`, `title`, `message`, `isRead`, `createdAt` | In-app notification events. |
| `repair_centres` | `centreId`, `name`, `category`, `city`, `area`, `contact`, `verificationStatus` | Verified local repair workshops. |
| `recycling_centres`| `centreId`, `name`, `supportedMaterials`, `city`, `area`, `contact` | Certified recycling drop-off centers. |

---

## 🛡️ Security Rules

Production-ready security rules are included in the repository:
- **`firestore.rules`**: Restricts profile edits to the authenticated user, enforces item ownership for edits/deletions, protects private request communications, and locks directories to read-only.
- **`storage.rules`**: Enforces authenticated image uploads, validates image MIME types, and caps photograph uploads at 5 MB.

---

## 🚀 Running the Application

### Immediate Browser Testing (Web)
```powershell
flutter run -d chrome
```

### Android Emulator or Physical Phone
1. Connect an Android phone via USB (with **USB Debugging** enabled) or launch an emulator from Android Studio.
2. Run:
```powershell
flutter run -d android
```

### Static Analysis & Tests
```powershell
flutter analyze
flutter test
```
*(Currently 0 warnings, 0 errors, all tests passing!)*

---

## 📄 License
This project is open-source under the MIT License for educational and community reuse purposes.
