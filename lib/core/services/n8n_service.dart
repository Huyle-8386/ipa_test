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

  /// Hàm hỗ trợ làm sạch giá trị tiền tệ - loại bỏ ký hiệu $ và định dạng lại
  dynamic _cleanCurrencyValue(dynamic value) {
    if (value == null) return value;
    if (value is String) {
      // Loại bỏ ký hiệu $ và các ký tự không phải số
      String cleaned = value.replaceAll('\$', '').replaceAll(',', '').trim();
      // Nếu là số hợp lệ, trả về số
      final parsed = double.tryParse(cleaned);
      if (parsed != null) return parsed;
      return cleaned;
    }
    if (value is Map) {
      return _cleanMapCurrencyValues(value as Map<String, dynamic>);
    }
    if (value is List) {
      return value.map((item) => _cleanCurrencyValue(item)).toList();
    }
    return value;
  }

  /// Làm sạch tất cả giá trị tiền tệ trong Map
  Map<String, dynamic> _cleanMapCurrencyValues(Map<String, dynamic> data) {
    final cleanedData = <String, dynamic>{};
    data.forEach((key, value) {
      cleanedData[key] = _cleanCurrencyValue(value);
    });
    return cleanedData;
  }

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
        Map<String, dynamic> result;
        if (data is List && data.isNotEmpty) {
          result = data.first as Map<String, dynamic>;
        } else {
          result = data as Map<String, dynamic>;
        }
        // Làm sạch dữ liệu tiền tệ (loại bỏ ký hiệu $)
        return _cleanMapCurrencyValues(result);
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
        Map<String, dynamic> result;
        if (data is List && data.isNotEmpty) {
          result = data.first as Map<String, dynamic>;
        } else {
          result = data as Map<String, dynamic>;
        }
        // Làm sạch dữ liệu tiền tệ (loại bỏ ký hiệu $)
        return _cleanMapCurrencyValues(result);
      } else {
        throw Exception(
          'Failed to load monthly report: ${response.statusCode}',
        );
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
        Map<String, dynamic> result;
        if (data is List && data.isNotEmpty) {
          result = data.first as Map<String, dynamic>;
        } else {
          result = data as Map<String, dynamic>;
        }
        // Làm sạch dữ liệu tiền tệ (loại bỏ ký hiệu $)
        return _cleanMapCurrencyValues(result);
      } else {
        throw Exception('Failed to load budget alerts: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error connecting to n8n: $e');
    }
  }
}
