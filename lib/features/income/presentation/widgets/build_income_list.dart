// Widget cho danh sách thu nhập
import 'package:fintrack/features/income/domain/entities/income_entity.dart';
import 'package:flutter/material.dart';

// Chấp nhận danh sách từ bên ngoài thay vì sử dụng danh sách tĩnh
Widget buildIncomeList(List<IncomeEntity> incomeItems) {
  return Column(
    children: incomeItems.map((income) => buildIncomeListItem(income)).toList(),
  );
}

// Widget cho một mục trong danh sách
// Đổi thành public để có thể gọi từ bên ngoài
Widget buildIncomeListItem(IncomeEntity income) {
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
              color: income.color,
              shape: BoxShape.circle,
            ),
            child: Image.asset(income.icon),
          ),
          const SizedBox(width: 12),
          Expanded(
            // Sử dụng Expanded để tránh overflow text
            flex: 2,
            child: Text(
              income.name,
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
                  income.amount,
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
                      income.percentage,
                      style: TextStyle(
                        color: income.isUp
                            ? Colors.greenAccent
                            : Colors.redAccent,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(width: 2),
                    Icon(
                      income.isUp ? Icons.arrow_upward : Icons.arrow_downward,
                      color: income.isUp
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
Widget buildEmptyIncomeList() {
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
