import 'package:expense_tracker_flutter/features/settings/controller/settings_controller.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settingsState = ref.watch(settingsControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings", style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 1,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: settingsState.when(
        data: (state) => ListView(
          children: [
            ListTile(
              title: const Text("Billing Cycle Start Day"),
              subtitle: Text(
                "Starts on the ${state.billingStartDay}${_getDaySuffix(state.billingStartDay)} of each Nepali month",
              ),
              trailing: DropdownButton<int>(
                value: state.billingStartDay,
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
            ),
            const Divider(),
            ListTile(
              title: const Text("Restaurant Budget Limit"),
              subtitle: Text(
                "Alert if monthly spend exceeds Rs ${state.restaurantLimit}",
              ),
              trailing: IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () {
                  _showLimitEditDialog(context, ref, state.restaurantLimit);
                },
              ),
            ),
          ],
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text("Error: $e")),
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
        return AlertDialog(
          title: const Text("Set Restaurant Limit"),
          content: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              prefixText: "Rs ",
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                final newLimit = int.tryParse(controller.text);
                if (newLimit != null) {
                  ref
                      .read(settingsControllerProvider.notifier)
                      .updateRestaurantLimit(newLimit);
                  Navigator.pop(context);
                }
              },
              child: const Text("Save"),
            ),
          ],
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
