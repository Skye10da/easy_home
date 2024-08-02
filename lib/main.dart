import 'package:easy_home/constant/routes.dart';
import 'package:easy_home/services/auth/auth_service.dart';
import 'package:easy_home/services/cloud/fcm_token_service.dart';
import 'package:easy_home/services/cloud/firebase_messaging_service.dart';
import 'package:easy_home/splash_screen.dart';
import 'package:easy_home/theme/lib/theme.dart';
import 'package:easy_home/theme/lib/util.dart';
import 'package:easy_home/utilities/notifications/notification_service.dart';
import 'package:easy_home/views/property/add_property.dart';
import 'package:easy_home/views/email_verify.dart';
import 'package:easy_home/views/navigation_view.dart';
import 'package:easy_home/views/login.dart';
import 'package:easy_home/views/property/advance_search.dart';
import 'package:easy_home/views/register.dart';
import 'package:easy_home/views/user/notification_view.dart';
import 'package:easy_home/views/user/user_dashboard.dart';
import 'package:easy_home/views/user/user_detail_update_view.dart';
import 'package:easy_home/views/welcome_screen_view.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AuthService.firebase().initialize();
  await FirebaseMessagingService.instance.initialize();
  await NotificationService.initialize();
  FCMService fcmService = FCMService();
  await fcmService.storeFCMToken();
  fcmService.handleTokenRefresh();
  await fcmService.unifyInitialize();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final brightness = View.of(context).platformDispatcher.platformBrightness;

    // Retrieves the default theme for the platform
    //TextTheme textTheme = Theme.of(context).textTheme;

    // Use with Google Fonts package to use downloadable fonts
    TextTheme textTheme =
        createTextTheme(context, "Roboto Flex", "Antic Didone");

    MaterialTheme theme = MaterialTheme(textTheme);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Easy Home',
      themeMode: ThemeMode.system,
      theme: brightness == Brightness.light
          ? theme.lightHighContrast()
          : theme.darkHighContrast(),
      home: const SplashScreen(),
      routes: {
        registerRoute: (context) => const Register(),
        loginRoute: (context) => const Login(),
        homeRoute: (context) => const NavigationView(),
        emailVerifyRoute: (context) => const EmailVerifyView(),
        welcomeRoute: (context) => const WelcomeScreen(),
        userDetailsRoute: (context) => const UserDetailsUpdatePage(),
        addPropertyRoute: (context) => const AddPropertyPage(),
        advanceSearchRoute: (context) => const AdvancedSearchPage(),
        userDashboardRoute: (context) => const DashboardPage(),
        navigationBarRoute: (context) => const NavigationView(),
        notificationRoute: (context) => const NotificationsPage(),
      },
    );
  }
}
