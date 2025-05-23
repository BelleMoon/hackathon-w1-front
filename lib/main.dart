import 'package:flutter/material.dart';
import 'package:w1app/pages/porque_w1.dart';
import 'pages/home_page.dart';
import 'pages/patrimonio_page.dart';
import 'pages/perfil_page.dart';
import 'pages/suporte_page.dart';
import 'pages/status_page.dart';
import 'pages/sobre_page.dart';
import 'pages/login_register_page.dart';
import 'pages/impostos_page.dart';
import 'pages/conta_completa.dart';
import 'pages/landing_page.dart';

void main() {
  runApp(const W1App());
}

class W1App extends StatelessWidget {
  const W1App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'W1 Holdings - Landing',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF0e1a1f),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Colors.black),
          bodyMedium: TextStyle(color: Colors.black87),
        ),
      ),
      initialRoute: '/landing',
      routes: {
        '/landing': (_) => const LandingPage(),
        '/': (_) => const HomePage(),
        '/patrimonio': (_) => const PatrimonioPage(),
        '/perfil': (_) => const PerfilPage(),
        '/status': (context) => const StatusPage(),
        '/suporte': (_) => const SuportePage(),
        '/login': (_) => const LoginRegisterPage(),
        '/sobre': (_) => const SobrePage(),
        '/impostos': (_) => const ImpostosPage(),
        '/porque': (_) => const PorQueFecharPage(),
        '/cadastro-patrimonio': (_) => const ContaCompletaPage(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
