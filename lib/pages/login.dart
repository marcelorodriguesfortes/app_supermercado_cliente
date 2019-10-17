import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../db/auth.dart';
import '../provider/user_provider.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {

  final _formKey = GlobalKey<FormState>();
  final _key = GlobalKey<ScaffoldState>();
  TextEditingController _email = TextEditingController();
  TextEditingController _password = TextEditingController();
  bool hidePass = true;
  Auth auth = Auth();

 /*caso o login seja bem sucedido,
   este método armazena o e-mail do usuário
  */
  armazenaDadosLogin() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString("emailusuario", _email.text);
  }


  @override
  Widget build(BuildContext context) {

    final user = Provider.of<UserProvider>(context);

    return Scaffold(
      key: _key,
      body: user.status == Status.Authenticating ? Center(child: CircularProgressIndicator()) : ListView(
        children: <Widget>[
          Container(
            child: Padding(
              padding: const EdgeInsets.only(left:25.0, right:25.0, top: 80, bottom: 100),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey[350],
                      blurRadius:
                      20.0, // has the effect of softening the shadow
                    )
                  ],
                ),

                child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Container(
                              alignment: Alignment.topCenter,
                              child: Image.asset(
                                'assets/logo_reis.png',
                                width: 120.0,
//                height: 240.0,
                              )),
                        ),

                        //Campo e-mail
                        Padding(
                          padding:
                          const EdgeInsets.fromLTRB(14.0, 8.0, 14.0, 8.0),
                          child: Material(
                            borderRadius: BorderRadius.circular(10.0),
                            color: Colors.grey.withOpacity(0.2),
                            elevation: 0.0,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 12.0),
                              child: ListTile(
                                title: TextFormField(
                                  controller: _email,
                                  decoration: InputDecoration(
                                      hintText: "E-mail",
                                      icon: Icon(Icons.alternate_email),
                                      border: InputBorder.none),
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      Pattern pattern =r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                                      RegExp regex = new RegExp(pattern);
                                      if (!regex.hasMatch(value))
                                        return 'Email inválido';
                                      else
                                        return null;
                                    }
                                  },
                                ),
                              ),
                            ),
                          ),
                        ),


                        
                        Padding(
                          padding:
                          const EdgeInsets.fromLTRB(14.0, 8.0, 14.0, 8.0),
                          child: Material(
                            borderRadius: BorderRadius.circular(10.0),
                            color: Colors.grey.withOpacity(0.2),
                            elevation: 0.0,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 12.0),
                              child: ListTile(
                                title: TextFormField(
                                  controller: _password,
                                  obscureText: hidePass,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: "Senha",
                                    icon: Icon(Icons.lock_outline),
                                  ),
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return "A senha não pode ter tamanho 0";
                                    } else if (value.length < 6) {
                                      return "A senha deve ter ao menos 6 caracteres";
                                    }
                                    return null;
                                  },
                                ),

                                trailing: IconButton(
                                    icon: Icon(Icons.remove_red_eye),
                                    onPressed: () {
                                      if (hidePass == true){
                                        setState(() {
                                          hidePass = false;
                                        });
                                      }else{
                                        setState(() {
                                          hidePass = true;
                                        });
                                      }
                                    }),
                              ),
                            ),
                          ),
                        ),


                        Padding(
                          padding:
                          const EdgeInsets.fromLTRB(14.0, 8.0, 14.0, 8.0),
                          child: Material(
                              borderRadius: BorderRadius.circular(20.0),
                              color: Colors.blue,
                              elevation: 0.0,
                              child: MaterialButton(
                                onPressed: () async{
                                  if(_formKey.currentState.validate()){
                                    armazenaDadosLogin();
                                    if(!await user.signIn(_email.text, _password.text)){
                                      _key.currentState.showSnackBar(SnackBar(content: Text("Sign in failed")));
                                    }
                                  }
                                },
                                minWidth: MediaQuery.of(context).size.width,
                                child: Text(
                                  "Login",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20.0),
                                ),
                              )),
                        ),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[

                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "Esqueci a senha",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),


                            Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: InkWell(
                                    onTap: () {
                                      user.changeStatusToSignup();
                                      //Navigator.push(context,MaterialPageRoute(builder: (context) => SignUp()));
                                    },
                                    child: Text(
                                      "Criar uma conta",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(color: Colors.black),
                                    ))),
                          ],
                        ),


                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[

                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text("Logar com", style: TextStyle(fontSize: 18,color: Colors.grey),),
                              ),


                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: MaterialButton(
                                    onPressed:() async {
                                      if(!await user.signInWithGoogle()){
                                        _key.currentState.showSnackBar(SnackBar(content: Text("Sign in failed")));
                                      }
                                    },
                                    child: Image.asset("assets/google_logo.png", width: 30,)
                                ),
                              ),
                            ],
                          ),
                        ),

                      ],
                    )),
              ),
            ),
          ),
        ],
      ),
    );
  }
}