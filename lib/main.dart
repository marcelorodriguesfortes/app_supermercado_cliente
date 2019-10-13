
import 'package:app_supermercado/pages/home.dart';
import 'package:app_supermercado/pages/login.dart';
import 'package:app_supermercado/pages/signup.dart';
import 'package:app_supermercado/pages/splash.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'provider/user_provider.dart';

void main() {
  runApp(
      ChangeNotifierProvider<UserProvider>(builder: (_) => UserProvider.initialize(),
        child: MaterialApp(debugShowCheckedModeBanner: false,
        theme: ThemeData(
            primaryColor: Colors.lightBlue
        ),
          home: ScreensController(),
        ),
  ));
}

class ScreensController extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context);
    switch(user.status){
      case Status.Uninitializaded:
        return Splash();
      case Status.Unauthenticated:
      case Status.Authenticating:
        return Login();
      case Status.Signup:
        return SignUp();
      case Status.Authenticated:
        return HomePage();
      case Status.Login:
        return Login();
      default: return Login();
    }
  }
}








