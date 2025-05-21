import 'package:flutter/material.dart';
import '../widgets/footer.dart';
import '../widgets/topbar.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff4f6f8),
      appBar: const TopBar(), // usa o header novo
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(32),
        child: Center(
          child: Wrap(
            alignment: WrapAlignment.center,
            spacing: 32,
            runSpacing: 32,
            children: [
              // Profile Box
              Container(
                width: 300,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 8,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(0),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.black, width: 2),
                      ),
                      child: const CircleAvatar(
                        radius: 60,
                        backgroundImage:
                            AssetImage('assets/imagens/avatar-placeholder.png'),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Olá, %Nome%',
                      style: TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                          fontWeight: FontWeight.w400,
                          fontFamily: 'Montserrat'),
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xff0e1a1f),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                      onPressed: () {
                        Navigator.pushNamed(context, '/perfil');
                      },
                      child: const Text('✏️ Editar Perfil'),
                    ),
                  ],
                ),
              ),

              // Services Box
              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      'Selecione o Serviço desejado',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Montserrat',
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Botão de Status
                    OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        backgroundColor:
                            const Color(0xff0e1a1f), // fundo escuro
                        foregroundColor: Colors.white, // texto branco
                        side: const BorderSide(
                            color: Color(0xff0e1a1f), width: 2),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        minimumSize: const Size(500, 120),
                      ),
                      onPressed: () => Navigator.pushNamed(context, '/status'),
                      child: const Text(
                        '✅ Status da Holding',
                        style: TextStyle(
                          fontSize: 30,
                          fontFamily: 'Montserrat',
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Botão de Patrimônio
                    OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        backgroundColor:
                            const Color(0xff0e1a1f), // fundo escuro
                        foregroundColor: Colors.white, // texto branco
                        side: const BorderSide(
                            color: Color(0xff0e1a1f), width: 2),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        minimumSize: const Size(500, 120),
                      ),
                      onPressed: () =>
                          Navigator.pushNamed(context, '/patrimonio'),
                      child: const Text(
                        '🏠 Dashboard de Patrimônio',
                        style:
                            TextStyle(fontSize: 30, fontFamily: 'Montserrat'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const Footer(),
    );
  }

  Widget _buildServiceButton(BuildContext context,
      {required String text, required String route}) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          foregroundColor: const Color(0xff0e1a1f),
          side: const BorderSide(color: Color(0xff0e1a1f), width: 2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          padding: const EdgeInsets.symmetric(vertical: 20),
        ),
        onPressed: () {
          Navigator.pushNamed(context, route);
        },
        child: Text(text, style: const TextStyle(fontWeight: FontWeight.bold)),
      ),
    );
  }
}
