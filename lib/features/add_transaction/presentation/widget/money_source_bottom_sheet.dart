import 'package:fintrack/core/theme/app_colors.dart';
import 'package:fintrack/core/theme/app_text_styles.dart';
import 'package:fintrack/core/utils/size_utils.dart';
import 'package:fintrack/features/add_transaction/domain/entities/money_source_entity.dart';

import 'package:fintrack/features/add_transaction/presentation/bloc/add_tx_bloc.dart';
import 'package:fintrack/features/add_transaction/presentation/bloc/add_tx_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MoneySourceBottomSheet extends StatelessWidget {
  const MoneySourceBottomSheet({super.key});
  static Future<String?> show(BuildContext context) {
    final bloc = context.read<AddTxBloc>();
    return showModalBottomSheet<String>(
      context: context,
      backgroundColor: AppColors.background,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
      ),
      builder: (_) => BlocProvider.value(
        value: bloc, // 👈 cung cấp lại bloc cho subtree sheet
        child: const MoneySourceBottomSheet(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final h = SizeUtils.height(context);
    final w = SizeUtils.width(context);
    // String? selected;
    // final st = context.read<AddTxBloc>().state;
    // if (st is AddTxLoaded) selected = st.moneySource;

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
                child: BlocBuilder<AddTxBloc, AddTxState>(
                  builder: (context, state) {
                    if (state is! AddTxLoaded) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    final String? selectedName = state.moneySource;
                    final List<MoneySourceEntity> sources = state.moneySources;

                    return GridView.builder(
                      itemCount: sources?.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            mainAxisSpacing: 12,
                            crossAxisSpacing: 12,
                            childAspectRatio: 1,
                          ),
                      itemBuilder: (_, index) {
                        final item = sources[index];
                        final bool isSelected =
                            (selectedName != null && selectedName == item.name);
                        return InkWell(
                          borderRadius: BorderRadius.circular(10),
                          onTap: () => Navigator.pop(context, item.name),
                          child: Container(
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? AppColors.main.withOpacity(
                                      0.10,
                                    ) // nền mờ khi đang chọn
                                  : AppColors.widget,
                              border: Border.all(
                                color: isSelected
                                    ? AppColors.main
                                    : AppColors.grey,
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),

                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: w * 0.01,
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(item.icon),
                                  Text(
                                    item.name,

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
