import '../../domain/entities/setting_card_entity.dart';

class SettingDatasource {
  List<SettingCardEntity> getSettingCards() {
    return [
      SettingCardEntity(
        iconPath: 'assets/icons/hao.png',
        title: 'Profile',
        subTitle: 'Login, authenticator',
      ),
      SettingCardEntity(
        iconPath: 'assets/icons/appearance.png',
        title: 'Appearance',
        subTitle: 'Widgets, Themes',
      ),
      SettingCardEntity(
        iconPath: 'assets/icons/general.png',
        title: 'General',
        subTitle: 'Currency, clear data and more',
      ),
      SettingCardEntity(
        iconPath: 'assets/icons/account.png',
        title: 'Account',
        subTitle: 'Account settings, alerts & notifications',
      ),
      SettingCardEntity(
        iconPath: 'assets/icons/data.png',
        title: 'Data',
        subTitle: 'Data management export and import features',
      ),
      SettingCardEntity(
        iconPath: 'assets/icons/privacy.png',
        title: 'Privacy',
        subTitle: 'Password management, privacy preferences',
      ),
    ];
  }
}
