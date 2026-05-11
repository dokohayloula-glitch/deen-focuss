import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';

import 'themes/app_theme.dart';
import 'providers/prayer_provider.dart';
import 'providers/task_provider.dart';
import 'providers/focus_provider.dart';
import 'providers/stats_provider.dart';
import 'providers/settings_provider.dart';
import 'services/storage_service.dart';
import 'services/notification_service.dart';
import 'services/prayer_service.dart';
import 'screens/app_shell.dart';
import 'screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Set preferred orientations
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  
  // Set system UI overlay style
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: AppTheme.carbonBlack,
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );
  
  // Initialize services
  final storageService = StorageService();
  await storageService.init();
  
  final notificationService = NotificationService();
  await notificationService.init();
  
  final prayerService = PrayerService();
  
  runApp(
    DeenFocusApp(
      storageService: storageService,
      notificationService: notificationService,
      prayerService: prayerService,
    ),
  );
}

class DeenFocusApp extends StatelessWidget {
  final StorageService storageService;
  final NotificationService notificationService;
  final PrayerService prayerService;

  const DeenFocusApp({
    super.key,
    required this.storageService,
    required this.notificationService,
    required this.prayerService,
  });

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => SettingsProvider(storageService),
        ),
        ChangeNotifierProvider(
          create: (_) => PrayerProvider(prayerService, storageService),
        ),
        ChangeNotifierProvider(
          create: (_) => TaskProvider(storageService),
        ),
        ChangeNotifierProvider(
          create: (_) => FocusProvider(storageService, notificationService),
        ),
        ChangeNotifierProvider(
          create: (_) => StatsProvider(storageService),
        ),
      ],
      child: MaterialApp(
        title: 'Deen Focus',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          brightness: Brightness.dark,
          scaffoldBackgroundColor: AppTheme.carbonBlack,
          colorScheme: const ColorScheme.dark(
            primary: AppTheme.islamicGold,
            secondary: AppTheme.deepEmerald,
            surface: AppTheme.surfaceGray,
            background: AppTheme.carbonBlack,
            onBackground: Colors.white,
            onSurface: Colors.white,
          ),
          textTheme: GoogleFonts.notoSansArabicTextTheme(
            ThemeData.dark().textTheme,
          ),
          fontFamily: GoogleFonts.notoSansArabic().fontFamily,
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.transparent,
            elevation: 0,
            centerTitle: true,
            iconTheme: IconThemeData(color: Colors.white),
          ),
          cardTheme: CardTheme(
            color: AppTheme.deepCharcoal,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
          ),
          bottomNavigationBarTheme: const BottomNavigationBarThemeData(
            backgroundColor: AppTheme.deepCharcoal,
            selectedItemColor: AppTheme.islamicGold,
            unselectedItemColor: AppTheme.secondaryText,
            type: BottomNavigationBarType.fixed,
            elevation: 8,
          ),
        ),
        home: const SplashScreen(),
      ),
    );
  }
}
