import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../widgets/topbar.dart';
import '../widgets/footer.dart';
import '../services/api_service.dart';
import 'package:intl/intl.dart';

class StatusPage extends StatefulWidget {
  const StatusPage({super.key});

  @override
  State<StatusPage> createState() => _StatusPageState();
}

class _StatusPageState extends State<StatusPage> {
  Map<String, dynamic>? _holdingData;

  @override
  void initState() {
    super.initState();
    _fetchHoldingData();
  }

  Future<void> _fetchHoldingData() async {
    final data = await ApiService.fetchSingleHoldingStatus();
    if (mounted) {
      setState(() {
        _holdingData = data;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff4f6f8),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color(0xff0e1a1f),
        title: const TopBar(),
        toolbarHeight: kToolbarHeight * 1.5,
      ),
      body: _holdingData == null
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      'Economia com a Holding',
                      style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
                    const SizedBox(height: 32),
                    LayoutBuilder(
                      builder: (context, constraints) {
                        final isMobile = constraints.maxWidth < 700;
                        return Flex(
                          direction: isMobile ? Axis.vertical : Axis.horizontal,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            _buildComparisonChart(_holdingData!),
                            const SizedBox(width: 32, height: 32),
                            _buildStatusSection(_holdingData!),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
      bottomNavigationBar: const Footer(),
    );
  }

  Widget _buildComparisonChart(Map<String, dynamic> holdingData) {
    final hasHolding = holdingData['status'] != 'NO_HOLDING';
    final withTax = double.tryParse(holdingData['tax_with'] ?? '0') ?? 0;
    final withoutTax = double.tryParse(holdingData['tax_without'] ?? '0') ?? 0;
    final economia = withoutTax > 0
        ? ((withoutTax - withTax) / withoutTax * 100).clamp(0, 100)
        : 0;
    final chartTitle =
        hasHolding ? 'Impostos Economizados' : 'O que você está perdendo';

    return SizedBox(
      width: 500,
      height: 600,
      child: Column(
        children: [
          Expanded(
            child: SfCartesianChart(
              title: ChartTitle(
                text: chartTitle,
                textStyle: const TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.w400,
                ),
              ),
              plotAreaBorderWidth: 0,
              primaryXAxis: CategoryAxis(
                axisLine: const AxisLine(width: 0),
                majorGridLines: const MajorGridLines(width: 0),
              ),
              primaryYAxis: NumericAxis(
                minimum: 0,
                numberFormat:
                    NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$'),
                axisLine: const AxisLine(width: 0),
                majorTickLines: const MajorTickLines(size: 0),
                majorGridLines: const MajorGridLines(width: 0),
              ),
              series: <ChartSeries>[
                ColumnSeries<_BarData, String>(
                  dataSource: [
                    _BarData('Sem Holding', withTax),
                    _BarData('Com Holding', withoutTax),
                  ],
                  xValueMapper: (_BarData data, _) => data.label,
                  yValueMapper: (_BarData data, _) => data.value,
                  pointColorMapper: (_BarData data, _) =>
                      data.label == 'Sem Holding' ? Colors.red : Colors.green,
                  dataLabelSettings: const DataLabelSettings(
                    isVisible: true,
                    textStyle: TextStyle(color: Colors.black),
                  ),
                  width: 0.4,
                  spacing: 0.3,
                  borderRadius: const BorderRadius.all(Radius.circular(6)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Text(
            '${economia.toStringAsFixed(2).replaceAll('.', ',')}% de economia',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 22,
              color: Color.fromARGB(255, 15, 97, 19),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusSection(Map<String, dynamic> holdingData) {
    final hasHolding = holdingData['status'] != 'NO_HOLDING';

    if (!hasHolding) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: const [
          Text(
            'Você ainda não tem uma holding!',
            style: TextStyle(fontSize: 30, color: Colors.black),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 16),
          Text(
            'Entre em contato com nossos especialistas para abrir sua holding!',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Text(
          'Status da Holding',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),
        Text(
          'Sua holding já está em funcionamento\ne aproveitando benefícios fiscais.',
          style: TextStyle(
            fontSize: 18,
            color: Colors.green[700], // ← verde mais escuro
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class _BarData {
  final String label;
  final double value;

  _BarData(this.label, this.value);
}
