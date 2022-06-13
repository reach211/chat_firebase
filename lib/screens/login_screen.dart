import 'package:loading_overlay/loading_overlay.dart';
import 'package:chat/constants.dart';
import 'chat_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:chat/components/rounded_button.dart';

class LoginScreen extends StatefulWidget {
  static const String id = "login_screen";
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _appState = false;
  final _auth = FirebaseAuth.instance;
  late String email, password;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: LoadingOverlay(
        isLoading: _appState,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Flexible(
                child: Hero(
                  tag: "logo",
                  child: SizedBox(
                    height: 200.0,
                    child: Image.asset('images/logo.png'),
                  ),
                ),
              ),
              SizedBox(
                height: 48.0,
              ),
              TextField(
                  enableSuggestions: true,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.black),
                  onChanged: (value) {
                    email = value;
                  },
                  decoration: kTextFieldDecoration.copyWith(
                    hintText: "Enter your email",
                  )),
              SizedBox(
                height: 8.0,
              ),
              TextField(
                enableSuggestions: true,
                  textAlign: TextAlign.center,
                  obscureText: true,
                  style: TextStyle(color: Colors.black),
                  onChanged: (value) {
                    password = value;
                  },
                  decoration: kTextFieldDecoration.copyWith(
                    hintText: "Enter your password",
                  )),
              SizedBox(
                height: 24.0,
              ),
              RoundedButton(
                buttonTitle: "Log in",
                colour: Colors.lightBlueAccent,
                onPressed: () async {
                  try {
                    setState(() {
                      _appState = true;
                    });
                    final loggedInUser = await _auth.signInWithEmailAndPassword(
                        email: email, password: password);

                    if (loggedInUser.additionalUserInfo?.isNewUser == false) {
                      Navigator.pushNamed(context, ChatScreen.id);
                    }
                  } catch (e) {
                    print(e);
                    showDialog<String>(
                      context: context,
                      builder: (BuildContext context) =>AlertDialog(
                        backgroundColor: Colors.white,
                        title: const Text('Log In Fail', style: TextStyle(color: Colors.blue),),
                        content: Text("$e", style: const TextStyle(color: Colors.blue),),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () => Navigator.pop(context, 'Cancel'),
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () => Navigator.pop(context, 'OK'),
                            child: const Text('OK'),
                          ),
                        ],
                      ),
                    );
                    setState(() {
                      _appState = false;
                    });
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
