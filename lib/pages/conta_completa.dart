import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class ContaCompletaPage extends StatefulWidget {
  const ContaCompletaPage({super.key});

  @override
  State<ContaCompletaPage> createState() => _ContaCompletaPageState();
}

class _ContaCompletaPageState extends State<ContaCompletaPage> {
  final _formKey = GlobalKey<FormState>();

  final _cpfController = TextEditingController();
  final _patrimonios = <String, double>{
    'Ações': 0,
    'Fundos Imobiliários': 0,
    'Fundos de Investimento': 0,
    'Títulos de Renda Fixa': 0,
    'Empresas fora da Bolsa': 0,
    'Bens Imobiliários': 0,
    'Outros Bens': 0,
  };

  final cpfFormatter = MaskTextInputFormatter(
    mask: '###.###.###-##',
    filter: {"#": RegExp(r'[0-9]')},
  );

  bool _enviado = false;

  void _submit() {
    if (_formKey.currentState!.validate()) {
      setState(() => _enviado = true);
      Future.delayed(const Duration(seconds: 2), () {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Cadastro completo!'),
            content: const Text(
              'Nossos especialistas logo entrarão em contato para te ajudar a levar seu patrimônio para o próximo nível.',
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pushReplacementNamed(context, '/patrimonio');
                },
                child: const Text('Ir para o Dashboard'),
              )
            ],
          ),
        );
      });
    }
  }

  Widget _buildSlider(String label, String key) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$label: R\$ ${_patrimonios[key]!.toStringAsFixed(0)}',
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
        Slider(
          value: _patrimonios[key]!,
          min: 0,
          max: 1000000,
          divisions: 100,
          label: _patrimonios[key]!.toStringAsFixed(0),
          onChanged: (value) {
            setState(() {
              _patrimonios[key] = value;
            });
          },
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff4f6f8),
      appBar: AppBar(
        backgroundColor: const Color(0xff0e1a1f),
        title: Image.asset('assets/imagens/logo-w1.png', height: 32),
        centerTitle: false,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 600),
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: const [
                BoxShadow(color: Colors.black12, blurRadius: 8)
              ],
            ),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Complete seu cadastro',
                    style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Color(0xff0e1a1f)),
                  ),
                  const SizedBox(height: 24),
                  TextFormField(
                    controller: _cpfController,
                    inputFormatters: [cpfFormatter],
                    keyboardType: TextInputType.number,
                    validator: (value) =>
                        value == null || value.isEmpty ? 'Informe o CPF' : null,
                    decoration: InputDecoration(
                      labelText: 'CPF',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8)),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 16),
                    ),
                  ),
                  const SizedBox(height: 24),
                  ..._patrimonios.keys
                      .map((key) => _buildSlider(key, key))
                      .toList(),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _enviado ? null : _submit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xff0e1a1f),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                      ),
                      child: Text(
                        _enviado ? 'Enviando...' : 'Finalizar Cadastro',
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
