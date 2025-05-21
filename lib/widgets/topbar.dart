import 'package:flutter/material.dart';

class TopBar extends StatelessWidget implements PreferredSizeWidget {
  const TopBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
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
          onPressed: () {},
          child: const Text('Suporte', style: TextStyle(color: Colors.white)),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: OutlinedButton(
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Colors.white),
            ),
            onPressed: () {
              Navigator.pushNamed(context, '/perfil');
            },
            child: const Text('Perfil', style: TextStyle(color: Colors.white)),
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
