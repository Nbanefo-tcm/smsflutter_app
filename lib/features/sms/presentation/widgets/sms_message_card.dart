import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../data/models/sms_message_model.dart';

class SmsMessageCard extends StatelessWidget {
  final SmsMessageModel message;
  final VoidCallback onTap;
  final VoidCallback onLongPress;

  const SmsMessageCard({
    super.key,
    required this.message,
    required this.onTap,
    required this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    final serviceColor = _resolveServiceColor(colorScheme.primary);
    final bool isUnread = !message.isRead;

    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          onLongPress: onLongPress,
          borderRadius: BorderRadius.circular(16.r),
          child: Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: isUnread
                  ? colorScheme.primaryContainer.withValues(alpha: 0.4)
                  : theme.cardColor,
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(
                color: isUnread
                    ? colorScheme.primary.withValues(alpha: 0.35)
                    : theme.dividerColor,
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: theme.shadowColor.withValues(alpha: 0.08),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header row
                Row(
                  children: [
                    // Sender info
                    Expanded(
                      child: Row(
                        children: [
                          // Service icon or generic message icon
                          Container(
                            width: 40.w,
                            height: 40.h,
                            decoration: BoxDecoration(
                              color: serviceColor.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(20.r),
                            ),
                            child: Icon(
                              _getServiceIcon(),
                              color: serviceColor,
                              size: 20.sp,
                            ),
                          ),
                          SizedBox(width: 12.w),
                          
                          // Sender name and service
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  message.sender,
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w600,
                                    color: textTheme.titleMedium?.color,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                if (message.service != null)
                                  Text(
                                    message.service!,
                                    style: TextStyle(
                                      fontSize: 12.sp,
                                      color: serviceColor,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    // Time and status
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          message.timeAgo,
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: textTheme.bodySmall?.color?.withValues(alpha: 0.75),
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (message.hasVerificationCode)
                              Container(
                                margin: EdgeInsets.only(right: 4.w),
                                padding: EdgeInsets.symmetric(
                                  horizontal: 6.w,
                                  vertical: 2.h,
                                ),
                                decoration: BoxDecoration(
                                  color: colorScheme.secondary,
                                  borderRadius: BorderRadius.circular(8.r),
                                ),
                                child: Text(
                                  'CODE',
                                  style: textTheme.bodySmall?.copyWith(
                                    fontSize: 10.sp,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            if (!message.isRead)
                              Container(
                                width: 8.w,
                                height: 8.h,
                                decoration: BoxDecoration(
                                  color: colorScheme.primary,
                                  borderRadius: BorderRadius.circular(4.r),
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 12.h),
                
                // Message preview
                Text(
                  message.message,
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: textTheme.bodyMedium?.color,
                    height: 1.4,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
                
                // Verification code highlight
                if (message.hasVerificationCode) ...[
                  SizedBox(height: 8.h),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 12.w,
                      vertical: 6.h,
                    ),
                    decoration: BoxDecoration(
                      color: colorScheme.secondaryContainer,
                      borderRadius: BorderRadius.circular(8.r),
                      border: Border.all(
                        color: colorScheme.secondary.withValues(alpha: 0.3),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.security,
                          size: 14.sp,
                          color: colorScheme.secondary,
                        ),
                        SizedBox(width: 6.w),
                        Text(
                          'Code: ${message.verificationCode}',
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: colorScheme.secondary,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 1,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color _resolveServiceColor(Color fallback) {
    final service = message.service?.toLowerCase();

    switch (service) {
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
        return fallback;
    }
  }

  IconData _getServiceIcon() {
    if (message.service == null) return Icons.message;
    
    switch (message.service!.toLowerCase()) {
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
}
