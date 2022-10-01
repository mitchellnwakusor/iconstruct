import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';

import '../../Core/models/advert_state.dart';
import '../../Core/models/formula_data_model.dart';
import '../widgets/widgets.dart';

class ChemistryCategoryScreen extends StatefulWidget {
  const ChemistryCategoryScreen({Key? key}) : super(key: key);

  @override
  State<ChemistryCategoryScreen> createState() => _ChemistryCategoryScreenState();
}

class _ChemistryCategoryScreenState extends State<ChemistryCategoryScreen> {
  List chemistryFormulas = [];
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
    bannerAd = adState.chemistryBanner;
    setState(() {});
    super.didChangeDependencies();
}

  @override
  Widget build(BuildContext context) {

    chemistryFormulas = Provider.of<DataModel>(context).chemistryFormula;
    favoriteFormulas = Provider.of<DataModel>(context,listen: false).favoriteFormulas;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Chemistry Formulas'),
        foregroundColor: Colors.blueAccent,
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        actions: [IconButton(onPressed: (){
          Navigator.pushNamed(context, '/favorites');
        }, icon: const Icon(Icons.star_border,),
        )],
      ),
      body: FormulaList(formulaList: chemistryFormulas, favoriteFormulaList: favoriteFormulas, bannerAd: bannerAd,)
    );
  }
}
