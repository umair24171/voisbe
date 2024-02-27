import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_notes/firebase_options.dart';
import 'package:social_notes/resources/colors.dart';
import 'package:social_notes/screens/add_note_screen.dart/view/add_hashtags_screen.dart';
import 'package:social_notes/screens/add_note_screen.dart/view/select_topic_screen.dart';
import 'package:social_notes/screens/auth_screens/providers/auth_provider.dart';
import 'package:social_notes/screens/auth_screens/view/auth_screen.dart';

import 'package:social_notes/screens/custom_bottom_bar.dart';
import 'package:social_notes/screens/home_screen/view/home_screen.dart';
import 'package:social_notes/screens/profile_screen/profile_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(
      create: (context) => AuthProvider(),
    )
  ], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.deepPurple, background: primaryColor),
        useMaterial3: true,
      ),
      home: AuthScreen(),
      routes: {
        ProfileScreen.routeName: (context) => const ProfileScreen(),
        HomeScreen.routeName: (context) => const HomeScreen(),
        AddHashtagsScreen.routeName: (context) => AddHashtagsScreen(),
        SelectTopicScreen.routeName: (context) => SelectTopicScreen(),
        BottomBar.routeName: (context) => const BottomBar(),
      },
    );
  }
}
