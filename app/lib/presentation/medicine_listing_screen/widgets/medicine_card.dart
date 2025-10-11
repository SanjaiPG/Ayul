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
    final name = currentLanguage == 'Tamil'
        ? (medicine['Name_Tamil'] ?? medicine['Name'] ?? 'Unknown')
        : (medicine['Name'] ?? 'Unknown');

    final description = currentLanguage == 'Tamil'
        ? (medicine['Description_Tamil'] ?? medicine['Description'] ?? '')
        : (medicine['Description'] ?? '');

    final type = currentLanguage == 'Tamil'
        ? (medicine['Type_Of_Medicine_Tamil'] ??
            medicine['Type_Of_Medicine'] ??
            '')
        : (medicine['Type_Of_Medicine'] ?? '');

    final imageUrl = medicine['Image'] ?? '';

    return GestureDetector(
      onTap: () => onTap(medicine),
      onLongPress: () => onLongPress(medicine),
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (imageUrl.isNotEmpty)
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
                child: Image.network(
                  imageUrl,
                  width: double.infinity,
                  height: 20.h,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: double.infinity,
                      height: 20.h,
                      color: Colors.grey[200],
                      child: Icon(
                        Icons.image_not_supported,
                        size: 10.w,
                        color: Colors.grey[400],
                      ),
                    );
                  },
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Container(
                      width: double.infinity,
                      height: 20.h,
                      color: Colors.grey[200],
                      child: Center(
                        child: CircularProgressIndicator(
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded /
                                  loadingProgress.expectedTotalBytes!
                              : null,
                        ),
                      ),
                    );
                  },
                ),
              ),
            Padding(
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
                  if (type.isNotEmpty)
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 2.w, vertical: 0.5.h),
                      decoration: BoxDecoration(
                        color:
                            AppTheme.lightTheme.primaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        type,
                        style:
                            AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                          color: AppTheme.lightTheme.primaryColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
