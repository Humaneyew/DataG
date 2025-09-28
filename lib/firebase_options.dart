import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        return windows;
      case TargetPlatform.linux:
        return linux;
      default:
        return android;
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'demo-api-key',
    appId: '1:000000000000:web:demo',
    messagingSenderId: '000000000000',
    projectId: 'datag-demo',
    authDomain: 'datag-demo.firebaseapp.com',
    storageBucket: 'datag-demo.appspot.com',
    measurementId: 'G-DEMO1234',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'demo-android-api-key',
    appId: '1:000000000000:android:demo',
    messagingSenderId: '000000000000',
    projectId: 'datag-demo',
    storageBucket: 'datag-demo.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'demo-ios-api-key',
    appId: '1:000000000000:ios:demo',
    messagingSenderId: '000000000000',
    projectId: 'datag-demo',
    storageBucket: 'datag-demo.appspot.com',
    iosBundleId: 'com.example.datag',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'demo-macos-api-key',
    appId: '1:000000000000:ios:demo',
    messagingSenderId: '000000000000',
    projectId: 'datag-demo',
    storageBucket: 'datag-demo.appspot.com',
    iosBundleId: 'com.example.datag',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'demo-windows-api-key',
    appId: '1:000000000000:web:demo',
    messagingSenderId: '000000000000',
    projectId: 'datag-demo',
    storageBucket: 'datag-demo.appspot.com',
  );

  static const FirebaseOptions linux = FirebaseOptions(
    apiKey: 'demo-linux-api-key',
    appId: '1:000000000000:web:demo',
    messagingSenderId: '000000000000',
    projectId: 'datag-demo',
    storageBucket: 'datag-demo.appspot.com',
  );
}
