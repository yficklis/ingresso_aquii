import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MaintenancePage extends StatelessWidget {
  const MaintenancePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Finalizar Pagamento',
            style: TextStyle(
              color: Color(0xff6003A2),
              fontSize: 20,
              fontFamily: 'Roboto',
              fontWeight: FontWeight.w600,
            ),
          ),
          iconTheme: IconThemeData(color: Color(0xff6003A2)),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/maintenance.png',
                height: 140,
              ),
              Text(
                "Atenção!!!",
                style: GoogleFonts.inter(fontSize: 24),
              ),
              Text(
                "Não utilize estamos em manutenção",
                style: GoogleFonts.inter(fontSize: 18),
              ),
            ],
          ),
        ));
  }
}
