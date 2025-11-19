import 'package:flutter/material.dart';
import '../../../domain/entities/setting_card_entity.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_text_styles.dart';
import '../../../../../core/utils/size_utils.dart';

class SettingCardWidget extends StatelessWidget {
  final SettingCardEntity card;

  const SettingCardWidget({super.key, required this.card});

  @override
  Widget build(BuildContext context) {
    final h = SizeUtils.height(context);
    final w = SizeUtils.width(context);

    return Card(
      color: AppColors.widget,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(w * 0.03),
      ),
      elevation: 2,
      child: Padding(
        padding: EdgeInsets.fromLTRB(w * 0.04, h * 0.02, w * 0.04, h * 0.004),

        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: h * 0.07,
              width: w * 0.15,
              decoration: BoxDecoration(
                color: AppColors.white, // nền container
                borderRadius: BorderRadius.circular(12), // bo góc
              ),
              child: Image.asset(
                card.iconPath,
                width: w * 0.08,
                height: w * 0.08,
                errorBuilder: (ctx, err, stack) => SizedBox(
                  width: w * 0.08,
                  height: w * 0.08,
                  child: const Icon(Icons.image_not_supported),
                ),
              ),
            ),
            SizedBox(height: h * 0.015),
            Text(
              card.title,
              style: AppTextStyles.body1.copyWith(
                fontSize: w * 0.045,
                color: AppColors.white,
              ),
            ),
            SizedBox(height: h * 0.008),
            Text(
              card.subTitle,
              style: AppTextStyles.caption.copyWith(
                fontSize: w * 0.032,
                color: AppColors.grey,
              ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
