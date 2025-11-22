import 'package:equatable/equatable.dart';
import '../../../domain/entities/money_source_entity.dart';

class MoneySourceState extends Equatable {
  final bool loading;
  final List<MoneySourceEntity> items;

  const MoneySourceState({required this.loading, required this.items});

  factory MoneySourceState.initial() =>
      const MoneySourceState(loading: false, items: []);

  MoneySourceState copyWith({bool? loading, List<MoneySourceEntity>? items}) {
    return MoneySourceState(
      loading: loading ?? this.loading,
      items: items ?? this.items,
    );
  }

  @override
  List<Object?> get props => [loading, items];
}
