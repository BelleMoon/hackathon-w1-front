import 'package:flutter/material.dart';

class TopBarLogoOnly2 extends StatelessWidget implements PreferredSizeWidget {
  const TopBarLogoOnly2({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false, // Impede o botão de voltar
      backgroundColor: const Color(0xff0e1a1f),
      title: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: () {
            final currentRoute = ModalRoute.of(context)?.settings.name;

            if (currentRoute == '/login' || currentRoute == '/porque') {
              Navigator.pushNamed(context, '/landing');
            }
            if (currentRoute != '/' && currentRoute != '/login') {
              Navigator.pushNamed(context, '/');
            }
          },
          child: Image.asset(
            'assets/imagens/logo-w1.png',
            height: 32,
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
