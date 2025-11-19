import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/setting_card_entity.dart';
import '../bloc/setting_bloc.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_text_styles.dart';
import '../../../../../core/utils/size_utils.dart';
import 'widgets/setting_card_widget.dart';

class SettingPage extends StatelessWidget {
  const SettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final h = SizeUtils.height(context);
    final w = SizeUtils.width(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: w * 0.05,
            vertical: h * 0.02,
          ),
          child: Column(
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const CircleAvatar(
                        backgroundImage: AssetImage("assets/icons/hao.png"),
                        radius: 20,
                      ),
                      SizedBox(width: w * 0.02),
                      Text(
                        "Phung Hao",
                        style: AppTextStyles.body1.copyWith(
                          color: AppColors.grey,
                        ),
                      ),
                    ],
                  ),
                  Image.asset(
                    "assets/icons/notification.png",
                    width: w * 0.06,
                    height: w * 0.06,
                    fit: BoxFit.contain,
                  ),
                ],
              ),

              SizedBox(height: h * 0.02),

              // Grid cards
              Expanded(
                child: BlocBuilder<SettingBloc, SettingState>(
                  builder: (context, state) {
                    if (state is SettingLoaded) {
                      return LayoutBuilder(
                        builder: (context, constraints) {
                          // Use the available constraints to compute a safe childAspectRatio
                          final double gridWidth = constraints.maxWidth;
                          final double gridHeight = constraints.maxHeight;
                          final double safeAspect =
                              (gridWidth / 2) / (gridHeight / 3);

                          return GridView.builder(
                            padding: EdgeInsets.symmetric(
                              horizontal: w * 0.001,
                              vertical: h * 0.005,
                            ),
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  mainAxisSpacing: h * 0.025,
                                  crossAxisSpacing: w * 0.005,
                                  childAspectRatio: safeAspect.clamp(0.85, 1.5),
                                ),
                            itemCount: state.cards.length,
                            itemBuilder: (context, index) {
                              return SettingCardWidget(
                                card: state.cards[index],
                              );
                            },
                          );
                        },
                      );
                    }

                    return const Center(child: CircularProgressIndicator());
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
