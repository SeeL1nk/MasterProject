import 'package:flutter/material.dart';

class MyTextField extends StatefulWidget{

  final TextEditingController textEditingController;
  final bool hasError;
  final String? hintText;
  final bool? passwordField;

  const MyTextField({
    super.key,
    required this.textEditingController,
    this.hintText,
    required this.hasError,
    this.passwordField
  });

  @override
  State<MyTextField> createState() => MyTextFieldState();

}

class MyTextFieldState extends State<MyTextField>{

  @override
  Widget build(BuildContext context){
    return Container(
      decoration: BoxDecoration(
          border: Border.all(
              color: widget.hasError
                  ? Colors.red
                  : Colors.grey,
              width: 2
          ),
          borderRadius: BorderRadius.circular(16)
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width*0.02),
        child: TextFormField(
          controller: widget.textEditingController,
          onChanged: (value) {
            int cursorPos = widget.textEditingController.selection.extentOffset;
            widget.textEditingController.text = value;
            widget.textEditingController.selection = TextSelection.fromPosition(TextPosition(offset: cursorPos));
          },
          obscureText: widget.passwordField ?? false,
          decoration: InputDecoration(
              hintText: widget.hintText ?? "",
              border: InputBorder.none,
              focusedBorder: InputBorder.none,
              focusedErrorBorder: InputBorder.none
          ),
        ),
      ),
    );
  }
}