// import 'package:fintrack/features/add_transaction/data/datasource/category.dart';
import 'package:fintrack/features/add_transaction/presentation/bloc/add_tx_state.dart';

// enum EntryTab { manual, image }

abstract class AddTxEvent {}

class AddTxInitEvent extends AddTxEvent {}

class AddTxTabChangedEvent extends AddTxEvent {
  final EntryTab tab;
  AddTxTabChangedEvent(this.tab);
}

class AddTxTypeChangedEvent extends AddTxEvent {
  final TransactionType type;
  AddTxTypeChangedEvent(this.type);
}

class AddTxCategorySelectedEvent extends AddTxEvent {
  final int? index;
  AddTxCategorySelectedEvent(this.index);
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

class AddTxNoteChangedEvent extends AddTxEvent {
  final String note;
  AddTxNoteChangedEvent(this.note);
}

class AddTxSubmitEvent extends AddTxEvent {}
