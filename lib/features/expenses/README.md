# Expenses Feature - Clean Architecture

## 📐 Cấu trúc Clean Architecture

```
expenses/
├── expenses_injection.dart          # Dependency Injection setup
├── data/                            # Data Layer (External)
│   ├── datasources/
│   │   └── expenses_data.dart       # Mock local data source
│   ├── models/
│   │   └── expense_model.dart       # Data model extends Entity + JSON serialization
│   └── repositories/
│       └── expenses_repository_impl.dart  # Repository implementation
├── domain/                          # Domain Layer (Core Business Logic)
│   ├── entities/
│   │   └── expense_entity.dart      # Pure business object
│   ├── repositories/
│   │   └── expenses_repository.dart # Repository interface (abstract)
│   └── usecases/
│       ├── get_expenses_usecase.dart     # Get expenses by category
│       ├── get_categories_usecase.dart   # Get all categories
│       └── search_expenses_usecase.dart  # Search expenses by query
└── presentation/                    # Presentation Layer (UI + State)
    ├── bloc/
    │   ├── expenses_bloc.dart       # Business logic + state management
    │   ├── expenses_event.dart      # User actions/events
    │   └── expenses_state.dart      # UI states
    ├── pages/
    │   └── expenses_page.dart       # Main expenses screen
    └── widgets/
        ├── build_chart_section.dart # Pie chart widget
        └── build_expenses_list.dart # Expenses list widget
```

## 🔄 Data Flow

### 1. Khởi tạo (LoadExpensesData)
```
ExpensesPage (initState)
    ↓
ExpensesBloc.add(LoadExpensesData)
    ↓
ExpensesBloc._onLoadExpensesData()
    ↓ (calls use cases)
GetCategoriesUsecase → ExpensesRepository → ExpensesLocalDataSource
GetExpensesUsecase → ExpensesRepository → ExpensesLocalDataSource
    ↓ (returns data)
ExpensesBloc.emit(ExpensesLoaded)
    ↓
ExpensesPage (BlocBuilder rebuilds UI)
```

### 2. Filter theo Category (FilterExpensesByCategory)
```
User taps "Weekly" category
    ↓
ExpensesBloc.add(FilterExpensesByCategory('Weekly'))
    ↓
ExpensesBloc._onFilterExpensesByCategory()
    ↓
GetExpensesUsecase.call(category: 'Weekly')
    ↓
ExpensesRepository.getExpenses(category: 'Weekly')
    ↓
ExpensesLocalDataSource.getExpenses(category: 'Weekly')
    ↓ (filters mock data based on category)
Returns List<ExpenseModel>
    ↓
ExpensesBloc.emit(ExpensesLoaded with filtered data)
    ↓
UI updates with new expenses list
```

### 3. Search (SearchExpenses)
```
User types "Food" in search bar
    ↓
ExpensesBloc.add(SearchExpenses('Food'))
    ↓
ExpensesBloc._onSearchExpenses()
    ↓
SearchExpensesUsecase.call(query: 'Food')
    ↓
ExpensesRepository.searchExpenses(query: 'Food')
    ↓
ExpensesLocalDataSource.searchExpenses(query: 'Food')
    ↓ (filters by name containing query)
Returns filtered List<ExpenseModel>
    ↓
ExpensesBloc.emit(ExpensesLoaded with search results)
    ↓
UI updates with matching expenses
```

## 🏗️ Layers Explanation

### Domain Layer (Core)
- **ExpenseEntity**: Business object với các thuộc tính: icon, color, name, value, amount, percentage, isUp
- **ExpensesRepository Interface**: Định nghĩa contract cho data operations
  - `getExpenses(category)`: Lấy expenses theo category
  - `getCategories()`: Lấy danh sách categories
  - `searchExpenses(query)`: Tìm kiếm expenses
- **Use Cases**: Mỗi use case = 1 business operation
  - Không phụ thuộc vào implementation details
  - Có thể test độc lập

### Data Layer (Implementation)
- **ExpenseModel**: Extends ExpenseEntity + thêm `fromJson/toJson`
- **ExpensesLocalDataSource**: Mock data source
  - Hiện tại: static data + filter logic
  - Tương lai: thay bằng API calls hoặc SQLite queries
- **ExpensesRepositoryImpl**: Implements domain repository interface
  - Ủy thác cho data source
  - Có thể thêm caching, error handling, data transformation

### Presentation Layer (UI)
- **ExpensesBloc**: State management với BLoC pattern
  - Nhận events từ UI
  - Gọi use cases
  - Emit states để update UI
- **ExpensesPage**: Main screen
  - BlocConsumer để listen states và handle side effects
  - Category tabs, search bar, chart, list
- **Widgets**: Reusable UI components

## 🔧 Dependency Injection

File `expenses_injection.dart` setup GetIt container:

```dart
// 1. Data source (implementation)
sl.registerLazySingleton<ExpensesLocalDataSource>(
  () => ExpensesLocalDataSourceImpl(),
);

// 2. Repository (implementation depends on data source)
sl.registerLazySingleton<ExpensesRepository>(
  () => ExpensesRepositoryImpl(sl()),
);

// 3. Use cases (depend on repository)
sl.registerLazySingleton(() => GetExpensesUsecase(sl()));
sl.registerLazySingleton(() => GetCategoriesUsecase(sl()));
sl.registerLazySingleton(() => SearchExpensesUsecase(sl()));

// 4. Bloc (factory - new instance mỗi lần, depends on use cases)
sl.registerFactory(
  () => ExpensesBloc(
    getExpenses: sl(),
    getCategories: sl(),
    searchExpenses: sl(),
  ),
);
```

### Usage trong main.dart:
```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initExpenses();  // Initialize DI
  runApp(MyApp());
}

// In widget tree:
BlocProvider(
  create: (context) => sl<ExpensesBloc>(),  // Resolve from GetIt
  child: ExpensesPage(),
)
```

## ✅ Benefits của Clean Architecture

1. **Testability**: Mỗi layer test riêng với mock dependencies
2. **Maintainability**: Thay đổi một layer không ảnh hưởng các layer khác
3. **Scalability**: Dễ thêm features mới theo cùng pattern
4. **Flexibility**: Dễ thay đổi:
   - UI framework (Bloc → Riverpod)
   - Data source (Mock → API → SQLite)
   - Business logic độc lập

## 🔄 So sánh với code cũ

### Trước (Không Clean Architecture):
- Bloc trực tiếp import và sử dụng mock data từ `expenses_data.dart`
- Logic filter nằm trong Bloc
- Không có separation of concerns
- Khó test, khó maintain

### Sau (Clean Architecture):
- Bloc chỉ biết về use cases (domain)
- Data source có thể swap dễ dàng
- Business logic tách biệt rõ ràng
- Dễ test từng layer
- Follow SOLID principles

## 🚀 Next Steps

1. **Add error handling**: Try-catch với custom exceptions
2. **Add caching**: Cache expenses data để giảm calls
3. **Add real data source**: Connect Firebase/API
4. **Add more use cases**: Update expense, Delete expense
5. **Add unit tests**: Test từng layer riêng biệt
