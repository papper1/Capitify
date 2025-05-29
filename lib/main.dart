import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:capytify/viewmodels/mini_player_provider.dart';
import 'package:capytify/widgets/home_root.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:capytify/views/screens/auth/auth_choice_screen.dart';
import 'package:capytify/viewmodels/auth_viewmodel.dart';



void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => MiniPlayerProvider()),
        ChangeNotifierProvider(create: (_) => AuthViewModel())
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Capytify',
      theme: ThemeData.dark(),
      initialRoute: '/login',
      routes: {
        '/login': (context) => const AuthChoiceScreen(),
        '/home': (context) => const HomeRootScreen(),
      }
    );
  }
}





