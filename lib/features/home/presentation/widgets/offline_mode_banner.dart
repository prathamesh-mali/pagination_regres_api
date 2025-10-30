import 'package:elyx_task/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

class OfflineModeBanner extends StatelessWidget {
  const OfflineModeBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.symmetric(
        vertical: 12,
        horizontal: 16,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: AppColors.warningStateGradient,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.offlineBannerBorder),
      ),
      child: Row(
        children: [
          Icon(
            Icons.wifi_off_rounded,
            size: 20,
            color: AppColors.offlineBannerIcon,
          ),
          const SizedBox(width: 12),
          Text(
            'Offline Mode',
            style: TextStyle(
              color: AppColors.offlineBannerIcon,
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
