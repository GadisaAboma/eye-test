import 'package:flutter/material.dart';
import 'package:frontend/pages/home.dart';
import 'package:frontend/pages/login.dart';
import 'package:frontend/pages/register-doctor.dart';
import 'package:frontend/pages/splash.dart';
import 'package:frontend/providers/doctors-provider.dart';
import 'package:frontend/providers/patients-provider.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: ((context) => DoctorsProvider()),
        ),
        ChangeNotifierProvider(
          create: ((context) => PatientsProvider()),
        )
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          fontFamily: "Inter",
          primarySwatch: const MaterialColor(
            0xFF000000,
            <int, Color>{
              50: Color(0xFFE5E5E5),
              100: Color(0xFFBFBFBF),
              200: Color(0xFF999999),
              300: Color(0xFF737373),
              400: Color(0xFF525252),
              500: Color(0xFF333333),
              600: Color(0xFF2E2E2E),
              700: Color(0xFF242424),
              800: Color(0xFF1D1D1D),
              900: Color(0xFF141414),
            },
          ),
        ),
        home: const SplashScreen(),
        routes: {
          '/login': (context) => const Login(),
          '/register-doctor': (context) => RegisterDoctor(),
          "/home": (context) => const Home()
        },
      ),
    );
  }
}
