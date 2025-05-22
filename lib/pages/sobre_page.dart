import 'package:flutter/material.dart';
import '../widgets/footer.dart';
import '../widgets/topbar.dart';

class SobrePage extends StatelessWidget {
  const SobrePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff5f5f5),
      appBar: const TopBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // HERO SECTION
            Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/imagens/bg-sobre.jpg'),
                  fit: BoxFit.cover,
                  alignment: Alignment.center,
                ),
              ),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 64, horizontal: 24),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.6),
                ),
                child: Column(
                  children: const [
                    Text(
                      'Transformando Patrimônio em Legado',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Combinamos expertise jurídica, financeira e tecnológica para proteger e evoluir o patrimônio de famílias e empresas.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // QUEM SOMOS
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: const [
                  Text(
                    'Quem Somos',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xff0e1a1f),
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'A W1 é uma holding de participações e consultoria patrimonial que une tecnologia de ponta com uma equipe altamente especializada para oferecer soluções completas e inteligentes na gestão de patrimônio, sucessão familiar e estruturação de empresas.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, color: Colors.black87),
                  ),
                  SizedBox(height: 12),
                  Text(
                    'Com atuação nacional e foco na excelência, a W1 proporciona segurança, performance e transparência aos seus clientes, auxiliando na construção de um legado duradouro.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, color: Colors.black87),
                  ),
                ],
              ),
            ),

            // VALORES
            Container(
              padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 24),
              color: Colors.white,
              child: Column(
                children: [
                  const Text(
                    'Nossos Pilares',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xff0e1a1f),
                    ),
                  ),
                  const SizedBox(height: 32),
                  Wrap(
                    spacing: 16,
                    runSpacing: 16,
                    alignment: WrapAlignment.center,
                    children: const [
                      _ValorBox(
                        emoji: '⚖️',
                        titulo: 'Excelência Jurídica',
                        descricao:
                            'Equipe qualificada que cuida de cada detalhe legal com segurança.',
                      ),
                      _ValorBox(
                        emoji: '📊',
                        titulo: 'Estratégia Financeira',
                        descricao:
                            'Planejamento para proteger, rentabilizar e expandir o patrimônio.',
                      ),
                      _ValorBox(
                        emoji: '💡',
                        titulo: 'Inovação Tecnológica',
                        descricao:
                            'Plataformas digitais para acompanhar holdings e processos.',
                      ),
                      _ValorBox(
                        emoji: '🤝',
                        titulo: 'Relacionamento Humano',
                        descricao:
                            'Atendimento consultivo, próximo e personalizado.',
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // NÚMEROS
            Container(
              padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 24),
              color: const Color(0xff0e1a1f),
              child: Column(
                children: [
                  const Text(
                    'Nossos Números',
                    style: TextStyle(
                      fontSize: 24,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 32),
                  Wrap(
                    spacing: 16,
                    runSpacing: 16,
                    alignment: WrapAlignment.center,
                    children: const [
                      _NumeroBox(
                          numero: '+200', descricao: 'Holdings Estruturadas'),
                      _NumeroBox(
                          numero: '+15 anos', descricao: 'de Experiência'),
                      _NumeroBox(
                          numero: 'R\$ 4 bi+',
                          descricao: 'em Patrimônio Acompanhado'),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const Footer(),
    );
  }
}

class _ValorBox extends StatelessWidget {
  final String emoji;
  final String titulo;
  final String descricao;

  const _ValorBox({
    required this.emoji,
    required this.titulo,
    required this.descricao,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: 250,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xfff0f0f0),
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 6)],
      ),
      child: Column(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 32)),
          const SizedBox(height: 8),
          Text(
            titulo,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Color(0xff0e1a1f),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            descricao,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 14, color: Colors.black87),
          ),
        ],
      ),
    );
  }
}

class _NumeroBox extends StatelessWidget {
  final String numero;
  final String descricao;

  const _NumeroBox({required this.numero, required this.descricao});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 400),
      width: 160,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xff1c2a31),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Text(
            numero,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xff50d4c7),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            descricao,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white70),
          ),
        ],
      ),
    );
  }
}
