import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../data/models/sms_message_model.dart';
import '../providers/sms_provider.dart';
import '../widgets/sms_message_card.dart';
import '../widgets/sms_filter_chips.dart';

class SmsInboxScreen extends StatefulWidget {
  const SmsInboxScreen({super.key});

  @override
  State<SmsInboxScreen> createState() => _SmsInboxScreenState();
}

class _SmsInboxScreenState extends State<SmsInboxScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    // Load messages when screen initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SmsProvider>().loadMessages();
      _animationController.forward();
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Consumer<SmsProvider>(
      builder: (context, smsProvider, _) {
        return FadeTransition(
          opacity: _fadeAnimation,
          child: Column(
            children: [
              // Header with unread count and actions
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Inbox',
                          style: textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '${smsProvider.unreadCount} unread',
                          style: textTheme.bodySmall?.copyWith(
                            fontSize: 12.sp,
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                    // Search and menu buttons
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.search),
                          onPressed: () {
                            if (context.mounted) {
                              showSearch(
                                context: context,
                                delegate: _SmsSearchDelegate(smsProvider),
                              );
                            }
                          },
                        ),
                        PopupMenuButton<String>(
                          icon: const Icon(Icons.more_vert),
                          onSelected: (value) {
                            switch (value) {
                              case 'mark_all_read':
                                smsProvider.markAllAsRead();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('All messages marked as read'),
                                  ),
                                );
                                break;
                              case 'clear_filters':
                                smsProvider.clearFilters();
                                break;
                            }
                          },
                          itemBuilder: (context) => [
                            const PopupMenuItem(
                              value: 'mark_all_read',
                              child: Row(
                                children: [
                                  Icon(Icons.mark_email_read, size: 20),
                                  SizedBox(width: 12),
                                  Text('Mark all as read'),
                                ],
                              ),
                            ),
                            const PopupMenuItem(
                              value: 'clear_filters',
                              child: Row(
                                children: [
                                  Icon(Icons.clear_all, size: 20),
                                  SizedBox(width: 12),
                                  Text('Clear filters'),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              
              // Filter Chips
              const SmsFilterChips(),
              
              // Messages List
              Expanded(
                child: smsProvider.isLoading && smsProvider.messages.isEmpty
                    ? _buildLoadingState()
                    : smsProvider.error != null
                        ? _buildErrorState(smsProvider.error!)
                        : smsProvider.messages.isEmpty
                            ? _buildEmptyState()
                            : RefreshIndicator(
                                onRefresh: smsProvider.refreshMessages,
                                child: ListView.builder(
                                  controller: _scrollController,
                                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                                  itemCount: smsProvider.messages.length,
                                  itemBuilder: (context, index) {
                                    final message = smsProvider.messages[index];
                                    return AnimatedBuilder(
                                      animation: _animationController,
                                      builder: (context, child) {
                                        final slideAnimation = Tween<Offset>(
                                          begin: const Offset(1.0, 0.0),
                                          end: Offset.zero,
                                        ).animate(CurvedAnimation(
                                          parent: _animationController,
                                          curve: Interval(
                                            (index * 0.1).clamp(0.0, 1.0),
                                            ((index * 0.1) + 0.3).clamp(0.0, 1.0),
                                            curve: Curves.easeOutBack,
                                          ),
                                        ));

                                        return SlideTransition(
                                          position: slideAnimation,
                                          child: SmsMessageCard(
                                            message: message,
                                            onTap: () => _onMessageTap(message),
                                            onLongPress: () => _onMessageLongPress(message),
                                          ),
                                        );
                                      },
                                    );
                                  },
                                ),
                              ),
              ),
              
              // Floating Action Button
              if (smsProvider.unreadCount > 0)
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: FloatingActionButton.extended(
                    onPressed: () {
                      smsProvider.markAllAsRead();
                      HapticFeedback.lightImpact();
                    },
                    icon: const Icon(Icons.mark_email_read),
                    label: Text('Mark ${smsProvider.unreadCount} as read'),
                    backgroundColor: Theme.of(context).colorScheme.primary,
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLoadingState() {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(),
          SizedBox(height: 16.h),
          Text(
            'Loading messages...',
            style: textTheme.bodyMedium?.copyWith(
              fontSize: 16.sp,
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(String error) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 48,
            color: colorScheme.error,
          ),
          SizedBox(height: 16),
          Text(
            'Error loading messages',
            style: textTheme.titleMedium?.copyWith(
              color: colorScheme.onErrorContainer,
            ),
          ),
          SizedBox(height: 8),
          Text(
            error,
            style: textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              context.read<SmsProvider>().loadMessages();
            },
            child: const Text('Try Again'),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;

    return Center(
      child: Padding(
        padding: EdgeInsets.all(32.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120.w,
              height: 120.h,
              decoration: BoxDecoration(
                color: colorScheme.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(60.r),
              ),
              child: Icon(
                Icons.message_outlined,
                size: 60.sp,
                color: colorScheme.primary,
              ),
            ),
            SizedBox(height: 24.h),
            Text(
              'No messages yet',
              style: textTheme.headlineSmall?.copyWith(
                fontSize: 24.sp,
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              'Your SMS messages will appear here once you rent a virtual number and start receiving verification codes.',
              textAlign: TextAlign.center,
              style: textTheme.bodyMedium?.copyWith(
                fontSize: 16.sp,
                color: colorScheme.onSurfaceVariant,
                height: 1.5,
              ),
            ),
            SizedBox(height: 32.h),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.of(context).pop();
                // Navigate to number rental screen
              },
              icon: const Icon(Icons.phone),
              label: const Text('Rent a Number'),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(
                  horizontal: 24.w,
                  vertical: 12.h,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onMessageTap(SmsMessageModel message) {
    // Mark as read if not already read
    if (!message.isRead) {
      context.read<SmsProvider>().markAsRead(message.id);
    }

    // Navigate to message detail screen
    // Navigator.of(context).pushNamed('/message-detail', arguments: message);
    
    // For now, show a bottom sheet with message details
    _showMessageDetails(message);
  }

  void _onMessageLongPress(SmsMessageModel message) {
    HapticFeedback.mediumImpact();
    _showMessageOptions(message);
  }

  void _showMessageDetails(SmsMessageModel message) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        final theme = Theme.of(context);
        final colorScheme = theme.colorScheme;
        final textTheme = theme.textTheme;

        return Container(
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
          ),
          padding: EdgeInsets.all(24.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Handle bar
              Center(
                child: Container(
                  width: 40.w,
                  height: 4.h,
                  decoration: BoxDecoration(
                    color: colorScheme.onSurfaceVariant.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(2.r),
                  ),
                ),
              ),
              SizedBox(height: 20.h),

              // Message header
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(8.w),
                    decoration: BoxDecoration(
                      color: colorScheme.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Icon(
                      Icons.message,
                      color: colorScheme.primary,
                      size: 20.sp,
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          message.sender,
                          style: textTheme.titleMedium?.copyWith(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          message.timeAgo,
                          style: textTheme.bodySmall?.copyWith(
                            fontSize: 14.sp,
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (message.service != null)
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 8.w,
                        vertical: 4.h,
                      ),
                      decoration: BoxDecoration(
                        color: colorScheme.primary,
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Text(
                        message.service!,
                        style: textTheme.labelSmall?.copyWith(
                          color: colorScheme.onPrimary,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                ],
              ),

              SizedBox(height: 20.h),

              // Message content
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(
                    color: colorScheme.outlineVariant,
                    width: 1,
                  ),
                ),
                child: Text(
                  message.message,
                  style: textTheme.bodyMedium?.copyWith(
                    fontSize: 16.sp,
                    height: 1.5,
                    color: colorScheme.onSurface,
                  ),
                ),
              ),

              // Verification code highlight
              if (message.hasVerificationCode) ...[
                SizedBox(height: 16.h),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(
                    color: colorScheme.secondary.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(
                      color: colorScheme.secondary.withValues(alpha: 0.35),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.security,
                        color: colorScheme.secondary,
                        size: 20.sp,
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        'Verification Code: ',
                        style: textTheme.bodyMedium?.copyWith(
                          fontSize: 14.sp,
                          color: colorScheme.secondary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          message.verificationCode!,
                          style: textTheme.titleMedium?.copyWith(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                            color: colorScheme.secondary,
                            letterSpacing: 2,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          Clipboard.setData(
                            ClipboardData(text: message.verificationCode!),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Verification code copied!'),
                            ),
                          );
                        },
                        icon: const Icon(Icons.copy),
                        color: colorScheme.secondary,
                        iconSize: 20.sp,
                      ),
                    ],
                  ),
                ),
              ],

              SizedBox(height: 24.h),

              // Action buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        Clipboard.setData(ClipboardData(text: message.message));
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Message copied!')),
                        );
                      },
                      icon: const Icon(Icons.copy),
                      label: const Text('Copy'),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                        _showMessageOptions(message);
                      },
                      icon: const Icon(Icons.more_horiz),
                      label: const Text('More'),
                    ),
                  ),
                ],
              ),

              SizedBox(height: MediaQuery.of(context).viewInsets.bottom),
            ],
          ),
        );
      },
    );
  }

  void _showMessageOptions(SmsMessageModel message) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.copy),
            title: const Text('Copy message'),
            onTap: () {
              Clipboard.setData(ClipboardData(text: message.message));
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Message copied!')),
              );
            },
          ),
          if (message.verificationCode != null && message.verificationCode!.isNotEmpty)
            ListTile(
              leading: const Icon(Icons.security),
              title: const Text('Copy verification code'),
              onTap: () {
                Clipboard.setData(
                  ClipboardData(text: message.verificationCode!),  
                );
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Verification code copied!')),
                );
              },
            ),
          ListTile(
            leading: Icon(
              message.isRead ? Icons.mark_email_unread : Icons.mark_email_read,
            ),
            title: Text(message.isRead ? 'Mark as unread' : 'Mark as read'),
            onTap: () {
              context.read<SmsProvider>().markAsRead(message.id);
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.delete, color: Colors.red),
            title: const Text('Delete message', style: TextStyle(color: Colors.red)),
            onTap: () {
              Navigator.pop(context);
              _confirmDelete(message);
            },
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  void _confirmDelete(SmsMessageModel message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Message'),
        content: const Text('Are you sure you want to delete this message?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              context.read<SmsProvider>().deleteMessage(message.id);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Message deleted')),
              );
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}

class _SmsSearchDelegate extends SearchDelegate<String> {
  final SmsProvider smsProvider;
  
  _SmsSearchDelegate(this.smsProvider);
  
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }
  
  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, '');
      },
    );
  }
  
  @override
  Widget buildResults(BuildContext context) {
    return _buildSearchResults();
  }
  
  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.isEmpty) {
      return _buildEmptyState(context);
    }
    return _buildSearchResults();
  }
  
  Widget _buildSearchResults() {
    return Consumer<SmsProvider>(
      builder: (context, smsProvider, _) {
        // Search through messages
        final queryLower = query.toLowerCase();
        final results = smsProvider.messages.where((message) => 
          message.message.toLowerCase().contains(queryLower) ||
          message.sender.toLowerCase().contains(queryLower)
        ).toList();
        
        if (results.isEmpty) {
          return _buildEmptyState(context);
        }
        
        return ListView.builder(
          itemCount: results.length,
          itemBuilder: (context, index) {
            final message = results[index];
            return ListTile(
              title: Text(message.sender.isNotEmpty ? message.sender : 'Unknown Sender'),
              subtitle: Text(
                message.message,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              onTap: () {
                close(context, message.id.toString());
              },
            );
          },
        );
      },
    );
  }
  
  Widget _buildEmptyState(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: 64,
            color: colorScheme.onSurfaceVariant.withAlpha((0.5 * 255).round()),
          ),
          const SizedBox(height: 16),
          Text(
            'No results found',
            style: textTheme.titleMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Try different search terms',
            style: textTheme.bodyMedium?.copyWith(
color: colorScheme.onSurfaceVariant.withAlpha((0.7 * 255).round()),
            ),
          ),
        ],
      ),
    );
  }
}