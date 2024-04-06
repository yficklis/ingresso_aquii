import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ingresso_aquii/util/default_button.dart';
import 'package:ingresso_aquii/util/gradient_button.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  void signAsAnonymous() async {
    try {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      );
      await FirebaseAuth.instance.signInAnonymously();
      Navigator.of(context).pushNamedAndRemoveUntil(
        '/homepage',
        (Route<dynamic> route) => false,
      );
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);
      switch (e.code) {
        case "operation-not-allowed":
          // print("Anonymous auth hasn't been enabled for this project.");
          break;
        default:
        // print("Unknown error.");
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.tertiary,
          ),
          child: Column(
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // logo
                    Padding(
                      padding: const EdgeInsets.only(top: 28.0),
                      child: SvgPicture.asset(
                        'assets/icons/Logo.svg',
                        width: 272,
                        height: 272,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 44.0, right: 44.0),
                      child: Text(
                        "Seu lugar para comprar \n ingressos!",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.inversePrimary,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  children: [
                    // Sign in button
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 28.0,
                        right: 28.0,
                        bottom: 16.0,
                      ),
                      child: GradientButton(
                        width: double.infinity,
                        onPressed: () {
                          Navigator.pushReplacementNamed(context, '/signin');
                        },
                        borderRadius: BorderRadius.circular(100),
                        child: Text(
                          'Entre',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.inversePrimary,
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.only(
                        left: 28.0,
                        right: 28.0,
                        bottom: 16.0,
                      ),
                      child: DefaultButton(
                        width: double.infinity,
                        onPressed: () {
                          Navigator.pushReplacementNamed(context, '/signup');
                        },
                        borderRadius: BorderRadius.circular(100),
                        child: Text(
                          'Cadastre-se',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const Spacer(),
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 28.0,
                        right: 28.0,
                        bottom: 44.0,
                      ),
                      child: GestureDetector(
                        onTap: () => signAsAnonymous(),
                        child: Text(
                          'Continuar sem uma conta',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.inversePrimary,
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.w500,
                            decoration: TextDecoration.underline,
                            decorationColor:
                                Theme.of(context).colorScheme.inversePrimary,
                            fontSize: 16.0,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
