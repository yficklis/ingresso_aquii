import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:ingresso_aquii/auth/update/forgot_password_page.dart';
import 'package:ingresso_aquii/util/custom_app_bar.dart';
import 'package:ingresso_aquii/util/default_textfield.dart';
import 'package:ingresso_aquii/util/gradient_button.dart';

class UpdatePasswordPage extends StatefulWidget {
  const UpdatePasswordPage({super.key});

  @override
  State<UpdatePasswordPage> createState() => _UpdatePasswordPageState();
}

class _UpdatePasswordPageState extends State<UpdatePasswordPage> {
  final _passwordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _newPasswordControllerConfirm = TextEditingController();

  final auth = FirebaseAuth.instance;
  final currentUser = FirebaseAuth.instance.currentUser!;

  void changePasswordMethod() async {
    if (_passwordController.text.isEmpty ||
        _newPasswordController.text.isEmpty) {
      showErrorMessage('Preencha todos os campos.');
      return;
    }

    if (_newPasswordController.text.trim() !=
        _newPasswordControllerConfirm.text.trim()) {
      showErrorMessage('As senhas devem ser iguais.');
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
          currentUser.updatePassword(_newPasswordController.text.trim()).then(
            (_) {
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
            'A senha atual de autenticação fornecida está incorreta..');
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
    _newPasswordController.dispose();
    _newPasswordControllerConfirm.dispose();
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
                    'assets/icons/iconLogo.svg',
                    height: 100,
                    width: 100,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(28.0),
                  child: Text(
                    'Vamos atualizar a sua senha. Favor insira abaixo o seu os dados necessários.',
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
                  padding: const EdgeInsets.symmetric(
                      horizontal: 28.0, vertical: 16.0),
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
                DefaultTextfield(
                  controller: _newPasswordController,
                  labelText: 'Nova Senha',
                  hintText: 'Digite aqui',
                  obscureText: true,
                  checkError: false,
                  messageError: '',
                ),

                const SizedBox(height: 16),

                DefaultTextfield(
                  controller: _newPasswordControllerConfirm,
                  labelText: 'Confirme sua senha',
                  hintText: 'Digite aqui',
                  obscureText: true,
                  checkError: false,
                  messageError: '',
                ),
                Padding(
                  padding: const EdgeInsets.all(28.0),
                  child: GradientButton(
                    width: double.infinity,
                    onPressed: changePasswordMethod,
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
    );
  }
}
