import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class FilterChipsRow extends StatelessWidget {
  final List<Map<String, dynamic>> activeFilters;
  final Function(String) onFilterRemoved;
  final String currentLanguage;

  const FilterChipsRow({
    Key? key,
    required this.activeFilters,
    required this.onFilterRemoved,
    required this.currentLanguage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (activeFilters.isEmpty) {
      return SizedBox.shrink();
    }

    return Container(
      height: 6.h,
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: activeFilters.length,
        separatorBuilder: (context, index) => SizedBox(width: 2.w),
        itemBuilder: (context, index) {
          final filter = activeFilters[index];
          return FilterChip(
            label: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  currentLanguage == 'Tamil'
                      ? filter['tamilName'] ?? filter['name']
                      : filter['name'],
                  style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onPrimary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                if (filter['count'] != null) ...[
                  SizedBox(width: 1.w),
                  Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: 1.5.w, vertical: 0.5.h),
                    decoration: BoxDecoration(
                      color: AppTheme.lightTheme.colorScheme.onPrimary
                          .withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '${filter['count']}',
                      style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ],
            ),
            onSelected: (bool selected) {}, // Add required onSelected parameter
            backgroundColor: AppTheme.lightTheme.primaryColor,
            deleteIcon: CustomIconWidget(
              iconName: 'close',
              color: AppTheme.lightTheme.colorScheme.onPrimary,
              size: 4.w,
            ),
            onDeleted: () => onFilterRemoved(filter['id']),
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            visualDensity: VisualDensity.compact,
          );
        },
      ),
    );
  }
}
