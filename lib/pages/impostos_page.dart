import 'package:flutter/material.dart';
import '../widgets/footer.dart';
import '../widgets/topbar.dart';

class ImpostosPage extends StatelessWidget {
  const ImpostosPage({super.key});

  Widget _buildStatusTile(String texto, Color bgColor, Color textColor) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        texto,
        style: TextStyle(color: textColor, fontWeight: FontWeight.w500),
      ),
    );
  }

  Widget _buildImpostoBox({
    required String titulo,
    required String descricao,
    required List<Widget> statusList,
  }) {
    return AnimatedOpacity(
      opacity: 1.0,
      duration: const Duration(milliseconds: 400),
      child: Container(
        width: 400, // define a largura para caber 2 por linha
        margin: const EdgeInsets.all(12),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(titulo,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xff0e1a1f),
                )),
            const SizedBox(height: 8),
            Text(descricao, style: const TextStyle(color: Colors.black87)),
            const SizedBox(height: 16),
            ...statusList,
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff5f6fa),
      appBar: const TopBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        child: Column(
          children: [
            const Text(
              'Impostos - Holding 1',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Color(0xff0e1a1f),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),

            // Bloco com 2 por linha
            Wrap(
              spacing: 16,
              runSpacing: 24,
              alignment: WrapAlignment.center,
              children: [
                _buildImpostoBox(
                  titulo: '📅 IRPJ - Imposto de Renda Pessoa Jurídica',
                  descricao: 'Tributação trimestral sobre o lucro da empresa.',
                  statusList: [
                    _buildStatusTile('✅ 1º Trimestre - Pago',
                        const Color(0xffe6f6ea), const Color(0xff2d8b57)),
                    _buildStatusTile('✅ 2º Trimestre - Pago',
                        const Color(0xffe6f6ea), const Color(0xff2d8b57)),
                    _buildStatusTile('❌ 3º Trimestre - Em aberto',
                        const Color(0xfffbe9e9), const Color(0xffb50000)),
                    _buildStatusTile('⌛ 4º Trimestre - A vencer (15/12)',
                        const Color(0xfffff7e6), const Color(0xffa67c00)),
                  ],
                ),
                _buildImpostoBox(
                  titulo: '📦 PIS / COFINS',
                  descricao: 'Contribuições mensais sobre o faturamento.',
                  statusList: [
                    _buildStatusTile('✅ Agosto - Pago', const Color(0xffe6f6ea),
                        const Color(0xff2d8b57)),
                    _buildStatusTile('✅ Setembro - Pago',
                        const Color(0xffe6f6ea), const Color(0xff2d8b57)),
                    _buildStatusTile('❌ Outubro - Pendente',
                        const Color(0xfffbe9e9), const Color(0xffb50000)),
                  ],
                ),
                _buildImpostoBox(
                  titulo: '🏛️ ISS - Imposto sobre Serviços',
                  descricao:
                      'Cobrado sobre os serviços prestados pela holding.',
                  statusList: [
                    _buildStatusTile('✅ Setembro - Pago',
                        const Color(0xffe6f6ea), const Color(0xff2d8b57)),
                    _buildStatusTile('⌛ Outubro - A vencer (25/10)',
                        const Color(0xfffff7e6), const Color(0xffa67c00)),
                  ],
                ),
                _buildImpostoBox(
                  titulo: '💼 CSLL - Contribuição Social sobre o Lucro Líquido',
                  descricao: 'Tributo trimestral que complementa o IRPJ.',
                  statusList: [
                    _buildStatusTile('✅ 1º Trimestre - Pago',
                        const Color(0xffe6f6ea), const Color(0xff2d8b57)),
                    _buildStatusTile('✅ 2º Trimestre - Pago',
                        const Color(0xffe6f6ea), const Color(0xff2d8b57)),
                    _buildStatusTile('❌ 3º Trimestre - Em aberto',
                        const Color(0xfffbe9e9), const Color(0xffb50000)),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: const Footer(),
    );
  }
}
