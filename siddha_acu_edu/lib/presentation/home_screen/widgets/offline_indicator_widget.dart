import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class OfflineIndicatorWidget extends StatelessWidget {
  final bool isOffline;

  const OfflineIndicatorWidget({
    Key? key,
    required this.isOffline,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return isOffline
        ? Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 1.h),
            color: AppTheme.lightTheme.colorScheme.error.withValues(alpha: 0.1),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomIconWidget(
                  iconName: 'wifi_off',
                  color: AppTheme.lightTheme.colorScheme.error,
                  size: 16,
                ),
                SizedBox(width: 2.w),
                Text(
                  'Offline Mode - Limited functionality',
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                    color: AppTheme.lightTheme.colorScheme.error,
                  ),
                ),
              ],
            ),
          )
        : SizedBox.shrink();
  }
}
