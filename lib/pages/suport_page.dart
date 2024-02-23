import 'package:flutter/material.dart';
import 'package:ingresso_aquii/util/custom_app_bar.dart';

class SuportPage extends StatefulWidget {
  const SuportPage({super.key});

  @override
  State<SuportPage> createState() => _SuportPageState();
}

class _SuportPageState extends State<SuportPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Suporte Page',
      ),
    );
  }
}
