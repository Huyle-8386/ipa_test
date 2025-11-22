import '../../domain/entities/setting_card_entity.dart';
import '../../domain/repositories/setting_repository.dart';
import '../datasource/setting_datasource.dart';

class SettingRepositoryImpl implements SettingRepository {
  final SettingDatasource datasource;

  SettingRepositoryImpl({required this.datasource});

  @override
  List<SettingCardEntity> getSettingCards() {
    return datasource.getSettingCards();
  }
}
