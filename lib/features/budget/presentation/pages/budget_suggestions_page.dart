import 'package:flutter/material.dart';
import 'package:fintrack/core/theme/app_colors.dart';
import 'package:fintrack/core/theme/app_text_styles.dart';
import 'package:fintrack/core/utils/size_utils.dart';
import 'package:fintrack/core/services/n8n_service.dart';

class BudgetSuggestionsPage extends StatefulWidget {
  final String userId;

  const BudgetSuggestionsPage({super.key, required this.userId});

  @override
  State<BudgetSuggestionsPage> createState() => _BudgetSuggestionsPageState();
}

class _BudgetSuggestionsPageState extends State<BudgetSuggestionsPage> {
  final N8nService _n8nService = N8nService();
  bool _isLoading = true;
  String _errorMessage = '';
  Map<String, dynamic>? _data;

  // Dữ liệu đã parse
  List<dynamic> _yourBudgets = [];
  List<dynamic> _needsAttention = [];
  List<dynamic> _detailedSuggestions = [];

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    try {
      final result = await _n8nService.fetchBudgetSuggestions(widget.userId);
      setState(() {
        _data = result;
        _yourBudgets = result['your_budgets'] ?? [];
        _needsAttention = result['needs_attention'] ?? [];
        _detailedSuggestions = result['detailed_suggestions'] ?? [];
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  Color _getColorFromStatus(String? status) {
    if (status == 'Critical') return AppColors.red;
    if (status == 'Warning') return AppColors.orange;
    return AppColors.green;
  }

  Color _getColorFromPercent(num percent) {
    if (percent > 100) return AppColors.red;
    if (percent >= 80) return AppColors.orange;
    return AppColors.main; // Green for under 100%
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
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Budget",
              style: AppTextStyles.heading1.copyWith(
                color: AppColors.white,
                fontSize: 24,
              ),
            ),
            Text(
              "Suggestions",
              style: AppTextStyles.heading1.copyWith(
                color: AppColors.white,
                fontSize: 24,
              ),
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Icon(
              Icons.lightbulb_outline,
              color: AppColors.main,
              size: 32,
            ),
          ),
        ],
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

    // Trạng thái Success - Hiển thị dữ liệu từ API
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
              final spent = (budget['spent'] ?? 0).toDouble();
              final limit = (budget['limit'] ?? 1).toDouble();
              final percent = (budget['percent'] ?? 0).toDouble();
              final status = budget['status'] as String?;
              final color = status != null
                  ? _getColorFromStatus(status)
                  : _getColorFromPercent(percent);

              return Padding(
                padding: EdgeInsets.only(bottom: h * 0.02),
                child: _buildBudgetUsageCard(
                  context,
                  category,
                  spent,
                  limit,
                  percent / 100,
                  color,
                ),
              );
            }),

            // Section: Needs Attention
            if (_needsAttention.isNotEmpty) ...[
              SizedBox(height: h * 0.02),
              Text(
                "Needs Attention",
                style: AppTextStyles.heading2.copyWith(color: AppColors.white),
              ),
              SizedBox(height: h * 0.02),
              Container(
                padding: EdgeInsets.all(w * 0.04),
                decoration: BoxDecoration(
                  color: AppColors.widget,
                  borderRadius: BorderRadius.circular(16),
                  border: Border(
                    left: BorderSide(color: AppColors.orange, width: 4),
                  ),
                ),
                child: Column(
                  children: _needsAttention.asMap().entries.map((entry) {
                    final index = entry.key;
                    final item = entry.value;
                    final category = item['category'] ?? 'Unknown';
                    final budget = (item['budget'] ?? 0).toDouble();
                    final spent = (item['spent'] ?? 0).toDouble();
                    final overspentBy = (item['overspentBy'] ?? 0).toDouble();

                    return Column(
                      children: [
                        _buildAttentionItem(
                          context,
                          category,
                          budget,
                          spent,
                          overspentBy,
                        ),
                        if (index < _needsAttention.length - 1)
                          Divider(color: AppColors.grey.withOpacity(0.2)),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ],

            // Section: Detailed Suggestions
            if (_detailedSuggestions.isNotEmpty) ...[
              SizedBox(height: h * 0.04),
              Text(
                "Detailed Suggestions",
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
                  children: _detailedSuggestions.asMap().entries.map((entry) {
                    final index = entry.key;
                    final item = entry.value;
                    final category = item['category'] ?? 'Unknown';
                    final currentBudget = (item['currentBudget'] ?? 0)
                        .toDouble();
                    final recommended =
                        (item['recommendedBudget'] ?? item['recommended'] ?? 0)
                            .toDouble();
                    final currentUsage =
                        item['currentUsage']?.toString() ?? '0%';
                    final adjustment = item['adjustment'] ?? '';
                    final isIncrease = recommended > currentBudget;

                    return Column(
                      children: [
                        _buildDetailedItem(
                          context,
                          category,
                          currentBudget,
                          recommended,
                          currentUsage,
                          adjustment,
                          isIncrease: isIncrease,
                        ),
                        if (index < _detailedSuggestions.length - 1)
                          Divider(color: AppColors.grey.withOpacity(0.2)),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ],

            SizedBox(height: h * 0.04),
          ],
        ),
      ),
    );
  }

  Widget _buildBudgetUsageCard(
    BuildContext context,
    String title,
    double spent,
    double total,
    double progress,
    Color color,
  ) {
    final w = SizeUtils.width(context);
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
                "\$${spent.toInt()} / \$${total.toInt()}",
                style: AppTextStyles.body1.copyWith(color: AppColors.white),
              ),
            ],
          ),
          SizedBox(height: 10),
          LinearProgressIndicator(
            value: progress > 1 ? 1 : progress,
            backgroundColor: AppColors.grey.withOpacity(0.3),
            color: color,
            minHeight: 8,
            borderRadius: BorderRadius.circular(4),
          ),
          SizedBox(height: 10),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              "${(progress * 100).toInt()}% used",
              style: AppTextStyles.caption.copyWith(color: color),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSuggestionBar(
    BuildContext context,
    String title,
    double spent,
    double progress,
    Color color,
  ) {
    final w = SizeUtils.width(context);
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
                "Spent: \$${spent.toInt()}",
                style: AppTextStyles.body2.copyWith(color: AppColors.grey),
              ),
            ],
          ),
          SizedBox(height: 10),
          LinearProgressIndicator(
            value: progress > 1 ? 1 : progress,
            backgroundColor: AppColors.grey.withOpacity(0.3),
            color: color,
            minHeight: 8,
            borderRadius: BorderRadius.circular(4),
          ),
          SizedBox(height: 10),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              "${(progress * 100).toInt()}% used",
              style: AppTextStyles.caption.copyWith(color: color),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAttentionItem(
    BuildContext context,
    String title,
    double budget,
    double spent,
    double overspent,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.warning_amber_rounded,
                color: AppColors.orange,
                size: 20,
              ),
              SizedBox(width: 8),
              Text(
                title,
                style: AppTextStyles.body1.copyWith(color: AppColors.white),
              ),
            ],
          ),
          SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Budget: \$${budget.toInt()}",
                style: AppTextStyles.caption.copyWith(color: AppColors.grey),
              ),
              Text(
                "Spent: \$${spent.toInt()}",
                style: AppTextStyles.caption.copyWith(color: AppColors.white),
              ),
            ],
          ),
          SizedBox(height: 4),
          Text(
            "Overspent by \$$overspent",
            style: AppTextStyles.body2.copyWith(color: AppColors.orange),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailedItem(
    BuildContext context,
    String title,
    double currentBudget,
    double recommended,
    String currentUsage,
    String adjustment, {
    required bool isIncrease,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                isIncrease ? Icons.trending_up : Icons.trending_down,
                color: isIncrease
                    ? AppColors.main
                    : AppColors.main, // Using main green for trend
                size: 20,
              ),
              SizedBox(width: 8),
              Text(
                title,
                style: AppTextStyles.body1.copyWith(color: AppColors.white),
              ),
            ],
          ),
          SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Current Budget",
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.grey,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    "\$${currentBudget.toInt()}",
                    style: AppTextStyles.body1.copyWith(color: AppColors.white),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Recommended",
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.grey,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    "\$${recommended.toInt()}",
                    style: AppTextStyles.body1.copyWith(color: AppColors.main),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Current Usage",
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.grey,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    currentUsage,
                    style: AppTextStyles.body1.copyWith(
                      color: isIncrease ? AppColors.white : AppColors.red,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Adjustment",
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.grey,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    adjustment,
                    style: AppTextStyles.body1.copyWith(color: AppColors.main),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
