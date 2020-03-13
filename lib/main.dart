import 'package:flutter/material.dart';
import 'package:maf_mentor/locator.dart';
import 'package:maf_mentor/screens/login.dart';
import 'package:maf_mentor/screens/onboarding_screen.dart';
import 'package:maf_mentor/screens/register_page.dart';
import 'package:maf_mentor/screens/schedule_meeting.dart';
import 'package:maf_mentor/screens/terms_service.dart';
import 'package:maf_mentor/screens/toolbar/profile_page.dart';
import 'package:maf_mentor/screens/verify_account.dart';
import 'package:maf_mentor/screens/upload_pic.dart';
import 'package:maf_mentor/screens/dashboard.dart';
import 'package:maf_mentor/screens/splash_screen.dart';
import 'package:maf_mentor/screens/welcome_screen.dart';

void main() {
  // Register all the models and services before the app starts
  setupLocator();
  runApp(MyApp());
}
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MAF Mentor',
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
      routes: <String, WidgetBuilder>{
        '/register_page': (BuildContext context) => new RegisterPage(),
        '/verify_account': (BuildContext context) => new VerifyAccountPage(),
        '/upload_pic': (BuildContext context) => new UploadPicPage(),
        '/dashboard': (BuildContext context) => new DashBoardPage(),
        '/onboarding_screen': (BuildContext context) => new OnboardingScreen(),
        '/terms_service': (BuildContext context) => new TermsServicePage(),
        '/sign_in': (BuildContext context) => new LoginScreen(),
        '/welcome_screen': (BuildContext context) => new WelcomeScreenPage(),
        '/profile_page': (BuildContext context) => new ProfilePage(),
      },
    );
  }

}