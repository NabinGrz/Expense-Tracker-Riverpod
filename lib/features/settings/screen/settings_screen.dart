import 'package:expense_tracker_flutter/constants/app_color.dart';
import 'package:expense_tracker_flutter/constants/app_strings.dart';
import 'package:expense_tracker_flutter/extension/num_extension.dart';
import 'package:expense_tracker_flutter/extension/sizebox_extension.dart';
import 'package:expense_tracker_flutter/extension/string_extension.dart';
import 'package:expense_tracker_flutter/features/savings/screen/savings_screen.dart';
import 'package:expense_tracker_flutter/features/settings/controller/settings_controller.dart';
import 'package:expense_tracker_flutter/features/settings/service/app_icon_service.dart';
import 'package:expense_tracker_flutter/shared/widgets/custom_input_dialog.dart';
import 'package:expense_tracker_flutter/features/remote_config/controller/remote_config_controller.dart';
import 'package:expense_tracker_flutter/snackbar/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  static const List<String> availableCategories = [
    AppString.categoryFood,
    AppString.categoryGrocery,
    AppString.categoryRestaurant,
    AppString.categoryKhaja,
    AppString.categoryPetrol,
    AppString.categoryPersonal,
    AppString.categoryClothing,
    AppString.categoryRent,
    AppString.categoryTransport,
    AppString.categoryUtils,
    AppString.categoryElectricty,
    AppString.categoryWater,
    AppString.categoryMedicine,
    AppString.categoryOther,
  ];

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
              subtitle: "Select your preferred theme mode",
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
            12.hGap,
            // Accent Theme Color Picker
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.cardColor,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.03),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColor.primary.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.palette_rounded,
                          color: AppColor.primary,
                          size: 24,
                        ),
                      ),
                      16.wGap,
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Accent Color",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: isDark ? Colors.white : Colors.black87,
                            ),
                          ),
                          4.hGap,
                          Text(
                            "Customize app highlight colors",
                            style: TextStyle(
                              fontSize: 13,
                              color: isDark
                                  ? Colors.grey[400]
                                  : Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  14.hGap,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ...AppColor.accentOptions.map((opt) {
                        final color = opt['color'] as Color;
                        final isSelected =
                            state.accentColorValue == color.toARGB32();

                        return GestureDetector(
                          onTap: () {
                            ref
                                .read(settingsControllerProvider.notifier)
                                .updateAccentColor(color.toARGB32());
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            width: 38,
                            height: 38,
                            decoration: BoxDecoration(
                              color: color,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: isSelected
                                    ? (isDark ? Colors.white : Colors.black87)
                                    : Colors.transparent,
                                width: 2.5,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: color.withValues(alpha: 0.35),
                                  blurRadius: 6,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: isSelected
                                ? const Icon(
                                    Icons.check_rounded,
                                    color: Colors.white,
                                    size: 18,
                                  )
                                : null,
                          ),
                        );
                      }),
                      // Rainbow Custom Color Picker Button
                      GestureDetector(
                        onTap: () {
                          _showCustomColorPickerDialog(
                            context,
                            ref,
                            state.accentColorValue,
                          );
                        },
                        child: Container(
                          width: 38,
                          height: 38,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: const SweepGradient(
                              colors: [
                                Colors.red,
                                Colors.amber,
                                Colors.green,
                                Colors.cyan,
                                Colors.blue,
                                Colors.purple,
                                Colors.red,
                              ],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black
                                    .withValues(alpha: isDark ? 0.4 : 0.15),
                                blurRadius: 6,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.tune_rounded,
                            color: Colors.white,
                            size: 18,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            20.hGap,
            _buildAppIconSection(context, ref),
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
            _buildSectionHeader(context, "Category Budget Limits"),
            ...state.categoryLimits.entries.map((entry) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _buildSettingCard(
                  context,
                  title: "${entry.key.capitalize()} Limit",
                  subtitle: "Alert limit: Rs ${entry.value.toCurrency}",
                  icon: Icons.pie_chart_outline_rounded,
                  iconColor: Colors.orangeAccent,
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.edit_rounded,
                          size: 20,
                          color: isDark ? Colors.grey[400] : Colors.grey[600],
                        ),
                        onPressed: () {
                          _showCategoryLimitDialog(
                            context,
                            ref,
                            category: entry.key,
                            currentLimit: entry.value,
                          );
                        },
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.delete_outline_rounded,
                          size: 20,
                          color: Colors.redAccent,
                        ),
                        onPressed: () {
                          ref
                              .read(settingsControllerProvider.notifier)
                              .removeCategoryLimit(entry.key);
                        },
                      ),
                    ],
                  ),
                  onTap: () => _showCategoryLimitDialog(
                    context,
                    ref,
                    category: entry.key,
                    currentLimit: entry.value,
                  ),
                ),
              );
            }),
            _buildSettingCard(
              context,
              title: "Add Category Budget",
              subtitle: "Set a custom monthly limit for another category",
              icon: Icons.add_circle_outline_rounded,
              iconColor: AppColor.primary,
              trailing: Icon(
                Icons.add_rounded,
                color: isDark ? Colors.white : AppColor.primary,
              ),
              onTap: () {
                _showAddCategoryLimitDialog(context, ref, state.categoryLimits);
              },
            ),
            20.hGap,
            _buildSectionHeader(context, "System & Remote Config"),
            Consumer(
              builder: (context, ref, child) {
                final rcState = ref.watch(remoteConfigControllerProvider);
                return rcState.when(
                  data: (config) => _buildSettingCard(
                    context,
                    title: "Firebase Remote Config",
                    subtitle:
                        'Welcome: "${config.welcomeMessage}" • Min: ${config.minAppVersion}',
                    icon: Icons.cloud_sync_rounded,
                    iconColor: Colors.blueAccent,
                    trailing: IconButton(
                      icon: const Icon(Icons.refresh_rounded),
                      onPressed: () async {
                        await ref
                            .read(remoteConfigControllerProvider.notifier)
                            .refreshConfig();
                        showSnackBar(
                          message: "Remote Config fetched & activated",
                          type: SnackBarTypes.Success,
                        );
                      },
                    ),
                  ),
                  loading: () => const Center(
                    child: Padding(
                      padding: EdgeInsets.all(12.0),
                      child: CircularProgressIndicator(),
                    ),
                  ),
                  error: (err, _) => _buildSettingCard(
                    context,
                    title: "Remote Config Error",
                    subtitle: err.toString(),
                    icon: Icons.error_outline_rounded,
                    iconColor: Colors.redAccent,
                    trailing: const SizedBox.shrink(),
                  ),
                );
              },
            ),
            40.hGap,
          ],
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text("Error: $e")),
      ),
    );
  }

  Widget _buildAppIconSection(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColor.primary.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.apps_rounded,
                  color: AppColor.primary,
                  size: 24,
                ),
              ),
              16.wGap,
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "App Icon",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                  ),
                  4.hGap,
                  Text(
                    "Choose your home screen icon style",
                    style: TextStyle(
                      fontSize: 13,
                      color: isDark ? Colors.grey[400] : Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ],
          ),
          16.hGap,
          _AppIconPicker(isDark: isDark),
        ],
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
            color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.03),
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
                    color: iconColor.withValues(alpha: 0.1),
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

  void _showCategoryLimitDialog(
    BuildContext context,
    WidgetRef ref, {
    required String category,
    required int currentLimit,
  }) {
    final controller = TextEditingController(text: currentLimit.toString());
    showDialog(
      context: context,
      builder: (context) {
        return CustomInputDialog(
          title: "Set ${category.capitalize()} Limit",
          primaryButtonText: "Save",
          onPrimaryPressed: () {
            final newLimit = int.tryParse(controller.text);
            if (newLimit != null && newLimit > 0) {
              ref
                  .read(settingsControllerProvider.notifier)
                  .updateCategoryLimit(category, newLimit);
              Navigator.pop(context);
            }
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Monthly Budget for ${category.capitalize()}",
                style: const TextStyle(
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

  void _showAddCategoryLimitDialog(
    BuildContext context,
    WidgetRef ref,
    Map<String, int> existingLimits,
  ) {
    final availableList = availableCategories
        .where((cat) => !existingLimits.containsKey(cat))
        .toList();

    if (availableList.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("All categories already have budget limits!"),
        ),
      );
      return;
    }

    String selectedCategory = availableList.first;
    final controller = TextEditingController(text: "5000");

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            final isDark = Theme.of(context).brightness == Brightness.dark;
            return CustomInputDialog(
              title: "Add Category Budget",
              primaryButtonText: "Add Limit",
              onPrimaryPressed: () {
                final newLimit = int.tryParse(controller.text);
                if (newLimit != null && newLimit > 0) {
                  ref
                      .read(settingsControllerProvider.notifier)
                      .updateCategoryLimit(selectedCategory, newLimit);
                  Navigator.pop(context);
                }
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Select Category",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  8.hGap,
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    decoration: BoxDecoration(
                      color: isDark ? Colors.grey[800] : const Color(0xffF1F5F9),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: selectedCategory,
                        isExpanded: true,
                        dropdownColor: isDark ? const Color(0xff1E293B) : Colors.white,
                        items: availableList.map((cat) {
                          return DropdownMenuItem(
                            value: cat,
                            child: Text(
                              cat.capitalize(),
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: isDark ? Colors.white : Colors.black87,
                              ),
                            ),
                          );
                        }).toList(),
                        onChanged: (val) {
                          if (val != null) {
                            setState(() {
                              selectedCategory = val;
                            });
                          }
                        },
                      ),
                    ),
                  ),
                  16.hGap,
                  const Text(
                    "Monthly Limit Amount",
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
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                    decoration: CustomInputDecoration.inputDecoration(
                      hintText: "E.g. 5000",
                      prefixIcon: const Icon(Icons.currency_rupee, size: 20),
                      isDark: isDark,
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _showCustomColorPickerDialog(
    BuildContext context,
    WidgetRef ref,
    int currentColorValue,
  ) {
    Color selectedColor = Color(currentColorValue);
    final hexController = TextEditingController(
      text: selectedColor.toARGB32().toRadixString(16).substring(2).toUpperCase(),
    );

    final List<Color> swatchPalette = [
      const Color(0xff428a78), // Teal Emerald
      const Color(0xff2563EB), // Sapphire Blue
      const Color(0xff7C3AED), // Amethyst Purple
      const Color(0xffE11D48), // Ruby Rose
      const Color(0xffD97706), // Sunset Amber
      const Color(0xff475569), // Midnight Slate
      const Color(0xff059669), // Mint Green
      const Color(0xff0891B2), // Cyan
      const Color(0xff4F46E5), // Indigo
      const Color(0xffC026D3), // Magenta
      const Color(0xffDC2626), // Crimson Red
      const Color(0xffEA580C), // Bright Orange
      const Color(0xffCA8A04), // Warm Yellow
      const Color(0xff65A30D), // Lime
      const Color(0xff16A34A), // Emerald Green
      const Color(0xff0284C7), // Sky Blue
    ];

    showDialog(
      context: context,
      builder: (context) {
        final isDark = Theme.of(context).brightness == Brightness.dark;

        return StatefulBuilder(
          builder: (context, setState) {
            return CustomInputDialog(
              title: "Custom Accent Color",
              primaryButtonText: "Apply Accent",
              onPrimaryPressed: () {
                ref
                    .read(settingsControllerProvider.notifier)
                    .updateAccentColor(selectedColor.toARGB32());
                Navigator.pop(context);
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: selectedColor,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: selectedColor.withValues(alpha: 0.4),
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                      ),
                      14.wGap,
                      Expanded(
                        child: TextField(
                          controller: hexController,
                          maxLength: 6,
                          autocorrect: false,
                          enableSuggestions: false,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: isDark ? Colors.white : Colors.black87,
                            letterSpacing: 1.5,
                          ),
                          decoration: CustomInputDecoration.inputDecoration(
                            hintText: "HEX (e.g. FF5722)",
                            prefixIcon: const Icon(Icons.numbers_rounded, size: 20),
                            isDark: isDark,
                          ).copyWith(counterText: ""),
                          onChanged: (val) {
                            if (val.length == 6) {
                              try {
                                final colorInt = int.parse("FF$val", radix: 16);
                                setState(() {
                                  selectedColor = Color(colorInt);
                                });
                              } catch (_) {}
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                  16.hGap,
                  Text(
                    "PRESET SWATCHES",
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: isDark ? Colors.grey[400] : Colors.grey[600],
                      letterSpacing: 1.1,
                    ),
                  ),
                  12.hGap,
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: swatchPalette.map((color) {
                      final isSelected = selectedColor.toARGB32() == color.toARGB32();
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedColor = color;
                            hexController.text = color
                                .toARGB32()
                                .toRadixString(16)
                                .substring(2)
                                .toUpperCase();
                          });
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 150),
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: color,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: isSelected
                                  ? (isDark ? Colors.white : Colors.black87)
                                  : Colors.transparent,
                              width: 2.5,
                            ),
                          ),
                          child: isSelected
                              ? const Icon(
                                  Icons.check_rounded,
                                  color: Colors.white,
                                  size: 18,
                                )
                              : null,
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            );
          },
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

/// A self-contained stateful widget for the icon picker.
/// Uses its own local state so parent doesn't need to manage selection.
class _AppIconPicker extends StatefulWidget {
  final bool isDark;
  const _AppIconPicker({required this.isDark});

  @override
  State<_AppIconPicker> createState() => _AppIconPickerState();
}

class _AppIconPickerState extends State<_AppIconPicker> {
  AppIconOption _selected = AppIconOption.defaultIcon;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final current = await AppIconService.getCurrentIcon();
    if (mounted) setState(() { _selected = current; _loading = false; });
  }

  Future<void> _onSelect(AppIconOption option) async {
    if (_selected == option) return;
    setState(() => _selected = option);
    final success = await AppIconService.switchIcon(option);
    if (!success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Icon switching is not supported on this device.'),
          duration: Duration(seconds: 2),
        ),
      );
      // revert on failure
      final reverted = await AppIconService.getCurrentIcon();
      if (mounted) setState(() => _selected = reverted);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const SizedBox(
        height: 100,
        child: Center(child: CircularProgressIndicator()),
      );
    }
    return Row(
      children: AppIconOption.values.map((option) {
        final isSelected = _selected == option;
        return Expanded(
          child: GestureDetector(
            onTap: () => _onSelect(option),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              margin: const EdgeInsets.symmetric(horizontal: 5),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: isSelected
                      ? AppColor.primary
                      : (widget.isDark
                          ? Colors.grey[700]!
                          : Colors.grey[200]!),
                  width: isSelected ? 2.5 : 1.5,
                ),
                color: isSelected
                    ? AppColor.primary.withValues(alpha: 0.08)
                    : Colors.transparent,
              ),
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(14),
                    child: Image.asset(
                      option.previewAsset,
                      width: 64,
                      height: 64,
                      fit: BoxFit.cover,
                    ),
                  ),
                  8.hGap,
                  Text(
                    option.label,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight:
                          isSelected ? FontWeight.w700 : FontWeight.w500,
                      color: isSelected
                          ? AppColor.primary
                          : (widget.isDark
                              ? Colors.grey[300]
                              : Colors.grey[700]),
                    ),
                  ),
                  4.hGap,
                  AnimatedOpacity(
                    duration: const Duration(milliseconds: 200),
                    opacity: isSelected ? 1.0 : 0.0,
                    child: Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: AppColor.primary,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
