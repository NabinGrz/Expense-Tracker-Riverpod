import 'package:expense_tracker_flutter/extension/num_extension.dart';
import 'package:expense_tracker_flutter/extension/sizebox_extension.dart';
import 'package:expense_tracker_flutter/features/savings/screen/savings_screen.dart';
import 'package:expense_tracker_flutter/features/settings/controller/settings_controller.dart';
import 'package:expense_tracker_flutter/shared/widgets/custom_input_dialog.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settingsState = ref.watch(settingsControllerProvider);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          "Settings",
          style: TextStyle(
            color: isDark ? Colors.white : Colors.black87,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        centerTitle: false,
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        iconTheme: IconThemeData(color: isDark ? Colors.white : Colors.black87),
      ),
      body: settingsState.when(
        data: (state) => ListView(
          padding: const EdgeInsets.all(20),
          children: [
            _buildSectionHeader(context, "Appearance"),
            _buildSettingCard(
              context,
              title: "App Theme",
              subtitle: "Select your preferred theme",
              icon: Icons.brightness_6_rounded,
              iconColor: Colors.purpleAccent,
              trailing: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: isDark ? Colors.grey[800] : Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: isDark ? Colors.grey[700]! : Colors.grey[300]!,
                  ),
                ),
                child: DropdownButton<ThemeMode>(
                  value: state.themeMode,
                  underline: const SizedBox(),
                  isDense: true,
                  dropdownColor: theme.cardColor,
                  icon: Icon(
                    Icons.arrow_drop_down_rounded,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                  items: const [
                    DropdownMenuItem(
                      value: ThemeMode.system,
                      child: Text("System"),
                    ),
                    DropdownMenuItem(
                      value: ThemeMode.light,
                      child: Text("Light"),
                    ),
                    DropdownMenuItem(
                      value: ThemeMode.dark,
                      child: Text("Dark"),
                    ),
                  ],
                  onChanged: (newMode) {
                    if (newMode != null) {
                      ref
                          .read(settingsControllerProvider.notifier)
                          .updateThemeMode(newMode);
                    }
                  },
                ),
              ),
            ),
            20.hGap,
            _buildSectionHeader(context, "Billing Preferences"),
            _buildSettingCard(
              context,
              title: "Billing Cycle Start Day",
              subtitle:
                  "Starts on the ${state.billingStartDay}${_getDaySuffix(state.billingStartDay)} of each Nepali month",
              icon: Icons.calendar_today_rounded,
              iconColor: Colors.blueAccent,
              trailing: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: isDark ? Colors.grey[800] : Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: isDark ? Colors.grey[700]! : Colors.grey[300]!,
                  ),
                ),
                child: DropdownButton<int>(
                  value: state.billingStartDay,
                  underline: const SizedBox(),
                  isDense: true,
                  dropdownColor: theme.cardColor,
                  icon: Icon(
                    Icons.arrow_drop_down_rounded,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                  items: List.generate(32, (index) => index + 1)
                      .map(
                        (day) => DropdownMenuItem(
                          value: day,
                          child: Text(
                            "$day",
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ),
                      )
                      .toList(),
                  onChanged: (newDay) {
                    if (newDay != null) {
                      ref
                          .read(settingsControllerProvider.notifier)
                          .updateBillingStartDay(newDay);
                    }
                  },
                ),
              ),
            ),
            20.hGap,
            _buildSectionHeader(context, "Savings & Goals"),
            _buildSettingCard(
              context,
              title: "Total Savings Overview",
              subtitle: "Manage and deposit to accumulated savings",
              icon: Icons.savings_rounded,
              iconColor: Colors.teal,
              trailing: Icon(
                Icons.arrow_forward_ios_rounded,
                size: 16,
                color: isDark ? Colors.grey[400] : Colors.grey,
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SavingsScreen(),
                  ),
                );
              },
            ),
            20.hGap,
            _buildSectionHeader(context, "Budget Alerts"),
            _buildSettingCard(
              context,
              title: "Restaurant Budget Limit",
              subtitle: "Alert limit: Rs ${state.restaurantLimit.toCurrency}",
              icon: Icons.restaurant_rounded,
              iconColor: Colors.orangeAccent,
              trailing: IconButton(
                icon: Icon(
                  Icons.edit_rounded,
                  color: isDark ? Colors.grey[400] : Colors.grey,
                ),
                onPressed: () {
                  _showLimitEditDialog(context, ref, state.restaurantLimit);
                },
              ),
              onTap: () =>
                  _showLimitEditDialog(context, ref, state.restaurantLimit),
            ),
          ],
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text("Error: $e")),
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.only(bottom: 12, left: 4),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: isDark ? Colors.grey[400] : Colors.grey[600],
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _buildSettingCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required Color iconColor,
    required Widget trailing,
    VoidCallback? onTap,
  }) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.3 : 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: iconColor.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: iconColor, size: 24),
                ),
                16.wGap,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : Colors.black87,
                        ),
                      ),
                      4.hGap,
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 13,
                          color: isDark ? Colors.grey[400] : Colors.grey[600],
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
                8.wGap,
                trailing,
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showLimitEditDialog(
    BuildContext context,
    WidgetRef ref,
    int currentLimit,
  ) {
    final controller = TextEditingController(text: currentLimit.toString());
    showDialog(
      context: context,
      builder: (context) {
        return CustomInputDialog(
          title: "Set Restaurant Limit",
          primaryButtonText: "Save",
          onPrimaryPressed: () {
            final newLimit = int.tryParse(controller.text);
            if (newLimit != null) {
              ref
                  .read(settingsControllerProvider.notifier)
                  .updateRestaurantLimit(newLimit);
              Navigator.pop(context);
            }
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Monthly Alert Threshold",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                  fontWeight: FontWeight.w500,
                ),
              ),
              8.hGap,
              TextField(
                controller: controller,
                keyboardType: TextInputType.number,
                autofocus: true,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.white
                      : Colors.black87,
                ),
                decoration: CustomInputDecoration.inputDecoration(
                  hintText: "E.g. 5000",
                  prefixIcon: const Icon(Icons.currency_rupee, size: 20),
                  isDark: Theme.of(context).brightness == Brightness.dark,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  String _getDaySuffix(int day) {
    if (day >= 11 && day <= 13) {
      return 'th';
    }
    switch (day % 10) {
      case 1:
        return 'st';
      case 2:
        return 'nd';
      case 3:
        return 'rd';
      default:
        return 'th';
    }
  }
}
