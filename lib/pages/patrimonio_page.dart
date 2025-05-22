import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../widgets/topbar.dart';
import '../widgets/footer.dart';
import '../services/api_service.dart';
import 'package:intl/intl.dart';
import '../models/patrimonio_models.dart';

class PatrimonioPage extends StatelessWidget {
  const PatrimonioPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: const Color(0xfff4f6f8),
        appBar: AppBar(
          toolbarHeight: kToolbarHeight * 1.5,
          automaticallyImplyLeading: false,
          backgroundColor: const Color(0xff0e1a1f),
          title: const TopBar(),
          bottom: const TabBar(
            indicatorColor: Colors.white,
            tabs: [
              Tab(icon: Icon(Icons.pie_chart), text: 'Alocação'),
              Tab(icon: Icon(Icons.bar_chart), text: 'Performance'),
              Tab(icon: Icon(Icons.show_chart), text: 'Evolução'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            _AlocacaoView(),
            _PerformanceView(),
            _EvolucaoView(),
          ],
        ),
        bottomNavigationBar: const Footer(),
      ),
    );
  }
}

class _AlocacaoView extends StatelessWidget {
  const _AlocacaoView();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<AllocationItem>>(
      future: ApiService.fetchAllocation(),
      builder: (context, snap) {
        if (!snap.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final data = snap.data!;
        final totalPercent = data.fold(0.0, (sum, item) => sum + item.percent);

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                'Alocação de Recursos',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                'Distribuição percentual dos investimentos por tipo de ativo',
                style: TextStyle(fontSize: 14, color: Colors.black54),
              ),
              const SizedBox(height: 32),
              Center(
                child: Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 32,
                  runSpacing: 32,
                  children: [
                    // Gráfico (sem borda)
                    SizedBox(
                      width: 300,
                      height: 300,
                      child: SfCircularChart(
                        tooltipBehavior: TooltipBehavior(enable: true),
                        annotations: <CircularChartAnnotation>[
                          CircularChartAnnotation(
                            widget: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  'Total',
                                  style: TextStyle(
                                      fontSize: 14, color: Colors.black54),
                                ),
                                Text(
                                  '${totalPercent.toStringAsFixed(0)}%',
                                  style: const TextStyle(
                                      fontSize: 28,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ],
                        series: <CircularSeries>[
                          DoughnutSeries<AllocationItem, String>(
                            dataSource: data,
                            xValueMapper: (item, _) => item.name,
                            yValueMapper: (item, _) => item.percent,
                            pointColorMapper: (item, _) => item.color,
                            innerRadius: '70%',
                            radius: '100%',
                            enableTooltip: true,
                          ),
                        ],
                      ),
                    ),

                    // Legendas
                    SizedBox(
                      width: 320,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: data.map((item) {
                          return Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: item.color.withOpacity(0.05),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: item.color, width: 1),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 14,
                                  height: 14,
                                  margin: const EdgeInsets.only(right: 12),
                                  decoration: BoxDecoration(
                                    color: item.color,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    item.name,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                                Text(
                                  '${item.percent.toStringAsFixed(2).replaceAll('.', ',')}%',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87),
                                )
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _PerformanceView extends StatelessWidget {
  const _PerformanceView();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<HoldingItem>>(
      future: ApiService.fetchHoldings(),
      builder: (context, snap) {
        if (snap.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snap.hasError) {
          return Center(child: Text('Erro: ${snap.error}'));
        }
        final data = snap.data!;
        if (data.isEmpty) {
          return const Center(child: Text('Nenhum dado disponível.'));
        }

        final maxValue =
            data.map((e) => e.value).reduce((a, b) => a > b ? a : b);

        return Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                'Patrimônio da Holding',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Cards laterais
                    SizedBox(
                      width: 220,
                      child: ListView.separated(
                        itemCount: data.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 16),
                        itemBuilder: (context, i) {
                          final item = data[i];
                          return Container(
                            height: 80,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: const [
                                BoxShadow(
                                    color: Colors.black12,
                                    blurRadius: 4,
                                    offset: Offset(0, 2))
                              ],
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 50,
                                  height: double.infinity,
                                  decoration: BoxDecoration(
                                    color: item.color,
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(12),
                                      bottomLeft: Radius.circular(12),
                                    ),
                                  ),
                                  child: Center(
                                    child: Image.asset(
                                      item.iconPath,
                                      width: 24,
                                      height: 24,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item.label,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        NumberFormat.currency(
                                                locale: 'pt_BR', symbol: 'R\$')
                                            .format(item.value),
                                        style: const TextStyle(
                                            color: Colors.black),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),

                    const SizedBox(width: 24),

                    // Gráfico de barras com tooltip
                    Expanded(
                      child: SfCartesianChart(
                        plotAreaBorderWidth: 0,
                        tooltipBehavior: TooltipBehavior(
                          enable: true,
                          builder: (dynamic dataPoint, dynamic point,
                              dynamic series, int pointIndex, int seriesIndex) {
                            final percent = (dataPoint.value / maxValue) * 100;
                            final formatted =
                                '${percent.toStringAsFixed(2).replaceAll('.', ',')}%';
                            return Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.black87,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                formatted,
                                style: const TextStyle(color: Colors.white),
                              ),
                            );
                          },
                        ),
                        primaryXAxis: CategoryAxis(isVisible: false),
                        primaryYAxis: NumericAxis(
                          isVisible: false,
                          minimum: 0,
                          maximum: 100,
                        ),
                        series: <ChartSeries>[
                          ColumnSeries<HoldingItem, String>(
                            dataSource: data,
                            xValueMapper: (item, _) => item.label,
                            yValueMapper: (item, _) =>
                                (item.value / maxValue) * 100,
                            pointColorMapper: (item, _) => item.color,
                            width: 0.9,
                            spacing: 0.0,
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10),
                            ),
                            enableTooltip: true,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

/// Card usado na legenda lateral
class _LegendCard extends StatelessWidget {
  final Color color;
  final String title;
  final String subtitle;

  const _LegendCard({
    required this.color,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2))
        ],
      ),
      child: Row(
        children: [
          // Ícone/color block
          Container(
            width: 50,
            decoration: BoxDecoration(
              color: color,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                bottomLeft: Radius.circular(12),
              ),
            ),
            child: const Icon(Icons.account_balance, color: Colors.white),
          ),

          const SizedBox(width: 12),

          // Textos
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 14)),
                const SizedBox(height: 4),
                Text(subtitle, style: const TextStyle(color: Colors.black54)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _EvolucaoView extends StatelessWidget {
  const _EvolucaoView();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<LineDataItem>>(
      future: ApiService.fetchEvolution(),
      builder: (context, snap) {
        if (!snap.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final rawData = snap.data!;
        if (rawData.length < 2) {
          return const Center(
              child: Text('Dados insuficientes para exibir variação.'));
        }

        // Calcula variação percentual mês a mês
        final List<LineDataItem> percentageData = [];
        for (int i = 1; i < rawData.length; i++) {
          final previous = rawData[i - 1].value;
          final current = rawData[i].value;
          final change = ((current - previous) / previous) * 100;
          percentageData.add(LineDataItem(rawData[i].label, change));
        }

        return Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Variação Patrimonial Mensal (%)',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: SfCartesianChart(
                  tooltipBehavior: TooltipBehavior(
                    enable: true,
                    builder: (dynamic dataPoint, dynamic point, dynamic series,
                        int pointIndex, int seriesIndex) {
                      final double value = dataPoint.value;
                      final String prefix = value >= 0 ? '+' : '';
                      final String formatted =
                          '$prefix${value.toStringAsFixed(2).replaceAll('.', ',')}%';
                      return Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.black87,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          formatted,
                          style: const TextStyle(color: Colors.white),
                        ),
                      );
                    },
                  ),
                  plotAreaBorderWidth: 0,
                  primaryXAxis: CategoryAxis(
                    labelRotation: -45,
                    majorGridLines: const MajorGridLines(width: 0),
                    edgeLabelPlacement: EdgeLabelPlacement.shift,
                  ),
                  primaryYAxis: NumericAxis(
                    numberFormat: NumberFormat.decimalPattern('pt_BR'),
                    majorGridLines: const MajorGridLines(dashArray: [4, 3]),
                  ),
                  series: <ChartSeries>[
                    SplineAreaSeries<LineDataItem, String>(
                      dataSource: percentageData,
                      xValueMapper: (item, _) => item.label,
                      yValueMapper: (item, _) => item.value,
                      gradient: LinearGradient(
                        colors: [
                          const Color(0xff50d4c7).withOpacity(0.4),
                          const Color(0xff50d4c7).withOpacity(0.05),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                      borderColor: const Color(0xff50d4c7),
                      borderWidth: 3,
                      markerSettings: const MarkerSettings(
                        isVisible: true,
                        height: 8,
                        width: 8,
                        shape: DataMarkerType.circle,
                        borderColor: Colors.white,
                        borderWidth: 2,
                      ),
                      enableTooltip: true,
                    )
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
