import 'package:elyx_task/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

class UserSearchBar extends StatelessWidget {
  final TextEditingController controller;
  final bool isTablet;
  final VoidCallback onClear;

  const UserSearchBar({
    super.key,
    required this.controller,
    required this.isTablet,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: isTablet ? 20 : 16,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadowLight,
              blurRadius: 20,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: 'Search users...',
            hintStyle: TextStyle(color: AppColors.hintText),
            prefixIcon: Icon(
              Icons.search_rounded,
              color: AppColors.primaryBlue,
              size: 24,
            ),
            suffixIcon: controller.text.isNotEmpty
                ? IconButton(
                    icon: Icon(
                      Icons.clear_rounded,
                      color: AppColors.iconGrey,
                    ),
                    onPressed: onClear,
                  )
                : null,
            filled: true,
            fillColor: AppColors.transparent,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 16,
            ),
          ),
        ),
      ),
    );
  }
}
