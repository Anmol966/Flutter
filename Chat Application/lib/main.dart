import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import './screens/chat_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import './screens/auth_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
          primarySwatch: Colors.teal,
          backgroundColor: Colors.pink,
          elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                  onPrimary: Colors.white,
                  primary: Colors.pink,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20))))),

      //  ButtonTheme.of(context).copyWith(
      //     buttonColor: Colors.green,
      //     textTheme: ButtonTextTheme.primary,
      //     shape: RoundedRectangleBorder(
      //         borderRadius: BorderRadius.circular(20)))),
      home: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (ctx, userSnapshot) {
          if (userSnapshot.hasData) {
            return ChatScreen();
          }
          return AuthScreen();
        },
      ),
    );
  }
}
