import 'package:flutter/material.dart';
import 'package:master_front/button_widget.dart';
import 'package:master_front/userdata.dart';

import 'login_page.dart';


class AccountPage extends StatefulWidget {


  const AccountPage({
    super.key
  });

  @override
  State<AccountPage> createState() => AccountPageState();
}

class AccountPageState extends State<AccountPage>{


  @override
  void initState(){
    super.initState();
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: const Text("Mon compte"),
      ),
      body: Column(
        children: [
          SizedBox(height: MediaQuery.of(context).size.width*0.1),
          Center(
            child: CircleAvatar(
                backgroundColor: Colors.grey,
                radius: MediaQuery.of(context).size.width*0.2,
                child: Icon(Icons.person, size: MediaQuery.of(context).size.width*0.2, color: Colors.black54)
            ),
          ),
          SizedBox(height: MediaQuery.of(context).size.width*0.05),
          Text(Userdata.username, style: TextStyle(fontSize: MediaQuery.of(context).size.width*0.05, fontWeight: FontWeight.w600)),
          SizedBox(height: MediaQuery.of(context).size.width*0.02),
          Text("${Userdata.name} ${Userdata.lastname}", style: TextStyle(fontSize: MediaQuery.of(context).size.width*0.05)),
          SizedBox(height: MediaQuery.of(context).size.width*0.05),
          SizedBox(
            height: MediaQuery.of(context).size.width*0.1,
            child: MyTextButton(
              text: "Se Déconnecter",
              noClick: false,
              onPressed: () async {
                Userdata.clear();
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginPage())
                );
              },
            ),
          )
        ],
      ),
    );
  }
}