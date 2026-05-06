import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart' show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) return web;
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      default:
        return web;
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyAHv1AlVyhkBue6l8jC5uPmuTh63oKMROY',
    authDomain: 'damas-eng.firebaseapp.com',
    projectId: 'damas-eng',
    storageBucket: 'damas-eng.firebasestorage.app',
    messagingSenderId: '331461320144',
    appId: '1:331461320144:web:33620a17eeb5529c35edd5',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAHv1AlVyhkBue6l8jC5uPmuTh63oKMROY',
    authDomain: 'damas-eng.firebaseapp.com',
    projectId: 'damas-eng',
    storageBucket: 'damas-eng.firebasestorage.app',
    messagingSenderId: '331461320144',
    appId: '1:331461320144:web:33620a17eeb5529c35edd5',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAHv1AlVyhkBue6l8jC5uPmuTh63oKMROY',
    authDomain: 'damas-eng.firebaseapp.com',
    projectId: 'damas-eng',
    storageBucket: 'damas-eng.firebasestorage.app',
    messagingSenderId: '331461320144',
    appId: '1:331461320144:web:33620a17eeb5529c35edd5',
  );
}
