class CategoryEntity {
  final String id;
  final String name;
  final String icon; // path assets / url
  final bool isIncome;

  const CategoryEntity({
    required this.id,
    required this.name,
    required this.icon,
    required this.isIncome,
  });
}