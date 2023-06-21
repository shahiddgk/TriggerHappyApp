// ignore_for_file: avoid_print, avoid_function_literals_in_foreach_calls

import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_quiz_app/Widgets/colors.dart';
import 'package:flutter_quiz_app/splash_screen.dart';
// import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:responsive_framework/responsive_framework.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Stripe.publishableKey = 'pk_live_51NAYCKLyPobj6EzkyRLf3pT2kzmHjAahmtahWsUfAEY5EV4ECruU6zlPTaTIwEGlQ7Tvip9hagaU8krn4mF5uHrl00sfo3RvfC';
//  await Stripe.instance.applySettings();
  await Firebase.initializeApp();
  _configureFirebase();

 // NotificationService().initNotification();
  //tz.initializeTimeZones();
  // Step 3
  SystemChrome.setPreferredOrientations(
      [ DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown, ]
  ).then((value) => runApp(const MyApp()));
  runApp(const MyApp());
}

//Too recieve FCM notification
void _configureFirebase() async {
  await Firebase.initializeApp();
  if (Platform.isIOS) {
    await FirebaseMessaging.instance.requestPermission();
  }
  var token = await FirebaseMessaging.instance.getToken();
  print("Device Token = $token");
  // await Clipboard.setData(ClipboardData(text: token));
  // final controllerChat = Get.put(ChatScreenController());
  FirebaseMessaging.onMessage.listen((message) {

    //print('Got a message whilst in the foreground!');

   // print('Message data: ${message.data}');
  });
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {

    // print('Got a message whilst in the foreground!');
    //
    // print('Message data: ${message.data}');

  });
  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    //print('Got a message whilst in the foreground!');
    // print(message.data);

    if (message.notification != null) {
      // print(
      //     'Message also contained a notification: ${message.notification!.body.toString()}');
    }
  });
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {

 // print("Handling a background message: ${message.messageId}");
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      builder: (context, child) => ResponsiveBreakpoints.builder(
        child: child!,
        breakpoints: [
          const Breakpoint(start: 0, end: 450, name: MOBILE),
          const Breakpoint(start: 451, end: 800, name: TABLET),
          const Breakpoint(start: 801, end: 1920, name: DESKTOP),
          const Breakpoint(start: 1921, end: double.infinity, name: '4K'),
        ],
      ),
      debugShowCheckedModeBanner: false,
      title: 'Burgeon',
      theme: ThemeData(
        primarySwatch: buildMaterialColor(AppColors.primaryColor),
      ),
      home: const SplashScreen(),
    );
  }

  MaterialColor buildMaterialColor(Color color) {
    List strengths = <double>[.05];
    Map<int, Color> swatch = {};
    final int r = color.red, g = color.green, b = color.blue;

    for (int i = 1; i < 10; i++) {
      strengths.add(0.1 * i);
    }
    strengths.forEach((strength) {
      final double ds = 0.5 - strength;
      swatch[(strength * 1000).round()] = Color.fromRGBO(
        r + ((ds < 0 ? r : (255 - r)) * ds).round(),
        g + ((ds < 0 ? g : (255 - g)) * ds).round(),
        b + ((ds < 0 ? b : (255 - b)) * ds).round(),
        1,
      );
    });
    return MaterialColor(color.value, swatch);
  }
}

