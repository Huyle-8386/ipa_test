import 'package:equatable/equatable.dart';

abstract class MoneySourceEvent extends Equatable {
  const MoneySourceEvent();
  @override
  List<Object?> get props => [];
}

class LoadMoneySources extends MoneySourceEvent {
  final String uid;
  const LoadMoneySources(this.uid);
}
