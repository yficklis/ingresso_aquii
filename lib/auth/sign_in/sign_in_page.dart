import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ingresso_aquii/pages/forgot_password_page.dart';
import 'package:ingresso_aquii/util/default_textfield.dart';
import 'package:ingresso_aquii/util/gradient_button.dart';
import 'package:ingresso_aquii/util/square_tile.dart';
import 'package:google_sign_in/google_sign_in.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  // text editing controllers
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  // sign user in method
  Future signUserIn() async {
    // show loading circle
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        });

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      Navigator.of(context).pushNamedAndRemoveUntil(
        '/homepage',
        (Route<dynamic> route) => false,
      );
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);
      if (e.code != '') {
        showErrorMessage('E-mail ou senha Incorretos');
      }
    }
  }

  signInWithGoogle() async {
    try {
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

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      );
      // Once signed in, return the UserCredential
      await FirebaseAuth.instance.signInWithCredential(credential);

      Navigator.of(context).pushNamedAndRemoveUntil(
        '/homepage',
        (Route<dynamic> route) => false,
      );
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);
      if (e.code != '') {
        showErrorMessage('Algo deu errado:');
      }
    } catch (e) {
      Navigator.pop(context);
      print(e);
    }
  }

  void showErrorMessage(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Center(
            child: Text(
              message,
              style: const TextStyle(
                color: Color(0xff260145),
                fontSize: 16,
                fontFamily: 'Roboto',
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Container(
            padding: const EdgeInsets.only(top: 16.0, bottom: 16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 25),
                //Logo
                SvgPicture.asset(
                  'assets/icons/iconLogo.svg',
                  height: 100,
                  width: 100,
                ),

                const SizedBox(height: 25),

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
                  controller: _emailController,
                  labelText: 'E-mail',
                  hintText: 'Digite aqui',
                  obscureText: false,
                  checkError: false,
                  messageError: '',
                ),

                const SizedBox(height: 10),
                // password textField
                DefaultTextfield(
                  controller: _passwordController,
                  labelText: 'Senha',
                  hintText: 'Digite aqui',
                  obscureText: true,
                  checkError: false,
                  messageError: '',
                ),

                const SizedBox(height: 10),

                //forgot password
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 28.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return ForgotPasswordPage();
                              },
                            ),
                          );
                        },
                        child: Text(
                          "Esqueceu sua senha?",
                          style: TextStyle(
                            fontFamily: 'Roboto',
                            color: Color(0xff260145),
                            fontWeight: FontWeight.w600,
                            decoration: TextDecoration.underline,
                            decorationColor: Color(0xff260145),
                            fontSize: 16.0,
                          ),
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // google button
                    GestureDetector(
                      onTap: () {
                        signInWithGoogle();
                      },
                      child: const SquareTile(
                          imagePath: 'assets/icons/google-colorful.svg'),
                    ),
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
                            fontFamily: 'Roboto',
                            color: Color(0xff260145),
                            fontWeight: FontWeight.w600,
                            decoration: TextDecoration.underline,
                            decorationColor: Color(0xff260145),
                            fontSize: 16.0,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
