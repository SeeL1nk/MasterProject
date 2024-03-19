import 'package:flutter/material.dart';
import 'package:master_front/recipe_button.dart';
import 'package:master_front/recommandation_choice.dart';
import 'package:master_front/space_widget.dart';


class ResultPage extends StatefulWidget {

  final List<Map<String, dynamic>> result;

  const ResultPage({
    required this.result,
    super.key
});

  @override
  State<ResultPage> createState() => ResultPageState();
}

class ResultPageState extends State<ResultPage>{


  List<Widget> recipes(List<Map<String, dynamic>> data, BuildContext theContext) {
    List<Widget> recipes = [];
    for (Map<String, dynamic> recipe in data){
      recipes.add(
          SizedBox(
            height: MediaQuery.of(context).size.width*0.15,
            width: MediaQuery.of(context).size.width,
            child: RecipeButton(text: recipe['name'], url: recipe['url']),
          )
      );
      recipes.add(MySpaceWidget(percentage: 0.01, pageContext: theContext));
    }
    return recipes;
  }

  @override
  void initState(){
    super.initState();
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Nos recommandations",
          style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800
          ),
        ),
        actions: [
          IconButton(onPressed: () {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const ChoicePage())
            );
          }, icon: const Icon(Icons.close))
        ],
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width*0.05),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: recipes(widget.result, context),
          ),
        ),
      ),
    );
  }
}