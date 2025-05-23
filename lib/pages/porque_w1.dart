import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:w1app/widgets/topbar_clean.dart';
import '../widgets/footer.dart';
import '../widgets/topbar.dart';
import 'package:intl/intl.dart';

class PorQueFecharPage extends StatefulWidget {
  const PorQueFecharPage({super.key});

  @override
  State<PorQueFecharPage> createState() => _PorQueFecharPageState();
}

class _PorQueFecharPageState extends State<PorQueFecharPage> {
  double _custoAtual = 20000;
  final double _economiaPercentual = 30;

  @override
  Widget build(BuildContext context) {
    // cálculos
    final double economia = _custoAtual * (_economiaPercentual / 100);
    final double custoComW1 = _custoAtual - economia;

    // dados para o gráfico de colunas
    final List<_ChartData> chartData = [
      _ChartData('Atual', _custoAtual, Colors.redAccent),
      _ChartData('Com W1', custoComW1, Colors.green),
    ];

    return Scaffold(
      appBar: const TopBarLogoOnly(),
      backgroundColor: const Color(0xfff5f6fa),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Hero Section
            Container(
              padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 24),
              color: const Color(0xff0e1a1f),
              child: Column(
                children: const [
                  Text(
                    'Transforme seus objetivos em conquistas com a W1',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Planejamento financeiro 360° personalizado para você.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ).animate().fade(duration: 600.ms).slideY(),
            ),

            // Números
            Padding(
              padding: const EdgeInsets.all(24),
              child: Wrap(
                alignment: WrapAlignment.center,
                spacing: 24,
                runSpacing: 24,
                children: [
                  _buildStatCard('+100 mil', 'Clientes Satisfeitos'),
                  _buildStatCard('+14 anos', 'de Excelência'),
                  _buildStatCard('+800', 'Consultores'),
                  _buildStatCard('+2 bi', 'em Patrimônio Gerido'),
                ],
              ).animate().fade(duration: 500.ms).moveY(begin: 40),
            ),

            // Soluções
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: const [
                  Text(
                    'Soluções sob medida',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xff0e1a1f),
                    ),
                  ),
                  SizedBox(height: 16),
                ],
              ).animate().fade().slideY(begin: 0.2),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Wrap(
                spacing: 16,
                runSpacing: 16,
                alignment: WrapAlignment.center,
                children: const [
                  _ServiceTile('Planejamento Financeiro 360°', Icons.pie_chart),
                  _ServiceTile(
                      'Wealth Management', Icons.account_balance_wallet),
                  _ServiceTile('Aposentadoria', Icons.emoji_people),
                  _ServiceTile('Expansão Patrimonial', Icons.trending_up),
                  _ServiceTile(
                      'Planejamento Sucessório', Icons.family_restroom),
                ],
              ).animate().fade(duration: 400.ms).moveY(begin: 30),
            ),

            // Diferenciais
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: const [
                  SizedBox(height: 48),
                  Text(
                    'Diferenciais da W1',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xff0e1a1f),
                    ),
                  ),
                  SizedBox(height: 16),
                ],
              ).animate().fade().slideY(begin: 0.2),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Wrap(
                spacing: 16,
                runSpacing: 16,
                alignment: WrapAlignment.center,
                children: const [
                  _ServiceTile('Tecnologia de ponta em gestão', Icons.devices),
                  _ServiceTile(
                      'Equipe multidisciplinar', Icons.groups_2_outlined),
                  _ServiceTile('Consultoria personalizada', Icons.person_pin),
                  _ServiceTile(
                      'Foco em crescimento sustentável', Icons.eco_outlined),
                ],
              ).animate().fade().moveY(begin: 40),
            ),

            // Depoimentos
            const SizedBox(height: 48),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: const [
                  Text(
                    'O que dizem nossos clientes',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xff0e1a1f),
                    ),
                  ),
                  SizedBox(height: 24),
                  _DepoimentoTile(
                    nome: 'Fernanda S.',
                    texto:
                        '“A W1 cuidou do meu patrimônio como se fosse deles. Me sinto segura e bem assessorada.”',
                  ),
                  SizedBox(height: 16),
                  _DepoimentoTile(
                    nome: 'Roberto C.',
                    texto:
                        '“Graças ao planejamento da W1, consegui organizar minha sucessão familiar com clareza e tranquilidade.”',
                  ),
                ],
              ).animate().fade().slideY(begin: 0.1),
            ),

            // Simulador de Economia (agora com gráfico de colunas)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
              child: Column(
                children: [
                  const Text(
                    'Simule sua economia com a W1',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xff0e1a1f),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),

                  // Gráfico de colunas
                  SfCartesianChart(
                    primaryXAxis: CategoryAxis(),
                    primaryYAxis: NumericAxis(
                      numberFormat: NumberFormat.currency(symbol: 'R\$'),
                    ),
                    series: <ColumnSeries<_ChartData, String>>[
                      ColumnSeries<_ChartData, String>(
                        dataSource: chartData,
                        xValueMapper: (_ChartData data, _) => data.label,
                        yValueMapper: (_ChartData data, _) => data.value,
                        pointColorMapper: (_ChartData data, _) => data.color,
                        dataLabelSettings:
                            const DataLabelSettings(isVisible: true),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(6),
                          topRight: Radius.circular(6),
                        ),
                      ),
                    ],
                  ).animate().fade().moveY(begin: 20),

                  const SizedBox(height: 16),
                  Text(
                    'Você economiza ${_economiaPercentual.toStringAsFixed(0)}%  →  R\$ ${economia.toStringAsFixed(0)}',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Color(0xff0e1a1f)),
                  ),

                  const SizedBox(height: 16),
                  Slider(
                    value: _custoAtual,
                    min: 5000,
                    max: 100000,
                    divisions: 95,
                    label: 'R\$ ${_custoAtual.toStringAsFixed(0)}',
                    onChanged: (value) => setState(() => _custoAtual = value),
                  ),
                ],
              ),
            ),

            // Porque W1
            const SizedBox(height: 48),
            Container(
              color: const Color(0xff0e1a1f),
              padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 24),
              child: Column(
                children: const [
                  Text(
                    'Por que a W1 é a escolha certa?',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Combinamos tecnologia, inteligência de mercado e atendimento humanizado para cuidar do seu patrimônio e garantir seu futuro financeiro.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white70),
                  ),
                ],
              ).animate().fade().slideY(begin: 0.1),
            ),

            // CTA Final
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 48),
              child: Column(
                children: [
                  const Text(
                    'Pronto para transformar seu futuro financeiro?',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      color: Color(0xff0e1a1f),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xff0e1a1f),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 32, vertical: 16),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                    onPressed: () {
                      Navigator.pushNamed(context, '/login');
                    },
                    child: const Text('Crie uma conta na W1'),
                  ),
                ],
              ).animate().fade().slideY(begin: 0.2),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const Footer(),
    );
  }

  Widget _buildStatCard(String title, String subtitle) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeOutCubic,
      padding: const EdgeInsets.all(16),
      width: 160,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 6),
        ],
      ),
      child: Column(
        children: [
          Text(title,
              style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xff0e1a1f))),
          const SizedBox(height: 4),
          Text(subtitle, textAlign: TextAlign.center),
        ],
      ),
    ).animate().fade(duration: 400.ms);
  }
}

// modelo de dados para o gráfico
class _ChartData {
  final String label;
  final double value;
  final Color color;
  _ChartData(this.label, this.value, this.color);
}

// Tile de serviço
class _ServiceTile extends StatelessWidget {
  final String label;
  final IconData icon;
  const _ServiceTile(this.label, this.icon);

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 400),
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      width: 220,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 6)],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: const Color(0xff0e1a1f), size: 32),
          const SizedBox(height: 12),
          Text(label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  fontWeight: FontWeight.w500, color: Color(0xff0e1a1f))),
        ],
      ),
    ).animate().fade().moveY(begin: 20);
  }
}

// Tile de depoimento
class _DepoimentoTile extends StatelessWidget {
  final String nome;
  final String texto;
  const _DepoimentoTile({required this.nome, required this.texto});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 500,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 6)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(texto,
              style: const TextStyle(fontSize: 14, color: Colors.black87)),
          const SizedBox(height: 12),
          Text('- $nome',
              style: const TextStyle(
                  fontWeight: FontWeight.bold, color: Color(0xff0e1a1f))),
        ],
      ),
    ).animate().fade().moveY(begin: 20);
  }
}
