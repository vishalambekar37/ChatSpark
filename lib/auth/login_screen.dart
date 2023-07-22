import 'dart:developer';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash_we_chat/auth/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../api/apis.dart';
import '../helper/dialogs.dart';
import '../main.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({
    super.key,
  });

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  bool _isAnimate = false;
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        _isAnimate = true;
      });
    });
  }

  _handleGoogleBtnClick(BuildContext context) {
    //for hiding progress bar
    Dialogs.showProgressBar(context);
    _signInWithGoogle().then((user) async {
      //for showing progress bar
      Navigator.pop(context);
      if (user != null) {
        log('\nUser: ${user.user}');
        log('\nUserAdditionalInfo: ${user.additionalUserInfo}');

        if ((await APIs.userExits())) {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (_) => const MyHomePage()));
        } else {
          APIs.createUser().then((value) {
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (_) => const MyHomePage()));
          });
        }
      }
    });
  }

  Future<UserCredential?> _signInWithGoogle() async {
    try {
      await InternetAddress.lookup('google.com');
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      // Obtain the auth details from the request
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      // Once signed in, return the UserCredential
      return await FirebaseAuth.instance.signInWithCredential(credential);
    } catch (e) {
      print('_/n_signInWithGoogle: $e');
      Dialogs.showSnackbar(context, 'Something Went Wrong (Check Internet!)',);
      return null;
    }
  }

  // sign out Function
  // _signOut() async{
  //   await FirebaseAuth.instance.signInWithCredential(credential);
  // }

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
  void dispose() {
    super.dispose();
    _animationController?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // mq = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Color.fromARGB(255, 64, 235, 248),
        title: Text(
          'Welcome to Flash Chat',
          style: TextStyle(color: Colors.black),
        ),
      ),
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
            // AnimatedContainer(
            //   duration: const Duration(seconds: 3),
            //   curve: Curves.easeInOut,
            //   width: _isAnimate ? mq.width * 1 : mq.width * 0.2,
            //   height: _isAnimate ? mq.height * 1 : mq.height * 0.2,
            //   child: Image.asset('assets/images/t.flash_logo.png'),
            // ),
            Positioned(
                bottom: mq.height * 0.5,
                width: mq.width * 1,
                left: mq.width * .02,
                height: mq.height * .2,
                child: Container(
                    child: Image.asset('assets/images/t.flash_logo.png'))),
            Positioned(
                bottom: mq.height * .15,
                width: mq.width * .9,
                left: mq.width * .05,
                height: mq.height * .06,
                child: ElevatedButton.icon(
                    onPressed: () {
                      _handleGoogleBtnClick(context);
                    },
                    icon: Image.asset(
                      'assets/images/g-logo.png',
                      height: mq.height * .03,
                    ),
                    label: RichText(
                        text: TextSpan(
                            style: TextStyle(color: Colors.black, fontSize: 16),
                            children: [
                          TextSpan(
                            text: 'Sign In With ',
                          ),
                          TextSpan(
                              text: 'Google',
                              style: TextStyle(fontWeight: FontWeight.bold))
                        ])),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromARGB(255, 64, 235, 248),
                        shape: StadiumBorder())))
          ],
        ),
      ),
    );
  }
}
