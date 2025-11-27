import 'package:flutter/material.dart';
import 'package:fintrack/core/theme/app_colors.dart';
import 'package:fintrack/core/theme/app_text_styles.dart';
import 'package:fintrack/core/utils/size_utils.dart';
import 'package:fintrack/core/services/n8n_service.dart';
import 'package:fintrack/core/utils/currency_formatter.dart';

class MonthlyReportPage extends StatefulWidget {
  final String userId;

  const MonthlyReportPage({super.key, required this.userId});

  @override
  State<MonthlyReportPage> createState() => _MonthlyReportPageState();
}

class _MonthlyReportPageState extends State<MonthlyReportPage> {
  final N8nService _n8nService = N8nService();
  bool _isLoading = true;
  String _errorMessage = '';

  // Dữ liệu từ API (Flutter1.json)
  double _totalSpending = 0;
  int _transactionCount = 0;
  List<Map<String, dynamic>> _topCategories = [];
  List<Map<String, dynamic>> _recurringServices = [];
  String _aiSuggestions = '';
  double _maxCategoryAmount = 0; // Để tính tỷ lệ progress bar

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  // Helper function để parse số an toàn
  double _parseDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }

  int _parseInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is num) return value.toInt();
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }

  Future<void> _fetchData() async {
    try {
      final result = await _n8nService.fetchMonthlyReport(widget.userId);

      setState(() {
        // Hỗ trợ cả snake_case và camelCase từ API
        _totalSpending = _parseDouble(
          result['total_spending'] ?? result['totalSpending'],
        );
        _transactionCount = _parseInt(
          result['transaction_count'] ?? result['transactionCount'],
        );

        // Parse topCategories - hỗ trợ cả 2 format key
        final topCategoriesData =
            result['top_categories'] ?? result['topCategories'];
        if (topCategoriesData is List) {
          // Chuyển đổi format: sum_amount -> amount, categoryName -> name
          _topCategories = topCategoriesData.map<Map<String, dynamic>>((item) {
            return {
              'name': item['categoryName'] ?? item['name'] ?? 'Unknown',
              'amount': _parseDouble(
                item['sum_amount'] ?? item['amount'] ?? item['total'],
              ),
              'icon':
                  item['first_categoryIcon'] ??
                  item['categoryIcon'] ??
                  item['icon'] ??
                  '',
            };
          }).toList();

          // Tính max amount để làm 100% cho progress bar
          if (_topCategories.isNotEmpty) {
            _maxCategoryAmount = _topCategories
                .map((e) => _parseDouble(e['amount']))
                .reduce((a, b) => a > b ? a : b);
          }
        } else if (topCategoriesData is String) {
          // Parse từ text dạng "- Dining: 450\n- Groceries: 300"
          _topCategories = _parseTextToCategories(topCategoriesData);
          if (_topCategories.isNotEmpty) {
            _maxCategoryAmount = _topCategories
                .map((e) => _parseDouble(e['amount']))
                .reduce((a, b) => a > b ? a : b);
          }
        }

        // Parse recurringServices - hỗ trợ cả 2 format
        final recurringData =
            result['recurring_services'] ?? result['recurringServices'];
        if (recurringData is List) {
          _recurringServices = recurringData.map<Map<String, dynamic>>((item) {
            return {
              'name': item['name'] ?? item['merchant'] ?? 'Unknown',
              'amount': _parseDouble(item['amount'] ?? item['sum_amount']),
              'icon': item['icon'] ?? item['categoryIcon'] ?? '',
            };
          }).toList();
        } else if (recurringData is String) {
          _recurringServices = _parseTextToRecurring(recurringData);
        }

        // AI Suggestions - hỗ trợ nhiều format key
        _aiSuggestions =
            result['ai_suggestions']?.toString() ??
            result['suggestions']?.toString() ??
            result['ai_analysis']?.toString() ??
            'No suggestions available for this month.';

        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  // Parse text "- Dining: 450.75" thành list categories
  List<Map<String, dynamic>> _parseTextToCategories(String text) {
    final List<Map<String, dynamic>> categories = [];
    final lines = text.split('\n');

    for (var line in lines) {
      line = line.trim();
      if (line.startsWith('- ')) {
        line = line.substring(2);
        final parts = line.split(':');
        if (parts.length >= 2) {
          final name = parts[0].trim();
          final amountStr = parts[1]
              .trim()
              .replaceAll('\$', '')
              .replaceAll(',', '');
          final amount = double.tryParse(amountStr) ?? 0;
          categories.add({'name': name, 'amount': amount});
        }
      }
    }
    return categories;
  }

  // Parse text "- Netflix: $15.49" thành list recurring
  List<Map<String, dynamic>> _parseTextToRecurring(String text) {
    return _parseTextToCategories(text); // Same format
  }

  // Mapping màu theo tên category - dựa trên AppColors
  static final Map<String, Color> _categoryColorMap = {
    'fnb': AppColors.brightOrange,
    'groceries': AppColors.green,
    'shopping': AppColors.orange,
    'transportation': AppColors.blue,
    'travel': AppColors.purple,
    'health': AppColors.turquoise,
    'salary': AppColors.purple,
    'business': AppColors.turquoise,
    'allowance': AppColors.brightOrange,
    'profit': AppColors.green,
    'reward': AppColors.scarlet,
    'collections': AppColors.royalBlue,
  };

  // Helper để lấy màu dựa trên tên category
  Color _getCategoryColor(String categoryName) {
    final key = categoryName.toLowerCase().trim();
    return _categoryColorMap[key] ?? AppColors.grey;
  }

  // Helper để lấy icon path dựa trên category name
  String _getIconPath(String categoryName) {
    final key = categoryName.toLowerCase().trim();
    return 'assets/images/$key.png';
  }

  @override
  Widget build(BuildContext context) {
    final h = SizeUtils.height(context);
    final w = SizeUtils.width(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.white),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: Column(
          children: [
            Text(
              "Monthly Report",
              style: AppTextStyles.heading1.copyWith(
                color: AppColors.white,
                fontSize: 24,
              ),
            ),
            Container(
              height: 4,
              width: 100,
              margin: const EdgeInsets.only(top: 4),
              decoration: BoxDecoration(
                color: AppColors.main,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ],
        ),
      ),
      body: _buildBody(context, h, w),
    );
  }

  Widget _buildBody(BuildContext context, double h, double w) {
    // Trạng thái Loading
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.main),
      );
    }

    // Trạng thái Error
    if (_errorMessage.isNotEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, color: AppColors.red, size: 48),
            SizedBox(height: 16),
            Text(
              'Unable to load data',
              style: AppTextStyles.heading2.copyWith(color: AppColors.white),
            ),
            SizedBox(height: 8),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: w * 0.1),
              child: Text(
                _errorMessage,
                style: AppTextStyles.caption.copyWith(color: AppColors.grey),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _isLoading = true;
                  _errorMessage = '';
                });
                _fetchData();
              },
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.main),
              child: Text('Retry', style: TextStyle(color: AppColors.white)),
            ),
          ],
        ),
      );
    }

    // Trạng thái Success
    return RefreshIndicator(
      onRefresh: _fetchData,
      color: AppColors.main,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.all(w * 0.05),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section: Overview
            Text(
              "Overview",
              style: AppTextStyles.heading2.copyWith(color: AppColors.white),
            ),
            SizedBox(height: h * 0.01),
            Container(
              padding: EdgeInsets.all(w * 0.04),
              decoration: BoxDecoration(
                color: AppColors.widget,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Align(
                    alignment: Alignment.topRight,
                    child: Icon(Icons.bar_chart, color: AppColors.grey),
                  ),
                  Text(
                    "Here's a summary of your financial activity this month. Based on AI analysis, you can see suggestions below.",
                    style: AppTextStyles.body2.copyWith(color: AppColors.grey),
                  ),
                ],
              ),
            ),
            SizedBox(height: h * 0.02),

            // Stats Cards
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    context,
                    "Total Spending",
                    CurrencyFormatter.formatVNDWithSymbol(_totalSpending),
                    Icons.account_balance_wallet,
                  ),
                ),
                SizedBox(width: w * 0.04),
                Expanded(
                  child: _buildStatCard(
                    context,
                    "Transactions",
                    "$_transactionCount",
                    Icons.receipt_long,
                  ),
                ),
              ],
            ),

            // Section: Top 5 Spending Categories
            if (_topCategories.isNotEmpty) ...[
              SizedBox(height: h * 0.04),
              Text(
                "Top ${_topCategories.length} Spending Categories",
                style: AppTextStyles.heading2.copyWith(color: AppColors.white),
              ),
              SizedBox(height: h * 0.02),
              Container(
                padding: EdgeInsets.all(w * 0.04),
                decoration: BoxDecoration(
                  color: AppColors.widget,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: _topCategories.asMap().entries.map((entry) {
                    final index = entry.key;
                    final item = entry.value;
                    final name =
                        item['name'] ?? item['categoryName'] ?? 'Unknown';
                    final amount = _parseDouble(
                      item['amount'] ?? item['total'],
                    );
                    // Ưu tiên icon từ API, nếu không có thì tự tạo từ tên category
                    String iconPath =
                        item['icon'] ??
                        item['first_categoryIcon'] ??
                        item['categoryIcon'] ??
                        '';
                    if (iconPath.isEmpty || !iconPath.startsWith('assets/')) {
                      iconPath = _getIconPath(name);
                    }
                    final color = _getCategoryColor(name);

                    // Tính progress dựa trên max amount (item đầu tiên = 100%)
                    final progress = _maxCategoryAmount > 0
                        ? amount / _maxCategoryAmount
                        : 0.0;

                    return Column(
                      children: [
                        _buildCategoryItem(
                          context,
                          name,
                          amount,
                          color,
                          iconPath,
                          progress,
                        ),
                        if (index < _topCategories.length - 1)
                          SizedBox(height: 16),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ],

            // Section: Recurring Services
            if (_recurringServices.isNotEmpty) ...[
              SizedBox(height: h * 0.04),
              Text(
                "Recurring Services",
                style: AppTextStyles.heading2.copyWith(color: AppColors.white),
              ),
              SizedBox(height: h * 0.02),
              Container(
                padding: EdgeInsets.all(w * 0.04),
                decoration: BoxDecoration(
                  color: AppColors.widget,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: _recurringServices.asMap().entries.map((entry) {
                    final index = entry.key;
                    final item = entry.value;
                    final name = item['name'] ?? 'Unknown';
                    final amount = _parseDouble(item['amount']);
                    String iconPath = item['icon'] ?? '';
                    // Lấy category từ icon path để xác định màu (ví dụ: assets/images/shopping.png -> shopping)
                    String categoryFromIcon = '';
                    if (iconPath.isNotEmpty && iconPath.contains('/')) {
                      final parts = iconPath.split('/');
                      categoryFromIcon = parts.last.replaceAll('.png', '');
                    }
                    final color = _getCategoryColor(
                      categoryFromIcon.isNotEmpty ? categoryFromIcon : name,
                    );

                    return Column(
                      children: [
                        _buildRecurringItem(
                          context,
                          name,
                          amount,
                          color,
                          iconPath,
                        ),
                        if (index < _recurringServices.length - 1)
                          Divider(color: AppColors.grey.withOpacity(0.2)),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ],

            // Section: AI Suggestions
            SizedBox(height: h * 0.04),
            Text(
              "Suggestions & Recommendations",
              style: AppTextStyles.heading2.copyWith(color: AppColors.main),
            ),
            SizedBox(height: h * 0.02),
            Container(
              padding: EdgeInsets.all(w * 0.04),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.widget, AppColors.widget.withOpacity(0.8)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.grey.withOpacity(0.2)),
              ),
              child: Text(
                _aiSuggestions,
                style: AppTextStyles.body2.copyWith(color: AppColors.grey),
              ),
            ),
            SizedBox(height: h * 0.05),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(
    BuildContext context,
    String title,
    String value,
    IconData icon,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.widget,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: AppColors.grey, size: 16),
              const SizedBox(width: 8),
              Text(
                title,
                style: AppTextStyles.caption.copyWith(color: AppColors.grey),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: AppTextStyles.heading1.copyWith(
              color: AppColors.white,
              fontSize: 24,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryItem(
    BuildContext context,
    String title,
    double amount,
    Color color,
    String iconPath,
    double progress,
  ) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.grey.withOpacity(0.15),
            borderRadius: BorderRadius.circular(8),
          ),
          child: _buildIcon(iconPath, color),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.body1.copyWith(color: AppColors.white),
                  ),
                  Text(
                    CurrencyFormatter.formatVNDWithSymbol(amount),
                    style: AppTextStyles.body1.copyWith(color: AppColors.white),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              LinearProgressIndicator(
                value: progress.clamp(0.0, 1.0),
                backgroundColor: AppColors.grey.withOpacity(0.2),
                color: color,
                minHeight: 4,
                borderRadius: BorderRadius.circular(2),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRecurringItem(
    BuildContext context,
    String title,
    double amount,
    Color color,
    String iconPath,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: _buildIcon(iconPath, color),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: AppTextStyles.body1.copyWith(color: AppColors.white),
            ),
          ),
          Text(
            CurrencyFormatter.formatVNDWithSymbol(amount),
            style: AppTextStyles.body1.copyWith(color: AppColors.white),
          ),
        ],
      ),
    );
  }

  // Helper để build icon từ asset path hoặc fallback icon
  Widget _buildIcon(String iconPath, Color color) {
    if (iconPath.isNotEmpty && iconPath.startsWith('assets/')) {
      return Image.asset(
        iconPath,
        width: 20,
        height: 20,
        errorBuilder: (context, error, stackTrace) {
          return Icon(Icons.attach_money, color: color, size: 20);
        },
      );
    }
    return Icon(Icons.attach_money, color: color, size: 20);
  }
}
