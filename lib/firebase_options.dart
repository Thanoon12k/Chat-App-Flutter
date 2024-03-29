// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
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
      throw UnsupportedError(
        'DefaultFirebaseOptions have not been configured for web - '
        'you can reconfigure this by running the FlutterFire CLI again.',
      );
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCUOsHecNsqZZQ6U5LjSS5IfQ9NttNovu0',
    appId: '1:353002107934:android:26602b7208dc4e3cadea0f',
    messagingSenderId: '353002107934',
    projectId: 'chatapp-6fbfd',
    databaseURL: 'https://chatapp-6fbfd-default-rtdb.firebaseio.com',
    storageBucket: 'chatapp-6fbfd.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyA9S8d88tQ2BCmT5MCkUnIXu-Inw8FQeqI',
    appId: '1:353002107934:ios:957eafec2b242b42adea0f',
    messagingSenderId: '353002107934',
    projectId: 'chatapp-6fbfd',
    databaseURL: 'https://chatapp-6fbfd-default-rtdb.firebaseio.com',
    storageBucket: 'chatapp-6fbfd.appspot.com',
    iosClientId: '353002107934-unaepelbkffud3514dd8cugkjfbp4puf.apps.googleusercontent.com',
    iosBundleId: 'com.example.chatapp',
  );
}
