# 💱 USD to IDR Exchange Rate

<div align="center">

![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white)
![API](https://img.shields.io/badge/Frankfurter-API-4CAF50?style=for-the-badge)

**A beautiful, modern USD to IDR exchange rate app built with Flutter**
## 🖼️ App Icon

This app uses an icon located at `assets/icon.png`.

**Icon copyright:**
Money icon by [Freepik - Flaticon](https://www.flaticon.com/free-icon/money_11112827?term=convert+money&page=1&position=2&origin=search&related_id=11112827)


[📱 Download APK](https://github.com/Ian7672/currency-exchange-app/releases) • [🎥 Demo Video](#-demo-video) • [📖 Documentation](#-documentation)

</div>

## 🌟 Features

✨ **Real-time Exchange Rates** - Get live currency rates from European Central Bank  
🎨 **Modern UI/UX** - Beautiful dark theme with glassmorphism effects  
🔄 **Easy Currency Swap** - One-tap currency switching  
📱 **Responsive Design** - Works perfectly on all screen sizes  
🚀 **No API Key Required** - Free to use with Frankfurter API  
🌍 **30+ Currencies** - Support for major world currencies  
💫 **Smooth Animations** - Delightful user experience with fluid animations  

## 🎥 Demo Video

[Link Demo App](https://github.com/user-attachments/assets/e5eb8d99-2c1c-492e-8c23-70ec19714539)



## 🚀 Getting Started

### Prerequisites

- Flutter SDK (>=3.0.0)
- Dart SDK (>=3.0.0)
- Android Studio / VS Code
- Android device or emulator


### Installation

1. **Clone the repository**
   ```pwsh
   git clone <repo-url>
   cd usd2idr_exchangerate
   ```

2. **Install dependencies**
   ```pwsh
   flutter pub get
   ```

3. **Run the app**
   ```pwsh
   flutter run
   ```

### Build APK

```bash
# Debug APK
flutter build apk --debug

# Release APK
flutter build apk --release

# Split APK by ABI (smaller size)
flutter build apk --split-per-abi
```

## 🔧 Configuration

### Dependencies

```yaml
dependencies:
   flutter:
      sdk: flutter
   http: ^1.1.0
   cupertino_icons: ^1.0.8
   url_launcher: ^6.2.5

dev_dependencies:
   flutter_test:
      sdk: flutter
   flutter_lints: ^5.0.0
```

### Supported Currencies

| Currency | Code | Flag |
|----------|------|------|
| US Dollar | USD | 🇺🇸 |
| Indonesian Rupiah | IDR | 🇮🇩 |
| Euro | EUR | 🇪🇺 |
| British Pound | GBP | 🇬🇧 |
| Japanese Yen | JPY | 🇯🇵 |
| Singapore Dollar | SGD | 🇸🇬 |
| Malaysian Ringgit | MYR | 🇲🇾 |
| Thai Baht | THB | 🇹🇭 |
| Chinese Yuan | CNY | 🇨🇳 |
| South Korean Won | KRW | 🇰🇷 |

## 🌐 API Documentation

This app uses the **Frankfurter API** - a free, open-source currency data API.

### Base URL
```
https://api.frankfurter.app
```

### Endpoint Used
```
GET /latest?from={FROM_CURRENCY}&to={TO_CURRENCY}
```

### Example Request
```bash
curl "https://api.frankfurter.app/latest?from=USD&to=IDR"
```

### Example Response
```json
{
  "amount": 1.0,
  "base": "USD",
  "date": "2024-01-15",
  "rates": {
    "IDR": 15425.123
  }
}
```

### API Features
- 🆓 **Free** - No API key required
- 📊 **Reliable** - Data from European Central Bank
- 🌍 **90+ Currencies** - Extensive currency support
- ⚡ **Fast** - Low latency responses
- 📈 **Historical Data** - Access to historical rates

## 🏗️ Architecture

```
lib/
├── main.dart                 # App entry point
└── currency_converter.dart   # Main UI and logic 
```

### Key Components

- **CurrencyExchangeApp**: Main app widget
- **CurrencyExchangePage**: Main page with conversion logic
- **HTTP Client**: For API communication
- **Animation Controller**: For smooth UI transitions

## 🎨 Design System

### Colors
- **Primary**: `#4F46E5` (Indigo)
- **Background**: `#0F0F23` → `#16213E` (Gradient)
- **Surface**: `rgba(255, 255, 255, 0.05)` (Glassmorphism)
- **Text**: `#FFFFFF` / `rgba(255, 255, 255, 0.6)`

### Typography
- **Font**: SF Pro Display
- **Headers**: 32px, Bold
- **Body**: 16px, Medium
- **Caption**: 12px, Regular

### Components
- **Cards**: Rounded corners (24px), Glass effect
- **Buttons**: Rounded (16px), Elevated style
- **Inputs**: Outlined, Focus states

## 🧪 Testing

```bash
# Run all tests
flutter test

# Run with coverage
flutter test --coverage

# Widget tests
flutter test test/widget_test.dart

# Integration tests
flutter drive --target=test_driver/app.dart
```

## 📦 Build & Release

### Android

1. **Configure signing**
   ```bash
   keytool -genkey -v -keystore ~/upload-keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload
   ```

2. **Update `android/key.properties`**
   ```properties
   storePassword=<password>
   keyPassword=<password>
   keyAlias=upload
   storeFile=<path-to-keystore>
   ```

3. **Build release APK**
   ```bash
   flutter build apk --release
   ```

### iOS

1. **Configure Xcode project**
2. **Set up provisioning profiles**
3. **Build for App Store**
   ```bash
   flutter build ios --release
   ```

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

1. Fork the project
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

### Code Style

- Follow [Effective Dart](https://dart.dev/guides/language/effective-dart) guidelines
- Use `flutter analyze` to check code quality
- Format code with `dart format`

## 📝 Changelog

### v1.0.0 (2024-01-15)
- ✨ Initial release
- 💱 Real-time currency conversion
- 🎨 Modern dark theme UI
- 📱 Responsive design
- 🔄 Currency swap functionality

## 🐛 Known Issues

- [ ] Currency list could be expanded to include more currencies
- [ ] Historical rate charts could be added
- [ ] Offline mode not yet implemented

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 👨‍💻 Author

**Ian7672**
- GitHub: [@Ian7672](https://github.com/Ian7672)

## 🙏 Acknowledgments

- [Frankfurter API](https://www.frankfurter.app/) - Free currency exchange rates API
- [Flutter Team](https://flutter.dev/) - Amazing cross-platform framework
- [European Central Bank](https://www.ecb.europa.eu/) - Currency data source
- [Material Design](https://material.io/) - Design system

---

<div align="center">

**⭐ Star this repository if you found it helpful!**

[Report Bug](https://github.com/Ian7672/currency-exchange-app/issues) • [Request Feature](https://github.com/Ian7672/currency-exchange-app/issues) • [Ask Question](https://github.com/Ian7672/currency-exchange-app/discussions)

</div>
