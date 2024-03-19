import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class RecipeButton extends StatefulWidget {

  final String text;
  final String url;
  final bool? isLiked;


  const RecipeButton({
    required this.text,
    required this.url,
    this.isLiked,
    super.key
  });

  @override
  State<RecipeButton> createState() => RecipeButtonState();

}

class RecipeButtonState extends State<RecipeButton> {

  late bool isLiked;

  @override
  void initState(){
    isLiked = widget.isLiked??false;
    super.initState();
  }

  Future<void> _launchUrl(String link) async {
    final Uri url = Uri.parse(link);
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context){
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey)
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width*0.01),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.width*0.15,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    alignment: Alignment.centerLeft,
                    elevation: 0,
                    foregroundColor: Colors.transparent
                  ),
                  onPressed: () async {
                    _launchUrl(widget.url);
                  },
                  child: Text(widget.text,
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: MediaQuery.of(context).size.width*0.04,
                        fontWeight: FontWeight.w500
                    ),),
                ),
              ),
            ),
            Align(
              alignment: Alignment.topRight,
              child: InkWell(
                  onTap: () {
                    setState(() {
                      isLiked = !isLiked;
                    });
                  },
                  child: (isLiked)
                      ? const Icon(Icons.favorite, color: Colors.red)
                      : const Icon(Icons.favorite_border)
              ),
            )
          ],
        ),
      ),
    );
  }
}