import 'package:expense_tracker_flutter/constants/app_color.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../controller/remote_config_controller.dart';

class RemoteConfigAnnouncementBanner extends ConsumerWidget {
  const RemoteConfigAnnouncementBanner({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final configAsync = ref.watch(remoteConfigControllerProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return configAsync.when(
      loading: () => const SizedBox.shrink(),
      error: (error, stackTrace) => const SizedBox.shrink(),
      data: (config) {
        final hasWelcome = config.welcomeMessage.trim().isNotEmpty;
        final hasAnnouncement = config.showAnnouncement || config.announcementMessage.isNotEmpty;
        final isMaintenance = config.isMaintenanceMode;

        // If no message/flag is active, return shrink
        if (!isMaintenance && !hasWelcome && !hasAnnouncement) {
          return const SizedBox.shrink();
        }

        final title = isMaintenance
            ? 'System Maintenance'
            : (hasWelcome ? 'Greeting' : 'Announcement');

        final message = isMaintenance
            ? (config.announcementMessage.isNotEmpty
                ? config.announcementMessage
                : 'Scheduled maintenance in progress.')
            : (hasWelcome ? config.welcomeMessage : config.announcementMessage);

        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: isMaintenance
                ? (isDark ? const Color(0xff451a03) : const Color(0xfffef3c7))
                : (isDark
                    ? AppColor.darkSurfaceCard
                    : AppColor.primary.withValues(alpha: 0.1)),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isMaintenance
                  ? (isDark ? const Color(0xffb45309) : const Color(0xfff59e0b))
                  : AppColor.primary.withValues(alpha: 0.3),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.04),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: isMaintenance
                      ? Colors.amber.withValues(alpha: 0.2)
                      : AppColor.primary.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  isMaintenance
                      ? CupertinoIcons.exclamationmark_triangle_fill
                      : CupertinoIcons.sparkles,
                  size: 18,
                  color: isMaintenance
                      ? (isDark ? Colors.amber[300] : Colors.amber[900])
                      : AppColor.primary,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: isMaintenance
                            ? (isDark ? Colors.amber[200] : Colors.amber[900])
                            : (isDark ? Colors.white : const Color(0xff0f172a)),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      message,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: isMaintenance
                            ? (isDark
                                ? Colors.amber[100]?.withValues(alpha: 0.8)
                                : Colors.amber[950])
                            : (isDark
                                ? Colors.grey[300]
                                : const Color(0xff475569)),
                      ),
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
}
