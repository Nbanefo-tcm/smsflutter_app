import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProfileAvatarButton extends StatelessWidget {
  final double size;
  final bool showBadge;

  const ProfileAvatarButton({
    super.key,
    this.size = 36,
    this.showBadge = false,
  });

  void _goToProfile(BuildContext context) {
    final currentRoute = ModalRoute.of(context)?.settings.name;
    if (currentRoute == '/profile') return;
    Navigator.of(context).pushNamed('/profile');
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
              backgroundColor: theme.colorScheme.secondary.withOpacity(0.15),
              child: Icon(
                Icons.person_outline,
                size: (size - 12).sp,
                color: theme.colorScheme.onSurface.withOpacity(0.8),
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
