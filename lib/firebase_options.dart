// Настройки подключения к Firebase-проекту flutterlukichev.
// Значения взяты из Firebase Console: Project settings → Your apps → Web app.
// Это не секреты — данные защищают правила Firestore (только вошедшим пользователям).

import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart' show kIsWeb;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) return web;
    throw UnsupportedError(
      'Firebase настроен только для web. Запускайте: flutter run -d chrome',
    );
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyDcvsL1d0bjMvqCu225u883ZGxiv_444sQ',
    appId: '1:1025666889150:web:beb9f1d0f75b34a9c375ef',
    messagingSenderId: '1025666889150',
    projectId: 'flutterlukichev',
    authDomain: 'flutterlukichev.firebaseapp.com',
    storageBucket: 'flutterlukichev.firebasestorage.app',
    measurementId: 'G-EE5M1SHX6X',
  );
}
