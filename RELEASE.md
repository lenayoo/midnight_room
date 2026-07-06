# Release Guide

This project is prepared for:

- iOS bundle ID: `com.verydays.midnightroom`
- Android application ID: `com.verydays.midnightroom`
- app name: `Midnight room`

## 1. Android signing

Create `android/key.properties` from `android/key.properties.example`.

Example:

```properties
storePassword=...
keyPassword=...
keyAlias=upload
storeFile=upload-keystore.jks
```

Place the keystore file under `android/` or update `storeFile` to the correct relative path.

## 2. AdMob config

Android app ID:

- copy `android/admob.properties.example` to `android/admob.properties`
- set `ADMOB_ANDROID_APP_ID`

iOS app ID:

- copy `ios/Flutter/AdMob.example.xcconfig` to `ios/Flutter/AdMob.xcconfig`
- set `GAD_APPLICATION_IDENTIFIER`

Banner unit IDs for Flutter release builds:

- copy `dart_defines.example.json` to `dart_defines.json`
- fill `ADMOB_ANDROID_BANNER_AD_UNIT_ID` and `ADMOB_IOS_BANNER_AD_UNIT_ID`

If banner IDs are empty, ads stay disabled in release.

## 3. Versioning

Update `pubspec.yaml`:

- `version: x.y.z+buildNumber`

## 4. Android release build

```bash
flutter build appbundle --release --dart-define-from-file=dart_defines.json
```

Output:

- `build/app/outputs/bundle/release/app-release.aab`

## 5. iOS release build

Local verification without signing:

```bash
flutter build ios --release --no-codesign --dart-define-from-file=dart_defines.json
```

Store upload flow:

1. Open `ios/Runner.xcworkspace` in Xcode.
2. Check Signing & Capabilities for the `Runner` target.
3. Select the Apple Developer team and provisioning profile.
4. Archive with `Product > Archive`.
5. Upload to TestFlight / App Store Connect.

## 6. Pre-flight checks

```bash
flutter analyze
flutter test
```
