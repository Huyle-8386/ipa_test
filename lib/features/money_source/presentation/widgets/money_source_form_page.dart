// lib/features/money_source/presentation/pages/money_source_form_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/money_source_entity.dart';
import '../bloc/money_source_bloc.dart';
import '../bloc/money_source_event.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/size_utils.dart';
import 'balance_input_field.dart';
import 'icon_dropdown_field.dart';
import 'name_input_field.dart';

class MoneySourceFormPage extends StatefulWidget {
  final String uid;
  final MoneySourceEntity? moneySource;
  final MoneySourceBloc bloc;

  const MoneySourceFormPage({
    super.key,
    required this.uid,
    required this.bloc,
    this.moneySource,
  });

  @override
  State<MoneySourceFormPage> createState() => _MoneySourceFormPageState();
}

class _MoneySourceFormPageState extends State<MoneySourceFormPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _iconController;
  late TextEditingController _balanceController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(
      text: widget.moneySource?.name ?? '',
    );
    _iconController = TextEditingController(
      text: widget.moneySource?.icon ?? '',
    );
    _balanceController = TextEditingController(
      text: (widget.moneySource?.balance ?? 0).toString(),
    );

    _fixSelection(_nameController);
    _fixSelection(_iconController);
    _fixSelection(_balanceController);
  }

  void _fixSelection(TextEditingController controller) {
    controller.selection = TextSelection.fromPosition(
      TextPosition(offset: controller.text.length),
    );
    controller.addListener(() {
      final textLength = controller.text.length;
      final selection = controller.selection;
      if (selection.start > textLength || selection.end > textLength) {
        controller.selection = TextSelection.fromPosition(
          TextPosition(offset: textLength),
        );
      }
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _iconController.dispose();
    _balanceController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final entity = MoneySourceEntity(
        id: widget.moneySource?.id ?? '',
        name: _nameController.text.trim(),
        icon: _iconController.text.trim(),
        balance: double.tryParse(_balanceController.text) ?? 0,
      );

      if (widget.moneySource == null) {
        widget.bloc.add(
          AddMoneySourceEvent(uid: widget.uid, moneySource: entity),
        );
      } else {
        widget.bloc.add(
          UpdateMoneySourceEvent(uid: widget.uid, moneySource: entity),
        );
      }

      Navigator.pop(context);
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
        leading: const BackButton(color: AppColors.white),
        title: Text(
          widget.moneySource == null ? 'Add Money Source' : 'Edit Money Source',
          style: AppTextStyles.body1.copyWith(color: AppColors.white),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: w * 0.05,
            vertical: h * 0.02,
          ),
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: const BorderSide(color: AppColors.grey, width: 1),
            ),
            color: AppColors.widget,
            elevation: 4,
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: w * 0.05,
                vertical: h * 0.03,
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    NameInputField(
                      controller: _nameController,
                    ), // dùng lại widget có sẵn
                    SizedBox(height: h * 0.025),
                    IconDropdownField(controller: _iconController),
                    SizedBox(height: h * 0.025),
                    BalanceInputField(controller: _balanceController),
                    SizedBox(height: h * 0.035),
                    // Save button
                    SizedBox(
                      width: double.infinity,
                      height: h * 0.065,
                      child: ElevatedButton(
                        onPressed: _submit,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.main,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          'Save',
                          style: AppTextStyles.body2.copyWith(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
