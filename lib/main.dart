import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:paypie/logic/provider_state.dart';
import 'package:paypie/login_pages/login_page.dart';
import 'package:paypie/pages/add_users.dart';
import 'package:paypie/pages/homepage.dart';
import 'package:paypie/profile/create_update_profile.dart';
import 'package:paypie/shared_prreference.dart';
import 'package:paypie/sign_up_pages/signup_page.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';

void main()async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await SharedPreferenceHelper.initialise();
  runApp( MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  // This widget is the root of your application.
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    User? user= _firebaseAuth.currentUser;
    return ChangeNotifierProvider(
      create: (context)=>ProviderState(),
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'PayPie',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: AnimatedSplashScreen(
            splash: 'assets/splash.jpg',
            nextScreen: Scaffold(
              body: DoubleBackToCloseApp(
                snackBar: SnackBar(content: Text('double back to close app')),
                child: user!=null && SharedPreferenceHelper.GetisLogin()?
                HomePage():
                LoginPage() ,
              ),
            ),
            splashTransition: SplashTransition.fadeTransition,
            // pageTransitionType: ,
          )

      ),
    );
  }
}

/* user!=null?
                HomePage():
                LoginPage() ,*/