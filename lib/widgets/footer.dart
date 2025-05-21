import 'package:flutter/material.dart';

class Footer extends StatelessWidget {
  const Footer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color.fromRGBO(14, 26, 31, 1),
      padding: const EdgeInsets.all(10),
      child: Wrap(
        alignment: WrapAlignment.spaceBetween,
        runSpacing: 10,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Conheça a W1',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white)),
              const SizedBox(height: 6),
              ...[
                'W1 Consciência',
                'W1 Capital',
                'W1 Tecnologia',
                'W1 Consultoria Patrimonial'
              ].map((text) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2),
                    child: Text(text,
                        style: const TextStyle(color: Color(0xff50d4c7))),
                  )),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text('Contato:',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white)),
              SizedBox(height: 8),
              Text(
                'Endereço: R. Funchal 418 - Conjunto 1701\nVila Olímpia, São Paulo - SP, 04551-060',
                style: TextStyle(color: Colors.white),
              ),
              SizedBox(height: 4),
              Text('Telefone: (11) 3001-3007',
                  style: TextStyle(color: Color(0xff50d4c7))),
            ],
          )
        ],
      ),
    );
  }
}
