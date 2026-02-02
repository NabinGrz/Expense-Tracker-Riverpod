import 'package:expense_tracker_flutter/features/settings/controller/settings_controller.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final billingDayState = ref.watch(settingsControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings", style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 1,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: ListView(
        children: [
          ListTile(
            title: const Text("Billing Cycle Start Day"),
            subtitle: Text(
              billingDayState.when(
                data: (day) =>
                    "Starts on the $day${_getDaySuffix(day)} of each Nepali month",
                loading: () => "Loading...",
                error: (_, __) => "Error loading setting",
              ),
            ),
            trailing: billingDayState.when(
              data: (currentDay) => DropdownButton<int>(
                value: currentDay,
                underline: const SizedBox(),
                items: List.generate(32, (index) => index + 1)
                    .map(
                      (day) => DropdownMenuItem(
                        value: day,
                        child: Text(day.toString()),
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
              loading: () => const SizedBox.shrink(),
              error: (_, __) => const Icon(Icons.error),
            ),
          ),
        ],
      ),
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
