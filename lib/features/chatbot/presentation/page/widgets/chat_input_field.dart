import 'package:flutter/material.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_text_styles.dart';

class ChatInputField extends StatefulWidget {
  final bool isSending;
  final Function(String text) onSend;
  final VoidCallback onRegenerate;
  final double h;
  final double w;

  const ChatInputField({
    super.key,
    required this.isSending,
    required this.onSend,
    required this.onRegenerate,
    required this.h,
    required this.w,
  });

  @override
  State<ChatInputField> createState() => _ChatInputFieldState();
}

class _ChatInputFieldState extends State<ChatInputField> {
  final TextEditingController controller = TextEditingController();

  void send() {
    final text = controller.text.trim();
    if (text.isEmpty) return;

    controller.clear();
    widget.onSend(text);
  }

  @override
  Widget build(BuildContext context) {
    final h = widget.h;
    final w = widget.w;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.background,
        border: Border(top: BorderSide(color: AppColors.widget, width: 0.4)),
      ),
      padding: EdgeInsets.symmetric(horizontal: w * 0.04, vertical: h * 0.015),

      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            /// -------------------------
            /// 🔥 PHẦN HIỂN THỊ “AI đang trả lời…”
            /// -------------------------
            if (widget.isSending)
              Padding(
                padding: EdgeInsets.only(bottom: h * 0.01),
                child: Row(
                  children: [
                    SizedBox(
                      height: h * 0.018,
                      width: h * 0.018,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: AppColors.main,
                      ),
                    ),
                    SizedBox(width: w * 0.02),
                    Text(
                      "AI đang trả lời...",
                      style: AppTextStyles.body2.copyWith(
                        color: AppColors.grey,
                        fontSize: w * 0.033,
                      ),
                    ),
                  ],
                ),
              ),

            /// -------------------------
            /// THANH INPUT
            /// -------------------------
            Row(
              children: [
                Icon(
                  Icons.add_circle_outline,
                  color: AppColors.grey,
                  size: w * 0.065,
                ),

                SizedBox(width: w * 0.03),

                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: w * 0.04),
                    decoration: BoxDecoration(
                      color: AppColors.widget,
                      borderRadius: BorderRadius.circular(w * 0.07),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: controller,
                            style: AppTextStyles.body2.copyWith(
                              color: AppColors.white,
                              fontSize: w * 0.035,
                            ),
                            decoration: InputDecoration(
                              hintText: "Send a message",
                              hintStyle: AppTextStyles.body2.copyWith(
                                color: AppColors.grey,
                                fontSize: w * 0.035,
                              ),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(
                                vertical: h * 0.015,
                              ),
                            ),
                            onSubmitted: (_) => send(),
                          ),
                        ),

                        Icon(
                          Icons.mic_none,
                          color: AppColors.grey,
                          size: w * 0.055,
                        ),
                      ],
                    ),
                  ),
                ),

                SizedBox(width: w * 0.03),

                IconButton(
                  padding: EdgeInsets.zero,
                  icon: Icon(
                    Icons.send,
                    color: AppColors.main,
                    size: w * 0.065,
                  ),
                  onPressed: widget.isSending ? null : send,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
