import 'package:app_supermercado/db/users.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../db/auth.dart';

enum Status{
  Uninitializaded,
  Authenticated,
  Authenticating,
  Unauthenticated,
  Signup,
  Login
}

class UserProvider with ChangeNotifier{

  FirebaseAuth _auth;
  FirebaseUser _user;
  Status _status = Status.Uninitializaded;
  Status get status => _status;
  FirebaseUser get user => _user;
  UserServices _userServices = UserServices();

  UserProvider.initialize(): _auth = FirebaseAuth.instance{
    _auth.onAuthStateChanged.listen(_onStateChanged);
  }


  Future<bool> signIn(String email, String password) async{
    try{
      _status = Status.Authenticating;
      notifyListeners();
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return true;
    }catch(e){
      _status = Status.Unauthenticated;
      notifyListeners();
      print(e.toString());
      return false;
    }
  }


  Future<bool> signInWithGoogle() async{
    try{
      _status = Status.Authenticating;
      notifyListeners();

      Auth auth = Auth();
      //beginin of login
      FirebaseUser firebaseUser = await auth.googleSignIn();
      if(firebaseUser == null){
        _userServices.createUser({
          "name": firebaseUser.displayName,
          "photo": firebaseUser.photoUrl,
          "email": firebaseUser.email,
          "userId": firebaseUser.uid
        });
      }

      _status = Status.Authenticated;
      notifyListeners();

      return true;
    }catch(e){
      _status = Status.Unauthenticated;
      notifyListeners();
      print(e.toString());
      return false;
    }
  }

  Future<String>getEmailUser(){

  }

  Future<bool> changeStatusToSignup(){
    _status = Status.Signup;
    notifyListeners();
  }

  Future<bool> changeStatusToHomePage(){
    _status = Status.Authenticated;
    notifyListeners();
  }

  Future<bool> changeStatusToLogin(){
    _status = Status.Login;
    notifyListeners();
  }

  Future<bool> signUp(String name, String email, String password) async{
    try{
      _status = Status.Authenticating;
      notifyListeners();

      await _auth.createUserWithEmailAndPassword(email: email, password: password).then((user){
        Map<String, dynamic> values={
          "name" : name,
          "email" : email,
          "user" : user.uid
        };
        _userServices.createUser(values);
      });

      _status = Status.Authenticated;
      notifyListeners();

      return true;
    }catch(e){
      _status = Status.Unauthenticated;
      notifyListeners();
      print(e.toString());
      return false;
    }
  }
  
  Future signOut() async{
   _auth.signOut();
   _status = Status.Unauthenticated;
   notifyListeners();
   return Future.delayed(Duration.zero);
  }

  Future<void> _onStateChanged(FirebaseUser user) async {
    if(user == null){
      _status = Status.Unauthenticated;
    }else{
      _user = user;
      _status = Status.Authenticated;
    }
    notifyListeners();
  }
}

