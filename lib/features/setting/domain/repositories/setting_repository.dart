import '../entities/setting_card_entity.dart';

abstract class SettingRepository {
  List<SettingCardEntity> getSettingCards();
}
