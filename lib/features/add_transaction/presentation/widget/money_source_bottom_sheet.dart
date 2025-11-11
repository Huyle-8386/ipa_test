import 'package:fintrack/core/theme/app_colors.dart';
import 'package:fintrack/core/theme/app_text_styles.dart';
import 'package:fintrack/core/utils/size_utils.dart';
import 'package:fintrack/features/add_transaction/data/datasource/resource_money.dart';
import 'package:flutter/material.dart';

class MoneySourceBottomSheet extends StatelessWidget {
  const MoneySourceBottomSheet({super.key});
  static Future<String?> show(BuildContext context) {
    return showModalBottomSheet<String>(
      context: context,
      backgroundColor: AppColors.background,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
      ),
      builder: (_) => const MoneySourceBottomSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final h = SizeUtils.height(context);
    final w = SizeUtils.width(context);
    return SizedBox(
      height: h * 0.5,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: w * 0.05,
          vertical: h * 0.015,
        ),
        child: Column(
          children: [
            Row(
              children: [
                SizedBox(),
                Expanded(
                  flex: 2,
                  child: Text(
                    "Select money source",
                    textAlign: TextAlign.center,
                    style: AppTextStyles.body2.copyWith(color: AppColors.white),
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: IconButton(
                    icon: const Icon(Icons.close),
                    color: AppColors.white,
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
              ],
            ),
            SizedBox(height: h * 0.02),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.widget,
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: EdgeInsets.symmetric(
                  horizontal: w * 0.03,
                  vertical: h * 0.02,
                ),
                child: GridView.builder(
                  itemCount: listResourceMoney.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 1,
                  ),
                  itemBuilder: (_, index) {
                    final item = listResourceMoney[index];
                    return InkWell(
                      borderRadius: BorderRadius.circular(10),
                      onTap: () => Navigator.pop(context, item.resource),
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppColors.widget,
                          border: Border.all(color: AppColors.grey),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding:  EdgeInsets.symmetric(horizontal: w*0.01),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(item.images),
                              Text(
                                item.resource,
            
                                overflow: TextOverflow.ellipsis,
                                style: AppTextStyles.body1.copyWith(
                                  color: AppColors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
