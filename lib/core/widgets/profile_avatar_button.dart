import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class ProfileAvatarButton extends StatelessWidget {
  final double size;
  final bool showBadge;
  final Color? iconColor;
  final Color? backgroundColor;

  const ProfileAvatarButton({
    super.key,
    this.size = 36,
    this.showBadge = false,
    this.iconColor,
    this.backgroundColor,
  });

  void _goToProfile(BuildContext context) {
    final currentRoute = GoRouterState.of(context).matchedLocation;
    if (currentRoute == '/profile') return;
    context.push('/profile');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 6.w),
      child: InkWell(
        onTap: () => _goToProfile(context),
        borderRadius: BorderRadius.circular(size.r / 2),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            CircleAvatar(
              radius: (size.r / 2),
              backgroundColor: backgroundColor ?? Colors.grey[200],
              child: Icon(
                Icons.person_outline,
                size: (size - 12).sp,
                color: iconColor ?? Colors.black,
              ),
            ),
            if (showBadge)
              Positioned(
                right: -2.w,
                bottom: -2.h,
                child: Container(
                  width: 12.w,
                  height: 12.w,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
