import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/holding_status.dart';

// MODELOS
class AllocationItem {
  final String name;
  final double percent;
  final Color color;
  AllocationItem(this.name, this.percent, this.color);
}

class LineDataItem {
  final String label;
  final double value;
  LineDataItem(this.label, this.value);
}

class HoldingItem {
  final String label;
  final double value;
  final Color color;
  final String iconPath;
  HoldingItem({
    required this.label,
    required this.value,
    required this.color,
    required this.iconPath,
  });
}

// API SERVICE
class ApiService {
  static const _baseUrl = 'http://localhost:3000';

  static Future<List<AllocationItem>> fetchAllocation() async {
    final resp = await http.get(Uri.parse('$_baseUrl/allocation'));
    final list = jsonDecode(resp.body) as List;
    return list.map((e) {
      Color c =
          Color(int.parse(e['color'].substring(1), radix: 16) + 0xFF000000);
      return AllocationItem(e['name'], e['percent'].toDouble(), c);
    }).toList();
  }

  static Future<List<HoldingItem>> fetchHoldings() async {
    final resp = await http.get(Uri.parse('$_baseUrl/holdings'));
    final list = jsonDecode(resp.body) as List;

    return list.map((e) {
      final hex = (e['color'] as String).substring(1);
      return HoldingItem(
        label: e['label'] as String,
        value: (e['value'] as num).toDouble(),
        color: Color(int.parse(hex, radix: 16) + 0xFF000000),
        iconPath: e['icon'] as String,
      );
    }).toList();
  }

  static Future<List<LineDataItem>> fetchEvolution() async {
    final resp = await http.get(Uri.parse('$_baseUrl/evolution'));
    final list = jsonDecode(resp.body) as List;
    return list
        .map((e) => LineDataItem(e['label'], e['value'].toDouble()))
        .toList();
  }

  static Future<List<HoldingStatus>> fetchHoldingsStatus() async {
    final resp = await http.get(Uri.parse('$_baseUrl/holdings_status'));
    final list = jsonDecode(resp.body) as List;
    return list.map((e) => HoldingStatus.fromJson(e)).toList();
  }
}
