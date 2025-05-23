import 'package:flutter/material.dart';
import '../widgets/footer.dart';
import '../widgets/topbar.dart';
import 'dart:convert'; // necessário para base64
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:typed_data';
import '../services/api_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Uint8List? _imageBytes;
  String? _nome;

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  Future<void> _loadProfileData() async {
    final userData = await ApiService.getUserData();

    if (userData == null) {
      // Sessão não está logada, redireciona para login
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/login');
      }
      return;
    }

    // Verifica se CPF está nulo ou vazio
    if (userData['cpf'] == null || userData['cpf'].toString().trim().isEmpty) {
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/cadastro-patrimonio');
      }
    }

    // Caso contrário, está tudo certo — carrega nome e imagem
    if (mounted) {
      setState(() {
        _nome = userData['name'];
      });

      final prefs = await SharedPreferences.getInstance();
      final imageBase64 = prefs.getString('perfil_image_base64');
      if (imageBase64 != null) {
        setState(() {
          _imageBytes = base64Decode(imageBase64);
        });
      }
    }
  }

  String _capitalizeFirst(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1).toLowerCase();
  }

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
                      child: CircleAvatar(
                        radius: 60,
                        backgroundImage: _imageBytes != null
                            ? MemoryImage(_imageBytes!)
                            : const AssetImage(
                                    'assets/imagens/avatar-placeholder.png')
                                as ImageProvider,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Olá, ${_nome != null ? _capitalizeFirst(_nome!.split(' ').first) : '%Nome%'}',
                      style: const TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                        fontWeight: FontWeight.w400,
                        fontFamily: 'Montserrat',
                      ),
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xff0e1a1f),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                      onPressed: () async {
                        Navigator.pushNamed(context, '/perfil').then((_) {
                          _loadProfileData();
                        });
                      },
                      child: const Text('✏️ Editar Perfil'),
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.logout),
                      label: const Text('Sair da conta'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red.shade600,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                      onPressed: () async {
                        final prefs = await SharedPreferences.getInstance();
                        await prefs.remove('jwt_token'); // limpa o token
                        Navigator.pushNamedAndRemoveUntil(
                            context, '/login', (route) => false);
                      },
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
                        backgroundColor: const Color(0xff0e1a1f),
                        foregroundColor: Colors.white,
                        side: const BorderSide(
                            color: Color(0xff0e1a1f), width: 2),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        minimumSize: const Size(500, 110),
                      ),
                      onPressed: () => Navigator.pushNamed(context, '/status'),
                      child: const Text(
                        '✅ Status da Holding',
                        style:
                            TextStyle(fontSize: 30, fontFamily: 'Montserrat'),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Botão de Patrimônio
                    OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        backgroundColor: const Color(0xff0e1a1f),
                        foregroundColor: Colors.white,
                        side: const BorderSide(
                            color: Color(0xff0e1a1f), width: 2),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        minimumSize: const Size(500, 110),
                      ),
                      onPressed: () =>
                          Navigator.pushNamed(context, '/patrimonio'),
                      child: const Text(
                        '🏠 Dashboard de Patrimônio',
                        style:
                            TextStyle(fontSize: 30, fontFamily: 'Montserrat'),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Botão de Impostos
                    OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        backgroundColor: const Color(0xff0e1a1f),
                        foregroundColor: Colors.white,
                        side: const BorderSide(
                            color: Color(0xff0e1a1f), width: 2),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        minimumSize: const Size(500, 110),
                      ),
                      onPressed: () =>
                          Navigator.pushNamed(context, '/impostos'),
                      child: const Text(
                        '📊 Página de Impostos',
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
