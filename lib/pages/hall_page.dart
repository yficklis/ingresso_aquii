import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ingresso_aquii/components/product_tile.dart';
import 'package:ingresso_aquii/models/shop.dart';
import 'package:ingresso_aquii/pages/product_detail.dart';

import 'package:ingresso_aquii/util/gradient_button.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class HallPage extends StatefulWidget {
  const HallPage({super.key});

  @override
  State<HallPage> createState() => _HallPageState();
}

class _HallPageState extends State<HallPage> {
  final user = FirebaseAuth.instance.currentUser!;
  final String messageError = 'Por favor preencha novamente!';

  final _searchController = TextEditingController();

  final listImages = [
    'assets/images/cartas/abigail.jpeg',
    'assets/images/cartas/a-primeira-profecia.jpeg',
    'assets/images/cartas/ghostbusters-apocalipse-de-gelo.jpeg',
    'assets/images/cartas/guerra-civil.jpeg',
    'assets/images/cartas/jorge-da-capadocia.jpeg',
    'assets/images/cartas/kung-fu-panda-4.jpeg',
  ];

  int activeIndex = 0;
  final controller = CarouselController();

  void navigateToFoodDetails(int index) {
    // get the product and it's menu
    final shop = context.read<Shop>();
    final productMenu = shop.productMenu;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductDetail(
          product: productMenu[index],
        ),
      ),
    );
  }

  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // get the product and it's menu
    final shop = context.read<Shop>();
    final productMenu = shop.productMenu;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // How to use movie ticket
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 25.0,
                  vertical: 25.0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Color(0xffEADDFF),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding:
                          EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                      child: Column(
                        children: [
                          // message
                          Text(
                            'Primeira vez? Sem problemas!',
                            style: GoogleFonts.roboto(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xff363435),
                            ),
                          ),
                          const SizedBox(height: 20),
                          // redeem button
                          GradientButton(
                            onPressed: () {
                              Navigator.pushNamed(context, '/howtousepage');
                            },
                            borderRadius: BorderRadius.circular(100),
                            child: Text(
                              'Saiba como utilizar seu ingresso',
                              style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'Roboto',
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              // search bar
              // SizedBox(height: 28),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    TextField(
                      controller: _searchController,
                      obscureText: false,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onBackground,
                      ),
                      decoration: InputDecoration(
                        constraints: BoxConstraints(maxWidth: 334),
                        prefixIcon: Icon(
                          Icons.search,
                          color: Theme.of(context).colorScheme.onBackground,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).colorScheme.onBackground,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).colorScheme.onBackground,
                          ),
                        ),
                        fillColor: Theme.of(context).colorScheme.onBackground,
                        filled: false,
                        hintText: 'Digite aqui',
                        hintStyle: TextStyle(
                          color: Theme.of(context).colorScheme.onBackground,
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.w400,
                        ),
                        labelText: "Produto",
                        labelStyle: TextStyle(
                          color: Theme.of(context).colorScheme.onBackground,
                        ),
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                      ),
                    ),
                  ],
                ),
              ),
              // options list
              SizedBox(height: 28),
              // products selection
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 25.0),
                child: Text(
                  'Em cartas',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Roboto',
                    fontSize: 18,
                    color: Theme.of(context).colorScheme.onBackground,
                  ),
                ),
              ),

              SizedBox(height: 16),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 12.0),
                decoration: BoxDecoration(
                  color: Colors.black,
                ),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CarouselSlider.builder(
                          itemCount: listImages.length,
                          itemBuilder: (context, index, realIndex) {
                            final urlImage = listImages[index];
                            return buildImage(urlImage, index);
                          },
                          options: CarouselOptions(
                            height: 400,
                            autoPlay: true,
                            enableInfiniteScroll: false,
                            autoPlayAnimationDuration: Duration(seconds: 2),
                            enlargeCenterPage: true,
                            onPageChanged: (index, reason) =>
                                setState(() => activeIndex = index),
                          ),
                        ),
                        SizedBox(height: 12),
                        buildIndicator(),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 25.0),
                child: Text(
                  'Produtos',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Roboto',
                    fontSize: 18,
                    color: Theme.of(context).colorScheme.onBackground,
                  ),
                ),
              ),

              SizedBox(height: 16),
              Container(
                height: 250,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: productMenu.length,
                  itemBuilder: (context, index) => ProductTile(
                    product: productMenu[index],
                    onTap: () => navigateToFoodDetails(index),
                  ),
                ),
              ),
              SizedBox(height: 25),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildIndicator() => AnimatedSmoothIndicator(
        onDotClicked: animateToSlide,
        effect: ExpandingDotsEffect(
            dotWidth: 15, activeDotColor: Colors.blue.shade200),
        activeIndex: activeIndex,
        count: listImages.length,
      );

  void animateToSlide(int index) => controller.animateToPage(index);
}

Widget buildImage(String urlImage, int index) =>
    Container(child: Image.asset(urlImage, fit: BoxFit.cover));
