import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:ingresso_aquii/pages/onboarding_page.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: 320,
      backgroundColor: Color(0xffEADDFF),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              // drawer header
              DrawerHeader(
                child: SvgPicture.asset(
                  'assets/icons/iconLogo.svg',
                  height: 100,
                  width: 100,
                ),
              ),

              const SizedBox(height: 28),

              // home tile

              ExpansionTile(
                title: Text("C O N F I G U R A Ç Õ E S"),
                leading: Icon(
                  Icons.settings,
                  color: Colors.grey[800],
                ),
                childrenPadding: EdgeInsets.only(left: 10),
                children: [
                  ListTile(
                    leading: Icon(
                      Icons.person,
                      color: Colors.grey[800],
                    ),
                    title: Text(
                      'Alterar dados de cadastro',
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        color: Colors.grey[800],
                        fontWeight: FontWeight.w600,
                        decorationColor: Colors.grey[800],
                        fontSize: 16.0,
                      ),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, '/updateprofile');
                    },
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.lock,
                      color: Colors.grey[800],
                    ),
                    title: Text(
                      'Alterar senha de acesso',
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        color: Colors.grey[800],
                        fontWeight: FontWeight.w600,
                        decorationColor: Colors.grey[800],
                        fontSize: 16.0,
                      ),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, '/updatepassword');
                    },
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.person_off,
                      color: Colors.grey[800],
                    ),
                    title: Text(
                      'Excluir conta',
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        color: Colors.grey[800],
                        fontWeight: FontWeight.w600,
                        decorationColor: Colors.grey[800],
                        fontSize: 16.0,
                      ),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, '/updatepassword');
                    },
                  ),
                ],
              ),
            ],
          ),
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 0),
                child: ListTile(
                  leading: Icon(
                    Icons.help,
                    color: Colors.grey[800],
                  ),
                  title: Text(
                    'S U P O R T E',
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      color: Colors.grey[800],
                      fontWeight: FontWeight.w600,
                      decorationColor: Colors.grey[800],
                      fontSize: 16.0,
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/suportpage');
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 25),
                child: ListTile(
                  leading: Icon(
                    Icons.logout,
                    color: Colors.grey[800],
                  ),
                  title: Text(
                    'S A I R',
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      color: Colors.grey[800],
                      fontWeight: FontWeight.w600,
                      decorationColor: Colors.grey[800],
                      fontSize: 16.0,
                    ),
                  ),
                  onTap: () async => {
                    Navigator.pop(context),
                    await GoogleSignIn().signOut(),
                    FirebaseAuth.instance.signOut(),
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                          builder: (context) => const OnboardingPage(),
                        ),
                        (route) => false)
                  },
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
