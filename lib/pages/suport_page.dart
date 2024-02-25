import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ingresso_aquii/util/custom_app_bar.dart';
import 'package:ingresso_aquii/util/default_textfield.dart';
import 'package:ingresso_aquii/util/gradient_button.dart';
import 'package:url_launcher/url_launcher.dart';

class SuportPage extends StatefulWidget {
  const SuportPage({super.key});

  @override
  State<SuportPage> createState() => _SuportPageState();
}

class _SuportPageState extends State<SuportPage> {
  final Uri phoneNumber = Uri.parse('tel:+55 13 99694-5005');
  final Uri whatsapp = Uri.parse('https://wa.me/5513997248398');

  final String messageError = 'Por favor preencha novamente!';

  final _emailController = TextEditingController();
  final _assuntoController = TextEditingController();
  final _mensagemController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _assuntoController.dispose();
    _mensagemController.dispose();
    super.dispose();
  }

  void sendReport() async {
    Map controllerList = {
      '_emailController': _emailController,
      '_assuntoController': _assuntoController,
      '_mensagemController': _mensagemController,
    };
    int count = 0;
    for (final value in controllerList.values) {
      if (value.text.isEmpty) {
        count++;
      }
    }

    if (count > 0) {
      openAnimetedDialog('Preencha todos os campos!', '');
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
      await FirebaseFirestore.instance.collection('feedback').doc().set({
        'email': _emailController.text.trim(),
        'assunto': _assuntoController.text.trim(),
        'mensagem': _mensagemController.text.trim(),
        'timestamp': FieldValue.serverTimestamp(),
      });
      Navigator.pop(context);
      openAnimetedDialog('Mensagem enviada com sucesso!', '');
    } on FirebaseException catch (e) {
      print("Failed with error '${e.code}': ${e.message}");
      Navigator.pop(context);
      openAnimetedDialog('algo deu errado, tente novamente mais tarde!', '');
    } catch (e) {
      Navigator.pop(context);
      openAnimetedDialog('algo deu errado, tente novamente mais tarde!', '');
      print("Failed with error catch '${e}'");
    }
  }

  void openAnimetedDialog(String title, String content) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: '',
      transitionDuration: const Duration(microseconds: 400),
      pageBuilder: (context, animation1, animation2) {
        return Container();
      },
      transitionBuilder: (context, a1, a2, widget) {
        return ScaleTransition(
          scale: Tween<double>(begin: 0.5, end: 1.0).animate(a1),
          child: FadeTransition(
            opacity: Tween<double>(begin: 0.5, end: 1.0).animate(a1),
            child: AlertDialog(
              title: Text(
                title,
                style: const TextStyle(
                  color: Color(0xff6003A2),
                  fontSize: 16,
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w500,
                ),
              ),
              content: Text(
                content,
                style: const TextStyle(
                  color: Color(0xff6003A2),
                  fontSize: 24,
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w600,
                ),
              ),
              shape: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16.0),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        );
      },
    );
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
                  padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        'Entre em contato',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontSize: 16,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Container(
                    margin: EdgeInsets.only(left: 8.0, right: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Card(
                          color: Theme.of(context).scaffoldBackgroundColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          margin: const EdgeInsets.all(8),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(16),
                            onTap: (() async {
                              await launchUrl(phoneNumber);
                            }),
                            child: Padding(
                              padding: const EdgeInsets.all(22),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.phone,
                                    color: Color(0xff6003A2),
                                    size: 64,
                                  ),
                                  Text(
                                    'Telefone',
                                    style: const TextStyle(
                                      color: Color(0xff6003A2),
                                      fontSize: 16,
                                      fontFamily: 'Roboto',
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        // SizedBox(width: 8),
                        Card(
                          color: Theme.of(context).scaffoldBackgroundColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          margin: const EdgeInsets.all(8),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(16),
                            onTap: () {
                              openAnimetedDialog('E-mail de contato',
                                  "ingressoaquii2@gmail.com");
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(22),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.email,
                                    color: Color(0xff6003A2),
                                    size: 64,
                                  ),
                                  Text(
                                    'E-mail',
                                    style: const TextStyle(
                                      color: Color(0xff6003A2),
                                      fontSize: 16,
                                      fontFamily: 'Roboto',
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        // SizedBox(width: 8),
                        Card(
                          color: Theme.of(context).scaffoldBackgroundColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          margin: const EdgeInsets.all(8),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(16),
                            onTap: (() async {
                              launchUrl(whatsapp);
                            }),
                            child: Padding(
                              padding: const EdgeInsets.all(22),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  SvgPicture.asset(
                                    'assets/icons/WhatsApp.svg',
                                    height: 64,
                                    width: 64,
                                    color: Color(0xff6003A2),
                                  ),
                                  Text(
                                    'Whatsapp',
                                    style: const TextStyle(
                                      color: Color(0xff6003A2),
                                      fontSize: 16,
                                      fontFamily: 'Roboto',
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        'Ou envie uma mensagem',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontSize: 16,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                DefaultTextfield(
                  controller: _emailController,
                  labelText: 'E-mail',
                  hintText: 'Digite aqui',
                  obscureText: false,
                  checkError: false,
                  messageError: messageError,
                ),
                const SizedBox(height: 10),
                DefaultTextfield(
                  controller: _assuntoController,
                  labelText: 'Assunto',
                  hintText: 'Digite aqui',
                  obscureText: false,
                  checkError: false,
                  messageError: messageError,
                ),
                const SizedBox(height: 10),
                DefaultTextfield(
                  controller: _mensagemController,
                  labelText: 'Assunto',
                  hintText: 'Digite aqui',
                  obscureText: false,
                  checkError: false,
                  messageError: messageError,
                  contentPadding: EdgeInsets.all(50),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(28.0, 28.0, 28.0, 0.0),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Política de privacidade',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.w500,
                            decoration: TextDecoration.underline,
                            fontSize: 16.0,
                          ),
                        ),
                        SizedBox(width: 100),
                        Row(
                          children: [
                            SvgPicture.asset(
                              'assets/icons/Instagram.svg',
                              height: 24,
                              width: 24,
                              color: Color(0xff260145),
                            ),
                            SizedBox(width: 10),
                            SvgPicture.asset(
                              'assets/icons/WhatsApp.svg',
                              height: 24,
                              width: 24,
                              color: Color(0xff260145),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(28.0),
                  child: GradientButton(
                    width: double.infinity,
                    onPressed: sendReport,
                    borderRadius: BorderRadius.circular(100),
                    child: const Text(
                      'Enviar Mensagem',
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
