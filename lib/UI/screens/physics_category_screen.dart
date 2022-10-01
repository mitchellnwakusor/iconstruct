import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';

import '../../Core/models/advert_state.dart';
import '../../Core/models/formula_data_model.dart';
import '../widgets/widgets.dart';

class PhysicsCategoryScreen extends StatefulWidget {
  const PhysicsCategoryScreen({Key? key}) : super(key: key);

  @override
  State<PhysicsCategoryScreen> createState() => _PhysicsCategoryScreenState();
}

class _PhysicsCategoryScreenState extends State<PhysicsCategoryScreen> {
  List physicsFormulas = [];
  List favoriteFormulas = [];
  BannerAd? bannerAd;

  void deleteItem(int id, List array){
    int searchValue = id;
    int index = 0;
    for(int i=0;i<array.length;i++){
      if(array[i].id == searchValue){
        index = i;
      }
    }
    array.removeAt(index);

  }
  @override
  void didChangeDependencies(){
    final adState = Provider.of<AdState>(context);
    bannerAd = adState.physicsBanner;
    setState(() {});
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    physicsFormulas = Provider.of<DataModel>(context).physicsFormula;
    favoriteFormulas = Provider.of<DataModel>(context).favoriteFormulas;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Physics Formulas'),
        foregroundColor: Colors.blueAccent,
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        actions: [IconButton(onPressed: (){
          Navigator.pushNamed(context, '/favorites');
        }, icon: const Icon(Icons.star_border,),
        )],
      ),
      body: FormulaList(formulaList: physicsFormulas, favoriteFormulaList: favoriteFormulas, bannerAd: bannerAd,)
    );
  }
}
