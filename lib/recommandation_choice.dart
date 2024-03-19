import 'package:flutter/material.dart';
import 'package:master_front/button_widget.dart';
import 'package:master_front/recipe_style_page.dart';

import 'login_page.dart';
import 'my_account.dart';

class ChoicePage extends StatefulWidget {


  const ChoicePage({
    super.key
  });

  @override
  State<ChoicePage> createState() => ChoicePageState();
}

class ChoicePageState extends State<ChoicePage>{


  @override
  void initState(){
    super.initState();
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: const Text("Type de Recommandation"),
        actions: [
          IconButton(onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AccountPage())
            );
          }, icon: const Icon(Icons.account_box_outlined)),
          IconButton(onPressed: () {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const LoginPage())
            );
          }, icon: const Icon(Icons.exit_to_app_rounded))
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: SizedBox(
              height: MediaQuery.of(context).size.width * 0.2,
              width: MediaQuery.of(context).size.width * 0.7,
              child: MyTextButton(
                  text: "Filtrage Collaboratif",
                  noClick: false,
                  onPressed: () async {
                    Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const RecipeStylePage(recommandation: "Filtrage Collaboratif"))
                    );
                  }
              ),
            ),
          ),
          SizedBox(height: MediaQuery.of(context).size.width*0.2),
          SizedBox(
            height: MediaQuery.of(context).size.width * 0.2,
            width: MediaQuery.of(context).size.width * 0.7,
            child: MyTextButton(
                text: "Basé sur le contenu",
                noClick: false,
                onPressed: () async {
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const RecipeStylePage(recommandation: "Basé sur le contenu"))
                  );
                }
            ),
          )
        ],
      ),
    );
  }
}