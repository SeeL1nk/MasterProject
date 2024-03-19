import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:master_front/userdata.dart';

Future<List<Map<String, dynamic>>> getModelResult(String type, String parameter) async {

  String apiUrl = 'https://fz63as11zk.execute-api.eu-west-1.amazonaws.com/dev/master_ec2_trigger';

  if (type == "Filtrage Collaboratif"){
    apiUrl += "?user=$parameter";
  }
  if (type == "Basé sur le contenu"){
    apiUrl += "?recipe=$parameter";
  }

  final response = await http.get(Uri.parse(apiUrl));
  if (response.statusCode == 200) {
    String result = response.body;
    List<Map<String, dynamic>> resultData = [];
    if (type == "Filtrage Collaboratif"){
      List<String> answers = extractResultSequences(result);

      for (String answer in answers){
        double estimation = double.parse(double.parse(extractBetween("Estimation: ", " Name", answer) ?? "0").toStringAsFixed(2));
        String name = extractBetween("Name: ", " Url", answer) ?? "";
        String url = extractBetween("Url: ", " endUrl", answer) ?? "https://www.google.com/";
        resultData.add({"estimation": estimation, "name": name, "url": url});
      }
      return resultData;
    } else {
      List<String> elements = result.split('\n').where((String line) => line.contains('-')).map((String line) => line.split(' ').last).toList();
      for (int i = 2; i < elements.length; i++){
        int index = Userdata.recipes.indexWhere((element) => element['recipe_id'] == elements[i]);
        resultData.add({"name": Userdata.recipes[index]['name'], "url": Userdata.recipes[index]['url']});
      }
      return resultData;
    }
  } else {
    print('error with api');
    return [];
  }
}

List<String> extractResultSequences(String input) {
  List<String> resultList = [];
  RegExp regex = RegExp(r"RESULT(.*?)RESULTEND");

  // Trouver toutes les correspondances dans la chaîne d'entrée
  Iterable<Match> matches = regex.allMatches(input);

  // Parcourir les correspondances et les ajouter à la liste de résultats
  for (Match match in matches) {
    resultList.add(match.group(1)!); // group(0) correspond à la séquence complète
  }

  return resultList;
}
String? extractBetween(String start, String end, String text){

  RegExp regex = RegExp("$start(.*?)$end");
  Match? match = regex.firstMatch(text);
  return match?.group(1);
}

Future<bool> login(String username, String password) async {

  String apiUrl = 'https://6gr7nmtttc.execute-api.eu-west-1.amazonaws.com/default/master_user_management?request=login&username=$username&password=$password';

  final response = await http.get(Uri.parse(apiUrl));
  if (response.statusCode == 200) {
    var data = jsonDecode(response.body);
    var firstItem = data[0];
    Userdata.lastname = firstItem['lastname'];
    Userdata.username = firstItem['username'];
    Userdata.name = firstItem['name'];
    Userdata.lovedRecipes = firstItem['lovedRecipes'];
    return true;
  } else {
    return false;
  }
}

Future<bool> createUser(String username, String name, String lastname, String password) async {

  String apiUrl = 'https://6gr7nmtttc.execute-api.eu-west-1.amazonaws.com/default/master_user_management?request=add&name=$name&lastname=$lastname&username=$username&password=$password';
  final response = await http.get(Uri.parse(apiUrl));
  if (response.statusCode == 200) {
    Userdata.name = name;
    Userdata.lastname = lastname;
    Userdata.username = username;
    return true;
  } else {
    return false;
  }
}