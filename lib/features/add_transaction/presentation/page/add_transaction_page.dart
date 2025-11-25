import 'dart:io';

import 'package:fintrack/core/theme/app_colors.dart';
import 'package:fintrack/core/theme/app_text_styles.dart';
import 'package:fintrack/core/utils/size_utils.dart';
import 'package:fintrack/core/di/injector.dart';

import 'package:fintrack/features/add_transaction/presentation/bloc/add_tx_bloc.dart';
import 'package:fintrack/features/add_transaction/presentation/bloc/add_tx_event.dart';
import 'package:fintrack/features/add_transaction/presentation/bloc/add_tx_state.dart';
import 'package:fintrack/features/add_transaction/presentation/bloc/image_entry_bloc.dart';
import 'package:fintrack/features/add_transaction/presentation/bloc/image_entry_event.dart';
import 'package:fintrack/features/add_transaction/presentation/bloc/image_entry_state.dart';
import 'package:fintrack/features/add_transaction/presentation/widget/image_entry.dart';
import 'package:fintrack/features/add_transaction/presentation/widget/manual_form.dart';
import 'package:fintrack/features/add_transaction/presentation/widget/manual_entry.dart';
import 'package:fintrack/features/add_transaction/presentation/page/transaction_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

class AddTransactionPage extends StatefulWidget {
  const AddTransactionPage({super.key});

  @override
  State<AddTransactionPage> createState() => _AddTransactionPageState();
}

class _AddTransactionPageState extends State<AddTransactionPage> {
  final amountCtrl = TextEditingController();
  final dateCtrl = TextEditingController();
  final moneyCtrl = TextEditingController();
  final merchantCtrl = TextEditingController();
  final ImagePicker _imagePicker = ImagePicker();
  File? _selectedImage;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    amountCtrl.dispose();
    dateCtrl.dispose();
    moneyCtrl.dispose();
    merchantCtrl.dispose();
    super.dispose();
  }

  Future<void> _openGallery() async {
    final picked = await _imagePicker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        _selectedImage = File(picked.path);
      });
    }
  }

  void _uploadSelectedImage(BuildContext context) {
    if (_selectedImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select an image first')),
      );
      return;
    }
    final state = context.read<AddTxBloc>().state;
    if (state is! AddTxLoaded) return;

    context.read<ImageEntryBloc>().add(
          UploadImageRequested(
            image: _selectedImage!,
            moneySources: state.moneySources,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    final h = SizeUtils.height(context);
    final w = SizeUtils.width(context);
    return MultiBlocProvider(
      providers: [
        BlocProvider<AddTxBloc>(
          create: (_) => sl<AddTxBloc>()..add(AddTxInitEvent()),
        ),
        BlocProvider<ImageEntryBloc>(
          create: (_) => sl<ImageEntryBloc>(),
        ),
      ],
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          title: Text(
            "Add transaction",
            style: AppTextStyles.body1.copyWith(color: AppColors.white),
          ),
          backgroundColor: AppColors.background,
          iconTheme: const IconThemeData(color: AppColors.white),
        ),

        // ========================= BODY =========================
        body: MultiBlocListener(
          listeners: [
            BlocListener<ImageEntryBloc, ImageEntryState>(
              listenWhen: (previous, current) =>
                  current is ImageEntryUploadSuccess ||
                  current is ImageEntryFailure,
              listener: (context, state) {
                if (state is ImageEntryUploadSuccess) {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => TransactionDetailPage(
                        transaction: state.transaction,
                      ),
                    ),
                  );
                } else if (state is ImageEntryFailure) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(state.message)),
                  );
                }
              },
            ),
          ],
          child: BlocBuilder<AddTxBloc, AddTxState>(
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

              if (state is! AddTxLoaded) {
                return const SizedBox.shrink();
              }

              final imageState = context.watch<ImageEntryBloc>().state;
              final isUploading = imageState is ImageEntryUploading;

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
                            active: state.tab == EntryTab.manual,
                            icon: "assets/icons/manual_entry.png",
                            text: "Manual Entry",

                            onTap: () => context.read<AddTxBloc>().add(
                              AddTxTabChangedEvent(EntryTab.manual),
                            ),
                          ),
                        ),
                        Expanded(
                          child: ManualEntry(
                            active: state.tab == EntryTab.image,
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
                  Expanded(
                    child: SingleChildScrollView(
                      padding: EdgeInsets.symmetric(
                        horizontal: w * 0.05,
                        vertical: h * 0.03,
                      ),
                      child: state.tab == EntryTab.manual
                          ? ManualForm(
                              h: h,
                              w: w,
                              state: state,
                              amountCtrl: amountCtrl,
                              dateCtrl: dateCtrl,
                              moneyCtrl: moneyCtrl,
                              merchantCtrl: merchantCtrl,
                            )
                          : Stack(
                              alignment: Alignment.topCenter,
                              children: [
                                AbsorbPointer(
                                  absorbing: isUploading,
                                  child: ImageEntry(
                                    h: h,
                                    w: w,
                                    selectedImage: _selectedImage,
                                    // Keep UI unchanged; block taps instead of altering labels or styles.
                                    isUploading: false,
                                    onSelectImage: _openGallery,
                                    onUpload: _selectedImage == null
                                        ? null
                                        : () => _uploadSelectedImage(context),
                                  ),
                                ),
                                if (isUploading && _selectedImage != null) ...[
                                  Positioned(
                                    top: 0,
                                    child: Container(
                                      height: h * 0.4,
                                      width: w,
                                      decoration: BoxDecoration(
                                        color: AppColors.background
                                            .withOpacity(0.25),
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    top: 0,
                                    child: SizedBox(
                                      height: h * 0.4,
                                      width: w,
                                      child: const Center(
                                        child: SizedBox(
                                          height: 34,
                                          width: 34,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 3,
                                            valueColor:
                                                AlwaysStoppedAnimation<Color>(
                                              AppColors.main,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                    ),
                  ),
                ],
              );
            },
          ),
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
          listenWhen: (previous, current) =>
              current is AddTxSubmitSuccess || current is AddTxError,
          listener: (context, state) {
            if (state is AddTxSubmitSuccess) {
              final msg = state.isEdit
                  ? 'Transaction updated'
                  : 'Saved transaction';
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(msg)));
              if (state.isEdit) {
                Navigator.pop(context, state.transaction);
              } else {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        TransactionDetailPage(transaction: state.transaction),
                  ),
                );
              }
            }
            if (state is AddTxError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.error)), //
              );
            }
          },
          builder: (context, state) {
            final h = SizeUtils.height(context);

            final imageState = context.watch<ImageEntryBloc>().state;
            final isUploading = imageState is ImageEntryUploading;
            final isLoading = state is AddTxLoading || isUploading;
            final AddTxLoaded? baseState = state is AddTxLoaded ? state : null;
            final isImageTab = baseState?.tab == EntryTab.image;
            final buttonText = baseState?.tab == EntryTab.manual
                ? (baseState!.isEdit
                      ? 'Update transaction'
                      : baseState.type == TransactionType.expense
                      ? 'Add Expense Transaction'
                      : 'Add Income Transaction')
                : 'Select Image Now';
            final canSubmit = baseState != null && !isUploading;
            final isButtonBlocked = isLoading || !canSubmit;
            return BottomAppBar(
              color: AppColors.widget,
              child: SizedBox(
                height: h * 0.1,
                child: AbsorbPointer(
                  absorbing: isButtonBlocked,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.main,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () async {
                      if (isButtonBlocked) return;
                      if (isImageTab) {
                        await _openGallery();
                        return;
                      }
                      context.read<AddTxBloc>().add(AddTxSubmitEvent());
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(buttonText, style: AppTextStyles.body2),
                        if (isLoading) ...[
                          const SizedBox(width: 10),
                          const SizedBox(
                            height: 18,
                            width: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.5,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                AppColors.main,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
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
