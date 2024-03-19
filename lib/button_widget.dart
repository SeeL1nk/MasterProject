import 'package:flutter/material.dart';

class MyTextButton extends StatefulWidget {

  final String text;
  final bool? noClick;
  final Future<void> Function() onPressed;

  const MyTextButton({
    required this.text,
    this.noClick,
    required this.onPressed,
    super.key
  });

  @override
  State<MyTextButton> createState() => MyTextButtonState();

}

class MyTextButtonState extends State<MyTextButton> {

  bool isProcessing = false;

  @override
  Widget build(BuildContext context){
    return ElevatedButton(
        onPressed: isProcessing || (widget.noClick ?? false)
            ? null
            :() async {
          setState(() {
            isProcessing = true;
          });
          await widget.onPressed();
          setState(() {
            isProcessing = false;
          });
        },
        style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16)
            )
        ),
        child: Text(
          widget.text,
          style: const TextStyle(
              color: Colors.white
          ),
        )
    );
  }
}