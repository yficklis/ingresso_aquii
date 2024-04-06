import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ingresso_aquii/components/product_tile.dart';
import 'package:ingresso_aquii/models/shop.dart';
import 'package:ingresso_aquii/pages/product_detail.dart';

import 'package:ingresso_aquii/util/gradient_button.dart';
import 'package:provider/provider.dart';

class HallPage extends StatefulWidget {
  const HallPage({super.key});

  @override
  State<HallPage> createState() => _HallPageState();
}

class _HallPageState extends State<HallPage> {
  final user = FirebaseAuth.instance.currentUser!;
  final String messageError = 'Por favor preencha novamente!';

  final _searchController = TextEditingController();

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
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Color(0xffEADDFF),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                    child: Column(
                      children: [
                        // message
                        Text(
                          'Primeira vez? Sem problemas!',
                          style: GoogleFonts.inter(
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
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
              // search bar
              SizedBox(height: 28),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: TextField(
                  controller: _searchController,
                  obscureText: false,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onBackground,
                  ),
                  decoration: InputDecoration(
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
              ),
              // options list
              SizedBox(height: 28),
              // products selection
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 25.0),
                child: Text(
                  'Produtos',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Inter',
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
}
