import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ingresso_aquii/util/default_textfield.dart';
import 'package:ingresso_aquii/util/gradient_button.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
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

  Future passwordReset() async {
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
      // await FirebaseAuth.instance.currentUser.updatePassword(newPassword)
      await FirebaseAuth.instance
          .sendPasswordResetEmail(
            email: _emailController.text.trim(),
          )
          .then((value) => {
                Navigator.pop(context),
                showErrorMessage('E-mail enviado com sucesso')
              });
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);
      if (e.code != '') {
        showErrorMessage(
            'O endereço de e-mail está mal formatado ou não existe.');
      }
    } catch (e) {
      Navigator.pop(context);
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.background,
        iconTheme: IconThemeData(
          color: Theme.of(context).colorScheme.inversePrimary,
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Center(
            child: Container(
              padding: const EdgeInsets.only(top: 16.0, bottom: 16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 25),
                  SvgPicture.asset(
                    'assets/icons/new_logo.svg',
                    height: 100,
                    width: 100,
                  ),
                  const SizedBox(height: 25),
                  Text(
                    'Vamos lhe enviar um e-mail com um link para redefinir sua senha. Favor insira abaixo o seu e-mail cadastrado.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.inversePrimary,
                      fontSize: 16,
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 50),
                  DefaultTextfield(
                    controller: _emailController,
                    labelText: 'E-mail',
                    hintText: 'Digite aqui',
                    obscureText: false,
                    checkError: false,
                    messageError: '',
                  ),
                  Padding(
                    padding: const EdgeInsets.all(28.0),
                    child: GradientButton(
                      width: double.infinity,
                      onPressed: passwordReset,
                      borderRadius: BorderRadius.circular(100),
                      child: const Text(
                        'Redefinir senha',
                        style: TextStyle(
                          color: Color(0xffFEFEFE),
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
