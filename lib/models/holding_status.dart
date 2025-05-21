import 'package:flutter/material.dart';

class HoldingStatus {
  final String nome;
  final String socios;
  final bool concluido;
  final List<EtapaStatus> etapas;

  HoldingStatus({
    required this.nome,
    required this.socios,
    required this.concluido,
    required this.etapas,
  });

  factory HoldingStatus.fromJson(Map<String, dynamic> json) {
    return HoldingStatus(
      nome: json['nome'],
      socios: json['socios'],
      concluido: json['concluido'],
      etapas:
          (json['etapas'] as List).map((e) => EtapaStatus.fromJson(e)).toList(),
    );
  }
}

class EtapaStatus {
  final String titulo;
  final String descricao;
  final String status;

  EtapaStatus({
    required this.titulo,
    required this.descricao,
    required this.status,
  });

  factory EtapaStatus.fromJson(Map<String, dynamic> json) {
    return EtapaStatus(
      titulo: json['titulo'],
      descricao: json['descricao'],
      status: json['status'],
    );
  }

  Color get cor {
    switch (status) {
      case 'aprovado':
        return Colors.green;
      case 'concluido':
        return Colors.blue;
      case 'pendente':
      default:
        return Colors.red;
    }
  }
}
