import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../controllers/landing_page_controller.dart';
import '../services/user_auth.dart';
import '../utils/app_constant.dart';

class LandingPage extends StatefulWidget {
  LandingPage({Key? key}) : super(key: key);

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  final controller = Get.find<LandingPageController>();
  final UserAuthService _userAuthService = UserAuthService();
  bool appleSignInAvailable = false;

  @override
  void initState() {
    super.initState();
    checkAvailibility();
  }

  checkAvailibility() async {
    await _userAuthService.appleSignInAvailable.then((value) {
      setState(() {
        appleSignInAvailable = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          color: const Color(mainBgColor),
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 50,
              ),
              Image.asset(
                'assets/logos/logo.png',
                width: MediaQuery.of(context).size.width / 3,
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height / 5,
              ),
              const Text(
                'Continue with ...',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
              const SizedBox(
                height: 30,
              ),
              // Google Button
              InkWell(
                onTap: () {
                  controller.signInWithGoogle();
                },
                child: Container(
                  margin: const EdgeInsets.only(left: 30),
                  width: MediaQuery.of(context).size.width / 2,
                  child: ListTile(
                    leading: Image.asset(
                      'assets/icons/Google.png',
                      width: 40,
                      height: 40,
                      fit: BoxFit.fill,
                      alignment: Alignment.bottomRight,
                      color: Colors.white,
                    ),
                    title: const Text(
                      'Google',
                      textAlign: TextAlign.start,
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              // Apple Button
              appleSignInAvailable
                  ? InkWell(
                      onTap: () {
                        controller.signInWithApple();
                      },
                      child: Container(
                        margin: const EdgeInsets.only(left: 30),
                        width: MediaQuery.of(context).size.width / 2,
                        child: ListTile(
                          leading: Image.asset(
                            'assets/icons/Apple.png',
                            width: 40,
                            height: 40,
                            fit: BoxFit.fill,
                            alignment: Alignment.bottomRight,
                            color: Colors.white,
                          ),
                          title: const Text(
                            'Apple',
                            textAlign: TextAlign.start,
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    )
                  : const SizedBox.shrink(),
              appleSignInAvailable
                  ? const SizedBox(
                      height: 30,
                    )
                  : const SizedBox.shrink(),
              //facebook
              InkWell(
                onTap: () {
                  controller.signInWithFacebook();
                },
                child: Container(
                  margin: const EdgeInsets.only(left: 30),
                  width: MediaQuery.of(context).size.width / 2,
                  child: ListTile(
                    leading: Image.asset(
                      'assets/icons/Facebook.png',
                      width: 40,
                      height: 40,
                      fit: BoxFit.fill,
                      alignment: Alignment.bottomRight,
                      color: Colors.white,
                    ),
                    title: const Text(
                      'Facebook',
                      textAlign: TextAlign.start,
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              //Twitter
              InkWell(
                onTap: () {
                  controller.signInWithTwitter();
                },
                child: Container(
                  margin: const EdgeInsets.only(left: 30),
                  width: MediaQuery.of(context).size.width / 2,
                  child: ListTile(
                    leading: Image.asset(
                      'assets/icons/Twitter.png',
                      width: 40,
                      height: 40,
                      color: Colors.white,
                    ),
                    title: const Text(
                      'Twitter',
                      textAlign: TextAlign.start,
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),

              SizedBox(
                height: MediaQuery.of(context).size.height / 8,
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 90),
                alignment: Alignment.center,
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    text: 'By continuing, you agree to our ',
                    style: const TextStyle(color: Colors.white, fontSize: 13),
                    children: [
                      TextSpan(
                          text: 'Terms of Service',
                          recognizer: TapGestureRecognizer()
                            ..onTap = (() {
                              launchUrl(Uri.parse(
                                  'https://choof.club/terms-service/'));
                            }),
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: 13)),
                      const TextSpan(
                        text: ' and ',
                        style: TextStyle(color: Colors.white, fontSize: 13),
                      ),
                      TextSpan(
                          text: 'Privacy Policy',
                          recognizer: TapGestureRecognizer()
                            ..onTap = (() {
                              launchUrl(Uri.parse(
                                  'https://choof.club/privacy-policy/'));
                            }),
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: 13)),
                    ],
                  ),
                ),
              ),
            ],
          )),
    );
  }
}
