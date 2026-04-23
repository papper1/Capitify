import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:capytify/features/music/presentation/state/artist_library_viewmodel.dart';
import 'package:capytify/features/music/presentation/state/mini_player_provider.dart';
import 'package:capytify/features/music/presentation/state/song_library_viewmodel.dart';
import 'package:capytify/features/home/presentation/screens/home_root_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:capytify/features/auth/presentation/screens/auth_choice_screen.dart';
import 'package:capytify/features/auth/presentation/screens/login_screen.dart';
import 'package:capytify/features/auth/presentation/screens/choose_mode_screen.dart';
import 'package:capytify/features/music/data/services/local_cache_service.dart';
import 'package:capytify/features/auth/presentation/state/auth_viewmodel.dart';



void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  final preferences = await SharedPreferences.getInstance();
  final localCacheService = LocalCacheService(preferences);

  runApp(AppProviders(
    localCacheService: localCacheService,
    child: const MyApp(),
  ));
}

class AppProviders extends StatelessWidget {
  const AppProviders({
    super.key,
    required this.child,
    required this.localCacheService,
  });

  final Widget child;
  final LocalCacheService localCacheService;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider.value(value: localCacheService),
        ChangeNotifierProvider(
          create: (_) => MiniPlayerProvider(localCacheService: localCacheService),
        ),
        ChangeNotifierProvider(create: (_) => AuthViewModel()),
        ChangeNotifierProvider(
          create: (_) => SongLibraryViewModel(localCacheService: localCacheService),
        ),
        ChangeNotifierProvider(
          create: (_) => ArtistLibraryViewModel(localCacheService: localCacheService),
        ),
      ],
      child: child,
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Capytify',
      theme: ThemeData.dark(),
      home: const AuthGate(),
      routes: {
        '/auth': (context) => const AuthChoiceScreen(),
        '/login': (context) => const LoginScreen(),
        '/home': (context) => const HomeRootScreen(),
        '/settings': (context) => const ChooseModeScreen(),
      },
    );
  }
}

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthViewModel>(
      builder: (context, authViewModel, child) {
        if (authViewModel.currentUser != null) {
          return const HomeRootScreen();
        }
        return const AuthChoiceScreen();
      },
    );
  }
}




