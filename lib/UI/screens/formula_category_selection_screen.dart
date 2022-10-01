import 'package:flutter/material.dart';
import 'package:iconstruct/UI/widgets/custom_text_style.dart';
import 'package:iconstruct/UI/widgets/widgets.dart';

class FormulaCategorySelectionScreen extends StatefulWidget {
  const FormulaCategorySelectionScreen({Key? key}) : super(key: key);

  @override
  State<FormulaCategorySelectionScreen> createState() => _FormulaCategorySelectionScreenState();
}

class _FormulaCategorySelectionScreenState extends State<FormulaCategorySelectionScreen> {
  @override
  Widget build(BuildContext context) {
    CustomStyle style = CustomStyle();
    return Scaffold(
      appBar: AppBar(
        title: Text('Choose a Category',style: style.appBarStyle,),
        foregroundColor: Colors.blueAccent,
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        actions: [IconButton(onPressed: (){
          Navigator.pushNamed(context, '/favorites');
        }, icon: const Icon(Icons.star_border,),
        )],
      ),
      body: const FormulaCategoryGrid(),
    );
  }
}
