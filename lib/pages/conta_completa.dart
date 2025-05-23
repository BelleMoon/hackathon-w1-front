import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:intl/intl.dart';
import 'package:w1app/widgets/topbar_clean.dart';
import '../services/api_service.dart';

class ContaCompletaPage extends StatefulWidget {
  const ContaCompletaPage({super.key});

  @override
  State<ContaCompletaPage> createState() => _ContaCompletaPageState();
}

class _ContaCompletaPageState extends State<ContaCompletaPage> {
  final _formKey = GlobalKey<FormState>();
  final _cpfController = TextEditingController();

  final cpfFormatter = MaskTextInputFormatter(
    mask: '###.###.###-##',
    filter: {"#": RegExp(r'[0-9]')},
  );

  final currencyFormatter =
      NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');

  late final Map<String, TextEditingController> _controllers;

  @override
  void initState() {
    super.initState();

    _controllers = {
      'Ações e CNPJs': TextEditingController(text: currencyFormatter.format(0)),
      'Fundos Imobiliários':
          TextEditingController(text: currencyFormatter.format(0)),
      'Fundos de Investimento':
          TextEditingController(text: currencyFormatter.format(0)),
      'Títulos de Renda Fixa':
          TextEditingController(text: currencyFormatter.format(0)),
      'Empresas fora da Bolsa':
          TextEditingController(text: currencyFormatter.format(0)),
      'Bens Imobiliários':
          TextEditingController(text: currencyFormatter.format(0)),
      'Outros Bens': TextEditingController(text: currencyFormatter.format(0)),
    };
  }

  bool _enviado = false;

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _enviado = true);

      final patrimonios = <String, double>{};
      _controllers.forEach((key, controller) {
        final value = controller.text
            .replaceAll(RegExp(r'[^\d,]'), '')
            .replaceAll(',', '.');
        patrimonios[key] = double.tryParse(value) ?? 0.0;
      });

      final cpf = _cpfController.text;

      final cpfOk = await ApiService.updateCPF(cpf);
      final patrimonyOk = await ApiService.updatePatrimony(patrimonios);

      if (cpfOk && patrimonyOk) {
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
      } else {
        _showError('Erro ao enviar dados. Tente novamente.');
      }

      setState(() => _enviado = false);
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Widget _buildValorField(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 14,
            )),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            CurrencyTextInputFormatter(),
          ],
          decoration: InputDecoration(
            hintText: 'R\$ 0,00',
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            contentPadding: const EdgeInsets.symmetric(
              vertical: 12,
              horizontal: 16,
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Informe o valor';
            }
            return null;
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
      appBar: TopBarLogoOnly(),
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
                      color: Color(0xff0e1a1f),
                    ),
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
                  ..._controllers.entries
                      .map((entry) => _buildValorField(entry.key, entry.value))
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
                          borderRadius: BorderRadius.circular(8),
                        ),
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

/// Formatter para entrada de moeda brasileira
class CurrencyTextInputFormatter extends TextInputFormatter {
  final NumberFormat _formatter =
      NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    String digits = newValue.text.replaceAll(RegExp(r'[^\d]'), '');
    double value = double.tryParse(digits) ?? 0.0;
    String newText = _formatter.format(value / 100);
    return TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: newText.length),
    );
  }
}
