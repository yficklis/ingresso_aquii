import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ingresso_aquii/util/default_button.dart';
import 'package:ingresso_aquii/util/gradient_button.dart';

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              // const SizedBox(height: 108),

              Expanded(
                child: Column(
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
                    const Padding(
                      padding: EdgeInsets.only(left: 44.0, right: 44.0),
                      child: Text(
                        "Seu lugar para comprar \n ingressos!",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(0xffFEFEFE),
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
                      onPressed: () {},
                      borderRadius: BorderRadius.circular(100),
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xff6003A2),
                          Color(0xff260145),
                        ],
                      ),
                      child: const Text(
                        'Entre',
                        style: TextStyle(
                          color: Color(0xffFEFEFE),
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),

                  // Sign up button

                  Padding(
                    padding: const EdgeInsets.only(
                      left: 28.0,
                      right: 28.0,
                      bottom: 38.0,
                    ),
                    child: DefaultButton(
                      width: double.infinity,
                      onPressed: () {},
                      borderRadius: BorderRadius.circular(100),
                      child: const Text(
                        'Cadastre-se',
                        style: TextStyle(
                          color: Color(0xff6003A2),
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),

                  // withou login
                  GestureDetector(
                    onTap: () {
                      print('clicou aqui');
                    },
                    child: const Text(
                      'Continuar sem uma conta',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w500,
                        decoration: TextDecoration.underline,
                        decorationColor: Colors.white,
                        fontSize: 16.0,
                      ),
                    ),
                  )
                ],
              ))
              // default text

              // const SizedBox(height: 175),
            ],
          ),
        ),
      ),
    );
  }
}
