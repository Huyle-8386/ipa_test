class MoneySourceEntity {
  final String id;
  final String name;
  final String icon;
  final double balance;

  MoneySourceEntity({
    required this.id,
    required this.name,
    required this.icon,
    required this.balance,
  });

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'icon': icon, 'balance': balance};
  }
}
