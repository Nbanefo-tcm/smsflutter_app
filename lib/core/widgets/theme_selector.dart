import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';

class ThemeSelector extends StatelessWidget {
  const ThemeSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return PopupMenuButton<ThemeMode>(
          icon: Icon(
            themeProvider.themeIcon,
            color: Theme.of(context).iconTheme.color,
          ),
          tooltip: 'Change theme',
          onSelected: (ThemeMode themeMode) {
            themeProvider.setThemeMode(themeMode);
          },
          itemBuilder: (BuildContext context) => [
            PopupMenuItem<ThemeMode>(
              value: ThemeMode.light,
              child: Row(
                children: [
                  Icon(
                    Icons.light_mode,
                    size: 20.sp,
                    color: themeProvider.themeMode == ThemeMode.light
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                  SizedBox(width: 12.w),
                  Text(
                    'Light',
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: themeProvider.themeMode == ThemeMode.light
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(context).textTheme.bodyLarge?.color,
                      fontWeight: themeProvider.themeMode == ThemeMode.light
                          ? FontWeight.w600
                          : FontWeight.normal,
                    ),
                  ),
                  const Spacer(),
                  if (themeProvider.themeMode == ThemeMode.light)
                    Icon(
                      Icons.check,
                      size: 16.sp,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                ],
              ),
            ),
            PopupMenuItem<ThemeMode>(
              value: ThemeMode.dark,
              child: Row(
                children: [
                  Icon(
                    Icons.dark_mode,
                    size: 20.sp,
                    color: themeProvider.themeMode == ThemeMode.dark
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                  SizedBox(width: 12.w),
                  Text(
                    'Dark',
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: themeProvider.themeMode == ThemeMode.dark
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(context).textTheme.bodyLarge?.color,
                      fontWeight: themeProvider.themeMode == ThemeMode.dark
                          ? FontWeight.w600
                          : FontWeight.normal,
                    ),
                  ),
                  const Spacer(),
                  if (themeProvider.themeMode == ThemeMode.dark)
                    Icon(
                      Icons.check,
                      size: 16.sp,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                ],
              ),
            ),
            PopupMenuItem<ThemeMode>(
              value: ThemeMode.system,
              child: Row(
                children: [
                  Icon(
                    Icons.brightness_auto,
                    size: 20.sp,
                    color: themeProvider.themeMode == ThemeMode.system
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                  SizedBox(width: 12.w),
                  Text(
                    'System',
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: themeProvider.themeMode == ThemeMode.system
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(context).textTheme.bodyLarge?.color,
                      fontWeight: themeProvider.themeMode == ThemeMode.system
                          ? FontWeight.w600
                          : FontWeight.normal,
                    ),
                  ),
                  const Spacer(),
                  if (themeProvider.themeMode == ThemeMode.system)
                    Icon(
                      Icons.check,
                      size: 16.sp,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                ],
              ),
            ),
          ],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.r),
          ),
          elevation: 8,
          offset: Offset(0, 40.h),
        );
      },
    );
  }
}
