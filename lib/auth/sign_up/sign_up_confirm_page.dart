import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:ingresso_aquii/util/default_textfield.dart';
import 'package:ingresso_aquii/util/gradient_button.dart';
import 'package:ingresso_aquii/util/square_tile.dart';

class SignUpConfirmPage extends StatefulWidget {
  final Map data;
  const SignUpConfirmPage({super.key, required this.data});
  @override
  State<SignUpConfirmPage> createState() => _SignUpConfirmPageState();
}

class _SignUpConfirmPageState extends State<SignUpConfirmPage> {
  // text create controllers
  final _passwordController = TextEditingController();
  final passwordConfirmController = TextEditingController();
  // message error text field
  final String messageError = 'Por favor preencha novamente!';

  // validating text input
  void signUpMethod() async {
    if (_passwordController.text.isEmpty ||
        passwordConfirmController.text.isEmpty) {
      showErrorMessage('Preencha todos os campos.');
      return;
    }

    if (_passwordController.text.trim() !=
        passwordConfirmController.text.trim()) {
      showErrorMessage('As senhas devem ser iguais.');
      return;
    }

    if (!isChecked) {
      showErrorMessage('Necessário concordar com os termos de privacidade.');
      return;
    }

    // show loading circle
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    try {
      // create user
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: widget.data['_emailController'].text.trim(),
        password: _passwordController.text.trim(),
      );

      // add user details
      addUserDetails();
      Navigator.of(context).pushNamedAndRemoveUntil(
        '/homepage',
        (Route<dynamic> route) => false,
      );
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);
      if (e.code == 'weak-password') {
        showErrorMessage('A senha fornecida é muito fraca.');
      } else if (e.code == 'email-already-in-use') {
        showErrorMessage('A conta já existe para esse e-mail.');
      } else if (e.code == 'invalid-email') {
        showErrorMessage(
          'O endereço de e-mail está mal formatado ou já existe.',
        );
      }
    } catch (e) {
      Navigator.pop(context);
    }
  }

  Future addUserDetails() async {
    try {
      await FirebaseFirestore.instance.collection('users').add({
        'first_name': widget.data['_nameController'].text.trim(),
        'cpf': widget.data['_documentIdController'].text.trim(),
        'birth': widget.data['_birthController'].text.trim(),
      });
    } on FirebaseException catch (e) {
      print("Failed with error '${e.code}': ${e.message}");
    } catch (e) {
      print("Failed with error catch '${e}'");
    }
  }

  @override
  void dispose() {
    _passwordController.dispose();
    passwordConfirmController.dispose();
    super.dispose();
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

  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
        ),
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
                    "Bem-vindo, vamos começar!",
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
                    controller: _passwordController,
                    labelText: 'Senha',
                    hintText: 'Digite aqui',
                    obscureText: true,
                    checkError: false,
                    messageError: messageError,
                  ),

                  const SizedBox(height: 10),
                  // password textField
                  DefaultTextfield(
                    controller: passwordConfirmController,
                    labelText: 'Confirme sua senha',
                    hintText: 'Digite aqui',
                    obscureText: true,
                    checkError: false,
                    messageError: messageError,
                  ),

                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 28.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Checkbox(
                          value: isChecked,
                          onChanged: (bool? value) {
                            setState(() {
                              isChecked = value!;
                            });
                          },
                        ),
                        Text(
                          "Li e concordo com a Política de Privacidade.",
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
                  const SizedBox(height: 10),

                  // sign in button
                  Padding(
                    padding: const EdgeInsets.all(28.0),
                    child: GradientButton(
                      width: double.infinity,
                      onPressed: signUpMethod,
                      borderRadius: BorderRadius.circular(100),
                      child: const Text(
                        'Cadastre-se',
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
                          'Já possui conta?',
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
                            Navigator.pushReplacementNamed(context, '/signin');
                          },
                          child: const Text(
                            'Entre',
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
                  )
                ],
              ),
            ),
          ),
        ));
  }
}
