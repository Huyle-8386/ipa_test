// import 'package:fintrack/features/add_transaction/data/datasource/category.dart';
import 'dart:io';

import 'package:fintrack/features/add_transaction/presentation/bloc/add_tx_state.dart';
import 'package:fintrack/features/add_transaction/domain/entities/transaction_entity.dart';
import 'package:fintrack/features/add_transaction/domain/entities/category_entity.dart';

// enum EntryTab { manual, image }

abstract class AddTxEvent {}

class AddTxInitEvent extends AddTxEvent {}

class AddTxInitEditEvent extends AddTxEvent {
  final TransactionEntity transaction;
  AddTxInitEditEvent(this.transaction);
}

class AddTxTabChangedEvent extends AddTxEvent {
  final EntryTab tab;
  AddTxTabChangedEvent(this.tab);
}

class AddTxTypeChangedEvent extends AddTxEvent {
  final TransactionType type;
  AddTxTypeChangedEvent(this.type);
}

class AddTxCategorySelectedEvent extends AddTxEvent {
  final CategoryEntity category;
  AddTxCategorySelectedEvent(this.category);
}

class AddTxAmountChangedEvent extends AddTxEvent {
  final String amount;
  AddTxAmountChangedEvent(this.amount);
}

class AddTxDateChangedEvent extends AddTxEvent {
  final String date; // yyyy-MM-dd
  AddTxDateChangedEvent(this.date);
}

class AddTxMoneySourceChangedEvent extends AddTxEvent {
  final String moneySource;
  AddTxMoneySourceChangedEvent(this.moneySource);
}

class AddTxMerchantChangedEvent extends AddTxEvent {
  final String merchant;
  AddTxMerchantChangedEvent(this.merchant);
}

class AddTxSubmitEvent extends AddTxEvent {}

class UploadImageEvent extends AddTxEvent {
  final File image;

  UploadImageEvent(this.image);
}
