import 'package:flutter/material.dart';

class TopBarLogoOnly extends StatelessWidget implements PreferredSizeWidget {
  const TopBarLogoOnly({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: const Color(0xff0e1a1f),
      // Botão de voltar padrão incluído automaticamente se necessário
      title: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: () {
            final currentRoute = ModalRoute.of(context)?.settings.name;
            if (currentRoute != '/') {
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
