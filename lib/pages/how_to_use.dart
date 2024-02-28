import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ingresso_aquii/util/custom_app_bar.dart';

class HowToUsePage extends StatelessWidget {
  const HowToUsePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: ''),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28.0),
              child: ListView(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 254, 248, 255),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    margin: EdgeInsets.symmetric(horizontal: 25),
                    padding: EdgeInsets.symmetric(vertical: 25, horizontal: 30),
                    child: Column(
                      children: [
                        Text(
                          "Como utilizar seu ingresso",
                          style: GoogleFonts.roboto(fontSize: 32),
                        ),
                        const SizedBox(height: 10),
                        Image.asset(
                          'assets/images/cinema.png',
                          height: 200,
                        ),
                        const SizedBox(height: 25),
                        RichText(
                          textAlign: TextAlign.justify,
                          text: TextSpan(
                            style: TextStyle(
                              fontSize: 16.0,
                              color: Colors.black,
                            ),
                            children: <TextSpan>[
                              TextSpan(
                                text:
                                    'Para resgatar seu ingresso de cinema comprado online, siga estes passos simples:\n\n',
                              ),
                              TextSpan(
                                text: '1. Confirmação de Compra:\n',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              TextSpan(
                                text:
                                    'Verifique seu e-mail ou a plataforma onde fez a compra para encontrar a confirmação da transação.\n\n',
                              ),
                              TextSpan(
                                text: '2. Código ou QR Code:\n',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              TextSpan(
                                text:
                                    'Dentro da confirmação, você encontrará um código único ou um QR code. Este é seu ingresso digital.\n\n',
                              ),
                              TextSpan(
                                text: '3. Acesso ao Cinema:\n',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              TextSpan(
                                text:
                                    'No dia do filme, dirija-se ao cinema selecionado.\n\n',
                              ),
                              TextSpan(
                                text: '4. Apresente o Ingresso:\n',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              TextSpan(
                                text:
                                    'Na bilheteria ou diretamente na entrada, mostre o código ou QR code ao atendente. Eles escanearão ou verificarão o código para permitir sua entrada.\n\n',
                              ),
                              TextSpan(
                                text: '5. Aproveite o Filme:\n',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              TextSpan(
                                text:
                                    'Com seu ingresso resgatado, entre na sala e desfrute do filme!\n\n',
                              ),
                              TextSpan(
                                text:
                                    'É isso! Com esses passos simples, você estará pronto para aproveitar sua sessão de cinema.',
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
