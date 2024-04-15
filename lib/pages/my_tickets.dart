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
        backgroundColor: Theme.of(context).colorScheme.primary,
        leading: Padding(
          padding: EdgeInsets.only(right: 16),
          child: IconButton(
            onPressed: () async => Navigator.pushNamed(context, '/homepage'),
            icon: const Icon(
              Icons.home,
              size: 36,
            ),
          ),
        ),
        title: Text(
          'Minhas compras',
          style: TextStyle(
            color: Theme.of(context).colorScheme.inversePrimary,
            fontSize: 20,
            fontFamily: 'Roboto',
            fontWeight: FontWeight.w600,
          ),
        ),
        iconTheme: IconThemeData(
          color: Theme.of(context).colorScheme.inversePrimary,
        ),
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
                    style: GoogleFonts.dmSerifDisplay(
                      fontSize: 28,
                      color: Theme.of(context).colorScheme.inversePrimary,
                    ),
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
                fontFamily: 'Roboto',
                fontSize: 20,
                color: Theme.of(context).colorScheme.onBackground,
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
          title: Text(
            'ID do Lote: ${ticket['loteId']}',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontFamily: 'Roboto',
              fontSize: 16,
              color: Theme.of(context).colorScheme.onBackground,
            ),
          ),
          subtitle: Text(
            'ID do Ingresso: ${ticket['ingressoId']}',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontFamily: 'Roboto',
              fontSize: 16,
              color: Theme.of(context).colorScheme.onBackground,
            ),
          ),
          // Adicione mais informações do ticket conforme necessário
        ),
      );
    }
    return ticketWidgets;
  }
}
