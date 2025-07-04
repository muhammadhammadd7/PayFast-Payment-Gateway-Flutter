# Fruit Shop with PayFast Payment Gateway

A Flutter application demonstrating a fruit shop with integrated PayFast payment gateway for secure payments.

## Features

- 🍎 **Fruit Shop UI**: Clean and modern interface displaying available fruits
- 💳 **PayFast Integration**: Secure payment processing using PayFast gateway
- ✅ **Payment Status**: Clear success and failure screens
- 📱 **Responsive Design**: Material 3 design with green theme
- 🔄 **Deep Link Handling**: Automatic navigation after payment completion

## Getting Started

### Prerequisites

- Flutter SDK (>=3.7.2)
- Android/iOS development environment
- PayFast merchant account for production

### Installation

1. Clone the repository
2. Install dependencies:
   ```bash
   flutter pub get
   ```
3. Run the application:
   ```bash
   flutter run
   ```

## App Structure

### Main Features

- **Fruit Shop Screen** (`lib/fruit_shop_screen.dart`): Main shopping interface
- **PayFast Service** (`lib/services/payfast_service.dart`): Payment gateway integration
- **Payment WebView** (`lib/payment_webview.dart`): Secure payment processing
- **Success/Failure Screens**: User-friendly payment result pages

### Payment Flow

1. User views available fruits in the shop
2. Clicks "Proceed to Checkout" to initiate payment
3. PayFast access token is requested from backend
4. User is redirected to PayFast payment page
5. After payment, user is redirected to success/failure screen
6. User can continue shopping or try again

### Deep Link Configuration

The app handles deep links for payment redirects:
- `myapp://payment-success` - Payment successful
- `myapp://payment-failure` - Payment failed

## Configuration

### PayFast Settings

Update the following in your PayFast merchant account:
- Success URL: `myapp://payment-success`
- Failure URL: `myapp://payment-failure`

### Backend Configuration

The app connects to: `https://payfast-backend-production.up.railway.app/get-access-token`

## Payment Details

- **Test Amount**: Rs. 499
- **Currency**: PKR (Pakistani Rupee)
- **Order ID**: Automatically generated with timestamp
- **Merchant**: PayFast integration

## Dependencies

- `flutter`: SDK
- `http`: HTTP requests
- `webview_flutter`: Payment page display
- `app_links`: Deep link handling
- `fluttertoast`: User notifications

## Screenshots

The app features:
- Modern fruit shop interface
- Smooth payment integration
- Clear success/failure feedback
- Professional UI design

## Development

To customize the app:

1. **Modify Fruits**: Update the fruit list in `FruitShopScreen`
2. **Change Amount**: Modify `_totalAmount` variable
3. **Update Styling**: Customize colors and themes
4. **Payment Details**: Update customer information in `_startPayment`

## Production Setup

1. Replace test PayFast credentials with production keys
2. Update backend URL if using custom server
3. Configure proper deep link handling in app manifests
4. Test payment flow thoroughly

## Support

For PayFast integration support:
- Visit [PayFast Documentation](https://payfast.co.za/documentation/)
- Contact PayFast support for merchant account issues

---

**Note**: This app uses PayFast sandbox for testing. Update credentials for production use.
