import 'package:fintrack/core/theme/app_colors.dart';
import 'package:fintrack/core/theme/app_text_styles.dart';
import 'package:fintrack/core/utils/size_utils.dart';
import 'package:fintrack/core/di/injector.dart';

import 'package:fintrack/features/add_transaction/presentation/bloc/add_tx_bloc.dart';
import 'package:fintrack/features/add_transaction/presentation/bloc/add_tx_event.dart';
import 'package:fintrack/features/add_transaction/presentation/bloc/add_tx_state.dart';
import 'package:fintrack/features/add_transaction/presentation/widget/image_entry.dart';
import 'package:fintrack/features/add_transaction/presentation/widget/manual_form.dart';
import 'package:fintrack/features/add_transaction/presentation/widget/manual_entry.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddTransactionPage extends StatefulWidget {
  const AddTransactionPage({super.key});

  @override
  State<AddTransactionPage> createState() => _AddTransactionPageState();
}

class _AddTransactionPageState extends State<AddTransactionPage> {
  final amountCtrl = TextEditingController();
  final dateCtrl = TextEditingController();
  final moneyCtrl = TextEditingController();
  final noteCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
  }
  @override
  void dispose() {
    amountCtrl.dispose();
    dateCtrl.dispose();
    moneyCtrl.dispose();
    noteCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final h = SizeUtils.height(context);
    final w = SizeUtils.width(context);
    return BlocProvider<AddTxBloc>(
      create: (_) => sl<AddTxBloc>()..add(AddTxInitEvent()),
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          title: Text(
            "Add transaction",
            style: AppTextStyles.body1.copyWith(color: AppColors.white),
          ),
          backgroundColor: AppColors.background,
        ),

        // ========================= BODY =========================
        body: BlocBuilder<AddTxBloc, AddTxState>(
          builder: (context, state) {
            if (state is AddTxLoading || state is AddTxInitial) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is AddTxError) {
              return Center(
                child: Text(
                  state.error,
                  style: const TextStyle(color: Colors.red),
                ),
              );
            }

            final s = state as AddTxLoaded;

            return Column(
              children: [
                // ======== TAB HEADER ========
                Container(
                  height: h * 0.1,
                  width: w,
                  color: AppColors.widget,
                  child: Row(
                    children: [
                      Expanded(
                        child: ManualEntry(
                          active: s.tab == EntryTab.manual,
                          icon: "assets/icons/manual_entry.png",
                          text: "Manual Entry",

                          onTap: () => context.read<AddTxBloc>().add(
                            AddTxTabChangedEvent(EntryTab.manual),
                          ),
                        ),
                      ),
                      Expanded(
                        child: ManualEntry(
                          active: s.tab == EntryTab.image,
                          icon: "assets/icons/image_entry.png",
                          text: "Image Entry",
                          onTap: () => context.read<AddTxBloc>().add(
                            AddTxTabChangedEvent(EntryTab.image),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: h * 0.01),

                // ======== BODY CONTENT ========
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: w * 0.05,
                    vertical: h * 0.03,
                  ),
                  child: s.tab == EntryTab.manual
                      ? ManualForm(
                          h: h,
                          w: w,
                          state: s,
                          amountCtrl: amountCtrl,
                          dateCtrl: dateCtrl,
                          moneyCtrl: moneyCtrl,
                          noteCtrl: noteCtrl,
                        )
                      : ImageEntry(h: h, w: w),
                ),
              ],
            );
          },
        ),
        // bottomNavigationBar: BlocBuilder<AddTxBloc, AddTxState>(
        //   builder: (context, state) {
        //     if (state is! AddTxLoaded) return const SizedBox.shrink();
        //     final s = state;

        //     return BottomAppBar(
        //       color: AppColors.widget,
        //       child: Container(
        //         height: h * 0.1,
        //         decoration: BoxDecoration(
        //           color: AppColors.main,
        //           borderRadius: BorderRadius.circular(10),
        //         ),
        //         child: Center(
        //           child: Text(
        //             s.tab == EntryTab.manual
        //                 ? (s.type == TransactionType.expense
        //                       ? "Add Expense Transaction"
        //                       : "Add Income Transaction")
        //                 : "Select Image Now",
        //             style: AppTextStyles.body2.copyWith(fontSize: 18),
        //           ),
        //         ),
        //       ),
        //     );
        //   },
        // ),

        bottomNavigationBar: BlocConsumer<AddTxBloc, AddTxState>(
          listener: (context,state){
            if (state is AddTxSubmitSuccess) {
              // đóng màn / show snackbar
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Saved transaction')),
              );
              // Navigator.pop(context);
            }
            if (state is AddTxError) {
                ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("error submit")),
                );
            }

          },
          builder: (context,state){
            final h = SizeUtils.height(context);

            final isLoading = state is AddTxLoading;
            return BottomAppBar(
                color: AppColors.widget,
                child: SizedBox(
                  height: h * 0.1,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.main,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: isLoading
                        ? null
                        : () {
                            context.read<AddTxBloc>().add(AddTxSubmitEvent());
                          },
                    child: isLoading
                        ? const CircularProgressIndicator()
                        : Text(
                            state is AddTxLoaded && state.tab == EntryTab.manual
                                ? (state.type == TransactionType.expense
                                    ? 'Add Expense Transaction'
                                    : 'Add Income Transaction')
                                : 'Select Image Now',
                            style: AppTextStyles.body2,
                          ),
                  ),
                ),
              );
          },



          
      
        ),


      ),
    );
  }
}
