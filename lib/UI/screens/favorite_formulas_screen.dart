import 'package:flutter/material.dart';
import 'package:iconstruct/UI/widgets/widgets.dart';
import 'package:provider/provider.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../../Core/models/advert_state.dart';
import '../../Core/models/formula_data_model.dart';

class FavoriteFormulasScreen extends StatefulWidget {
  const FavoriteFormulasScreen({Key? key}) : super(key: key);

  @override
  State<FavoriteFormulasScreen> createState() => _FavoriteFormulasScreenState();
}

class _FavoriteFormulasScreenState extends State<FavoriteFormulasScreen> {
  List favoriteFormulas = [];
  InterstitialAd? interstitialAd;
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
    final adState = Provider.of<AdState>(context,listen: false);
    final dataModel = Provider.of<DataModel>(context,listen: false);
    if(dataModel.favoriteFormulas.length>3){
      adState.showInterstitialAd();
    }
    super.didChangeDependencies();

  }
  @override
  Widget build(BuildContext context) {
    favoriteFormulas = Provider.of<DataModel>(context).favoriteFormulas;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorite Formulas'),
        foregroundColor: Colors.blueAccent,
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: FavoriteFormulaList(favoriteFormulas: favoriteFormulas)
    );
  }
}
