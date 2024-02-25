import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ingresso_aquii/models/movie.dart';
import 'package:ingresso_aquii/models/movie_shop.dart';
import 'package:ingresso_aquii/read_data/get_user_name.dart';
import 'package:ingresso_aquii/util/movie_tile.dart';
import 'package:provider/provider.dart';

class HallPage extends StatefulWidget {
  const HallPage({super.key});

  @override
  State<HallPage> createState() => _HallPageState();
}

class _HallPageState extends State<HallPage> {
  final user = FirebaseAuth.instance.currentUser!;

  // add movie ticket to cart
  void addToCart(Movie movie) {
    // add to cart
    Provider.of<MovieShop>(context, listen: false).addItemToCart(movie);

    // let user know it add been successfully added
    openAnimetedDialog('Parabéns', 'Item adicionado com sucesso ao carrinho');
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

  // @override
  // void initState() {
  //   print(user);
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    return Consumer<MovieShop>(
      builder: (context, value, child) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              SvgPicture.asset(
                'assets/icons/iconLogo.svg',
                height: 100,
                width: 100,
              ),
              const Text(
                "Bem-vindo, selecione um produto abaixo!",
                style: TextStyle(
                  color: Color(0xff260145),
                  fontSize: 16,
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w500,
                ),
              ),

              const SizedBox(height: 16.0),
              Expanded(
                child: ListView.builder(
                  itemCount: value.movieShop.length,
                  itemBuilder: (context, index) {
                    // get individual movie ticket
                    Movie eachMovie = value.movieShop[index];

                    // return the tile for this movie
                    return MovieTile(
                      movie: eachMovie,
                      onPressed: () => addToCart(eachMovie),
                      icon: Icon(Icons.add),
                    );
                  },
                ),
              ),
              // Card(
              //   color: Theme.of(context).scaffoldBackgroundColor,
              //   shape: RoundedRectangleBorder(
              //     borderRadius: BorderRadius.circular(16),
              //   ),
              //   margin: const EdgeInsets.all(8),
              //   child: InkWell(
              //     borderRadius: BorderRadius.circular(16),
              //     onTap: (() async {}),
              //     child: Padding(
              //       padding: const EdgeInsets.all(16),
              //       child: Column(
              //         mainAxisSize: MainAxisSize.min,
              //         children: [
              //           Text(
              //             'Como utilizar seu ingresso',
              //             style: const TextStyle(
              //               color: Color(0xff363435),
              //               fontSize: 20,
              //               fontFamily: 'Inter',
              //               fontWeight: FontWeight.w400,
              //             ),
              //           ),
              //           SizedBox(height: 10),
              //           Image(
              //               image: AssetImage('assets/images/Imagepocorn.jpg')),
              //           SizedBox(height: 10),
              //           Card(
              //             color: Theme.of(context).scaffoldBackgroundColor,
              //             elevation: 0.2,
              //             child: ConstrainedBox(
              //               constraints: BoxConstraints(
              //                 minHeight: 100,
              //               ),
              //               child: Text(
              //                 'Acesso ao Cinema: No dia do filme, dirija-se ao cinema selecionado. Apresente o Ingresso: Na bilheteria ou diretamente na entrada, mostre o código ou QR code ao atendente. Eles escanearão ou verificarão o código para permitir sua entrada. Aproveite o Filme: Com seu ingresso resgatado, entre na sala e desfrute do filme!',
              //                 overflow: TextOverflow.clip,
              //                 textAlign: TextAlign.justify,
              //                 style: const TextStyle(
              //                   color: Color(0xff363435),
              //                   fontSize: 16,
              //                   fontFamily: 'Inter',
              //                   fontWeight: FontWeight.w400,
              //                 ),
              //               ),
              //             ),
              //           ),
              //         ],
              //       ),
              //     ),
              //   ),
              // )
            ],
          ),
        ),
      ),
    );
  }
}
