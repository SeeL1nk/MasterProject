import 'package:flutter/material.dart';
import 'package:master_front/button_widget.dart';
import 'package:master_front/fetch_api.dart';
import 'package:master_front/recommandation_choice.dart';

import 'my_text_field.dart';

class RegistrationPage extends StatefulWidget {

  const RegistrationPage({super.key});

  @override
  State<RegistrationPage> createState() => RegistrationPageState();
}

class RegistrationPageState extends State<RegistrationPage>{


  TextEditingController firstNameEditingController = TextEditingController();
  TextEditingController lastNameEditingController = TextEditingController();
  TextEditingController usernameEditingController = TextEditingController();
  TextEditingController passwordEditingController = TextEditingController();
  TextEditingController confirmPwEditingController = TextEditingController();

  bool firstNameHasError = false;
  bool lastNameHasError = false;
  bool usernameHasError = false;
  bool passwordHasError = false;
  bool confirmPwHasError = false;
  String errorMessage = "";

  @override
  void initState(){
    super.initState();
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: const Text("Créer votre compte"),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width*0.05, vertical: MediaQuery.of(context).size.width*0.01),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Prénom:"),
                SizedBox(
                  width: MediaQuery.of(context).size.width*0.6,
                  child: MyTextField(textEditingController: firstNameEditingController, hasError: firstNameHasError),
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Nom:"),
                SizedBox(
                  width: MediaQuery.of(context).size.width*0.6,
                  child: MyTextField(textEditingController: lastNameEditingController, hasError: lastNameHasError),
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Nom d'utilisateur:"),
                SizedBox(
                  width: MediaQuery.of(context).size.width*0.6,
                  child: MyTextField(textEditingController: usernameEditingController, hasError: usernameHasError),
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Mot de passe:"),
                SizedBox(
                  width: MediaQuery.of(context).size.width*0.6,
                  child: MyTextField(textEditingController: passwordEditingController, hasError: passwordHasError, passwordField: true),
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Confirmer:"),
                SizedBox(width: MediaQuery.of(context).size.width*0.05),
                SizedBox(
                  width: MediaQuery.of(context).size.width*0.6,
                  child: MyTextField(textEditingController: confirmPwEditingController, hasError: confirmPwHasError, passwordField: true),
                )
              ],
            ),
            MyTextButton(text: "Créer mon compte", onPressed: () async {

              firstNameHasError = false;
              lastNameHasError = false;
              usernameHasError = false;
              passwordHasError = false;
              confirmPwHasError = false;
              errorMessage = "";

              setState(() {
                if (firstNameEditingController.text == "" || RegExp(r'[!@#<>?":_`~;[\]\\|=+)(*&^%0-9 ]').hasMatch(firstNameEditingController.text)){
                  firstNameHasError = true;
                  errorMessage += "- prénom invalide.\n";
                }
                if (lastNameEditingController.text == "" || RegExp(r'[!@#<>?":_`~;[\]\\|=+)(*&^%0-9 ]').hasMatch(lastNameEditingController.text)){
                  lastNameHasError = true;
                  errorMessage += "- nom invalide.\n";
                }
                if (usernameEditingController.text == "" || RegExp(r'[!@#<>?":`~;[\]\\|=+)(*&^% ]').hasMatch(usernameEditingController.text)){
                  usernameHasError = true;
                  errorMessage += "- nom d'utilisateur invalide.\n";
                }
                if (passwordEditingController.text == ""){
                  passwordHasError = true;
                  errorMessage += "- mot de passe invalide.\n";
                }
                if (confirmPwEditingController.text == ""){
                  confirmPwHasError = true;
                  errorMessage += "- confirmation invalide.\n";
                }
                if (passwordEditingController.text != confirmPwEditingController.text){
                  passwordHasError = true;
                  confirmPwHasError = true;
                  errorMessage += "- mots de passe différents";
                }
              });

              if (firstNameHasError || lastNameHasError || usernameHasError || passwordHasError || confirmPwHasError){
                if (mounted){
                  showDialog(context: context, builder: (context){
                    return AlertDialog(
                      title: const Text('Erreur'),
                      content: Text(errorMessage),
                      actions: <Widget>[
                        TextButton(child: const Text('Fermer'),onPressed: () {
                          Navigator.of(context).pop();
                        },)
                      ],
                    );
                  });
                }
              } else {
                if (await createUser(usernameEditingController.text, firstNameEditingController.text, lastNameEditingController.text, passwordEditingController.text)){
                  if (mounted){
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const ChoicePage())
                    );
                  }
                } else {
                  if (mounted){
                    showDialog(context: context, builder: (context){
                      return AlertDialog(
                        title: const Text('Erreur'),
                        content: const Text("Une erreur a eu lieu empêchant la création de votre compte."),
                        actions: <Widget>[
                          TextButton(child: const Text('Fermer'),onPressed: () {
                            Navigator.of(context).pop();
                          },)
                        ],
                      );
                    });
                  }
                }

              }

            })
          ],
        )
      ),
    );
  }
}