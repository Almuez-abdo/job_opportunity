import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'core/theme.dart';
import 'services/app_provider.dart';
import 'screens/welcome_screen.dart';
import 'screens/auth_screens.dart';
import 'screens/agency_screens.dart';
import 'screens/user_screens.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final provider = AppProvider();
  await provider.init();
  runApp(ChangeNotifierProvider.value(value: provider, child: const JobApp()));
}

class JobApp extends StatelessWidget {
  const JobApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Job Opportunity',
      debugShowCheckedModeBanner: false,
      theme: appTheme(),
      locale: const Locale('ar'),
      supportedLocales: const [Locale('ar'), Locale('en')],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      builder: (context, child) => Directionality(textDirection: TextDirection.rtl, child: child!),
      initialRoute: '/',
      routes: {
        '/': (_) => const WelcomeScreen(),
        '/login': (_) => const LoginRoute(),
        '/registerUser': (_) => const RegisterUserScreen(),
        '/registerAgency': (_) => const RegisterAgencyScreen(),
        '/agency': (_) => const AgencyShell(),
        '/user': (_) => const UserShell(),
      },
    );
  }
}

class LoginRoute extends StatelessWidget {
  const LoginRoute({super.key});
  @override Widget build(BuildContext context){
    final arg = ModalRoute.of(context)?.settings.arguments as String?;
    return LoginScreen(role: arg=='agency'?'agency':'user');
  }
}
