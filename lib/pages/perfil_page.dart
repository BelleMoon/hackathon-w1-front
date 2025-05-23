import 'package:flutter/material.dart';
import '../widgets/topbar.dart';
import '../widgets/footer.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'dart:typed_data';
import 'dart:convert'; // necessário para base64
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import '../services/api_service.dart';

class PerfilPage extends StatefulWidget {
  const PerfilPage({super.key});

  @override
  State<PerfilPage> createState() => _PerfilPageState();
}

class _PerfilPageState extends State<PerfilPage> {
  Uint8List? _imageBytes;

  final _nomeController = TextEditingController();
  final _emailController = TextEditingController();
  final _telefoneController = TextEditingController();
  /*final _senhaController = TextEditingController();
  final _confirmarSenhaController = TextEditingController();*/

  final cpfFormatter = MaskTextInputFormatter(
    mask: '###.###.###-##',
    filter: {"#": RegExp(r'[0-9]')},
  );

  @override
  void initState() {
    super.initState();
    _loadProfileData(); // ← isso é necessário para carregar nome etc
  }

  Future<void> _loadImage() async {
    final prefs = await SharedPreferences.getInstance();
    final base64String = prefs.getString('perfil_image_base64');
    if (base64String != null) {
      final bytes = base64Decode(base64String);
      setState(() {
        _imageBytes = bytes;
      });
    }
  }

  Future<void> _loadProfileData() async {
    final userData = await ApiService.getUserData();

    if (userData != null) {
      setState(() {
        _nomeController.text = userData['name'] ?? '';
        _emailController.text = userData['email'] ?? '';

        final rawCpf = userData['cpf'] ?? '';
        final cleanedCpf = rawCpf.replaceAll(RegExp(r'\D'), '');
        _telefoneController.text = cpfFormatter.maskText(cleanedCpf);

        if (userData['profile_image'] != null &&
            userData['profile_image'] != '') {
          try {
            _imageBytes = base64Decode(userData['profile_image']);
          } catch (e) {
            print('Erro ao decodificar imagem de perfil: $e');
          }
        }
      });
    } else {
      print('Erro: não foi possível carregar dados do usuário.');
    }
  }

  Future<void> _pickImage() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.image);

    if (result != null) {
      Uint8List? bytes = result.files.single.bytes;

      if (bytes == null && result.files.single.path != null) {
        bytes = await File(result.files.single.path!).readAsBytes();
      }

      if (bytes != null) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('perfil_image_base64', base64Encode(bytes));

        setState(() {
          _imageBytes = bytes;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final cpfFormatter = MaskTextInputFormatter(
      mask: '###.###.###-##',
      filter: {"#": RegExp(r'[0-9]')},
    );

    return Scaffold(
      backgroundColor: const Color(0xfff4f6f8),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color(0xff0e1a1f),
        title: const TopBar(),
        toolbarHeight: kToolbarHeight * 1.5,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(32),
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 600),
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: const [
                BoxShadow(
                    color: Colors.black12, blurRadius: 8, offset: Offset(0, 4)),
              ],
            ),
            child: Column(
              children: [
                GestureDetector(
                  onTap: _pickImage,
                  child: Container(
                    padding: const EdgeInsets.all(2),
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
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: _pickImage,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xff0e1a1f),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  icon: const Icon(Icons.image),
                  label: const Text('Trocar Imagem'),
                ),
                const SizedBox(height: 24),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Dados do Perfil',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _nomeController,
                  decoration: const InputDecoration(
                    labelText: 'Nome completo',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'E-mail',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _telefoneController,
                  inputFormatters: [cpfFormatter],
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'CPF',
                    border: OutlineInputBorder(),
                  ),
                ),
                /*const SizedBox(height: 32),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Alterar Senha',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _senhaController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Nova Senha',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _confirmarSenhaController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Confirmar Nova Senha',
                    border: OutlineInputBorder(),
                  ),
                ),*/
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      String? imageBase64;
                      if (_imageBytes != null) {
                        imageBase64 = base64Encode(_imageBytes!);
                      }

                      final success = await ApiService.updateUserData(
                        name: _nomeController.text.trim(),
                        email: _emailController.text.trim(),
                        cpf: _telefoneController.text
                            .replaceAll(RegExp(r'\D'), ''),
                        profileImageBase64: imageBase64,
                      );

                      if (success) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Alterações salvas com sucesso.')),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Erro ao salvar alterações.')),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xff0e1a1f),
                    ),
                    child: const Text('Salvar Alterações'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: const Footer(),
    );
  }
}

class CustomInput extends StatelessWidget {
  final String label;
  final bool obscure;
  const CustomInput({super.key, required this.label, this.obscure = false});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.black)),
        const SizedBox(height: 4),
        TextField(
          obscureText: obscure,
          style: const TextStyle(color: Colors.black),
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            hintStyle: TextStyle(color: Colors.black54),
          ),
        ),
        const SizedBox(height: 12),
      ],
    );
  }
}

class ButtonRow extends StatelessWidget {
  const ButtonRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: Colors.black, // texto preto
          ),
          child: const Text('Confirmar'),
        ),
        const SizedBox(width: 16),
        ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            foregroundColor: Colors.black, // texto preto
          ),
          child: const Text('Desconectar'),
        ),
      ],
    );
  }
}
