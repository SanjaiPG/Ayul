import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class FilterBottomSheet extends StatefulWidget {
  final Map<String, dynamic> currentFilters;
  final Function(Map<String, dynamic>) onFiltersApplied;
  final String currentLanguage;

  const FilterBottomSheet({
    Key? key,
    required this.currentFilters,
    required this.onFiltersApplied,
    required this.currentLanguage,
  }) : super(key: key);

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  late Map<String, dynamic> _tempFilters;

  final List<Map<String, dynamic>> _medicineTypes = [
    {'id': 'herbal', 'name': 'Herbal', 'tamilName': 'மூலிகை'},
    {'id': 'mineral', 'name': 'Mineral', 'tamilName': 'கனிம'},
    {'id': 'animal', 'name': 'Animal', 'tamilName': 'விலங்கு'},
    {'id': 'compound', 'name': 'Compound', 'tamilName': 'கலவை'},
  ];

  final List<Map<String, dynamic>> _bodySystems = [
    {'id': 'respiratory', 'name': 'Respiratory', 'tamilName': 'சுவாச'},
    {'id': 'digestive', 'name': 'Digestive', 'tamilName': 'செரிமான'},
    {'id': 'nervous', 'name': 'Nervous', 'tamilName': 'நரம்பு'},
    {'id': 'circulatory', 'name': 'Circulatory', 'tamilName': 'இரத்த ஓட்ட'},
    {
      'id': 'musculoskeletal',
      'name': 'Musculoskeletal',
      'tamilName': 'தசை எலும்பு'
    },
  ];

  final List<Map<String, dynamic>> _preparationMethods = [
    {'id': 'powder', 'name': 'Powder', 'tamilName': 'பொடி'},
    {'id': 'decoction', 'name': 'Decoction', 'tamilName': 'கசாயம்'},
    {'id': 'oil', 'name': 'Oil', 'tamilName': 'எண்ணெய்'},
    {'id': 'tablet', 'name': 'Tablet', 'tamilName': 'மாத்திரை'},
  ];

  @override
  void initState() {
    super.initState();
    _tempFilters = Map<String, dynamic>.from(widget.currentFilters);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80.h,
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Handle Bar
          Container(
            width: 12.w,
            height: 0.5.h,
            margin: EdgeInsets.symmetric(vertical: 2.h),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant
                  .withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          // Header
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.currentLanguage == 'Tamil' ? 'வடிகட்டி' : 'Filters',
                  style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      _tempFilters.clear();
                    });
                  },
                  child: Text(
                    widget.currentLanguage == 'Tamil' ? 'அழிக்க' : 'Clear All',
                    style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                      color: AppTheme.lightTheme.primaryColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Divider(height: 1),
          // Filter Content
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(4.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildFilterSection(
                    title: widget.currentLanguage == 'Tamil'
                        ? 'மருந்து வகை'
                        : 'Medicine Type',
                    items: _medicineTypes,
                    filterKey: 'medicineTypes',
                  ),
                  SizedBox(height: 3.h),
                  _buildFilterSection(
                    title: widget.currentLanguage == 'Tamil'
                        ? 'உடல் அமைப்பு'
                        : 'Body System',
                    items: _bodySystems,
                    filterKey: 'bodySystems',
                  ),
                  SizedBox(height: 3.h),
                  _buildFilterSection(
                    title: widget.currentLanguage == 'Tamil'
                        ? 'தயாரிப்பு முறை'
                        : 'Preparation Method',
                    items: _preparationMethods,
                    filterKey: 'preparationMethods',
                  ),
                  SizedBox(height: 3.h),
                  _buildSortingSection(),
                ],
              ),
            ),
          ),
          // Apply Button
          Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.surface,
              border: Border(
                top: BorderSide(
                  color: AppTheme.lightTheme.colorScheme.outline
                      .withValues(alpha: 0.2),
                ),
              ),
            ),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  widget.onFiltersApplied(_tempFilters);
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.lightTheme.primaryColor,
                  padding: EdgeInsets.symmetric(vertical: 2.h),
                ),
                child: Text(
                  widget.currentLanguage == 'Tamil'
                      ? 'பயன்படுத்து'
                      : 'Apply Filters',
                  style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterSection({
    required String title,
    required List<Map<String, dynamic>> items,
    required String filterKey,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: AppTheme.lightTheme.colorScheme.onSurface,
          ),
        ),
        SizedBox(height: 1.h),
        Wrap(
          spacing: 2.w,
          runSpacing: 1.h,
          children: items.map((item) {
            final isSelected = (_tempFilters[filterKey] as List<String>?)
                    ?.contains(item['id']) ??
                false;
            return FilterChip(
              label: Text(
                widget.currentLanguage == 'Tamil'
                    ? item['tamilName'] ?? item['name']
                    : item['name'],
              ),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  _tempFilters[filterKey] ??= <String>[];
                  final filterList = _tempFilters[filterKey] as List<String>;
                  if (selected) {
                    filterList.add(item['id']);
                  } else {
                    filterList.remove(item['id']);
                  }
                });
              },
              backgroundColor: AppTheme.lightTheme.colorScheme.surface,
              selectedColor:
                  AppTheme.lightTheme.primaryColor.withValues(alpha: 0.2),
              checkmarkColor: AppTheme.lightTheme.primaryColor,
              labelStyle: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                color: isSelected
                    ? AppTheme.lightTheme.primaryColor
                    : AppTheme.lightTheme.colorScheme.onSurface,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildSortingSection() {
    final sortOptions = [
      {'id': 'name_asc', 'name': 'Name A-Z', 'tamilName': 'பெயர் அ-ஃ'},
      {'id': 'name_desc', 'name': 'Name Z-A', 'tamilName': 'பெயர் ஃ-அ'},
      {'id': 'popularity', 'name': 'Popularity', 'tamilName': 'பிரபலம்'},
      {
        'id': 'recent',
        'name': 'Recently Added',
        'tamilName': 'சமீபத்தில் சேர்க்கப்பட்டது'
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.currentLanguage == 'Tamil' ? 'வரிசைப்படுத்து' : 'Sort By',
          style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: AppTheme.lightTheme.colorScheme.onSurface,
          ),
        ),
        SizedBox(height: 1.h),
        ...sortOptions.map((option) {
          return RadioListTile<String>(
            title: Text(
              widget.currentLanguage == 'Tamil'
                  ? option['tamilName']!
                  : option['name']!,
              style: AppTheme.lightTheme.textTheme.bodyMedium,
            ),
            value: option['id']!,
            groupValue: _tempFilters['sortBy'] as String?,
            onChanged: (value) {
              setState(() {
                _tempFilters['sortBy'] = value;
              });
            },
            activeColor: AppTheme.lightTheme.primaryColor,
            contentPadding: EdgeInsets.zero,
            visualDensity: VisualDensity.compact,
          );
        }).toList(),
      ],
    );
  }
}
