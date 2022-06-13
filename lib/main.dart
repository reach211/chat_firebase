import 'package:chat/screens/chat.dart';
import 'package:flutter/material.dart';
import 'screens/welcome_screen.dart';
import 'screens/login_screen.dart';
import 'screens/registration_screen.dart';
import 'screens/chat_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:wakelock/wakelock.dart';
void main ()async {

  WidgetsFlutterBinding.ensureInitialized();
  Wakelock.enable();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const FlashChat());
}
class FlashChat extends StatelessWidget {
  const FlashChat({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // theme: ThemeData.dark().copyWith(
      //   textTheme: const TextTheme(
      //       bodyText1: TextStyle(color: Colors.black),
      //   )
      // ),
      initialRoute: WelcomeScreen.id,
      // initialRoute: ChatPage.id,
      routes: {
        WelcomeScreen.id : (context) => const WelcomeScreen(),
        RegistrationScreen.id: (context) => RegistrationScreen(),
        ChatScreen.id: (context) => ChatScreen(),
        ChatPage.id: (context) => ChatPage(),
        LoginScreen.id: (context) => LoginScreen()
      },
    );
  }
}






















