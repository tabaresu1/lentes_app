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
    apiKey: 'AIzaSyCSMU06spg08QsRLlCDFp6Ay7s3KcDN3v4',
    appId: '1:1035906787532:web:7610dae2f57afdd72dba69',
    messagingSenderId: '1035906787532',
    projectId: 'app-oticas',
    authDomain: 'app-oticas.firebaseapp.com',
    storageBucket: 'app-oticas.firebasestorage.app',
    measurementId: 'G-7ZDFSP19NQ',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDHowfGQpSXS5V48NFjpcTa3ZwlyCc4B-w',
    appId: '1:1035906787532:android:221761b3db916bbf2dba69',
    messagingSenderId: '1035906787532',
    projectId: 'app-oticas',
    storageBucket: 'app-oticas.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCT8gDnZe8hyeFXVi_k9rfGCAZuAPQlEEE',
    appId: '1:1035906787532:ios:61e2f684471739a42dba69',
    messagingSenderId: '1035906787532',
    projectId: 'app-oticas',
    storageBucket: 'app-oticas.firebasestorage.app',
    iosBundleId: 'com.example.lentesApp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCT8gDnZe8hyeFXVi_k9rfGCAZuAPQlEEE',
    appId: '1:1035906787532:ios:61e2f684471739a42dba69',
    messagingSenderId: '1035906787532',
    projectId: 'app-oticas',
    storageBucket: 'app-oticas.firebasestorage.app',
    iosBundleId: 'com.example.lentesApp',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyCSMU06spg08QsRLlCDFp6Ay7s3KcDN3v4',
    appId: '1:1035906787532:web:694d24e630fb90212dba69',
    messagingSenderId: '1035906787532',
    projectId: 'app-oticas',
    authDomain: 'app-oticas.firebaseapp.com',
    storageBucket: 'app-oticas.firebasestorage.app',
    measurementId: 'G-3LYDE6KD6J',
  );
}
