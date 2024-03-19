import 'package:flutter/material.dart';

class MyDropdownButton extends StatefulWidget {

  final String? hint;
  final List<String> items;
  String? selectedItem;
  final bool hasError;

  MyDropdownButton({
    this.hint,
    required this.items,
    required this.selectedItem,
    required this.hasError,
    super.key
  });

  @override
  State<MyDropdownButton> createState() => MyDropdownButtonState();

}

class MyDropdownButtonState extends State<MyDropdownButton> {

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
      child: DropdownButton<String>(
        value: widget.selectedItem,
        hint: Text(widget.hint ?? "Select"),
        items: widget.items.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        onChanged: (String? newValue) {
          setState(() {
            widget.selectedItem = newValue;
          });
        },
        underline: Container(),
        isExpanded: true,
        borderRadius: BorderRadius.circular(16),
        focusColor: Colors.transparent,
        padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width*0.01),
      ),
    );
  }
}