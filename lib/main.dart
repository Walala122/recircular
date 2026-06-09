import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'theme/app_theme.dart';
import 'models/app_state.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/feed_screen.dart';
import 'screens/ventas_screen.dart';
import 'screens/contactos_screen.dart';
import 'widgets/shared_widgets.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
  ));
  runApp(
    ChangeNotifierProvider(
      create: (_) => AppState(),
      child: const ReCircularApp(),
    ),
  );
}

class ReCircularApp extends StatelessWidget {
  const ReCircularApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RE-CIRCULAR',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.theme.copyWith(
        textTheme: GoogleFonts.nunitoTextTheme(AppTheme.theme.textTheme),
      ),
      home: const AppNavigator(),
    );
  }
}

enum Screen { login, register, main }

class AppNavigator extends StatefulWidget {
  const AppNavigator({super.key});

  @override
  State<AppNavigator> createState() => _AppNavigatorState();
}

class _AppNavigatorState extends State<AppNavigator> {
  Screen screen = Screen.login;
  int navIndex = 0;

  void _goTo(Screen s) => setState(() => screen = s);
  void _setNav(int i) {
    if (i == 2) {
      showToast(context, '🔔 Sin nuevas alertas');
      return;
    }
    setState(() => navIndex = i);
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();

    if (screen == Screen.login) {
      return LoginScreen(
        onLogin: () => _goTo(Screen.register),
        onRegister: () => _goTo(Screen.register),
      );
    }

    if (screen == Screen.register) {
      return RegisterScreen(
        appState: appState,
        onSave: () => _goTo(Screen.main),
      );
    }

    // Main app with bottom nav
    final screens = [
      FeedScreen(appState: appState, onProfile: () => setState(() => navIndex = 4)),
      VentasScreen(appState: appState),
      const SizedBox(), // alerts placeholder
      ContactosScreen(appState: appState),
      RegisterScreen(appState: appState, onSave: () => setState(() => navIndex = 0)),
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      body: screens[navIndex],
      bottomNavigationBar: ReCircularBottomNav(
        currentIndex: navIndex,
        onTap: _setNav,
      ),
    );
  }
}
