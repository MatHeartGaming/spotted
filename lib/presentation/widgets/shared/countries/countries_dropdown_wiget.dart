import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:multi_dropdown/multi_dropdown.dart';
import 'package:spotted/config/config.dart';

class CountrySelector extends StatelessWidget {
  final MultiSelectController<String>? controller;
  final List<DropdownItem<String>> items;

  const CountrySelector({
    super.key,
    required this.items,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return MultiDropdown<String>(
      items: items,
      controller: controller,
      enabled: true,
      searchEnabled: true,
      singleSelect: true,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      chipDecoration: const ChipDecoration(
        backgroundColor: Colors.yellow,
        wrap: true,
        runSpacing: 2,
        spacing: 10,
      ),
      fieldDecoration: FieldDecoration(
        hintText: 'login_screen_countries_hint_text'.tr(),
        hintStyle: TextStyle(color: colors.primary),
        prefixIcon: const Icon(FontAwesomeIcons.flag),
        showClearIcon: false,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colors.secondaryContainer),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colors.primaryContainer),
        ),
      ),
      dropdownDecoration: DropdownDecoration(
        marginTop: 2,
        maxHeight: 500,
        backgroundColor: colors.tertiaryContainer,
        header: Padding(
          padding: EdgeInsets.all(8),
          child: Text(
            'login_screen_select_your_country_text'.tr(),
            textAlign: TextAlign.start,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
      ),
      dropdownItemDecoration: DropdownItemDecoration(
        selectedIcon: Icon(Icons.check_box, color: colors.inversePrimary),
        disabledIcon: Icon(Icons.lock, color: colors.tertiary),
        textColor: colors.onTertiaryContainer,
        backgroundColor: colors.tertiaryContainer,
        selectedTextColor: colors.onSurface,
        selectedBackgroundColor: colors.surfaceContainerHighest,
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'login_screen_validation_country_text'.tr();
        }
        return null;
      },
      onSelectionChange: (selectedItems) {
        logger.i("OnSelectionChange: $selectedItems");
      },
    );
  }
}
