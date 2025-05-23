import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/holding_status.dart';
import '../models/patrimonio_models.dart';

// API SERVICE
class ApiService {
  static const _baseUrl = 'http://localhost:9000';

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
      Uri.parse('$_baseUrl/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': senha}),
    );

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      return body['access_token'];
    } else {
      debugPrint('Erro login: ${response.statusCode}');
      debugPrint('Corpo: ${response.body}');
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
      Uri.parse('$_baseUrl/auth/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'name': nome,
        'username': usuario,
        'email': email,
        'password': senha,
      }),
    );

    return response.statusCode == 200;
  }

  static Future<Map<String, dynamic>?> getUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwt_token');

    if (token == null) return null;

    final response = await http.get(
      Uri.parse('$_baseUrl/account/me'),
      headers: {
        'auth': token, // <- Aqui está o cabeçalho correto!
        'Content-Type': 'application/json',
        'accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      if (body['success'] == true) {
        return body['user_data'];
      }
    } else {
      print('Erro ao buscar dados do usuário: ${response.statusCode}');
      print('Corpo da resposta: ${response.body}');
    }

    return null;
  }

  // Atualiza o CPF do usuário
  static Future<bool> updateCPF(String cpf) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwt_token');

    if (token == null) return false;

    final response = await http.put(
      Uri.parse('$_baseUrl/account/update'),
      headers: {
        'auth': token,
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'cpf': cpf,
      }),
    );

    return response.statusCode == 200;
  }

  // Atualiza os valores do patrimônio
  static Future<bool> updatePatrimony(Map<String, double> data) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwt_token');

    if (token == null) return false;

    final response = await http.put(
      Uri.parse('$_baseUrl/patrimony/update'),
      headers: {
        'auth': token,
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'stocks': data['Ações'] ?? 0,
        'real_estate_funds': data['Fundos Imobiliários'] ?? 0,
        'investment_funds': data['Fundos de Investimento'] ?? 0,
        'fixed_income': data['Títulos de Renda Fixa'] ?? 0,
        'companies': data['Empresas fora da Bolsa'] ?? 0,
        'real_estate': data['Bens Imobiliários'] ?? 0,
        'others': data['Outros Bens'] ?? 0,
      }),
    );

    return response.statusCode == 200;
  }
}
