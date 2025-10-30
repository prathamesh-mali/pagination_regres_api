import 'package:elyx_task/config/routes/routes.dart';
import 'package:elyx_task/core/constants/app_colors.dart';
import 'package:elyx_task/features/home/data/models/user_data_model.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class UserTile extends StatelessWidget {
  final UserData user;
  final int index;
  final VoidCallback onNavigationError;

  const UserTile({
    super.key,
    required this.user,
    required this.index,
    required this.onNavigationError,
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 300 + (index * 50)),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, 20 * (1 - value)),
          child: Opacity(opacity: value, child: child),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: AppColors.cardGradient,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadowLight,
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Material(
          color: AppColors.transparent,
          child: InkWell(
            onTap: () {
              try {
                context.pushNamed(Routes.userDetail, extra: user);
              } catch (e) {
                onNavigationError();
              }
            },
            borderRadius: BorderRadius.circular(20),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Hero(
                    tag: 'user_avatar_${user.id}',
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: AppColors.avatarGradient,
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.shadowBlue,
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.all(3),
                      child: CircleAvatar(
                        radius: 32,
                        backgroundColor: AppColors.avatarBackground,
                        backgroundImage:
                            user.avatar != null && user.avatar!.isNotEmpty
                            ? NetworkImage(user.avatar!)
                            : null,
                        child: user.avatar == null || user.avatar!.isEmpty
                            ? Icon(
                                Icons.person,
                                size: 32,
                                color: AppColors.iconGrey,
                              )
                            : null,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${user.firstName ?? 'Unknown'} ${user.lastName ?? ''}',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.black87,
                            letterSpacing: 0.3,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            Icon(
                              Icons.email_outlined,
                              size: 14,
                              color: AppColors.iconGrey,
                            ),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                user.email ?? 'No email',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: AppColors.textLighter,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.iconLightBlue,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 16,
                      color: AppColors.iconBlue,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
