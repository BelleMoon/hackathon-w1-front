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
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwt_token');

    final response = await http.get(
      Uri.parse('$_baseUrl/patrimony'),
      headers: {
        'auth': token ?? '',
        'Content-Type': 'application/json',
        'accept': 'application/json',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Erro ao carregar alocação: ${response.statusCode}');
    }

    final Map<String, dynamic> body = jsonDecode(response.body);
    final Map<String, String> patrimony =
        Map<String, String>.from(body['patrimony']);

    final Map<String, Color> colors = {
      'stocks': Colors.blue,
      'real_estate_funds': Colors.green,
      'investment_funds': Colors.orange,
      'fixed_income': Colors.purple,
      'companies': Colors.red,
      'real_estate': Colors.brown,
      'others': Colors.grey,
    };

    final Map<String, String> labels = {
      'stocks': 'Ações',
      'real_estate_funds': 'Fundos Imobiliários',
      'investment_funds': 'Fundos de Investimento',
      'fixed_income': 'Renda Fixa',
      'companies': 'Empresas',
      'real_estate': 'Imóveis',
      'others': 'Outros',
    };

    final entries = patrimony.entries
        .map((e) => MapEntry(e.key, double.tryParse(e.value) ?? 0.0));
    final total = entries.fold(0.0, (sum, entry) => sum + entry.value);

    return entries.map((entry) {
      final percent = total > 0 ? (entry.value / total) * 100 : 0.0;
      return AllocationItem(
        labels[entry.key] ?? entry.key,
        percent,
        colors[entry.key] ?? Colors.black,
      );
    }).toList();
  }

  static Future<List<HoldingItem>> fetchHoldings() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwt_token');

    final response = await http.get(
      Uri.parse('$_baseUrl/patrimony'),
      headers: {
        'auth': token ?? '',
        'Content-Type': 'application/json',
        'accept': 'application/json',
      },
    );

    final data = jsonDecode(response.body)['patrimony'] as Map<String, dynamic>;

    final List<Color> predefinedColors = [
      Colors.blue,
      Colors.orange,
      Colors.green,
      Colors.purple,
      Colors.red,
      Colors.teal,
      Colors.brown,
    ];

    final List<String> labels = [
      'Ações',
      'Fundos Imobiliários',
      'Fundos de Investimento',
      'Títulos de Renda Fixa',
      'Empresas fora da Bolsa',
      'Bens Imobiliários',
      'Outros Bens',
    ];

    final List<String> keys = [
      'stocks',
      'real_estate_funds',
      'investment_funds',
      'fixed_income',
      'companies',
      'real_estate',
      'others',
    ];

    return List.generate(keys.length, (i) {
      final valueStr = data[keys[i]] ?? '0';
      final value = double.tryParse(valueStr.toString()) ?? 0.0;
      return HoldingItem(
        label: labels[i],
        value: value,
        color: predefinedColors[i % predefinedColors.length],
        iconPath: 'assets/icones/${keys[i]}.png', // ajuste conforme necessário
      );
    });
  }

  static Future<List<LineDataItem>> fetchEvolution() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwt_token');

    final response = await http.get(
      Uri.parse('$_baseUrl/patrimony/patrimony-history'),
      headers: {
        'auth': token ?? '',
        'Content-Type': 'application/json',
        'accept': 'application/json',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Erro ao buscar histórico patrimonial');
    }

    final data = jsonDecode(response.body);
    final List<dynamic> evolutionList = data['evolution'];

    return evolutionList
        .map((e) => LineDataItem(
              e['month'] ?? '',
              (e['value'] ?? 0).toDouble(),
            ))
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

  static Future<bool> updateUserData({
    required String name,
    required String email,
    required String cpf,
    String? profileImageBase64,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwt_token');
    if (token == null) return false;

    final body = {
      'name': name,
      'username': '',
      'email': email,
      'cpf': cpf,
    };

    if (profileImageBase64 != null) {
      body['profile_image'] = profileImageBase64;
    }

    final response = await http.put(
      Uri.parse('$_baseUrl/account/update'),
      headers: {
        'auth': token,
        'Content-Type': 'application/json',
      },
      body: jsonEncode(body),
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
        'patrimony': {
          'stocks': data['Ações'] ?? 0,
          'real_estate_funds': data['Fundos Imobiliários'] ?? 0,
          'investment_funds': data['Fundos de Investimento'] ?? 0,
          'fixed_income': data['Títulos de Renda Fixa'] ?? 0,
          'companies': data['Empresas fora da Bolsa'] ?? 0,
          'real_estate': data['Bens Imobiliários'] ?? 0,
          'others': data['Outros Bens'] ?? 0,
        }
      }),
    );

    return response.statusCode == 200;
  }
}
