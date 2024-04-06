import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ingresso_aquii/auth/sign_up/sign_up_confirm_page.dart';
import 'package:ingresso_aquii/util/default_textfield.dart';
import 'package:ingresso_aquii/util/gradient_button.dart';
import 'package:ingresso_aquii/util/square_tile.dart';
import 'package:ingresso_aquii/util/textfield_with_mask.dart';
import 'package:google_sign_in/google_sign_in.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  // text create controllers
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _documentIdController = TextEditingController();
  final _birthController = TextEditingController();

  // message error text field
  final String messageError = 'Por favor preencha novamente!';

  void showErrorMessage(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Center(
            child: Text(
              message,
              style: TextStyle(
                color: Theme.of(context).colorScheme.inversePrimary,
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

  // validating text input
  void signUpNextStep() {
    Map controllerList = {
      '_nameController': _nameController,
      '_emailController': _emailController,
      '_documentIdController': _documentIdController,
      '_birthController': _birthController,
    };
    int count = 0;
    for (final value in controllerList.values) {
      if (value.text.isEmpty) {
        count++;
      }
    }

    if (count > 0) {
      showErrorMessage('Preencha todos os campos!');
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SignUpConfirmPage(data: controllerList),
      ),
    );
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

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _documentIdController.dispose();
    _birthController.dispose();
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
                  'assets/icons/new_logo.svg',
                  height: 100,
                  width: 100,
                ),

                const SizedBox(height: 25),

                // Default message
                Text(
                  "Bem-vindo, vamos começar!",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.inversePrimary,
                    fontSize: 16,
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w500,
                  ),
                ),

                const SizedBox(height: 50),

                // username textField
                DefaultTextfield(
                  controller: _nameController,
                  labelText: 'Nome',
                  hintText: 'Digite aqui',
                  obscureText: false,
                  checkError: false,
                  messageError: messageError,
                ),

                const SizedBox(height: 10),
                // password textField
                DefaultTextfield(
                  controller: _emailController,
                  labelText: 'E-mail',
                  hintText: 'Digite aqui',
                  obscureText: false,
                  checkError: false,
                  messageError: messageError,
                ),

                const SizedBox(height: 10),

                TextfieldWithMask(
                  controller: _documentIdController,
                  labelText: 'CPF',
                  hintText: 'Digite aqui',
                  obscureText: false,
                  maskInput: "###.###.###-##",
                  checkError: false,
                  messageError: messageError,
                ),

                const SizedBox(height: 10),
                // password textField
                TextfieldWithMask(
                  controller: _birthController,
                  labelText: 'Data de nascimento',
                  hintText: 'Digite aqui',
                  obscureText: false,
                  maskInput: "##/##/####",
                  checkError: false,
                  messageError: messageError,
                ),

                const SizedBox(height: 10),

                // sign in button
                Padding(
                  padding: const EdgeInsets.all(28.0),
                  child: GradientButton(
                    width: double.infinity,
                    onPressed: signUpNextStep,
                    borderRadius: BorderRadius.circular(100),
                    child: const Text(
                      'Próximo',
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
                          color: Theme.of(context).colorScheme.inversePrimary,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10.0),
                        child: Text(
                          'Ou continue com',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.inversePrimary,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Divider(
                          thickness: 0.5,
                          color: Theme.of(context).colorScheme.inversePrimary,
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
                      Text(
                        'Já possui conta?',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onBackground,
                          fontSize: 16,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      const SizedBox(width: 4),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushReplacementNamed(context, '/signin');
                        },
                        child: Text(
                          'Entre',
                          style: TextStyle(
                            fontFamily: 'Roboto',
                            color: Theme.of(context).colorScheme.onSecondary,
                            fontWeight: FontWeight.w600,
                            decoration: TextDecoration.underline,
                            decorationColor:
                                Theme.of(context).colorScheme.onSecondary,
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
    );
  }
}
