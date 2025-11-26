import 'dart:convert';
import 'package:http/http.dart' as http;

class N8nService {
  // Thay thế bằng URL Production của bạn từ n8n
  // Ví dụ: 'https://your-n8n-instance.com/webhook'
  final String _baseUrl = 'https://n8n-vietnam.id.vn/webhook';

  // Singleton pattern để dùng chung 1 instance
  static final N8nService _instance = N8nService._internal();
  factory N8nService() => _instance;
  N8nService._internal();

  // ============================================================
  // Hàm gọi API Budget Suggestions (Flutter2.json)
  // Trả về: your_budgets, needs_attention, detailed_suggestions
  // ============================================================
  Future<Map<String, dynamic>> fetchBudgetSuggestions(String userId) async {
    final url = Uri.parse('$_baseUrl/budget-suggestions?userId=$userId');
    
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        // n8n có thể trả về dạng list hoặc object, cần xử lý
        if (data is List && data.isNotEmpty) {
          return data.first as Map<String, dynamic>;
        }
        return data as Map<String, dynamic>;
      } else {
        throw Exception('Failed to load suggestions: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error connecting to n8n: $e');
    }
  }

  // ============================================================
  // Hàm gọi API Monthly Report (Flutter1.json)
  // Trả về: totalSpending, transactionCount, topCategories, recurringServices, ai_suggestions
  // ============================================================
  Future<Map<String, dynamic>> fetchMonthlyReport(String userId) async {
    final url = Uri.parse('$_baseUrl/monthly-report?userId=$userId');
    
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data is List && data.isNotEmpty) {
          return data.first as Map<String, dynamic>;
        }
        return data as Map<String, dynamic>;
      } else {
        throw Exception('Failed to load monthly report: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error connecting to n8n: $e');
    }
  }

  // ============================================================
  // Hàm gọi API Budget Alerts (Flutter3.json)
  // Trả về: ui_data.your_budgets, ui_data.near_limit, ui_data.exceeded_budgets
  // ============================================================
  Future<Map<String, dynamic>> fetchBudgetAlerts(String userId) async {
    final url = Uri.parse('$_baseUrl/budget-alerts?userId=$userId');
    
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data is List && data.isNotEmpty) {
          return data.first as Map<String, dynamic>;
        }
        return data as Map<String, dynamic>;
      } else {
        throw Exception('Failed to load budget alerts: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error connecting to n8n: $e');
    }
  }
}