import 'package:eco_web/webapp/screens/home_screen.dart';
import 'package:eco_web/webapp/screens/signin_screen.dart';
import 'package:eco_web/webapp/screens/signup_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (kIsWeb) {
    await Firebase.initializeApp(
        options: FirebaseOptions(
            apiKey: "AIzaSyCo9UegsA-dMa4ayqGmcfoe-8Ir5Gm80Ok",
            authDomain: "eco-collect-app.firebaseapp.com",
            projectId: "eco-collect-app",
            storageBucket: "eco-collect-app.appspot.com",
            messagingSenderId: "719946172570",
            appId: "1:719946172570:web:485c278806a3894a82f723",
            measurementId: "G-F97P3SFQSW"));
  } else {
    await Firebase.initializeApp();
  }

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/signin',
      routes: {
        '/signin': (context) => SignInPage(),
        '/signup': (context) => SignUpPage(),
        '/home': (context) => HomeScreen(),
      },
      // Optional: Add a fallback page if route is not found
      onUnknownRoute: (settings) {
        return MaterialPageRoute(builder: (context) => SignInPage());
      },
    );
  }
}
