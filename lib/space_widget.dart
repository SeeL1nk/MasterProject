import 'package:flutter/material.dart';

class MySpaceWidget extends StatelessWidget {

  final double percentage;
  final BuildContext pageContext;

  const MySpaceWidget({
    required this.percentage,
    required this.pageContext,
    super.key
  });

  @override
  Widget build(BuildContext context){
    return SizedBox(height: MediaQuery.of(pageContext).size.width*percentage);
  }
}