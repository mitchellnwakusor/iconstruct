import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:iconstruct/Core/models/formula_data_model.dart';
import 'package:iconstruct/UI/widgets/widgets.dart';
import 'package:provider/provider.dart';

import '../../Core/models/advert_state.dart';

class MathematicsCategoryScreen extends StatefulWidget {
  const MathematicsCategoryScreen({Key? key}) : super(key: key);

  @override
  State<MathematicsCategoryScreen> createState() => _MathematicsCategoryScreenState();
}

class _MathematicsCategoryScreenState extends State<MathematicsCategoryScreen> {
  List mathFormulas = [];
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
    bannerAd = adState.mathsBanner;
    setState(() {});
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    mathFormulas = Provider.of<DataModel>(context).mathFormula;
    favoriteFormulas = Provider.of<DataModel>(context,listen: false).favoriteFormulas;
    return Scaffold(
      appBar: AppBar(
        title:  const Text('Mathematical Formulas',),
        foregroundColor: Colors.blueAccent,
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        actions: [IconButton(onPressed: (){
          Navigator.pushNamed(context, '/favorites');
        }, icon: const Icon(Icons.star_border,),
        )],
      ),
      body: FormulaList(formulaList: mathFormulas, favoriteFormulaList: favoriteFormulas, bannerAd: bannerAd,)
    );
  }
}
