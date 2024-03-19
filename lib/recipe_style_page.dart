import 'package:flutter/material.dart';
import 'package:master_front/button_widget.dart';
import 'package:master_front/loading_screen.dart';
import 'package:master_front/my_account.dart';
import 'package:master_front/restriction_picker.dart';
import 'package:master_front/space_widget.dart';
import 'package:master_front/userdata.dart';

class RecipeStylePage extends StatefulWidget {

  final String recommandation;

  const RecipeStylePage({
    required this.recommandation,
    super.key
  });

  @override
  State<RecipeStylePage> createState() => RecipeStylePageState();
}

class RecipeStylePageState extends State<RecipeStylePage>{

  String? selectedDiet;
  bool dietHasError = false;
  TextEditingController lovedIngController = TextEditingController();

  String? selectedRecipe;
  bool recipeHasError = false;

  String errorMessage = "";
  String recipe_id = "";

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.recommandation),
          actions: [
            IconButton(onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AccountPage())
              );
            }, icon: const Icon(Icons.account_box_outlined)),
          ]
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width*0.1, vertical: MediaQuery.of(context).size.width*0.01),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: MediaQuery.of(context).size.width*0.4),
            const Text(
              "Trouvons la recette parfaite !",
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800
              ),
            ),
            MySpaceWidget(percentage: 0.05, pageContext: context),
            const Text(
              "Régimes",
              style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700
              ),
            ),
            MySpaceWidget(percentage: 0.02, pageContext: context),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Container(
                decoration: BoxDecoration(
                    border: Border.all(
                        color: dietHasError
                            ? Colors.red
                            : Colors.grey,
                        width: 2
                    ),
                    borderRadius: BorderRadius.circular(16)
                ),
                child: DropdownButton<String>(
                  value: selectedDiet,
                  hint: const Text("Sélectionné"),
                  items: const [
                    "Diabétique",
                    "Faible en Cholestérole",
                    "Perte de Poids",
                    "Faible en Sodium",
                    "Enceinte"
                  ].map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedDiet = newValue;
                    });
                  },
                  underline: Container(),
                  isExpanded: true,
                  borderRadius: BorderRadius.circular(16),
                  focusColor: Colors.transparent,
                  padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width*0.01),
                ),
              ),
            ),
            (widget.recommandation=="Basé sur le contenu")
                ? Column(
              children: [
                MySpaceWidget(percentage: 0.02, pageContext: context),
                const Text(
                  "Choisissez une recette qui vous plait :",
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700
                  ),
                ),
                MySpaceWidget(percentage: 0.02, pageContext: context),
                Container(
                  decoration: BoxDecoration(
                      border: Border.all(
                          color: recipeHasError
                              ? Colors.red
                              : Colors.grey,
                          width: 2
                      ),
                      borderRadius: BorderRadius.circular(16)
                  ),
                  child: DropdownButton<String>(
                    value: selectedRecipe,
                    hint: const Text("Sélectionné"),
                    items: Userdata.recipes.map((element) => element['name']!).toList().map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedRecipe = newValue;
                      });
                    },
                    underline: Container(),
                    isExpanded: true,
                    borderRadius: BorderRadius.circular(16),
                    focusColor: Colors.transparent,
                    padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width*0.01),
                  ),
                )
              ],
            )
                : MySpaceWidget(percentage: 0.02, pageContext: context),
            MySpaceWidget(percentage: 0.03, pageContext: context),
            MyTextButton(text: "Ajouter des resctrictions", onPressed: () async {
              Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const RestrictionPicker())
              );
            }),
            MySpaceWidget(percentage: 0.2, pageContext: context),
            MyTextButton(text: "Chercher", onPressed: () async {
              dietHasError = false;
              recipeHasError = false;
              errorMessage = "";
              setState(() {
                if (selectedDiet == null){
                  errorMessage += "- Veuillez sélectionné un régime.\n";
                  dietHasError = true;
                }
                if (selectedRecipe == null && widget.recommandation == "Basé sur le contenu"){
                  errorMessage += "- Veuillez sélectionné une recette.\n";
                  recipeHasError = true;
                }
              });
              if (dietHasError || recipeHasError){
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
                if (widget.recommandation == "Basé sur le contenu"){
                  int index = Userdata.recipes.indexWhere((element) => element['name'] == selectedRecipe);
                  recipe_id = Userdata.recipes[index]['recipe_id']??"*";
                  print(recipe_id);
                }
                if (mounted) {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => LoadingPage(requestInfo: {'type':widget.recommandation,'user':'newUser','recipe':recipe_id},))
                  );
                }
              }
            })
          ],
        ),
      ),
    );
  }
}