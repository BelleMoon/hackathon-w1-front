import 'package:flutter/material.dart';
import '../widgets/topbar.dart';
import '../widgets/footer.dart';
import '../models/holding_status.dart';
import '../services/api_service.dart';

class StatusPage extends StatefulWidget {
  const StatusPage({super.key});

  @override
  State<StatusPage> createState() => _StatusPageState();
}

class _StatusPageState extends State<StatusPage> {
  String? _selectedStep;

  final List<_StepInfo> _steps = const [
    _StepInfo(
      title: 'Contrato Social e Estatuto',
      description:
          'Estrutura da holding, regras de gestão e direitos dos sócios.',
    ),
    _StepInfo(
      title: 'Registro na Junta Comercial',
      description: 'Cadastro da holding na Junta Comercial do estado sede.',
    ),
    _StepInfo(
      title: 'Inscrição no CNPJ',
      description:
          'Registro da holding na Receita Federal como pessoa jurídica.',
    ),
    _StepInfo(
      title: 'Integralização de Capital',
      description:
          'Formalizar a transferência de bens ou valores para compor o capital social.',
    ),
    _StepInfo(
      title: 'Ações Adicionais',
      description:
          'Planejamento sucessório, organização contábil e registro no INSS, conforme as necessidades da holding.',
    ),
  ];

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
      body: FutureBuilder<List<HoldingStatus>>(
        future: ApiService.fetchHoldingsStatus(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final holdings = snapshot.data!;
          return LayoutBuilder(
            builder: (context, constraints) {
              final isMobile = constraints.maxWidth < 800;
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (!isMobile)
                    Container(
                      width: 300,
                      color: const Color(0xffe8ebef),
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Status das Holdings',
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black)),
                          const SizedBox(height: 24),
                          for (var step in _steps)
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  _selectedStep = step.title;
                                });
                              },
                              child: Container(
                                margin: const EdgeInsets.symmetric(vertical: 8),
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8),
                                  boxShadow: const [
                                    BoxShadow(
                                        color: Colors.black12,
                                        blurRadius: 4,
                                        offset: Offset(0, 2))
                                  ],
                                ),
                                child: Row(
                                  children: [
                                    Icon(Icons.arrow_downward,
                                        size: 16,
                                        color: _selectedStep == step.title
                                            ? Colors.blue
                                            : Colors.black45),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            step.title,
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              color: _selectedStep == step.title
                                                  ? Colors.blue
                                                  : Colors.black,
                                            ),
                                          ),
                                          if (_selectedStep == step.title)
                                            Padding(
                                              padding:
                                                  const EdgeInsets.only(top: 4),
                                              child: Text(
                                                step.description,
                                                style: const TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.blue),
                                              ),
                                            ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(24),
                      scrollDirection:
                          isMobile ? Axis.vertical : Axis.horizontal,
                      child: Flex(
                        direction: isMobile ? Axis.vertical : Axis.horizontal,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: holdings
                            .map((holding) => Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: _HoldingColumn(holding: holding),
                                ))
                            .toList(),
                      ),
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
      bottomNavigationBar: const Footer(),
    );
  }
}

class _HoldingColumn extends StatelessWidget {
  final HoldingStatus holding;

  const _HoldingColumn({required this.holding});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 6)],
      ),
      child: Column(
        children: [
          Text(holding.nome,
              style:
                  const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(holding.socios, style: const TextStyle(color: Colors.black54)),
          const SizedBox(height: 16),
          for (int i = 0; i < holding.etapas.length; i++) ...[
            _EtapaBox(etapa: holding.etapas[i]),
            if (i < holding.etapas.length - 1)
              const Icon(Icons.arrow_downward, size: 16, color: Colors.black54),
          ],
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: holding.concluido ? Colors.green : Colors.red[100],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              holding.concluido
                  ? 'PROCESSO CONCLUÍDO'
                  : 'PROCESSO NÃO CONCLUÍDO',
              style: TextStyle(
                color: holding.concluido ? Colors.white : Colors.red[900],
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          )
        ],
      ),
    );
  }
}

class _EtapaBox extends StatelessWidget {
  final EtapaStatus etapa;

  const _EtapaBox({required this.etapa});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(12),
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(color: etapa.cor),
        color: etapa.cor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(etapa.titulo,
              style: TextStyle(
                  color: etapa.cor, fontWeight: FontWeight.bold, fontSize: 14)),
          if (etapa.descricao.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              etapa.descricao,
              style: const TextStyle(fontSize: 12),
            ),
          ]
        ],
      ),
    );
  }
}

class _StepInfo {
  final String title;
  final String description;
  const _StepInfo({required this.title, required this.description});
}
