import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:proyectomovil/main.dart';

class Login extends StatefulWidget {
  @override
  _Login createState() => _Login();
}

class _Login extends State<Login>{
  TextEditingController usernameController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();

  bool _isLoading = false;

  final Shader linearGradient = LinearGradient(
    colors: <Color>[Colors.red, Colors.deepOrangeAccent],
  ).createShader(Rect.fromLTWH(0.0, 0.0, 200.0, 0.0));

  signIn(String username, String password) async{
    Map data ={
      'username' : username,
      'password' : password
    };
    var jsonData = null;
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var response = await http.post("http://192.168.42.115:8000/api/v1/login", body: data);
    if(response.statusCode == 200){
      jsonData = json.decode(response.body);
      setState((){
        _isLoading = false;
      });
      sharedPreferences.setString("token", jsonData['token']);
      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => MyApp()), (Route<dynamic> route) => false);

    }else{
      print(response.body);
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: Color(0xff1d1d1d),
      extendBodyBehindAppBar: true,
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        title: Text("Login", style: TextStyle(color: Colors.black38),),
        backgroundColor: Colors.transparent,
        actions: <Widget>[
          new IconButton(icon: const Icon(Icons.add,
              color: Colors.white) ,
              onPressed: null,
          color: Colors.black,)
        ],
      ),
      body: Container(
        child: _isLoading ? Center(child: CircularProgressIndicator(),):SingleChildScrollView(
          child: Column(
            children: <Widget>[
               Container(
                height: 400,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage("assets/img/13688-minimalista.png"),
                        fit: BoxFit.cover
                    )
                ),
                child: Stack(
                  children: <Widget>[
                    Positioned(
                      child: Container(
                        child: Stack(
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.fromLTRB(0.0, 300.0, 0.0, 0.0),
                              child: Text('LOGIN',
                                  style: TextStyle(
                                      fontSize: 80.0, fontWeight: FontWeight.bold, foreground: Paint()..shader = linearGradient)),
                            ),
                            Container(
                              padding: EdgeInsets.fromLTRB(200.0, 300.0, 0.0, 0.0),
                              child: Text('.',
                                  style: TextStyle(
                                      fontSize: 80.0,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.red)),
                            )
                          ],
                        )
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.all(30.0),
                child: Column(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                          color: Color(0xff1d1d1d),
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black,
                                blurRadius: 20.0,
                                offset: Offset(0,10)
                            )
                          ]
                      ),
                      child: Column(
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.all(8.0),
                            decoration: BoxDecoration(
                                border: Border(bottom: BorderSide(color: Colors.red))
                            ),
                            child:
                            TextField(
                              controller: usernameController,
                              style: TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "Correo Electronico",
                                  hintStyle: TextStyle(color: Colors.grey[400], fontFamily: 'Montserrat',),
                                  prefixIcon: Icon(Icons.email,color: Colors.deepOrangeAccent,)

                              ),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.all(8.0),
                            child: TextField(
                              controller: passwordController,
                              style: TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "Contraseña",
                                  hintStyle: TextStyle(color: Colors.grey[400], fontFamily: 'Montserrat',),
                                  prefixIcon: Icon(Icons.enhanced_encryption, color: Colors.deepOrangeAccent,)
                              ),
                              obscureText: true,
                            ),
                          )
                        ],
                      ),
                    ),
                    Container(
                      alignment: Alignment(1.0, 0.0),
                      padding: EdgeInsets.only(top: 15.0, left: 20.0),
                      child: InkWell(
                        onTap: null,
                        child: Text(
                          'Forgot Password',
                          style: TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Montserrat',
                              fontSize: 16,
                              decoration: TextDecoration.underline),
                        ),
                      ),
                    ),
                    SizedBox(height: 30,),
                    Container(
                      height: 50,
                      width: 250,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.redAccent
                      ),
                      child: Material(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.red,
                          shadowColor: Colors.black,
                          elevation: 7,
                          child: GestureDetector(
                            onTap: () {
                              setState((){
                                _isLoading = true;
                              });
                              signIn(usernameController.text, passwordController.text);
                            },
                            child: Center(
                              child: Text("LOGIN", style: TextStyle(color:Colors.white,fontWeight: FontWeight.bold, fontSize: 20, fontFamily: 'Montserrat',),),


                            )
                          ),
                        ),
                    ),
                    SizedBox(height: 70,),

                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}