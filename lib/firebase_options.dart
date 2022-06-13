// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars
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
    // ignore: missing_enum_constant_in_switch
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
    }

    throw UnsupportedError(
      'DefaultFirebaseOptions are not supported for this platform.',
    );
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCK_kpe5iD9-eAiZ5m7xgermDNVADI4fvs',
    appId: '1:104529155637:android:4dd22487f501717559037c',
    messagingSenderId: '104529155637',
    projectId: 'flash-chat-f9a5b',
    storageBucket: 'flash-chat-f9a5b.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyB-7xbIvC9SJtqb33WWx3rye-14DSsGXZY',
    appId: '1:104529155637:ios:250d609ce78fc00859037c',
    messagingSenderId: '104529155637',
    projectId: 'flash-chat-f9a5b',
    storageBucket: 'flash-chat-f9a5b.appspot.com',
    iosClientId: '104529155637-8ckhcvi8qki528vq8qpa8a7tponuhg6j.apps.googleusercontent.com',
    iosBundleId: 'end',
  );
}