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
    apiKey: 'AIzaSyC7zrAxnz_wXsQ1J9AmAHopfuXIuWO7hgQ',
    appId: '1:474942712627:web:31ad3dc343b14ee885ac46',
    messagingSenderId: '474942712627',
    projectId: 'biosync-6d4f2',
    authDomain: 'biosync-6d4f2.firebaseapp.com',
    storageBucket: 'biosync-6d4f2.firebasestorage.app',
    measurementId: 'G-VGSW1K346Y',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBlBDUCOJ_gQyCz2cDjXckCZpE0LWhIp4E',
    appId: '1:474942712627:android:715d79af362a3fb485ac46',
    messagingSenderId: '474942712627',
    projectId: 'biosync-6d4f2',
    storageBucket: 'biosync-6d4f2.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDj9E3Y4JIPey8wVgBOjnxV8wv6rTjZTj8',
    appId: '1:474942712627:ios:6e1d66de860b98b085ac46',
    messagingSenderId: '474942712627',
    projectId: 'biosync-6d4f2',
    storageBucket: 'biosync-6d4f2.firebasestorage.app',
    iosBundleId: 'com.example.finalYear',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDj9E3Y4JIPey8wVgBOjnxV8wv6rTjZTj8',
    appId: '1:474942712627:ios:6e1d66de860b98b085ac46',
    messagingSenderId: '474942712627',
    projectId: 'biosync-6d4f2',
    storageBucket: 'biosync-6d4f2.firebasestorage.app',
    iosBundleId: 'com.example.finalYear',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyC7zrAxnz_wXsQ1J9AmAHopfuXIuWO7hgQ',
    appId: '1:474942712627:web:e28196f28f3e26fb85ac46',
    messagingSenderId: '474942712627',
    projectId: 'biosync-6d4f2',
    authDomain: 'biosync-6d4f2.firebaseapp.com',
    storageBucket: 'biosync-6d4f2.firebasestorage.app',
    measurementId: 'G-BT4Z89VMQZ',
  );
}
