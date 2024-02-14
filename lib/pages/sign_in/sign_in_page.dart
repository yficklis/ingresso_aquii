import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ingresso_aquii/util/default_textfield.dart';
import 'package:ingresso_aquii/util/gradient_button.dart';
import 'package:ingresso_aquii/util/square_tile.dart';

class SignInPage extends StatelessWidget {
  SignInPage({super.key});

  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  void signUserIn() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Container(
              padding: const EdgeInsets.only(top: 16.0, bottom: 16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 50),
                  //Logo
                  SvgPicture.asset(
                    'assets/icons/iconLogo.svg',
                    height: 100,
                    width: 100,
                  ),

                  const SizedBox(height: 50),

                  // Default message
                  const Text(
                    "Bem-vindo de volta, sentimos sua falta!",
                    style: TextStyle(
                      color: Color(0xff260145),
                      fontSize: 16,
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w500,
                    ),
                  ),

                  const SizedBox(height: 50),

                  // username textField
                  DefaultTextfield(
                    controller: usernameController,
                    labelText: 'E-mail',
                    hintText: 'Digite aqui',
                    obscureText: false,
                  ),

                  const SizedBox(height: 10),
                  // password textField
                  DefaultTextfield(
                    controller: passwordController,
                    labelText: 'Senha',
                    hintText: 'Digite aqui',
                    obscureText: true,
                  ),

                  const SizedBox(height: 10),

                  //forgot password
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 28.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          "Esqueceu sua senha?",
                          style: TextStyle(
                            color: Colors.grey[600],
                            decoration: TextDecoration.underline,
                            decorationColor: Colors.white,
                            fontSize: 16.0,
                          ),
                        )
                      ],
                    ),
                  ),

                  // sign in button
                  Padding(
                    padding: const EdgeInsets.all(28.0),
                    child: GradientButton(
                      width: double.infinity,
                      onPressed: signUserIn,
                      borderRadius: BorderRadius.circular(100),
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
                  const SizedBox(height: 10),
                  // or continue with
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Divider(
                            thickness: 0.5,
                            color: Colors.grey[400],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: Text(
                            'Ou continue com',
                            style: TextStyle(color: Colors.grey[700]),
                          ),
                        ),
                        Expanded(
                          child: Divider(
                            thickness: 0.5,
                            color: Colors.grey[400],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 50),
                  // google + facebook sign in buttons
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // google button
                      SquareTile(imagePath: 'assets/icons/google-colorful.svg'),

                      SizedBox(width: 10),
                      // facebook button

                      SquareTile(
                          imagePath: 'assets/icons/facebook-colorful.svg'),
                    ],
                  ),

                  // not a member? register now
                  Padding(
                    padding: const EdgeInsets.only(top: 50.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Não possui conta?',
                          style: TextStyle(
                            color: Color(0xff363435),
                            fontSize: 16,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        const SizedBox(width: 4),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushReplacementNamed(context, '/signup');
                          },
                          child: const Text(
                            'Cadastre-se',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              color: Color(0xff260145),
                              fontWeight: FontWeight.w500,
                              decoration: TextDecoration.underline,
                              decorationColor: Color(0xff260145),
                              fontSize: 16.0,
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
        ),
      ),
    );
  }
}
