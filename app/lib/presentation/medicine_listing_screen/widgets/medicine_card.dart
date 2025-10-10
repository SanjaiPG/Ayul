import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class MedicineCard extends StatelessWidget {
  final Map<String, dynamic> medicine;
  final String currentLanguage;
  final Function(Map<String, dynamic>) onTap;
  final Function(Map<String, dynamic>) onLongPress;

  const MedicineCard({
    Key? key,
    required this.medicine,
    required this.currentLanguage,
    required this.onTap,
    required this.onLongPress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(medicine),
      onLongPress: () => onLongPress(medicine),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.all(4.w),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Medicine Image
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: CustomImageWidget(
                  imageUrl: medicine['image'] ?? '',
                  width: 20.w,
                  height: 20.w,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(width: 4.w),
              // Medicine Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Medicine Name
                    Text(
                      currentLanguage == 'Tamil'
                          ? medicine['tamilName'] ?? medicine['name']
                          : medicine['name'],
                      style:
                          AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppTheme.lightTheme.colorScheme.onSurface,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 1.h),
                    // Brief Description
                    Text(
                      currentLanguage == 'Tamil'
                          ? medicine['tamilDescription'] ??
                              medicine['description']
                          : medicine['description'],
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 1.5.h),
                    // Related Diseases Count
                    Row(
                      children: [
                        CustomIconWidget(
                          iconName: 'local_hospital',
                          color: AppTheme.lightTheme.primaryColor,
                          size: 4.w,
                        ),
                        SizedBox(width: 1.w),
                        Text(
                          currentLanguage == 'Tamil'
                              ? '${medicine['relatedDiseases']} நோய்கள்'
                              : '${medicine['relatedDiseases']} diseases',
                          style: AppTheme.lightTheme.textTheme.labelSmall
                              ?.copyWith(
                            color: AppTheme.lightTheme.primaryColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Column(
                children: [
                  ElevatedButton(
                    onPressed: () => onTap(medicine),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.lightTheme.primaryColor,
                      foregroundColor:
                          AppTheme.lightTheme.colorScheme.onPrimary,
                      padding:
                          EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                      minimumSize: Size(0, 0),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: Text(
                      currentLanguage == 'Tamil' ? 'விவரங்கள்' : 'Details',
                      style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onPrimary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
