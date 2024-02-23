import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
                ],
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 25),
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
        ],
      ),
    );
  }
}
