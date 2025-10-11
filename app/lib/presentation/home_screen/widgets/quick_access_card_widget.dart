// File: lib/screens/home/widgets/quick_access_card_widget.dart (Modified)

import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class QuickAccessCardWidget extends StatelessWidget {
  final String title;
  final String subtitle;
  final String? imageUrl; // Made nullable
  final String type;
  final VoidCallback onTap;
  final IconData? iconData; // ✨ NEW: Optional icon data

  const QuickAccessCardWidget({
    Key? key,
    required this.title,
    required this.subtitle,
    this.imageUrl, // Optional
    required this.type,
    required this.onTap,
    this.iconData, // Optional
  }) : super(key: key);

  // Helper method to determine the color scheme
  Color get _primaryColor =>
      type == 'medicine' ? AppTheme.lightTheme.primaryColor : Colors.green;
  Color get _lightColor =>
      type == 'medicine' ? Colors.blue.shade50 : Colors.green.shade50;
  Color get _borderColor =>
      type == 'medicine' ? Colors.blue.shade200 : Colors.green.shade200;
  Color get _darkColor =>
      type == 'medicine' ? Colors.blue.shade700 : Colors.green.shade700;

  @override
  Widget build(BuildContext context) {
    // Determine if we should show the image or the icon placeholder
    final bool useIconPlaceholder = iconData != null || imageUrl == null;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40.w,
        margin: EdgeInsets.only(right: 3.w),
        decoration: BoxDecoration(
            color: AppTheme.lightTheme.colorScheme.surface,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: AppTheme.lightTheme.colorScheme.outline.withOpacity(0.3),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: AppTheme.lightTheme.colorScheme.shadow.withOpacity(0.05),
                blurRadius: 5,
                offset: const Offset(0, 3),
              ),
            ]),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image/Icon Section
            ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(8)),
              child: Container(
                width: double.infinity,
                height: 10.h,
                color: useIconPlaceholder
                    ? _lightColor.withOpacity(0.5)
                    : Colors.grey.shade50,
                child: useIconPlaceholder
                    ? Center(
                        child: Icon(
                          iconData ??
                              Icons
                                  .folder_open, // Use provided icon or a default one
                          size: 5.h,
                          color: _primaryColor,
                        ),
                      )
                    : CustomImageWidget(
                        // Only show image if imageUrl is provided
                        imageUrl: imageUrl!,
                        width: double.infinity,
                        height: 10.h,
                        fit: BoxFit.cover,
                      ),
              ),
            ),

            // Content Section
            Padding(
              padding: EdgeInsets.all(4.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Type Badge
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.3.h),
                    decoration: BoxDecoration(
                      color: _lightColor,
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(
                        color: _borderColor,
                        width: 0.5,
                      ),
                    ),
                    child: Text(
                      type == 'medicine' ? 'MEDICINE' : 'DISEASE',
                      style: TextStyle(
                        fontSize: 8.sp,
                        fontWeight: FontWeight.w600,
                        color: _darkColor,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),

                  SizedBox(height: 1.5.h),

                  // Title
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.lightTheme.colorScheme.onSurface,
                      height: 1.2,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),

                  SizedBox(height: 0.5.h),

                  // Subtitle
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 9.sp,
                      fontWeight: FontWeight.w400,
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      height: 1.3,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
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
