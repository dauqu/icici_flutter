import 'package:flutter/material.dart';
import 'package:icici/home.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AccountNumber extends StatefulWidget {
  const AccountNumber({Key? key}) : super(key: key);

  @override
  State<AccountNumber> createState() => _AccountNumberState();
}

class _AccountNumberState extends State<AccountNumber> {
  final TextEditingController _accountNumberController =
      TextEditingController();

  var loading = false;

  Future<void> _saveAccountNumber() async {
    setState(() {
      loading = true;
    });
    final accountNumber = _accountNumberController.text;

    if (accountNumber.isEmpty || accountNumber.length != 12) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Invalid Account Number'),
            content:
                const Text('Please enter a valid 12-digit account number.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
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

    // Save the account number to SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('account_number', accountNumber);

    //Wait for 2 sec
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      loading = false;
    });

    // ignore: use_build_context_synchronously
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const MyHomePage(),
      ),
    );
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
              const SizedBox(
                height: 20,
              ),
              const Text(
                "Authenticate your 16-digit account number to continue. The account number is available on your passbook and cheque book.",
                textAlign: TextAlign.start,
                style: TextStyle(fontSize: 15),
              ),
              const SizedBox(
                height: 60,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Account Number*"),
                  const SizedBox(
                    height: 10,
                  ),
                  TextField(
                    maxLength: 12,
                    controller: _accountNumberController,
                    style: const TextStyle(color: Colors.black),
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.all(15),
                      isDense: true,
                      hintText: 'Account Number',
                      hintStyle: TextStyle(color: Colors.black),
                      filled: true,
                      prefixIcon:
                          Icon(Icons.account_balance, color: Colors.black),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 50,
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.yellow.shade900,
                    padding: const EdgeInsets.all(5),
                    elevation: 0,
                  ),
                  onPressed: loading ? null : _saveAccountNumber,
                  child: Text(
                    loading ? 'Loading...' : 'Continue',
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
              // Some text about safety
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
