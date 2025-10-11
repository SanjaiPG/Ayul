import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../../../core/app_export.dart';

class DiseaseCard extends StatelessWidget {
  final Map<String, dynamic> disease;
  final String currentLanguage;
  final Function(Map<String, dynamic>) onTap;
  final Function(Map<String, dynamic>) onLongPress;

  const DiseaseCard({
    Key? key,
    required this.disease,
    required this.currentLanguage,
    required this.onTap,
    required this.onLongPress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final name = currentLanguage == 'Tamil'
        ? (disease['Name_Tamil'] ?? disease['name'] ?? 'Unknown')
        : (disease['name'] ?? 'Unknown');

    final description = currentLanguage == 'Tamil'
        ? (disease['Description_Tamil'] ?? disease['description'] ?? '')
        : (disease['description'] ?? '');

    final medicines = currentLanguage == 'Tamil'
        ? (disease['Medicines_Tamil'] ?? disease['medicines'] ?? '')
        : (disease['medicines'] ?? '');

    final treatments = currentLanguage == 'Tamil'
        ? (disease['Treatments_Tamil'] ?? disease['treatments'] ?? '')
        : (disease['treatments'] ?? '');

    return GestureDetector(
      onTap: () => onTap(disease),
      onLongPress: () => onLongPress(disease),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
        decoration: BoxDecoration(
          color: Color(0x7BFAFAFA),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.all(3.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppTheme.lightTheme.colorScheme.onSurface,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 1.h),
              if (description.isNotEmpty)
                Text(
                  description,
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              if (medicines.isNotEmpty) ...[
                SizedBox(height: 1.h),
                Text(
                  currentLanguage == 'Tamil' ? 'மருந்துகள்' : 'Medicines',
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 0.5.h),
                Text(
                  medicines,
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
              if (treatments.isNotEmpty) ...[
                SizedBox(height: 1.h),
                Text(
                  currentLanguage == 'Tamil' ? 'சிகிச்சைகள்' : 'Treatments',
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 0.5.h),
                Text(
                  treatments,
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
