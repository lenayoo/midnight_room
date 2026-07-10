# Release Guide

This project is prepared for:

- iOS bundle ID: `com.verydays.midnightroom`
- Android application ID: `com.verydays.midnight_room`
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

Banner ad unit IDs:

- debug/profile builds automatically use Google's test banner IDs
- release builds use production banner IDs
- Android release requires `ADMOB_ANDROID_BANNER_AD_UNIT_ID`
- iOS release uses the current production ID in code by default, and can be
  overridden with `ADMOB_IOS_BANNER_AD_UNIT_ID`

Local release verification with test ads:

```bash
flutter run --release --dart-define=ADMOB_FORCE_TEST_IDS=true
```

## 3. Versioning

Update `pubspec.yaml`:

- `version: x.y.z+buildNumber`

## 4. Android release build

```bash
flutter build appbundle --release \
  --dart-define=ADMOB_ANDROID_BANNER_AD_UNIT_ID=ca-app-pub-.../...
```

Output:

- `build/app/outputs/bundle/release/app-release.aab`

## 5. iOS release build

Local verification without signing:

```bash
flutter build ios --release --no-codesign
```

Store upload flow:

1. Open `ios/Runner.xcworkspace` in Xcode.
2. Check Signing & Capabilities for the `Runner` target.
3. If you want to override the default iOS production banner ID, set
   `ADMOB_IOS_BANNER_AD_UNIT_ID` in the Flutter build you archive from.
4. Select the Apple Developer team and provisioning profile.
5. Archive with `Product > Archive`.
6. Upload to TestFlight / App Store Connect.

## 6. Pre-flight checks

```bash
flutter analyze
flutter test
```
