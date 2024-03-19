import 'package:flutter/material.dart';
import 'package:master_front/fetch_api.dart';
import 'package:master_front/result_page.dart';

class LoadingPage extends StatefulWidget {

  final Map<String, dynamic> requestInfo;

  const LoadingPage({
    required this.requestInfo,
    super.key
  });

  @override
  State<LoadingPage> createState() => LoadingPageState();
}

class LoadingPageState extends State<LoadingPage>{


  @override
  void initState(){
    if (widget.requestInfo['type'] == 'Filtrage Collaboratif'){
      getModelResult(widget.requestInfo['type'], widget.requestInfo['user']).then(
          (value) {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => ResultPage(result: value))
            );
          }
      );
    }
    if (widget.requestInfo['type'] == 'Basé sur le contenu'){
      getModelResult(widget.requestInfo['type'], widget.requestInfo['recipe']).then(
              (value) {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => ResultPage(result: value))
            );
          }
      );
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Notre modèle cherche les meilleurs recettes à vous recommander.", textAlign: TextAlign.center, style: TextStyle(
              fontSize: MediaQuery.of(context).size.width*0.05, fontWeight: FontWeight.w500),
            ),
            SizedBox(height: MediaQuery.of(context).size.width*0.05),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width*0.05),
              child: Container(
                height: 10,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: Colors.black26
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(5), // Bords arrondis pour le contenu aussi
                  child: const LinearProgressIndicator(
                    backgroundColor: Colors.transparent,
                    color: Colors.red,// Fond transparent pour que le conteneur soit visible derrière
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}