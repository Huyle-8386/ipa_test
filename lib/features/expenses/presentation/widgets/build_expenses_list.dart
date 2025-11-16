// Widget cho danh sách chi tiêu
import 'package:fintrack/features/expenses/data/datasources/expenses_data.dart';
import 'package:flutter/material.dart';

// Chấp nhận danh sách chi tiêu từ bên ngoài thay vì sử dụng danh sách tĩnh
Widget buildExpenseList(List<ExpenseData> expenseItems) {
  return Column(
    children: expenseItems
        .map((expense) => buildExpenseListItem(expense))
        .toList(),
  );
}

// Widget cho một mục trong danh sách
// Đổi thành public để có thể gọi từ bên ngoài
Widget buildExpenseListItem(ExpenseData expense) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 12.0),
    child: Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF212121), // Màu nền của toàn bộ item
        borderRadius: BorderRadius.circular(10),
        // Thêm đổ bóng nhẹ để nổi bật item hơn
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 35,
            height: 35,
            decoration: BoxDecoration(
              color: expense.color,
              shape: BoxShape.circle,
            ),
            child: Image.asset(expense.icon),
          ),
          const SizedBox(width: 12),
          Expanded(
            // Sử dụng Expanded để tránh overflow text
            flex: 2,
            child: Text(
              expense.name,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
              overflow: TextOverflow.ellipsis, // Xử lý tràn text
            ),
          ),
          Expanded(
            // Sử dụng Expanded cho phần bên phải
            flex: 1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  expense.amount,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisSize:
                      MainAxisSize.min, // Row chỉ chiếm không gian cần thiết
                  children: [
                    Text(
                      expense.percentage,
                      style: TextStyle(
                        color: expense.isUp
                            ? Colors.greenAccent
                            : Colors.redAccent,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(width: 2),
                    Icon(
                      expense.isUp ? Icons.arrow_upward : Icons.arrow_downward,
                      color: expense.isUp
                          ? Colors.greenAccent
                          : Colors.redAccent,
                      size: 16,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

// Thêm widget mới để hiển thị khi danh sách trống
Widget buildEmptyExpenseList() {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.search_off, color: Colors.grey, size: 50),
        const SizedBox(height: 16),
        Text(
          "Không tìm thấy khoản chi tiêu nào",
          style: TextStyle(color: Colors.grey[400], fontSize: 16),
        ),
      ],
    ),
  );
}
