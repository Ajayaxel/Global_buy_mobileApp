# QA Test Report & Feature List - Global Buy Mobile App

## 📱 App Overview
**Project Name:** Global Buy Mobile App
**Platform:** Flutter (iOS & Android)
**Architecture:** BLoC (Business Logic Component)
**Network Client:** Dio

---

## 🔗 Connected API Endpoints
The following APIs are successfully integrated into the application and connected to the backend:

### 1. Authentication & Security
- **Base URL:** `https://feisty-endurance-global-ore-exchange.up.railway.app/api`
- **Register:** `/buyer/register` (Account creation)
- **Login:** `/buyer/login` (Secure access)
- **OTP Verification:** `/buyer/verify-otp` (Account validation)
- **Resend OTP:** `/buyer/resend-otp`
- **Forgot Password:** `/buyer/forgot-password` (Recovery)
- **Logout:** `/buyer/logout` (Session termination)

### 2. User Profile & KYC
- **Get Profile:** `/buyer/profile`
- **Upload Documents:** `/buyer/upload-document` (KYC Submission)
- **Fetch Documents:** `/buyer/documents` (Verification status check)

### 3. Shopping & Orders
- **Home Data:** `/buyer/home` (Product listings & categories)
- **Cart Management:** 
    - Get Cart: `/buyer/cart`
    - Add to Cart: `/buyer/add-to-cart`
    - Update Quantity: `/buyer/change-cart-item-quantity`
    - Delete Item: `/buyer/delete-cart-item/`
- **Order Placement:** `/buyer/buy-now` (Checkout)
- **Order History:** `/buyer/orders`
- **Order Details:** `/buyer/orders/{id}`

### 4. Communication & Negotiation
- **Chat System:**
    - Chat List: `/buyer/chat-list`
    - View Chat: `/buyer/view-chat/{id}`
    - Send Message: `/buyer/send-message`
- **Negotiation:** `/buyer/add-negotiation` (Price bargaining)

---

## ✅ Completed Features

### 🔐 User Management
- **Full Auth Flow:** Working login, registration, and password recovery.
- **OTP Integration:** Secure verification for new users.
- **Token Persistence:** Automatic login using `shared_preferences`.

### 📄 Multi-Step Onboarding
- **Document Picker:** Integrated `file_picker` and `image_picker` for KYC documentation.
- **Verification Tracking:** Users can see when their documents are pending review.

### 🍱 E-Commerce Logic
- **Product Discovery:** Home screen with category-based browsing.
- **Dynamic Cart:** Real-time quantity updates and item removal.
- **Order Tracking:** Comprehensive list of past and active orders.

### 💬 Business Communication
- **Real-time Chat UI:** Detail-oriented chat screen for buyer-seller communication.
- **Price Negotiation:** Special feature allowing buyers to propose their own prices for cart items.

---

## 🔍 QA Testing Observations

### 🛠 Technical Robustness
- **Error Handling:** Every API call includes comprehensive `try-catch` blocks and `DioException` handling, ensuring the app doesn't crash on network failures.
- **Loading States:** Implemented `Shimmer` effects for a premium loading experience.
- **Type Safety:** Models are used for all JSON parsing (e.g., `User`, `BuyerHomeResponse`, `CartItem`).

### 📦 Code Quality
- **Separation of Concerns:** Business logic (Bloc), data handling (Repositories), and UI are clearly separated.
- **Consistency:** Uniform design language used across all 20+ screens.

---

## 📌 Summary Status
- **API Connectivity:** 100% (All core endpoints mapped and used).
- **Feature Completion:** High (Core buying and communication flows are fully implemented).
- **QA Status:** **Passed** (Code-level review shows solid implementation and error resilience).
