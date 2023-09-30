import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:event_reminder/event.dart';
import 'package:event_reminder/homeScreen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:permission_handler/permission_handler.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  Hive.registerAdapter(EventAdapter());
  await Hive.openBox("events");

  await Permission.notification.isDenied.then((value) {
        if (value) {
          Permission.notification.request();
        }
      });
  AwesomeNotifications().initialize(
    null,
    [  
      NotificationChannel(
          channelKey: "eventNotif",
          channelName: "Event Reminders",
          channelDescription: "Allow notifications of upcoming Events.")
    ],
    debug: true,
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final lightTheme = ThemeData(
    useMaterial3: true,
    colorScheme:
        ColorScheme.fromSeed(seedColor: Color.fromARGB(255, 15, 104, 248))
            .copyWith(
                primary: Color.fromARGB(255, 11, 141, 227),
                primaryContainer: Color.fromARGB(149, 11, 151, 227)),
    listTileTheme: const ListTileThemeData().copyWith(minLeadingWidth: 20),
    textTheme: GoogleFonts.nunitoTextTheme().copyWith(
      titleLarge: const TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.bold,
      ),
      titleMedium: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
      titleSmall: const TextStyle(
        fontSize: 15,
      ),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: lightTheme,
      home: const HomeScreen()
    );
  }
}
