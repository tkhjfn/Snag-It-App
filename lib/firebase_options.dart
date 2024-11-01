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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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
    apiKey: 'AIzaSyCmAqfeKeMa20fwFE69Mn4_vdGBrHUj7a4',
    appId: '1:232859962907:web:de34cf0ec41b3d777f72be',
    messagingSenderId: '232859962907',
    projectId: 'auth-545a8',
    authDomain: 'auth-545a8.firebaseapp.com',
    storageBucket: 'auth-545a8.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBNghb0ZWGr5ey0cN-xupwnkpvGAFhpbLk',
    appId: '1:232859962907:android:83a888621297617a7f72be',
    messagingSenderId: '232859962907',
    projectId: 'auth-545a8',
    storageBucket: 'auth-545a8.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCmGSvQ2AvuhahIQBitev9Ty1pZGA1zTqo',
    appId: '1:232859962907:ios:8a4c57f29972b4eb7f72be',
    messagingSenderId: '232859962907',
    projectId: 'auth-545a8',
    storageBucket: 'auth-545a8.appspot.com',
    iosBundleId: 'com.example.app1',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCmGSvQ2AvuhahIQBitev9Ty1pZGA1zTqo',
    appId: '1:232859962907:ios:8a4c57f29972b4eb7f72be',
    messagingSenderId: '232859962907',
    projectId: 'auth-545a8',
    storageBucket: 'auth-545a8.appspot.com',
    iosBundleId: 'com.example.app1',
  );
}
