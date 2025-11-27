import 'package:intl/intl.dart';

class CurrencyFormatter {
  /// Format số tiền theo định dạng Việt Nam
  /// Ví dụ: 20000 -> "20.000"
  ///        1500000 -> "1.500.000"
  static String formatVND(double amount) {
    final formatter = NumberFormat('#,###', 'vi_VN');
    return formatter.format(amount).replaceAll(',', '.');
  }

  /// Format số tiền với ký hiệu tiền tệ
  /// Ví dụ: 20000 -> "20.000"
  ///        1500000 -> "1.500.000"
  static String formatVNDWithSymbol(double amount) {
    return '${formatVND(amount)}';
  }

  /// Format số tiền với ký hiệu tiền tệ đầy đủ
  /// Ví dụ: 20000 -> "20.000 VND"
  ///        1500000 -> "1.500.000 VND"
  static String formatVNDWithCurrency(double amount) {
    return '${formatVND(amount)} VND';
  }

  /// Parse chuỗi tiền Việt Nam về số
  /// Ví dụ: "20.000" -> 20000
  ///        "1.500.000" -> 1500000
  static double parseVND(String amount) {
    // Loại bỏ dấu chấm và ký hiệu tiền tệ
    String cleaned = amount
        .replaceAll('.', '')
        .replaceAll('đ', '')
        .replaceAll('VND', '')
        .trim();
    return double.tryParse(cleaned) ?? 0.0;
  }

  /// Format số tiền với màu sắc dựa trên loại (thu nhập/chi tiêu)
  /// Trả về Map với 'text' và 'isPositive'
  static Map<String, dynamic> formatWithType({
    required double amount,
    required bool isIncome,
    bool showSymbol = true,
  }) {
    final formatted = showSymbol
        ? formatVNDWithSymbol(amount.abs())
        : formatVND(amount.abs());
    return {'text': formatted, 'isPositive': isIncome};
  }
}
