// enum TransactionType { expense, income }

class Category {
  final String name;
  final String icon;

  Category({required this.name, required this.icon});
}

List<Category> expenseCategories = [
  Category(icon: 'assets/images/groeries.png', name: "Groceries"),
  Category(icon: 'assets/images/shopping.png', name: "Shopping"),
  Category(icon: 'assets/images/food.png', name: "Food"),

  Category(icon: 'assets/images/health.png', name: "Health"),

  Category(icon: 'assets/images/travel.png', name: "Travel"),

  Category(icon: 'assets/images/taxi.png', name: "Taxi"),
];

final List<Category> incomeCategories = [
  Category(icon: 'assets/images/business.png', name: 'Business'),
  Category(icon: 'assets/images/salary.png', name: 'Salary'),
  Category(icon: 'assets/images/profit.png', name: 'Profit'),
  Category(icon: 'assets/images/reward.png', name: 'Reward'),
  Category(icon: 'assets/images/collections.png', name: 'Collections'),
  Category(icon: 'assets/images/allowance.png', name: 'Allowance'),
];
