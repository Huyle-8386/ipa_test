import 'package:equatable/equatable.dart';
import '../../domain/entities/money_source_entity.dart';

abstract class MoneySourceEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadMoneySources extends MoneySourceEvent {
  final String uid;
  LoadMoneySources({required this.uid});
  @override
  List<Object?> get props => [uid];
}

class AddMoneySourceEvent extends MoneySourceEvent {
  final String uid;
  final MoneySourceEntity moneySource;
  AddMoneySourceEvent({required this.uid, required this.moneySource});
  @override
  List<Object?> get props => [uid, moneySource];
}

class UpdateMoneySourceEvent extends MoneySourceEvent {
  final String uid;
  final MoneySourceEntity moneySource;
  UpdateMoneySourceEvent({required this.uid, required this.moneySource});
  @override
  List<Object?> get props => [uid, moneySource];
}

class DeleteMoneySourceEvent extends MoneySourceEvent {
  final String uid;
  final String id;
  DeleteMoneySourceEvent({required this.uid, required this.id});
  @override
  List<Object?> get props => [uid, id];
}
