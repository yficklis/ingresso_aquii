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
                                    'Instruções para Resgate de Códigos de Ingressos ou Combos de Cinema\n\n',
                              ),
                              TextSpan(
                                text: 'Caro(a) cliente,\n\n',
                              ),
                              TextSpan(
                                text:
                                    'Agradecemos por escolher nossa plataforma para adquirir seus ingressos ou combos de cinema! Para garantir uma experiência tranquila e satisfatória no resgate de seu produto, por favor, siga atentamente as instruções abaixo:\n\n',
                              ),
                              TextSpan(
                                text: '1. Compra pelo Aplicativo:\n',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              TextSpan(
                                text:
                                    'Após realizar a compra do seu ingresso ou combo através do nosso aplicativo, o código correspondente será gerado e vinculado à sua conta. Por favor, esteja ciente de que uma vez realizada a compra, não será possível efetuar reembolso, visto que os códigos são únicos e não reutilizáveis.\n\n',
                              ),
                              TextSpan(
                                text: '2. Resgate Presencial:\n',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              TextSpan(
                                text:
                                    'O resgate do seu código de ingresso ou combo deverá ser feito presencialmente na únidade físicas. Escolha a unidade mais conveniente para você e dirija-se ao balcão de atendimento para efetuar o resgate.\n\n',
                              ),
                              TextSpan(
                                text: '3. Não-Modificação de Combos::\n',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              TextSpan(
                                text:
                                    'Caso tenha adquirido um combo específico, por favor, esteja ciente de que o resgate deverá ser feito exatamente para o combo adquirido. Não será possível realizar trocas ou modificações, como resgatar um combo diferente do adquirido. Por exemplo, se você comprou o Combo X, o código gerado será exclusivo para este combo e não poderá ser utilizado para resgatar o Combo Y.\n\n',
                              ),
                              TextSpan(
                                text: '4. Escolha do Filme:\n',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              TextSpan(
                                text:
                                    'Após o resgate do seu código no balcão de atendimento, você terá a liberdade de escolher qualquer filme em exibição para utilizar seu ingresso ou combo. Nossa equipe estará disponível para auxiliá-lo na escolha e no processo de resgate do seu produto.\n\n',
                              ),
                              TextSpan(
                                text: '5. Validade do Código:\n',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              TextSpan(
                                text:
                                    'Verifique a validade do seu código antes de realizar o resgate. Códigos expirados não serão aceitos e não poderão ser reativados.\n\n',
                              ),
                              TextSpan(
                                text: '6. Atendimento ao Cliente:\n',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              TextSpan(
                                text:
                                    'Em caso de dúvidas ou problemas durante o processo de resgate, não hesite em contatar nosso serviço de atendimento ao cliente. Estamos aqui para ajudá-lo e garantir sua satisfação.\n\n',
                              ),
                              TextSpan(
                                text:
                                    'Agradecemos sua compreensão e colaboração. Esperamos que aproveite seu momento no cinema conosco!',
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
