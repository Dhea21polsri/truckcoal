import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:truckcoal_app/login/splashscreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: "AIzaSyAqy-BAipxD1lgyH0exPml1FOyYkRziB7g",
      authDomain: "truckcoal-7ea59.firebaseapp.com",
      projectId: "truckcoal-7ea59",
      storageBucket: "truckcoal-7ea59.firebasestorage.app",
      messagingSenderId: "522745813269",
      appId: "1:522745813269:web:3f0543c3642e2c03aab11c",
    ),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: Splashscreen());
  }
}
