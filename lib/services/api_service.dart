import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/holding_status.dart';
import '../models/patrimonio_models.dart';

// API SERVICE
class ApiService {
  static const _baseUrl = 'http://localhost:5432';

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

  static Future<String?> login(String email, String senha) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'senha': senha}),
    );

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      return body['access_token']; // JWT Token
    } else {
      return null;
    }
  }

  static Future<bool> register({
    required String nome,
    required String usuario,
    required String email,
    required String senha,
  }) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'nome': nome,
        'usuario': usuario,
        'email': email,
        'senha': senha,
      }),
    );

    return response.statusCode == 201;
  }

  // GET com token JWT
  static Future<http.Response> getWithAuth(String path) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwt_token');

    return http.get(
      Uri.parse('$_baseUrl$path'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );
  }
}
