import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xffFEFAFF),
        body: SafeArea(
          child: Center(
            child: Column(
              children: [
                const SizedBox(height: 50),
                //Logo
                SvgPicture.asset(
                  'assets/icons/iconLogo.svg',
                  height: 100,
                  width: 100,
                ),

                const SizedBox(height: 50),

                // Welcome back, you've been missed!
                const Text("Welcome back you've been missed!",
                    style: TextStyle(color: Color(0xff260145), fontSize: 16)),

                const SizedBox(height: 50),

                //password textField

                //forgot password

                // sign in button

                // or continue with

                // google + facebook sign in buttons

                // not a member? register now
              ],
            ),
          ),
        ));
  }
}
