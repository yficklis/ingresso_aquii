import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MyTickets extends StatefulWidget {
  const MyTickets({super.key});

  @override
  State<MyTickets> createState() => _MyTicketsState();
}

class _MyTicketsState extends State<MyTickets> {
  final user = FirebaseAuth.instance.currentUser!;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Minhas compras',
          style: TextStyle(
            color: Color(0xff6003A2),
            fontSize: 20,
            fontFamily: 'Roboto',
            fontWeight: FontWeight.w600,
          ),
        ),
        iconTheme: IconThemeData(color: Color(0xff6003A2)),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection('my_tickets')
            .orderBy('tipo') // Ordena por tipo de ticket
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/empty_cart.png',
                    height: 140,
                  ),
                  Text(
                    "Nenhum pedido encontrado",
                    style: GoogleFonts.inter(fontSize: 18),
                  ),
                ],
              ),
            );
          }
          return ListView(
            children: _buildTicketList(snapshot.data!.docs),
          );
        },
      ),
    );
  }

  List<Widget> _buildTicketList(List<DocumentSnapshot> tickets) {
    List<Widget> ticketWidgets = [];
    String currentType = '';

    for (DocumentSnapshot ticket in tickets) {
      if (ticket['tipo'] != currentType) {
        // Adiciona um título para o novo tipo de ticket
        ticketWidgets.add(
          ListTile(
            title: Text(
              ticket['tipo'],
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18.0,
              ),
            ),
          ),
        );
        currentType = ticket['tipo'];
      }

      // Adiciona um ListTile para cada ticket
      ticketWidgets.add(
        ListTile(
          leading: Image.asset('assets/images/checked.png'),
          title: Text('ID do Lote: ${ticket['loteId']}'),
          subtitle: Text('ID do Ingresso: ${ticket['ingressoId']}'),
          // Adicione mais informações do ticket conforme necessário
        ),
      );
    }
    return ticketWidgets;
  }
}
