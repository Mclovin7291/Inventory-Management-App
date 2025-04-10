// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyC3PUtFeluPy5sEo3lF8F1KV_fwu7XcSwM',
    appId: '1:1043365384982:web:8657e0f89a83d5902b7637',
    messagingSenderId: '1043365384982',
    projectId: 'inventory-management-app-39b36',
    authDomain: 'inventory-management-app-39b36.firebaseapp.com',
    storageBucket: 'inventory-management-app-39b36.firebasestorage.app',
    measurementId: 'G-41SQMKE4M4',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyC_yHSmmJntvZMGX9uX9I-rYMGIt3xiyws',
    appId: '1:1043365384982:android:0891fddb355725c22b7637',
    messagingSenderId: '1043365384982',
    projectId: 'inventory-management-app-39b36',
    storageBucket: 'inventory-management-app-39b36.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAj5HlHhYB-fy8ZxpoBi_0Fa7mt9L4VlJ0',
    appId: '1:1043365384982:ios:122c1de0cfeb92b02b7637',
    messagingSenderId: '1043365384982',
    projectId: 'inventory-management-app-39b36',
    storageBucket: 'inventory-management-app-39b36.firebasestorage.app',
    iosBundleId: 'com.example.inventorymanagementapp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAj5HlHhYB-fy8ZxpoBi_0Fa7mt9L4VlJ0',
    appId: '1:1043365384982:ios:122c1de0cfeb92b02b7637',
    messagingSenderId: '1043365384982',
    projectId: 'inventory-management-app-39b36',
    storageBucket: 'inventory-management-app-39b36.firebasestorage.app',
    iosBundleId: 'com.example.inventorymanagementapp',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyC3PUtFeluPy5sEo3lF8F1KV_fwu7XcSwM',
    appId: '1:1043365384982:web:5af0af38d5e0deee2b7637',
    messagingSenderId: '1043365384982',
    projectId: 'inventory-management-app-39b36',
    authDomain: 'inventory-management-app-39b36.firebaseapp.com',
    storageBucket: 'inventory-management-app-39b36.firebasestorage.app',
    measurementId: 'G-DT0TBP3XZR',
  );
}
