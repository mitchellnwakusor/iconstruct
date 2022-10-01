import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:iconstruct/Core/models/advert_state.dart';
import 'package:iconstruct/UI/widgets/custom_text_style.dart';
import 'package:provider/provider.dart';

import '../../Core/models/formula_data_model.dart';

class CustomCard extends StatelessWidget {

  final String routePath;
  final String cardTitle;
  final String imageAssetPath;
  final TextStyle cardTitleStyle;

  const CustomCard({required this.routePath, required this.imageAssetPath, required this.cardTitle, required this.cardTitleStyle, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, routePath),
      child: Container(
        decoration:  BoxDecoration(
          boxShadow: const <BoxShadow> [BoxShadow(color: Colors.black12,offset: Offset(2.6,3.2),blurRadius: 0.7,spreadRadius: 1.2,)],
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.all(8),
        width: 150,
        height: 150,
        child: Column(
          children: [
            Expanded(child: Image.asset(imageAssetPath)),
            const SizedBox(height: 8,),
            Text(cardTitle, style: cardTitleStyle,)
          ],
        ),
      ),
    );
  }
}

class HomeScreenGrid extends StatefulWidget {
  const HomeScreenGrid({Key? key}) : super(key: key);

  @override
  State<HomeScreenGrid> createState() => _HomeScreenGridState();
}

class _HomeScreenGridState extends State<HomeScreenGrid> {
  CustomStyle style = CustomStyle();
  BannerAd? bannerAd;
  bool? isInitialized;

  @override
  void didChangeDependencies(){
    final adState = Provider.of<AdState>(context);
    if(isInitialized == null || isInitialized == false || adState.interstitialAd == null){
      isInitialized = true;
      Future.delayed(const Duration(seconds: 10),(){
        adState.initialization.then((status){
          setState(() {
            bannerAd = BannerAd(size: AdSize.fullBanner, adUnitId: adState.bannerAdUnitId, listener: adState.bannerAdListener, request: const AdRequest())..load();
            adState.chemistryBanner = BannerAd(size: AdSize.fullBanner, adUnitId: adState.bannerAdUnitId, listener: adState.bannerAdListener, request: const AdRequest())..load();
            adState.mathsBanner = BannerAd(size: AdSize.fullBanner, adUnitId: adState.bannerAdUnitId, listener: adState.bannerAdListener, request: const AdRequest())..load();
            adState.physicsBanner = BannerAd(size: AdSize.fullBanner, adUnitId: adState.bannerAdUnitId, listener: adState.bannerAdListener, request: const AdRequest())..load();
            adState.loadInterstitialAd();
          });
        });
      });

    }
    super.didChangeDependencies();
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomCard(routePath: '/formulas', imageAssetPath: 'assets/icons/formulas.png', cardTitle: 'Formulas', cardTitleStyle: style.appBarStyle),
                  const SizedBox(width: 32),
                  CustomCard(routePath: '/favorites', imageAssetPath: 'assets/icons/favorite.png', cardTitle: 'Favorites', cardTitleStyle: style.appBarStyle),
                ],),
              const SizedBox(height: 32,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomCard(routePath: '/contact', imageAssetPath: 'assets/icons/contact_us.png', cardTitle: 'Contact Us', cardTitleStyle: style.appBarStyle),
                ],
              ),
            ],
          ),
        ),
      if(bannerAd == null)
        const SizedBox(height: 50)
      else
        Container(height: 50, child: AdWidget(ad: bannerAd!,))
      ],
    );
  }
}

class FormulaCategoryGrid extends StatelessWidget {
  const FormulaCategoryGrid({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    CustomStyle style = CustomStyle();
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomCard(routePath: '/mathematics', imageAssetPath: 'assets/icons/maths.png', cardTitle: 'Maths', cardTitleStyle: style.appBarStyle),
            const SizedBox(width: 32),
            CustomCard(routePath: '/physics', imageAssetPath: 'assets/icons/physics.png', cardTitle: 'Physics', cardTitleStyle: style.appBarStyle),
          ],),
        const SizedBox(height: 32,),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomCard(routePath: '/chemistry', imageAssetPath: 'assets/icons/chemistry.png', cardTitle: 'Chemistry', cardTitleStyle: style.appBarStyle),
          ],
        ),
      ],
    );
  }
}

class NotificationDialog extends StatelessWidget {
  const NotificationDialog({required this.title, required this.content, Key? key}) : super(key: key);
  final String title;
  final String content;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      icon: const Icon(Icons.check),
      title: Text(title),
      titlePadding: const EdgeInsets.all(16),
      actions: [
        TextButton(onPressed: (){
          Navigator.of(context).pop();
        }, child: const Text('Ok'))
      ],
      // content: SingleChildScrollView(
      //   child: Text(content),
      // ),
      // contentPadding: const EdgeInsets.all(8),
    );
  }
}

class FormulaList extends StatefulWidget {
  const FormulaList({required this.bannerAd,required this.formulaList,required this.favoriteFormulaList,Key? key}) : super(key: key);
  final List? formulaList;
  final List? favoriteFormulaList;
  final BannerAd? bannerAd;

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
  State<FormulaList> createState() => _FormulaListState();
}

class _FormulaListState extends State<FormulaList> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: widget.formulaList?.length,
        itemBuilder: (context, item){
          if(widget.bannerAd==null){
            return ListTile(
              title: Text(widget.formulaList?[item].formulaTitle),
              subtitle: Text(widget.formulaList?[item].formulaEquation),
              trailing: IconButton(onPressed: () {
                if(widget.formulaList?[item].isFavorited!=true){
                  widget.formulaList?[item].isFavorited = true;
                  setState(() {});
                  widget.favoriteFormulaList?.add(widget.formulaList?[item]);
                }
                else{
                  widget.formulaList?[item].isFavorited = false;
                  setState(() {});
                  if(widget.favoriteFormulaList!.isNotEmpty){
                    widget.deleteItem(widget.formulaList?[item].id, widget.favoriteFormulaList!);
                  }
                }
                Provider.of<DataModel>(context,listen: false).favoriteFormulas.forEach((element) {
                });
              }, icon: const Icon(Icons.favorite_rounded),
                color: widget.formulaList?[item].isFavorited ? Colors.redAccent : Colors.grey,
              ),
            );
          }
          else {
            return item == 5 ? Container(height:50, color: Colors.transparent, child: AdWidget(ad: widget.bannerAd!)) : ListTile(
            title: Text(widget.formulaList?[item].formulaTitle),
            subtitle: Text(widget.formulaList?[item].formulaEquation),
            trailing: IconButton(onPressed: () {
              if(widget.formulaList?[item].isFavorited!=true){
                widget.formulaList?[item].isFavorited = true;
                setState(() {});
                widget.favoriteFormulaList?.add(widget.formulaList?[item]);
              }
              else{
                widget.formulaList?[item].isFavorited = false;
                setState(() {});
                if(widget.favoriteFormulaList!.isNotEmpty){
                  widget.deleteItem(widget.formulaList?[item].id, widget.favoriteFormulaList!);
                }
              }
              Provider.of<DataModel>(context,listen: false).favoriteFormulas.forEach((element) {
              });
            }, icon: const Icon(Icons.favorite_rounded),
              color: widget.formulaList?[item].isFavorited ? Colors.redAccent : Colors.grey,
            ),
          );
          }
        });
  }
}

class FavoriteFormulaList extends StatefulWidget {
  const FavoriteFormulaList({required this.favoriteFormulas, Key? key}) : super(key: key);
  final List? favoriteFormulas;

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
  State<FavoriteFormulaList> createState() => _FavoriteFormulaListState();
}

class _FavoriteFormulaListState extends State<FavoriteFormulaList> {
  @override
  Widget build(BuildContext context) {
    return  ListView.builder(
        itemCount: widget.favoriteFormulas?.length,
        itemBuilder: (context, item){
          return ListTile(
            title: Text(widget.favoriteFormulas?[item].formulaTitle),
            subtitle: Text(widget.favoriteFormulas?[item].formulaEquation),
            trailing: IconButton(onPressed: () {
              if(widget.favoriteFormulas?[item].isFavorited==true){
                widget.favoriteFormulas?[item].isFavorited = false;
                setState(() {});
                if(widget.favoriteFormulas!.isNotEmpty){
                  widget.deleteItem(widget.favoriteFormulas?[item].id, widget.favoriteFormulas!);
                }
              }
              Provider.of<DataModel>(context,listen: false).favoriteFormulas.forEach((element) {
              });
            }, icon: const Icon(Icons.favorite_rounded),
              color: widget.favoriteFormulas?[item].isFavorited ? Colors.redAccent : Colors.grey,
            ),
          );
        });
  }
}

class ContactCard extends StatefulWidget {
  const ContactCard({Key? key}) : super(key: key);

  @override
  State<ContactCard> createState() => _ContactCardState();
}

class _ContactCardState extends State<ContactCard> {

  final CustomStyle style = CustomStyle();
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  final TextEditingController nameFieldController = TextEditingController();
  final TextEditingController emailFieldController = TextEditingController();
  final TextEditingController messageFieldController = TextEditingController();

  Future sendEmail({required String name, required String email, required String message}) async {
    const serviceId = 'service_4j3nigm';
    const templateId = 'template_5l2ml0l';
    const userId = '7kcG8wYpRMI6SlOSA';

    final url = Uri.parse('https://api.emailjs.com/api/v1.0/email/send');
    final response = await http.post(url, headers: {
      'origin': 'http://localhost',
      'Content-Type': 'application/json',
    }, body: json.encode({'service_id': serviceId, 'template_id': templateId, 'user_id': userId, 'template_params': {
      'user_name': name,
      'user_email': email,
      'user_message': message,
    }}));
    if(response.statusCode==200){
      showDialog(context: context, builder: (BuildContext context){
        return const NotificationDialog(title: 'Message Sent', content: 'Message sent successfully');
      });
    }
    else{
      showDialog(context: context, builder: (BuildContext context){
        return const NotificationDialog(title: 'Message failed to send', content: 'Message failed to send');
      });
    }
  }

  @override
  void dispose(){
    nameFieldController.dispose();
    emailFieldController.dispose();
    messageFieldController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          height: 512,
          decoration: BoxDecoration(
              color: Colors.black12,
              borderRadius: BorderRadius.circular(24)
          ),
          padding: const EdgeInsets.fromLTRB(8,16,8,16),
          child: Form(
            key: _key,
            child: ListView(
              children: [
                Align(alignment: Alignment.center,child: Text('Get in touch',style: style.contactFormHeader ,)),
                const SizedBox(height: 16,),
                TextFormField(
                  controller: nameFieldController,
                  validator: (value){
                    if(value == null || value.isEmpty){
                      return 'This field is required';
                    }
                    return null;
                  },
                  inputFormatters: [FilteringTextInputFormatter.allow(RegExp('[A-Z a-z]'))],
                  decoration:  InputDecoration(
                      prefixIcon: const Icon(Icons.person),
                      hintText: 'Name',
                      filled: true,
                      fillColor: Colors.white,
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: const BorderSide(color: Colors.transparent)
                      )
                  ),
                  keyboardType: TextInputType.name,
                  textInputAction: TextInputAction.next,
                ),
                const SizedBox(height: 16,),
                TextFormField(
                  controller: emailFieldController,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {return 'This field is required.';}
                    String pattern = r'\w+@\w+\.\w+';
                    if (!RegExp(pattern).hasMatch(value)) {return 'Invalid E-mail address format.';}
                    return null;
                  },
                  inputFormatters: [FilteringTextInputFormatter.deny(RegExp('[!#/\$~&*]'))],
                  decoration:  InputDecoration(
                      prefixIcon: const Icon(Icons.email),
                      hintText: 'Email address',
                      filled: true,
                      fillColor: Colors.white,
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: const BorderSide(color: Colors.transparent)
                      )
                  ),
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                ),
                const SizedBox(height: 16,),
                TextFormField(
                  controller: messageFieldController,
                  validator: (value){
                    if(value == null || value.isEmpty){
                      return 'Please enter some text';
                    }
                    return null;
                  },
                  decoration:  InputDecoration(
                      hintText: 'Type a message',
                      filled: true,
                      fillColor: Colors.white,
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: const BorderSide(color: Colors.transparent)
                      )
                  ),
                  keyboardType: TextInputType.text,
                  maxLines: 3,
                ),
                const SizedBox(height: 32,),
                Align(alignment: Alignment.center,child: ElevatedButton(onPressed: () async {
                  if(_key.currentState!.validate()){
                    try {
                      sendEmail(name: nameFieldController.text, email: emailFieldController.text, message: messageFieldController.text);
                    }  on Exception catch (e) {
                      showDialog(context: context, builder: (BuildContext context){
                        return  NotificationDialog(title: '$e', content: 'Message failed to send');
                      });
                    }
                  }
                }, child: const Text('Send')))
              ],
            ),
          ),

        ),
      ),
    );
  }
}





