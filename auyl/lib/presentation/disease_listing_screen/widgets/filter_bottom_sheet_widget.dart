import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class FilterBottomSheetWidget extends StatefulWidget {
  final Map<String, dynamic> currentFilters;
  final Function(Map<String, dynamic>) onFiltersApplied;

  const FilterBottomSheetWidget({
    Key? key,
    required this.currentFilters,
    required this.onFiltersApplied,
  }) : super(key: key);

  @override
  State<FilterBottomSheetWidget> createState() =>
      _FilterBottomSheetWidgetState();
}

class _FilterBottomSheetWidgetState extends State<FilterBottomSheetWidget> {
  late Map<String, dynamic> _filters;

  final List<String> _bodySystems = [
    'Respiratory',
    'Digestive',
    'Skin',
    'Neurological',
    'Musculoskeletal',
    'Cardiovascular',
    'Endocrine',
    'Immune',
  ];

  final List<String> _severityLevels = ['Mild', 'Moderate', 'Severe'];
  final List<String> _sortOptions = ['A-Z', 'Z-A', 'Severity', 'Most Common'];

  @override
  void initState() {
    super.initState();
    _filters = Map<String, dynamic>.from(widget.currentFilters);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle Bar
          Container(
            margin: EdgeInsets.only(top: 2.h),
            width: 12.w,
            height: 0.5.h,
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.outline,
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Header
          Padding(
            padding: EdgeInsets.all(4.w),
            child: Row(
              children: [
                Text(
                  'Filter Diseases',
                  style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Spacer(),
                TextButton(
                  onPressed: _clearFilters,
                  child: Text(
                    'Clear All',
                    style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.primary,
                    ),
                  ),
                ),
              ],
            ),
          ),

          Divider(height: 1),

          // Filter Content
          Flexible(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(4.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Body Systems Filter
                  _buildSectionTitle('Body Systems'),
                  SizedBox(height: 1.h),
                  _buildBodySystemsFilter(),

                  SizedBox(height: 3.h),

                  // Severity Filter
                  _buildSectionTitle('Severity Level'),
                  SizedBox(height: 1.h),
                  _buildSeverityFilter(),

                  SizedBox(height: 3.h),

                  // Sort Options
                  _buildSectionTitle('Sort By'),
                  SizedBox(height: 1.h),
                  _buildSortOptions(),

                  SizedBox(height: 4.h),
                ],
              ),
            ),
          ),

          // Action Buttons
          Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.surface,
              border: Border(
                top: BorderSide(
                  color: AppTheme.lightTheme.colorScheme.outline
                      .withValues(alpha: 0.2),
                  width: 1,
                ),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('Cancel'),
                  ),
                ),
                SizedBox(width: 4.w),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _applyFilters,
                    child: Text('Apply Filters'),
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: MediaQuery.of(context).padding.bottom),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
        fontWeight: FontWeight.w600,
        color: AppTheme.lightTheme.colorScheme.onSurface,
      ),
    );
  }

  Widget _buildBodySystemsFilter() {
    final List<String> selectedSystems =
        List<String>.from(_filters['bodySystems'] ?? []);

    return Wrap(
      spacing: 2.w,
      runSpacing: 1.h,
      children: _bodySystems.map((system) {
        final isSelected = selectedSystems.contains(system);
        return FilterChip(
          label: Text(system),
          selected: isSelected,
          onSelected: (selected) {
            setState(() {
              if (selected) {
                selectedSystems.add(system);
              } else {
                selectedSystems.remove(system);
              }
              _filters['bodySystems'] = selectedSystems;
            });
          },
          backgroundColor: AppTheme.lightTheme.colorScheme.surface,
          selectedColor:
              AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.2),
          checkmarkColor: AppTheme.lightTheme.colorScheme.primary,
          labelStyle: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
            color: isSelected
                ? AppTheme.lightTheme.colorScheme.primary
                : AppTheme.lightTheme.colorScheme.onSurface,
          ),
          side: BorderSide(
            color: isSelected
                ? AppTheme.lightTheme.colorScheme.primary
                : AppTheme.lightTheme.colorScheme.outline,
          ),
        );
      }).toList(),
    );
  }

  Widget _buildSeverityFilter() {
    final List<String> selectedSeverities =
        List<String>.from(_filters['severities'] ?? []);

    return Row(
      children: _severityLevels.map((severity) {
        final isSelected = selectedSeverities.contains(severity);
        return Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 1.w),
            child: FilterChip(
              label: Text(severity),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  if (selected) {
                    selectedSeverities.add(severity);
                  } else {
                    selectedSeverities.remove(severity);
                  }
                  _filters['severities'] = selectedSeverities;
                });
              },
              backgroundColor: AppTheme.lightTheme.colorScheme.surface,
              selectedColor: _getSeverityColor(severity).withValues(alpha: 0.2),
              checkmarkColor: _getSeverityColor(severity),
              labelStyle: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                color: isSelected
                    ? _getSeverityColor(severity)
                    : AppTheme.lightTheme.colorScheme.onSurface,
              ),
              side: BorderSide(
                color: isSelected
                    ? _getSeverityColor(severity)
                    : AppTheme.lightTheme.colorScheme.outline,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildSortOptions() {
    final String selectedSort = _filters['sortBy'] ?? 'A-Z';

    return Column(
      children: _sortOptions.map((option) {
        final isSelected = selectedSort == option;
        return RadioListTile<String>(
          title: Text(
            option,
            style: AppTheme.lightTheme.textTheme.bodyMedium,
          ),
          value: option,
          groupValue: selectedSort,
          onChanged: (value) {
            setState(() {
              _filters['sortBy'] = value;
            });
          },
          activeColor: AppTheme.lightTheme.colorScheme.primary,
          contentPadding: EdgeInsets.zero,
        );
      }).toList(),
    );
  }

  Color _getSeverityColor(String severity) {
    switch (severity.toLowerCase()) {
      case 'mild':
        return Colors.green;
      case 'moderate':
        return Colors.orange;
      case 'severe':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  void _clearFilters() {
    setState(() {
      _filters = {
        'bodySystems': <String>[],
        'severities': <String>[],
        'sortBy': 'A-Z',
      };
    });
  }

  void _applyFilters() {
    widget.onFiltersApplied(_filters);
    Navigator.pop(context);
  }
}
