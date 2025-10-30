import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  static const Color primaryBlue = Color(0xFF1E88E5);
  static const Color primaryBlueLight = Color(0xFF42A5F5);
  static const Color primaryBlueDark = Color(0xFF1565C0);

  static const Color primaryPurple = Color(0xFFAB47BC);
  static const Color primaryPurpleLight = Color(0xFFBA68C8);
  static const Color primaryPurpleDark = Color(0xFF8E24AA);

  static const Color backgroundLight = Color(0xFFFAFAFA);
  static const Color backgroundWhite = Color(0xFFFFFFFF);
  static final Color backgroundGrey = Colors.grey[50]!;

  static const Color textPrimary = Color(0xFF212121);
  static const Color textSecondary = Color(0xFF757575);
  static final Color textLight = Colors.grey[600]!;
  static final Color textLighter = Colors.grey[700]!;

  static final List<Color> blueGradient = [
    Colors.blue[600]!,
    Colors.blue[400]!,
    Colors.purple[400]!,
  ];

  static final List<Color> cardGradient = [Colors.white, Colors.grey[50]!];

  static final List<Color> avatarGradient = [
    Colors.blue[300]!,
    Colors.purple[300]!,
  ];

  static final List<Color> emptyStateGradient = [
    Colors.blue[100]!,
    Colors.blue[50]!,
  ];

  static final Color iconGrey = Colors.grey[600]!;
  static final Color iconBlue = Colors.blue[700]!;
  static final Color iconLightBlue = Colors.blue[50]!;

  static Color shadowLight = Colors.black.withValues(alpha: 0.08);
  static Color shadowBlue = Colors.blue.withValues(alpha: 0.3);

  static const Color snackbarError = Color(0xFFFF5252);
  static const Color snackbarWarning = Color(0xFFFFB74D);
  static const Color snackbarSuccess = Color(0xFF66BB6A);
  static const Color snackbarInfo = Color(0xFF42A5F5);

  static final List<Color> errorStateGradient = [
    Colors.red[100]!,
    Colors.red[50]!,
  ];
  static final Color errorIcon = Colors.red[700]!;

  static final List<Color> warningStateGradient = [
    Colors.orange[100]!,
    Colors.orange[50]!,
  ];
  static final Color warningIcon = Colors.orange[700]!;

  static const Color buttonPrimary = Color(0xFF448AFF);
  static final Color hintText = Colors.grey[400]!;

  static final Color offlineBannerBorder = Colors.orange[200]!;
  static final Color offlineBannerIcon = Colors.orange[900]!;

  static final Color endOfListBackground = Colors.grey[200]!;
  static final Color endOfListText = Colors.grey[800]!;
  static final Color endOfListDivider = Colors.grey[300]!;

  static final List<Color> userDetailsGradient = [
    Colors.blueAccent,
    Colors.blue[700]!,
    Colors.indigo[400]!,
  ];
  static final Color userDetailsAvatarBg = Colors.grey[300]!;
  static final Color infoBorder = Colors.blue[100]!;
  static final Color infoBackground = Colors.blue[50]!;
  static final Color infoText = Colors.blue[900]!;

  static final Color avatarBackground = Colors.grey[200]!;
  static final Color overlayWhite20 = Colors.white.withValues(alpha: 0.2);
  static const Color transparent = Colors.transparent;
  static const Color white = Colors.white;
  static const Color white70 = Color(0xB3FFFFFF);
  static const Color black87 = Color(0xDE000000);
}
