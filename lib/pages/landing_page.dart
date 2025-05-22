import 'package:flutter/material.dart';
import 'package:w1app/pages/porque_w1.dart';
import '../widgets/footer.dart';
import '../widgets/topbar.dart';

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
                    const EdgeInsets.symmetric(vertical: 24, horizontal: 64),
                backgroundColor: Colors.white,
                foregroundColor: const Color(0xFF0e1a1f),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
              onPressed: () {
                Navigator.pushNamed(context, '/porque');
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
          onPressed: () {
            Navigator.pushNamed(context, '/sobre');
          },
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
