import 'package:flutter/material.dart';
import 'pages/home_page.dart';
import 'pages/patrimonio_page.dart';
import 'pages/perfil_page.dart';
import 'pages/suporte_page.dart';
import 'pages/status_page.dart';
import 'pages/login_register_page.dart';

import '../widgets/footer.dart';

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
      },
      debugShowCheckedModeBanner: false,
    );
  }
}

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0e1a1f),
      body: Column(
        children: const [
          TopBarLanding(),
          Expanded(child: _LandingHeroSection()),
        ],
      ),
      bottomNavigationBar: const Footer(),
    );
  }
}

class _LandingHeroSection extends StatelessWidget {
  const _LandingHeroSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/imagens/bg-landing_upscayl_2x.png'),
          fit: BoxFit.cover,
          alignment: Alignment(0, -0.3),
        ),
      ),
      child: Container(
        alignment: Alignment.center,
        color: const Color.fromRGBO(0, 80, 70, 0.8), // overlay
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 48),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Blindagem patrimonial e crescimento estratégico para holdings.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 28,
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(vertical: 14, horizontal: 36),
                backgroundColor: Colors.white,
                foregroundColor: const Color(0xFF0e1a1f),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
              onPressed: () {
                Navigator.pushNamed(context, '/login');
              },
              child: const Text(
                'Começar',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TopBarLanding extends StatelessWidget implements PreferredSizeWidget {
  const TopBarLanding({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false, // remove botão de voltar
      backgroundColor: const Color(0xff0e1a1f),
      title: Image.asset(
        'assets/imagens/logo-w1.png',
        height: 32,
      ),
      actions: [
        TextButton(
          onPressed: () {},
          child: const Text('Sobre', style: TextStyle(color: Colors.white)),
        ),
        TextButton(
          onPressed: () {
            Navigator.pushNamed(context, '/suporte');
          },
          child: const Text('Suporte', style: TextStyle(color: Colors.white)),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: OutlinedButton(
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Colors.white),
            ),
            onPressed: () {
              Navigator.pushNamed(context, '/');
            },
            child: const Text('Entrar', style: TextStyle(color: Colors.white)),
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
