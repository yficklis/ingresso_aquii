import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ingresso_aquii/auth/update/forgot_password_page.dart';
import 'package:ingresso_aquii/util/custom_app_bar.dart';
import 'package:ingresso_aquii/util/default_textfield.dart';
import 'package:ingresso_aquii/util/gradient_button.dart';

class DeleteAccountPage extends StatefulWidget {
  const DeleteAccountPage({super.key});

  @override
  State<DeleteAccountPage> createState() => _DeleteAccountPageState();
}

class _DeleteAccountPageState extends State<DeleteAccountPage> {
  final _passwordController = TextEditingController();

  final auth = FirebaseAuth.instance;
  final currentUser = FirebaseAuth.instance.currentUser!;

  void deleteAccountByPasswordMethod() async {
    if (_passwordController.text.isEmpty) {
      showErrorMessage('Preencha a senha atual.');
      return;
    }

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
      final credential = await EmailAuthProvider.credential(
        email: currentUser.email!,
        password: _passwordController.text.trim(),
      );

      await currentUser.reauthenticateWithCredential(credential).then(
        (value) async {
          await currentUser.delete().then(
            (_) async {
              await FirebaseFirestore.instance
                  .collection('users')
                  .doc(currentUser.uid)
                  .delete();
              Navigator.of(context).pushNamedAndRemoveUntil(
                '/signin',
                (Route<dynamic> route) => false,
              );
            },
          ).catchError(
            (error) {
              print(error);
            },
          );
        },
      );
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);
      if (e.code != '') {
        showErrorMessage(
          'A senha atual de autenticação fornecida está incorreta..',
        );
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
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: '',
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Container(
            padding: const EdgeInsets.only(top: 16.0, bottom: 16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 25.0),
                  child: SvgPicture.asset(
                    'assets/icons/new_logo.svg',
                    height: 100,
                    width: 100,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(28.0),
                  child: Text(
                    'Poxa é uma pena, e lembrando que todos os seus dados de comprar serão deletas.\n Favor insira abaixo o seu os dados necessários.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                DefaultTextfield(
                  controller: _passwordController,
                  labelText: 'Senha atual',
                  hintText: 'Digite aqui',
                  obscureText: true,
                  checkError: false,
                  messageError: '',
                ),

                //forgot password
                Padding(
                  padding:
                      const EdgeInsets.only(left: 28.0, right: 28.0, top: 16),
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
                Padding(
                  padding: const EdgeInsets.all(28.0),
                  child: GradientButton(
                    width: double.infinity,
                    onPressed: deleteAccountByPasswordMethod,
                    borderRadius: BorderRadius.circular(100),
                    child: const Text(
                      'Deletar conta',
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
    );
  }
}
