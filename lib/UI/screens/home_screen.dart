import 'package:flutter/material.dart';
import 'package:iconstruct/Core/models/formula_data_model.dart';
import 'package:iconstruct/UI/widgets/custom_text_style.dart';
import 'package:iconstruct/UI/widgets/widgets.dart';


import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  CustomStyle style = CustomStyle();

  @override
  void initState(){
    super.initState();
    getData();
  }

  void getData(){
    Provider.of<DataModel>(context,listen: false).createListOfObjectsFromDataMap();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body:  SafeArea(child: HomeScreenGrid()),
    );
  }
}



