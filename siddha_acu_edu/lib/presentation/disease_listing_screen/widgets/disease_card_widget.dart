import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class DiseaseCardWidget extends StatelessWidget {
  final Map<String, dynamic> disease;
  final VoidCallback onTap;
  final VoidCallback onLongPress;

  const DiseaseCardWidget({
    Key? key,
    required this.disease,
    required this.onTap,
    required this.onLongPress,
  }) : super(key: key);

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

  IconData _getBodySystemIcon(String system) {
    switch (system.toLowerCase()) {
      case 'respiratory':
        return Icons.air;
      case 'digestive':
        return Icons.restaurant;
      case 'skin':
        return Icons.face;
      case 'neurological':
        return Icons.psychology;
      case 'musculoskeletal':
        return Icons.accessibility_new;
      case 'cardiovascular':
        return Icons.favorite;
      default:
        return Icons.medical_services;
    }
  }

  @override
  Widget build(BuildContext context) {
    final String name = disease['name'] ?? 'Unknown Disease';
    final String tamilName = disease['tamilName'] ?? '';
    final List<dynamic> bodySystems = disease['bodySystems'] ?? [];
    final int symptomCount = disease['symptomCount'] ?? 0;
    final String severity = disease['severity'] ?? 'mild';
    final int medicineCount = disease['medicineCount'] ?? 0;
    final List<dynamic> keySymptoms = disease['keySymptoms'] ?? [];

    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
          border: Border.all(
            color:
                AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Section
            Padding(
              padding: EdgeInsets.all(4.w),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          style: AppTheme.lightTheme.textTheme.titleMedium
                              ?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: AppTheme.lightTheme.colorScheme.onSurface,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (tamilName.isNotEmpty) ...[
                          SizedBox(height: 0.5.h),
                          Text(
                            tamilName,
                            style: AppTheme.lightTheme.textTheme.bodySmall
                                ?.copyWith(
                              color: AppTheme
                                  .lightTheme.colorScheme.onSurfaceVariant,
                              fontStyle: FontStyle.italic,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ],
                    ),
                  ),
                  SizedBox(width: 2.w),
                  // Severity Indicator
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                    decoration: BoxDecoration(
                      color: _getSeverityColor(severity).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color:
                            _getSeverityColor(severity).withValues(alpha: 0.3),
                        width: 1,
                      ),
                    ),
                    child: Text(
                      severity.toUpperCase(),
                      style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                        color: _getSeverityColor(severity),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Body Systems Icons
            if (bodySystems.isNotEmpty)
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                child: Row(
                  children: [
                    CustomIconWidget(
                      iconName: 'medical_services',
                      color: AppTheme.lightTheme.colorScheme.primary,
                      size: 4.w,
                    ),
                    SizedBox(width: 2.w),
                    Expanded(
                      child: Wrap(
                        spacing: 2.w,
                        children: bodySystems.take(3).map((system) {
                          return Container(
                            padding: EdgeInsets.all(1.w),
                            decoration: BoxDecoration(
                              color: AppTheme.lightTheme.colorScheme.primary
                                  .withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Icon(
                              _getBodySystemIcon(system.toString()),
                              size: 4.w,
                              color: AppTheme.lightTheme.colorScheme.primary,
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    if (bodySystems.length > 3)
                      Text(
                        '+${bodySystems.length - 3}',
                        style:
                            AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                          color:
                              AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                  ],
                ),
              ),

            SizedBox(height: 2.h),

            // Key Symptoms Preview
            if (keySymptoms.isNotEmpty)
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Key Symptoms:',
                      style:
                          AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppTheme.lightTheme.colorScheme.onSurface,
                      ),
                    ),
                    SizedBox(height: 0.5.h),
                    Text(
                      keySymptoms.take(3).join(', ') +
                          (keySymptoms.length > 3 ? '...' : ''),
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),

            SizedBox(height: 2.h),

            // Footer Section
            Container(
              padding: EdgeInsets.all(4.w),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.surface
                    .withValues(alpha: 0.5),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(12),
                  bottomRight: Radius.circular(12),
                ),
              ),
              child: Row(
                children: [
                  // Symptom Count
                  Row(
                    children: [
                      CustomIconWidget(
                        iconName: 'list_alt',
                        color: AppTheme.lightTheme.colorScheme.primary,
                        size: 4.w,
                      ),
                      SizedBox(width: 1.w),
                      Text(
                        '$symptomCount symptoms',
                        style:
                            AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                          color:
                              AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(width: 4.w),

                  // Medicine Count
                  Row(
                    children: [
                      CustomIconWidget(
                        iconName: 'medication',
                        color: AppTheme.lightTheme.colorScheme.secondary,
                        size: 4.w,
                      ),
                      SizedBox(width: 1.w),
                      Text(
                        '$medicineCount medicines',
                        style:
                            AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                          color:
                              AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),

                  Spacer(),

                  // View Details Button
                  TextButton(
                    onPressed: onTap,
                    style: TextButton.styleFrom(
                      padding:
                          EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'View Details',
                          style: AppTheme.lightTheme.textTheme.labelMedium
                              ?.copyWith(
                            color: AppTheme.lightTheme.colorScheme.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(width: 1.w),
                        CustomIconWidget(
                          iconName: 'arrow_forward_ios',
                          color: AppTheme.lightTheme.colorScheme.primary,
                          size: 3.w,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
