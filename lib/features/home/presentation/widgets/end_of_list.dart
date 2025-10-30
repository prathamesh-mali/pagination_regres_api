import 'package:elyx_task/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

class EndOfListWidget extends StatelessWidget {
  const EndOfListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.endOfListBackground,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.check_circle_outline_rounded,
              size: 48,
              color: AppColors.iconGrey,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'You\'ve reached the end',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.endOfListText,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'No more users to load',
            style: TextStyle(fontSize: 14, color: AppColors.iconGrey),
          ),
        ],
      ),
    );
  }
}
