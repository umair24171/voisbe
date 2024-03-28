// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_auth/firebase_auth.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_notification_channel/flutter_notification_channel.dart';
import 'package:flutter_notification_channel/notification_importance.dart';
import 'package:flutter_notification_channel/notification_visibility.dart';
import 'package:provider/provider.dart';
import 'package:social_notes/firebase_options.dart';
import 'package:social_notes/resources/colors.dart';
import 'package:social_notes/screens/add_note_screen/provider/note_provider.dart';
// import 'package:social_notes/screens/add_note_screen.dart/view/add_note_screen.dart';
import 'package:social_notes/screens/auth_screens/providers/auth_provider.dart';
// import 'package:social_notes/screens/auth_screens/providers/auth_provider.dart';
import 'package:social_notes/screens/chat_screen.dart/provider/chat_provider.dart';

import 'package:social_notes/screens/custom_bottom_bar.dart';
import 'package:social_notes/screens/home_screen/provider/display_notes_provider.dart';
import 'package:social_notes/screens/home_screen/provider/filter_provider.dart';
import 'package:social_notes/screens/home_screen/view/home_screen.dart';
// import 'package:social_notes/screens/profile_screen/controller/update_profile_controller.dart';
import 'package:social_notes/screens/profile_screen/profile_screen.dart';
import 'package:social_notes/screens/profile_screen/provider.dart/update_profile_provider.dart';
import 'package:social_notes/screens/search_screen/view/provider/search_screen_provider.dart';
import 'package:social_notes/screens/subscribe_screen.dart/view/subscribe_screen.dart';
import 'package:social_notes/screens/upload_sounds/provider/sound_provider.dart';
import 'package:social_notes/screens/user_profile/provider/user_profile_provider.dart';
import 'package:social_notes/screens/user_profile/view/widgets/custom_player.dart';
import 'package:social_notes/splash_screen.dart';
// import 'package:social_notes/splash_screen.dart';
import 'package:social_notes/spotify/methods/model/provider/tracks_provider.dart';
import 'package:social_notes/spotify/methods/spotify_class.dart';

// import './screens/auth_screens/providers/auth_provider.dart'

flutterNotificationChannel() async {
  await FlutterNotificationChannel().registerNotificationChannel(
    description: 'Channel for Voisbe Chats',
    id: 'chats',
    importance: NotificationImportance.IMPORTANCE_HIGH,
    name: 'Chats',
    visibility: NotificationVisibility.VISIBILITY_PUBLIC,
    allowBubbles: true,
    enableVibration: true,
    enableSound: true,
    showBadge: true,
  );
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  flutterNotificationChannel();
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(
      create: (context) => UserProvider(),
    ),
    ChangeNotifierProvider(
      create: (context) => NoteProvider(),
    ),
    ChangeNotifierProvider(
      create: (context) => DisplayNotesProvider(),
    ),
    ChangeNotifierProvider(
      create: (context) => ChatProvider(),
    ),
    ChangeNotifierProvider(
      create: (context) => FilterProvider(),
    ),
    ChangeNotifierProvider(
      create: (context) => UserProfileProvider(),
    ),
    ChangeNotifierProvider(
      create: (context) => UpdateProfileProvider(),
    ),
    ChangeNotifierProvider(
      create: (context) => SoundProvider(),
    ),
    ChangeNotifierProvider(
      create: (context) => TracksProvider(),
    ),
    ChangeNotifierProvider(
      create: (context) => SearchScreenProvider(),
    ),
  ], child: const MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    SpotifyClass().getToken(context);
    // SpotifyClass().getRefreshToken();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Voisbe',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.deepPurple, background: primaryColor),
        useMaterial3: true,
      ),
      home: const SplashScreen(),
      //  const SplashScreen(),
      routes: {
        ProfileScreen.routeName: (context) => const ProfileScreen(),
        HomeScreen.routeName: (context) => const HomeScreen(),
        SubscribeScreen.routeName: (context) => const SubscribeScreen(),
        // AddHashtagsScreen.routeName: (context) => AddHashtagsScreen(),
        // SelectTopicScreen.routeName: (context) => SelectTopicScreen(
        //       title: '',
        //     ),
        BottomBar.routeName: (context) => const BottomBar(),
      },
    );
  }
}
