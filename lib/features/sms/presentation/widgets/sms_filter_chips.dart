import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../providers/sms_provider.dart';

class SmsFilterChips extends StatelessWidget {
  const SmsFilterChips({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SmsProvider>(
      builder: (context, smsProvider, child) {
        final hasFilters = smsProvider.selectedService != null ||
            smsProvider.selectedDate != null ||
            smsProvider.searchQuery.isNotEmpty;

        if (!hasFilters && smsProvider.availableServices.isEmpty) {
          return const SizedBox.shrink();
        }

        return Container(
          height: 50.h,
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Row(
            children: [
              Expanded(
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    // Clear filters chip
                    if (hasFilters) ...[
                      _buildClearFiltersChip(context, smsProvider),
                      SizedBox(width: 8.w),
                    ],
                    
                    // Service filter chips
                    ...smsProvider.availableServices.map(
                      (service) => Padding(
                        padding: EdgeInsets.only(right: 8.w),
                        child: _buildServiceFilterChip(
                          context,
                          smsProvider,
                          service,
                        ),
                      ),
                    ),
                    
                    // Date filter chip
                    Padding(
                      padding: EdgeInsets.only(right: 8.w),
                      child: _buildDateFilterChip(context, smsProvider),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildClearFiltersChip(BuildContext context, SmsProvider smsProvider) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return FilterChip(
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.clear_all,
            size: 16.sp,
            color: colorScheme.error,
          ),
          SizedBox(width: 4.w),
          Text(
            'Clear filters',
            style: TextStyle(
              fontSize: 12.sp,
              color: colorScheme.error,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
      onSelected: (_) => smsProvider.clearFilters(),
      backgroundColor: colorScheme.error.withValues(alpha: 0.12),
      selectedColor: colorScheme.error.withValues(alpha: 0.2),
      side: BorderSide(
        color: colorScheme.error.withValues(alpha: 0.3),
        width: 1,
      ),
      selected: false,
    );
  }

  Widget _buildServiceFilterChip(
    BuildContext context,
    SmsProvider smsProvider,
    String service,
  ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isSelected = smsProvider.selectedService == service;
    final serviceColor = _getServiceColor(service, colorScheme.primary);

    return FilterChip(
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            _getServiceIcon(service),
            size: 16.sp,
            color: isSelected ? Colors.white : serviceColor,
          ),
          SizedBox(width: 4.w),
          Text(
            service,
            style: TextStyle(
              fontSize: 12.sp,
              color: isSelected ? Colors.white : serviceColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
      selected: isSelected,
      onSelected: (selected) {
        smsProvider.filterByService(selected ? service : null);
      },
      backgroundColor: serviceColor.withValues(alpha: 0.1),
      selectedColor: serviceColor,
      side: BorderSide(
        color: serviceColor.withValues(alpha: 0.3),
        width: 1,
      ),
    );
  }

  Widget _buildDateFilterChip(BuildContext context, SmsProvider smsProvider) {
    final isSelected = smsProvider.selectedDate != null;
    final colorScheme = Theme.of(context).colorScheme;

    return FilterChip(
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.calendar_today,
            size: 16.sp,
            color: isSelected ? Colors.white : colorScheme.primary,
          ),
          SizedBox(width: 4.w),
          Text(
            isSelected
                ? _formatDate(smsProvider.selectedDate!)
                : 'Date',
            style: TextStyle(
              fontSize: 12.sp,
              color: isSelected ? Colors.white : colorScheme.primary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
      selected: isSelected,
      onSelected: (selected) async {
        if (selected) {
          final date = await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime.now().subtract(const Duration(days: 30)),
            lastDate: DateTime.now(),
            builder: (context, child) {
              return Theme(
                data: Theme.of(context).copyWith(
                  colorScheme: Theme.of(context).colorScheme.copyWith(
                    primary: colorScheme.primary,
                  ),
                ),
                child: child!,
              );
            },
          );
          if (date != null) {
            smsProvider.filterByDate(date);
          }
        } else {
          smsProvider.filterByDate(null);
        }
      },
      backgroundColor: colorScheme.primary.withAlpha((0.12 * 255).round()),
      selectedColor: colorScheme.primary,
      side: BorderSide(
        color: colorScheme.primary.withAlpha((0.3 * 255).round()),
        width: 1,
      ),
    );
  }

  Color _getServiceColor(String service, Color defaultColor) {
    switch (service.toLowerCase()) {
      case 'whatsapp':
        return const Color(0xFF25D366);
      case 'telegram':
        return const Color(0xFF0088CC);
      case 'google':
        return const Color(0xFF4285F4);
      case 'instagram':
        return const Color(0xFFE4405F);
      case 'facebook':
        return const Color(0xFF1877F2);
      case 'twitter':
        return const Color(0xFF1DA1F2);
      case 'discord':
        return const Color(0xFF5865F2);
      default:
        return defaultColor;
    }
  }

  IconData _getServiceIcon(String service) {
    switch (service.toLowerCase()) {
      case 'whatsapp':
        return Icons.chat;
      case 'telegram':
        return Icons.send;
      case 'google':
        return Icons.account_circle;
      case 'instagram':
        return Icons.camera_alt;
      case 'facebook':
        return Icons.facebook;
      case 'twitter':
        return Icons.alternate_email;
      case 'discord':
        return Icons.discord;
      default:
        return Icons.message;
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final dateToCheck = DateTime(date.year, date.month, date.day);

    if (dateToCheck == today) {
      return 'Today';
    } else if (dateToCheck == yesterday) {
      return 'Yesterday';
    } else {
      return '${date.day}/${date.month}';
    }
  }
}
