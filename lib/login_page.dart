import 'package:flutter/material.dart';
import 'package:master_front/fetch_api.dart';
import 'package:master_front/my_text_field.dart';
import 'package:master_front/recommandation_choice.dart';
import 'package:master_front/registration_page.dart';
import 'package:master_front/userdata.dart';

import 'button_widget.dart';

class LoginPage extends StatefulWidget {

  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage>{


  TextEditingController usernameEditingController = TextEditingController();
  TextEditingController passwordEditingController = TextEditingController();

  bool usernameHasError = false;
  bool passwordHasError = false;
  String errorMessage = "";

  @override
  void initState(){
    Userdata.getLocalRecipes();
    super.initState();
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width*0.1, vertical: MediaQuery.of(context).size.width*0.1),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SizedBox(),
            const Text(
              "Bienvenue ! Connectez-vous ou créer votre compte.",
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800
              ),
            ),
            MyTextField(textEditingController: usernameEditingController, hintText: "nom d'utilisateur", hasError: usernameHasError),
            MyTextField(textEditingController: passwordEditingController, hintText: "mot de passe", hasError: passwordHasError, passwordField: true),
            SizedBox(
              width: MediaQuery.of(context).size.width*0.4,
              child: MyTextButton(
                text: "Se Connecter",
                onPressed: () async {

                  usernameHasError = false;
                  passwordHasError = false;
                  errorMessage = "";

                  if (usernameEditingController.text == ""){
                    usernameHasError = true;
                    errorMessage += "- Le champ 'Nom d'utilisateur' est vide !\n";
                  }

                  if (passwordEditingController.text == ""){
                    passwordHasError = true;
                    errorMessage += "- Le champ 'Mot de passe' est vide !\n";
                  }

                  if (usernameHasError || passwordHasError){
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
                    if (await login(usernameEditingController.text, passwordEditingController.text)){
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
                            content: const Text("Nom d'utilisateur ou mot de passe incorrecte."),
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


                },
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const RegistrationPage())
                );
              },
              child: const Text(
                "Créer un compte",
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                    decoration: TextDecoration.underline
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}