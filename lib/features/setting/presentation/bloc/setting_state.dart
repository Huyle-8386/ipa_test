part of 'setting_bloc.dart';

abstract class SettingState {}

class SettingInitial extends SettingState {}

class SettingLoaded extends SettingState {
  final List<SettingCardEntity> cards;
  final String userName;

  SettingLoaded({required this.cards, required this.userName});
}
