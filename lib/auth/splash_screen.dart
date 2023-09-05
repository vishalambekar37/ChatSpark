import 'package:flash_we_chat/api/apis.dart';
import 'package:flash_we_chat/auth/login_screen.dart';
import 'package:flash_we_chat/auth/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../main.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({
    super.key,
  });

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
      //SingleTickerProviderStateMixin  to set up and manage the _animationController for the background color transition animation in the splash screen.
  // bool _isAnimate = false;
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 4000), () {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge); //mean this screen use whole screen
      SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
          systemNavigationBarColor: Colors.white,
          statusBarColor: Colors.white));

//if user already login then it direct go to home screen,
      if (APIs.auth.currentUser != null) {
        print('\nUser: ${APIs.auth.currentUser}');
        print('\nUserAdditionalInfo: ${APIs.auth.currentUser}');
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => const MyHomePage()));
      } else {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => const LoginScreen()));
      }

      //pushReplacement use to we dont want to come return in this page.
    });
  }

  ColorTween _colorTween =
      ColorTween(begin: Color(0xff031856), end: Colors.blue);
  AnimationController? _animationController;

  @override
  void iniState() {
    super.initState();
    _animationController =
        AnimationController(duration: Duration(seconds: 5), vsync: this)
          ..repeat();
    _animationController?.addListener(() {
      print(_animationController?.value);
    });
  }

  @override
  //dispose() Method: This method is called when the state is disposed
  void dispose() {
    super.dispose();
    _animationController?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    mq = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              _colorTween.evaluate(
                AlwaysStoppedAnimation(_animationController?.value ?? 0),
              ),
              Colors.black,
            ].map((color) => color as Color).toList(),
          ),
        ),
        child: Stack(
          children: [
            Positioned(
              top: mq.height * .25,
              right: mq.width * .25,
              width: mq.width * .5,
              child: Image.asset('assets/images/t.flash_logo.png'),
            ),
            Positioned(
              bottom: mq.height * 0.07,
              // top: mq.height * .5,
              width: mq.width,
              child: const Text(
                'Made in India With ❤️',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 16,
                    color: Color.fromARGB(255, 64, 235, 248),
                    letterSpacing: .5),
              ),
            )
          ],
        ),
      ),
    );
  }
}
