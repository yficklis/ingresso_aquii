import 'package:cloud_firestore/cloud_firestore.dart';

updateTicket() async {
  CollectionReference cinemaRef =
      FirebaseFirestore.instance.collection('cinemas');
  QuerySnapshot cinemasSnapshot = await cinemaRef
      .where('unidade', isEqualTo: 'Praia Grande')
      .where('tipo', isEqualTo: 'regional')
      .where('status', isEqualTo: true)
      .get();
  if (cinemasSnapshot.docs.isNotEmpty) {
    // Obtém o ID do documento retornado pela consulta
    String cinemaId = cinemasSnapshot.docs.first.id;

    // Referência para a subcoleção "lotes" dentro do documento
    CollectionReference lotesRef = cinemaRef.doc(cinemaId).collection('lotes');

    // Obtém o documento com o ID "32023" dentro da subcoleção "lotes"
    CollectionReference ingressosRef =
        lotesRef.doc('32024').collection('combos');

    Map<String, Map<String, dynamic>> ingressosData = {
      "00VJ5YJV3": {"status": true, "vendido": false, "reembolso": false},
      "00WAAEFTY": {"status": true, "vendido": false, "reembolso": false},
      "00XTBFDSZ": {"status": true, "vendido": false, "reembolso": false},
      "00Y1M3FD1": {"status": true, "vendido": false, "reembolso": false},
      "00Y7GAP8J": {"status": true, "vendido": false, "reembolso": false},
      "00YCY5HJG": {"status": true, "vendido": false, "reembolso": false},
      "00YYQQ9FA": {"status": true, "vendido": false, "reembolso": false},
      "011DGJLWP": {"status": true, "vendido": false, "reembolso": false},
      "011P55C6B": {"status": true, "vendido": false, "reembolso": false},
      "011Q9Z70Z": {"status": true, "vendido": false, "reembolso": false},
      "012TF7PJP": {"status": true, "vendido": false, "reembolso": false},
      "014RUG886": {"status": true, "vendido": false, "reembolso": false},
      "015586G98": {"status": true, "vendido": false, "reembolso": false},
      "0158VLZRK": {"status": true, "vendido": false, "reembolso": false}
    };

    await Future.forEach(ingressosData.entries, (entry) async {
      await ingressosRef.doc(entry.key).set(entry.value);
    });
  }
}
