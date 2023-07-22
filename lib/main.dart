import 'package:flash_we_chat/auth/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'firebase_options.dart';

//global object for accessing device screen size.
late Size mq;
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown
  ]).then((value) => {
        _initializeFirebase(),
        runApp(const MyApp())
      }); //this is use to open our application in full screen and set orientation.
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flash Chat',
        theme: ThemeData(
          appBarTheme: const AppBarTheme(
              centerTitle: true,
              elevation: 1,
              iconTheme: IconThemeData(color: Colors.black)),
        ),
        home: const SplashScreen());
  }
}

_initializeFirebase() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
}
