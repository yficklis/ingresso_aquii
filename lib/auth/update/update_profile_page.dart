import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ingresso_aquii/util/custom_app_bar.dart';
import 'package:ingresso_aquii/util/default_textfield.dart';
import 'package:ingresso_aquii/util/gradient_button.dart';
import 'package:ingresso_aquii/util/textfield_with_mask.dart';

class UpdateProfilePage extends StatefulWidget {
  const UpdateProfilePage({super.key});

  @override
  State<UpdateProfilePage> createState() => _UpdateProfilePageState();
}

class _UpdateProfilePageState extends State<UpdateProfilePage> {
  // text create controllers
  final _nameController = TextEditingController();
  final _documentIdController = TextEditingController();
  final _birthController = TextEditingController();

  // message error text field
  final String messageError = 'Por favor preencha novamente!';

  final auth = FirebaseFirestore.instance;
  final currentUser = FirebaseAuth.instance.currentUser!;

  void getUserDetails() async {
    DocumentSnapshot documentSnapshot =
        await auth.collection('users').doc(currentUser.uid).get();
    if (documentSnapshot.exists) {
      dynamic data = documentSnapshot.data()!;
      if (data.containsKey("first_name")) {
        _nameController.text = data['first_name'] ?? '';
      }
      if (data.containsKey("birth")) {
        _birthController.text = data['birth'] ?? '';
      }
      if (data.containsKey("cpf")) {
        _documentIdController.text = data['cpf'] ?? '';
      }
    } else {
      print('Document does not exist');
    }
  }

  void showErrorMessage(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Center(
            child: Text(
              message,
              style: const TextStyle(
                color: Color(0xff260145),
                fontSize: 16,
                fontFamily: 'Roboto',
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        );
      },
    );
  }

  void updateProfileMethod() async {
    Map controllerList = {
      '_nameController': _nameController,
      '_documentIdController': _documentIdController,
      '_birthController': _birthController,
    };
    int count = 0;
    for (final value in controllerList.values) {
      if (value.text.isEmpty) {
        count++;
      }
    }

    if (count > 0) {
      showErrorMessage('Preencha todos os campos!');
      return;
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser.uid)
          .set({
        'first_name': _nameController.text.trim(),
        'cpf': _documentIdController.text.trim(),
        'birth': _birthController.text.trim(),
      });
      Navigator.pop(context);
      showErrorMessage(
        'Dados Atualizados com sucesso!',
      );
    } on FirebaseException catch (e) {
      print("Failed with error '${e.code}': ${e.message}");
      Navigator.pop(context);
      showErrorMessage(
        'algo deu errado, tente novamente mais tarde!',
      );
    } catch (e) {
      Navigator.pop(context);
      showErrorMessage(
        'algo deu errado, tente novamente mais tarde!',
      );
      print("Failed with error catch '${e}'");
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _documentIdController.dispose();
    _birthController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    getUserDetails();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar(
          title: '',
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Container(
              padding: const EdgeInsets.only(top: 16.0, bottom: 16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 25),
                  //Logo
                  SvgPicture.asset(
                    'assets/icons/iconLogo.svg',
                    height: 100,
                    width: 100,
                  ),

                  const SizedBox(height: 25),

                  // Default message
                  const Text(
                    "Bem-vindo, vamos começar!",
                    style: TextStyle(
                      color: Color(0xff260145),
                      fontSize: 16,
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w500,
                    ),
                  ),

                  const SizedBox(height: 50),

                  // username textField
                  DefaultTextfield(
                    controller: _nameController,
                    labelText: 'Nome',
                    hintText: 'Digite aqui',
                    obscureText: false,
                    checkError: false,
                    messageError: messageError,
                  ),

                  const SizedBox(height: 10),

                  TextfieldWithMask(
                    controller: _documentIdController,
                    labelText: 'CPF',
                    hintText: 'Digite aqui',
                    obscureText: false,
                    maskInput: "###.###.###-##",
                    checkError: false,
                    messageError: messageError,
                  ),

                  const SizedBox(height: 10),
                  // password textField
                  TextfieldWithMask(
                    controller: _birthController,
                    labelText: 'Data de nascimento',
                    hintText: 'Digite aqui',
                    obscureText: false,
                    maskInput: "##/##/####",
                    checkError: false,
                    messageError: messageError,
                  ),

                  const SizedBox(height: 10),

                  // sign in button
                  Padding(
                    padding: const EdgeInsets.all(28.0),
                    child: GradientButton(
                      width: double.infinity,
                      onPressed: updateProfileMethod,
                      borderRadius: BorderRadius.circular(100),
                      child: const Text(
                        'Atualizar dados',
                        style: TextStyle(
                          color: Color(0xffFEFEFE),
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
