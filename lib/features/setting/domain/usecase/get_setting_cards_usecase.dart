import '../entities/setting_card_entity.dart';
import '../repositories/setting_repository.dart';

class GetSettingCardsUseCase {
  final SettingRepository repository;

  GetSettingCardsUseCase({required this.repository});

  List<SettingCardEntity> call() {
    return repository.getSettingCards();
  }
}
