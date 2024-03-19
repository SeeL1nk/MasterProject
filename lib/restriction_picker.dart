import 'package:flutter/material.dart';
import 'package:master_front/button_widget.dart';
import 'package:master_front/my_text_field.dart';

class RestrictionPicker extends StatefulWidget {

  const RestrictionPicker({super.key});

  @override
  State<RestrictionPicker> createState() => RestrictionPickerState();
}

class RestrictionPickerState extends State<RestrictionPicker>{

  late TextEditingController caloriesLimiterText;
  late TextEditingController fatLimiterText;
  late TextEditingController sodiumLimiterText;
  late TextEditingController sugarsLimiterText;
  late TextEditingController proteinLimiterText;

  bool caloriesHasError = false;
  bool fatHasError = false;
  bool sodiumHasError = false;
  bool sugarsHasError = false;
  bool proteinHasError = false;

  String errorMessage = "";

  @override
  void initState(){
    super.initState();
    caloriesLimiterText = TextEditingController();
    fatLimiterText = TextEditingController();
    sodiumLimiterText = TextEditingController();
    sugarsLimiterText = TextEditingController();
    proteinLimiterText = TextEditingController();
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width*0.1, vertical: MediaQuery.of(context).size.width*0.01),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
                "Selection of Criteria",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.width*0.03),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Calories Limit :"),
                SizedBox(width: MediaQuery.of(context).size.width*0.05),
                SizedBox(
                  width: MediaQuery.of(context).size.width*0.5,
                  child: MyTextField(textEditingController: caloriesLimiterText, hintText: "cal", hasError: caloriesHasError),
                )
              ],
            ),
            SizedBox(height: MediaQuery.of(context).size.width*0.02),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Fat Limit :"),
                SizedBox(width: MediaQuery.of(context).size.width*0.05),
                SizedBox(
                  width: MediaQuery.of(context).size.width*0.5,
                  child: MyTextField(textEditingController: fatLimiterText, hintText: "g", hasError: fatHasError),
                )
              ],
            ),
            SizedBox(height: MediaQuery.of(context).size.width*0.02),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Sodium Limit :"),
                SizedBox(width: MediaQuery.of(context).size.width*0.05),
                SizedBox(
                  width: MediaQuery.of(context).size.width*0.5,
                  child: MyTextField(textEditingController: sodiumLimiterText, hintText: "mg", hasError: sodiumHasError),
                )
              ],
            ),
            SizedBox(height: MediaQuery.of(context).size.width*0.02),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Sugars Limit :"),
                SizedBox(width: MediaQuery.of(context).size.width*0.05),
                SizedBox(
                  width: MediaQuery.of(context).size.width*0.5,
                  child: MyTextField(textEditingController: sugarsLimiterText, hintText: "g", hasError: sugarsHasError),
                )
              ],
            ),
            SizedBox(height: MediaQuery.of(context).size.width*0.02),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Protein Limit :"),
                SizedBox(width: MediaQuery.of(context).size.width*0.05),
                SizedBox(
                  width: MediaQuery.of(context).size.width*0.5,
                  child: MyTextField(textEditingController: proteinLimiterText, hintText: "g", hasError: proteinHasError),
                )
              ],
            ),
            SizedBox(height: MediaQuery.of(context).size.width*0.05),
            SizedBox(
              width: MediaQuery.of(context).size.width*0.3,
              child: MyTextButton(
                  text: "Set restrictions",
                  onPressed: () async {
                    setState((){

                      caloriesHasError = false;
                      fatHasError = false;
                      sodiumHasError = false;
                      sugarsHasError = false;
                      proteinHasError = false;
                      errorMessage = "";

                      if (!RegExp(r'^[0-9]+$').hasMatch(caloriesLimiterText.text)){
                        caloriesHasError = true;
                        errorMessage += "- Invalid calories limit.\n";
                      }
                      if (!RegExp(r'^[0-9]+$').hasMatch(fatLimiterText.text)){
                        fatHasError = true;
                        errorMessage += "- Invalid fat limit.\n";
                      }
                      if (!RegExp(r'^[0-9]+$').hasMatch(sodiumLimiterText.text)){
                        sodiumHasError = true;
                        errorMessage += "- Invalid sodium limit.\n";
                      }
                      if (!RegExp(r'^[0-9]+$').hasMatch(sugarsLimiterText.text)){
                        sugarsHasError = true;
                        errorMessage += "- Invalid sugars limit.\n";
                      }
                      if (!RegExp(r'^[0-9]+$').hasMatch(proteinLimiterText.text)){
                        proteinHasError = true;
                        errorMessage += "- Invalid protein limit.\n";
                      }
                    });
                    if (caloriesHasError || fatHasError || sodiumHasError || sugarsHasError || proteinHasError) {
                      if (mounted){
                        showDialog(context: context, builder: (context){
                          return AlertDialog(
                            title: const Text('Error'),
                            content: Text(errorMessage),
                            actions: <Widget>[
                              TextButton(child: const Text('Close'),onPressed: () {
                                Navigator.of(context).pop();
                              },)
                            ],
                          );
                        });
                      }
                    } else {
                      Navigator.pop(context);
                    }
                  }
              ),
            )
          ],
        ),
      ),
    );
  }
}