import 'package:flutter/material.dart';
import 'pages/home_page.dart';
import 'pages/patrimonio_page.dart';
import 'pages/perfil_page.dart';
import 'pages/suporte_page.dart';

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
      initialRoute: '/',
      routes: {
        '/': (_) => const HomePage(),
        '/patrimonio': (_) => const PatrimonioPage(),
        '/perfil': (_) => const PerfilPage(),
        '/suporte': (_) => const SuportePage(),
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
      body: Column(
        children: const [
          TopBar(),
          Expanded(child: HeroSection()),
          Footer(),
        ],
      ),
    );
  }
}

class TopBar extends StatelessWidget {
  const TopBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
      color: const Color(0xFF0e1a1f),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'w1',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          Row(
            children: [
              NavItem(title: 'Sobre'), // sem rota, só texto
              NavItem(title: 'Suporte', route: '/suporte'),
              NavItem(title: 'Entrar', outlined: true, route: '/perfil'),
            ],
          ),
        ],
      ),
    );
  }
}

class NavItem extends StatelessWidget {
  final String title;
  final String? route;
  final bool outlined;

  const NavItem(
      {super.key, required this.title, this.route, this.outlined = false});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: route != null ? () => Navigator.pushNamed(context, route!) : null,
      child: Container(
        margin: const EdgeInsets.only(left: 16),
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        decoration: outlined
            ? BoxDecoration(
                border: Border.all(color: Colors.white),
                borderRadius: BorderRadius.circular(5),
              )
            : null,
        child: Text(title),
      ),
    );
  }
}

class HeroSection extends StatelessWidget {
  const HeroSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/imagens/bg-landing_upscayl_2x.png'),
          fit: BoxFit.cover,
          alignment: Alignment(0, -0.3),
        ),
      ),
      child: Container(
        color: const Color.fromRGBO(0, 80, 70, 0.8),
        alignment: Alignment.center,
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Blindagem patrimonial e crescimento estratégico para holdings.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 24),
            GestureDetector(
              onTap: () => Navigator.pushNamed(context, '/patrimonio'),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 32),
                decoration: BoxDecoration(
                  color: const Color(0xFF0e1a1f),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: const Text(
                  'Começar',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Footer extends StatelessWidget {
  const Footer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF0e1a1f),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Conheça a W1',
              style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          const Text('• W1 Consciência'),
          const Text('• W1 Capital'),
          const Text('• W1 Tecnologia'),
          const Text('• W1 Consultoria Patrimonial'),
          const SizedBox(height: 24),
          const Text('Contato:', style: TextStyle(fontWeight: FontWeight.bold)),
          const Text(
              'Endereço: R. Funchal 418 - Conjunto 1701 - Vila Olímpia, São Paulo - SP, 04551-060'),
          const Text('Telefone: (11) 3001-3007'),
        ],
      ),
    );
  }
}
