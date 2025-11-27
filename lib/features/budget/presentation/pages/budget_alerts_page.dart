import 'package:flutter/material.dart';
import 'package:fintrack/core/theme/app_colors.dart';
import 'package:fintrack/core/theme/app_text_styles.dart';
import 'package:fintrack/core/utils/size_utils.dart';
import 'package:fintrack/core/services/n8n_service.dart';
import 'package:fintrack/core/utils/currency_formatter.dart';

class BudgetAlertsPage extends StatefulWidget {
  final String userId;

  const BudgetAlertsPage({super.key, required this.userId});

  @override
  State<BudgetAlertsPage> createState() => _BudgetAlertsPageState();
}

class _BudgetAlertsPageState extends State<BudgetAlertsPage> {
  final N8nService _n8nService = N8nService();
  bool _isLoading = true;
  String _errorMessage = '';

  // Dữ liệu từ API (Flutter3.json)
  List<dynamic> _yourBudgets = [];
  List<dynamic> _nearLimit = [];
  List<dynamic> _exceededBudgets = [];

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  // Helper function để parse số an toàn (xử lý cả String và num)
  double _parseDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }

  Future<void> _fetchData() async {
    try {
      final result = await _n8nService.fetchBudgetAlerts(widget.userId);

      // Dữ liệu từ n8n trả về dạng: ui_data.your_budgets, ui_data.near_limit, ui_data.exceeded_budgets
      final uiData = result['ui_data'] ?? result;

      setState(() {
        _yourBudgets = uiData['your_budgets'] ?? [];
        _nearLimit = uiData['near_limit'] ?? [];
        _exceededBudgets = uiData['exceeded_budgets'] ?? [];
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
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
        title: Row(
          children: [
            const Icon(Icons.notifications_outlined, color: AppColors.main),
            SizedBox(width: w * 0.02),
            Text(
              "Budget Alerts",
              style: AppTextStyles.heading2.copyWith(color: AppColors.white),
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
            // Section: Your Budgets
            Text(
              "Your Budgets",
              style: AppTextStyles.heading2.copyWith(color: AppColors.white),
            ),
            SizedBox(height: h * 0.02),
            ..._yourBudgets.map((budget) {
              final category = budget['category'] ?? 'Unknown';
              final limit = _parseDouble(budget['limit']);
              final percent = _parseDouble(budget['percent']);

              return Padding(
                padding: EdgeInsets.only(bottom: h * 0.02),
                child: _buildBudgetCard(
                  context,
                  category,
                  limit,
                  percent / 100,
                  AppColors.main,
                ),
              );
            }),

            // Section: Near Limit (Cảnh báo vàng/cam)
            if (_nearLimit.isNotEmpty) ...[
              SizedBox(height: h * 0.02),
              Text(
                "Near Limit",
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
                  children: _nearLimit.asMap().entries.map((entry) {
                    final index = entry.key;
                    final item = entry.value;
                    final category = item['category'] ?? 'Unknown';
                    final budget = _parseDouble(item['budget']);
                    final spent = _parseDouble(item['spent']);
                    final remaining = _parseDouble(
                      item['remaining'] ?? (budget - spent),
                    );

                    return Column(
                      children: [
                        _buildAlertItem(
                          context,
                          category,
                          budget,
                          spent,
                          remaining.abs(),
                          isExceeded: false,
                        ),
                        if (index < _nearLimit.length - 1)
                          Divider(color: AppColors.grey.withOpacity(0.2)),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ],

            // Section: Exceeded Budgets (Cảnh báo đỏ)
            if (_exceededBudgets.isNotEmpty) ...[
              SizedBox(height: h * 0.04),
              Text(
                "Exceeded Budgets",
                style: AppTextStyles.heading2.copyWith(color: AppColors.white),
              ),
              SizedBox(height: h * 0.02),
              Container(
                padding: EdgeInsets.all(w * 0.04),
                decoration: BoxDecoration(
                  color: AppColors.widget,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.red.withOpacity(0.5)),
                ),
                child: Column(
                  children: _exceededBudgets.asMap().entries.map((entry) {
                    final index = entry.key;
                    final item = entry.value;
                    final category = item['category'] ?? 'Unknown';
                    final budget = _parseDouble(item['budget']);
                    final spent = _parseDouble(item['spent']);
                    final overspentBy = _parseDouble(
                      item['overspentBy'] ?? (spent - budget),
                    );

                    return Column(
                      children: [
                        _buildAlertItem(
                          context,
                          category,
                          budget,
                          spent,
                          overspentBy.abs(),
                          isExceeded: true,
                        ),
                        if (index < _exceededBudgets.length - 1)
                          Divider(color: AppColors.grey.withOpacity(0.2)),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ],

            // Thông báo khi không có cảnh báo nào
            if (_nearLimit.isEmpty && _exceededBudgets.isEmpty) ...[
              SizedBox(height: h * 0.04),
              Container(
                padding: EdgeInsets.all(w * 0.04),
                decoration: BoxDecoration(
                  color: AppColors.widget,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.green.withOpacity(0.5)),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.check_circle_outline,
                      color: AppColors.green,
                      size: 32,
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        "Great! All your budgets are within the allowed range.",
                        style: AppTextStyles.body2.copyWith(
                          color: AppColors.grey,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],

            SizedBox(height: h * 0.04),
          ],
        ),
      ),
    );
  }

  Widget _buildBudgetCard(
    BuildContext context,
    String title,
    double budget,
    double progress,
    Color color,
  ) {
    final w = SizeUtils.width(context);
    // Xác định màu thanh progress bar: đỏ nếu vượt 100%, giữ nguyên color nếu không
    final progressColor = progress > 1.0 ? AppColors.red : color;
    // Giới hạn progress để hiển thị tối đa 100% trên thanh
    final displayProgress = progress > 1.0 ? 1.0 : progress;

    return Container(
      padding: EdgeInsets.all(w * 0.04),
      decoration: BoxDecoration(
        color: AppColors.widget,
        borderRadius: BorderRadius.circular(16),
      ),
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
                "${(progress * 100).toInt()}%",
                style: AppTextStyles.body1.copyWith(
                  color: progress > 1.0 ? AppColors.red : AppColors.white,
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          LinearProgressIndicator(
            value: displayProgress,
            backgroundColor: AppColors.grey.withOpacity(0.3),
            color: progressColor,
            minHeight: 8,
            borderRadius: BorderRadius.circular(4),
          ),
          SizedBox(height: 10),
          Text(
            "Budget: ${CurrencyFormatter.formatVNDWithSymbol(budget)}",
            style: AppTextStyles.body2.copyWith(color: AppColors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildAlertItem(
    BuildContext context,
    String title,
    double budget,
    double spent,
    double diff, {
    required bool isExceeded,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: isExceeded
                  ? AppColors.red.withOpacity(0.2)
                  : AppColors.orange.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(
              isExceeded ? Icons.error_outline : Icons.warning_amber_rounded,
              color: isExceeded ? AppColors.red : AppColors.orange,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.body1.copyWith(color: AppColors.white),
                ),
                const SizedBox(height: 4),
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: "Budget: ",
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.green,
                        ),
                      ),
                      TextSpan(
                        text: CurrencyFormatter.formatVNDWithSymbol(budget),
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.green,
                        ),
                      ),
                    ],
                  ),
                ),
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: "Spent: ",
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.orange,
                        ),
                      ),
                      TextSpan(
                        text: CurrencyFormatter.formatVNDWithSymbol(spent),
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.orange,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                isExceeded
                    ? "Overspent by ${CurrencyFormatter.formatVNDWithSymbol(diff)}"
                    : "Remaining: ${CurrencyFormatter.formatVNDWithSymbol(diff)}",
                style: AppTextStyles.body2.copyWith(
                  color: isExceeded ? AppColors.red : AppColors.orange,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
