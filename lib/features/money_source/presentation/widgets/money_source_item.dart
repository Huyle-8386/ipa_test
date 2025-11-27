import 'package:flutter/material.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../domain/entities/money_source_entity.dart';
import 'package:fintrack/core/theme/app_colors.dart';
import 'package:fintrack/core/theme/app_text_styles.dart';
import 'package:fintrack/core/utils/size_utils.dart';

class MoneySourceItem extends StatelessWidget {
  final MoneySourceEntity moneySource;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const MoneySourceItem({
    super.key,
    required this.moneySource,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final w = SizeUtils.width(context);
    final h = SizeUtils.height(context);

    return Container(
      margin: EdgeInsets.symmetric(horizontal: w * 0.03, vertical: h * 0.008),
      decoration: BoxDecoration(
        color: AppColors.widget,
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(
          horizontal: w * 0.04,
          vertical: h * 0.015,
        ),
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: Image.asset(
            moneySource.icon,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => Container(
              color: AppColors.grey,
              child: const Icon(Icons.image_not_supported, color: Colors.white),
            ),
          ),
        ),
        title: Text(
          moneySource.name,
          style: AppTextStyles.body1.copyWith(
            color: AppColors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(
          // 'Balance: \$${moneySource.balance.toStringAsFixed(2)}',
          'Balance: ${CurrencyFormatter.formatVNDWithSymbol(moneySource.balance)}',
          style: AppTextStyles.caption.copyWith(color: AppColors.grey),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit, color: AppColors.main),
              onPressed: onEdit,
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: AppColors.red),
              onPressed: () async {
                if (onDelete != null) {
                  // Hiện dialog xác nhận
                  final confirmed = await showDialog<bool>(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      backgroundColor: AppColors.widget, // theo theme dark
                      title: Text(
                        'Confirm Delete',
                        style: AppTextStyles.body1.copyWith(
                          color: AppColors.white,
                        ),
                      ),
                      content: Text(
                        'Are you sure you want to delete "${moneySource.name}"?',
                        style: AppTextStyles.body2.copyWith(
                          color: AppColors.grey,
                        ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(ctx).pop(false),
                          child: Text(
                            'Cancel',
                            style: AppTextStyles.body2.copyWith(
                              color: AppColors.grey,
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () => Navigator.of(ctx).pop(true),
                          child: Text(
                            'Delete',
                            style: AppTextStyles.body2.copyWith(
                              color: AppColors.red,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );

                  // Nếu người dùng xác nhận mới gọi onDelete
                  if (confirmed == true) {
                    onDelete!();
                  }
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
