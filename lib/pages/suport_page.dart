import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ingresso_aquii/util/custom_app_bar.dart';
import 'package:url_launcher/url_launcher.dart';

class SuportPage extends StatefulWidget {
  const SuportPage({super.key});

  @override
  State<SuportPage> createState() => _SuportPageState();
}

class _SuportPageState extends State<SuportPage> {
  //

  final Uri phoneNumber = Uri.parse('tel:+55 13 99694-5005');
  final Uri whatsapp = Uri.parse('https://wa.me/5513997248398');
  final Uri _url = Uri.parse('https://wa.me/5513997248398');
  //
  Future<void> redirectWhatsapp() async {
    if (!await launchUrl(_url)) {
      throw Exception('Could not launch $_url');
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
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
