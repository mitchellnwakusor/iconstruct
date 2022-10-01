import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart' as service;
import 'dart:convert';

class Formulas {
  String? formulaTitle;
  String? formulaEquation;
  bool? isFavorited;
  int? id;

  Formulas({required this.formulaTitle,required this.formulaEquation, required this.isFavorited, required this.id});
}

class DataModel with ChangeNotifier {

  final String _filePath = 'assets/config.json';
  List _mathFormula = [];
  List _chemistryFormula = [];
  List _physicsFormula = [];
  List _favoriteFormulas = [];
  List<Map> _dataMapsList = [];


  String get filePath{return _filePath;}
  List get mathFormula{return _mathFormula;}
  List get chemistryFormula{return _chemistryFormula;}
  List get physicsFormula{return _physicsFormula;}
  List get favoriteFormulas{return _favoriteFormulas;}
  List<Map> get dataMapList{return _dataMapsList;}

  set mathFormula(List math) {
    _mathFormula = math;
    notifyListeners();
  }
  set chemistryFormula(List chemistry) {
    _chemistryFormula = chemistry;
    notifyListeners();
  }
  set physicsFormula(List physics) {
    _physicsFormula = physics;
    notifyListeners();
  }
  set favoriteFormulas(List favFormulas) {
    _favoriteFormulas = favFormulas;
    notifyListeners();
  }
  set dataMapList(List<Map> maps) {
    _dataMapsList = maps;
    notifyListeners();
  }

  void addToFavoritesList(dynamic item){
    favoriteFormulas.add(item);
  }

  Future<String> createJsonStringFromFilePath() async{
    String jsonString = await service.rootBundle.loadString(filePath);
    return jsonString;
  }

  Future<void> createDataMapListFromJsonString() async{
    Map mappedJson = await jsonDecode(await createJsonStringFromFilePath());
    Map key = mappedJson['Formula'];

    Map mathDataMap = key['Mathematical'];
    Map physicsDataMap = key['Physics'];
    Map chemistryDataMap = key['Chemistry'];

    dataMapList = [mathDataMap,physicsDataMap,chemistryDataMap];
  }

  Future<void> createListOfObjectsFromDataMap() async{
    await createDataMapListFromJsonString();
   
    List tempData0 = [];
    List tempData1 = [];
    List tempData2 = [];
    int idCounter = 0;
    int idCounter1 = 0;
    int idCounter2 = 0;

    dataMapList[0].forEach((key, value) {
      idCounter += 1;
      tempData0.add(Formulas(formulaTitle: key, formulaEquation: value, isFavorited: false, id: idCounter-1));
    }
    );

    idCounter1 = tempData0.length;

    dataMapList[1].forEach((key, value) {
      idCounter1 += 1;
      tempData1.add(Formulas(formulaTitle: key, formulaEquation: value, isFavorited: false, id: idCounter1-1));
    }
    );


    idCounter2 = tempData1.length;

    dataMapList[2].forEach((key, value) {
      idCounter2 += 1;
      tempData2.add(Formulas(formulaTitle: key, formulaEquation: value, isFavorited: false, id: idCounter2-1));
    }
    );

    mathFormula = tempData0;
    physicsFormula = tempData1;
    chemistryFormula = tempData2;

  }

}


