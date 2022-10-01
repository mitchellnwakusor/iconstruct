import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:iconstruct/Core/models/advert_state.dart';
import 'package:iconstruct/Core/models/formula_data_model.dart';
import 'package:iconstruct/UI/screens/formula_category_selection_screen.dart';
import 'package:iconstruct/UI/screens/chemistry_category_screen.dart';
import 'package:iconstruct/UI/screens/contact_screen.dart';
import 'package:iconstruct/UI/screens/favorite_formulas_screen.dart';
import 'package:iconstruct/UI/screens/home_screen.dart';
import 'package:iconstruct/UI/screens/mathematics_category_screen.dart';
import 'package:iconstruct/UI/screens/physics_category_screen.dart';

import 'package:provider/provider.dart';

// set test device ID
// List<String> testDeviceIds = ['C07FD104D8C768661F7D7CBCCE7AEBFF'];

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.remove();
  final initFuture = MobileAds.instance.initialize();
  final adState = AdState(initialization: initFuture);
  // 24 & 25 configures admob to run as a test device without this ads won't run unless they have been published to the app store
  // RequestConfiguration configuration = RequestConfiguration(testDeviceIds: testDeviceIds);
  // MobileAds.instance.updateRequestConfiguration(configuration);

    runApp( MultiProvider( providers: [
      ChangeNotifierProvider(create: (context)=> DataModel()),
      ChangeNotifierProvider(create: (context)=> AdState(initialization: initFuture)),
    ],
    child: const IConstruct()));
}

class IConstruct extends StatefulWidget {
  const IConstruct({Key? key}) : super(key: key);

  @override
  State<IConstruct> createState() => _IConstructState();
}

class _IConstructState extends State<IConstruct> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeScreen(),
        '/formulas': (context) => const FormulaCategorySelectionScreen(),
        '/mathematics': (context) => const MathematicsCategoryScreen(),
        '/physics': (context) => const PhysicsCategoryScreen(),
        '/chemistry': (context) => const ChemistryCategoryScreen(),
        '/favorites': (context) => const FavoriteFormulasScreen(),
        '/contact': (context) => const ContactScreen(),
      },
    );
  }
}





