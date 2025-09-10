import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class CommonConditionsTabWidget extends StatelessWidget {
  final Map<String, dynamic> bodyPartData;
  final bool isEnglish;
  final Function(String) onConditionTap;

  const CommonConditionsTabWidget({
    Key? key,
    required this.bodyPartData,
    required this.isEnglish,
    required this.onConditionTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final conditions = bodyPartData["commonConditions"] as List;

    return SingleChildScrollView(
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            isEnglish
                ? "Common conditions affecting this body part"
                : "இந்த உடல் பகுதியை பாதிக்கும் பொதுவான நிலைகள்",
            style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
          ),
          SizedBox(height: 2.h),
          ListView.separated(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: conditions.length,
            separatorBuilder: (context, index) => SizedBox(height: 2.h),
            itemBuilder: (context, index) {
              final condition = conditions[index] as Map<String, dynamic>;
              return _buildConditionCard(condition);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildConditionCard(Map<String, dynamic> condition) {
    return GestureDetector(
      onTap: () => onConditionTap(condition["id"].toString()),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color:
                AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.2),
          ),
          boxShadow: [
            BoxShadow(
              color: AppTheme.lightTheme.colorScheme.shadow
                  .withValues(alpha: 0.05),
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    isEnglish
                        ? (condition["name"]["english"] as String)
                        : (condition["name"]["tamil"] as String),
                    style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppTheme.lightTheme.colorScheme.onSurface,
                    ),
                  ),
                ),
                _buildSeverityIndicator(condition["severity"] as String),
              ],
            ),
            SizedBox(height: 1.h),
            Text(
              isEnglish
                  ? (condition["description"]["english"] as String)
                  : (condition["description"]["tamil"] as String),
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                height: 1.4,
              ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 2.h),
            Text(
              isEnglish ? "Common Symptoms:" : "பொதுவான அறிகுறிகள்:",
              style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: AppTheme.lightTheme.colorScheme.primary,
              ),
            ),
            SizedBox(height: 0.5.h),
            Wrap(
              spacing: 1.w,
              runSpacing: 0.5.h,
              children: (condition["symptoms"] as List)
                  .take(3)
                  .map((symptom) => Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 2.w, vertical: 0.5.h),
                        decoration: BoxDecoration(
                          color: AppTheme.lightTheme.colorScheme.primary
                              .withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          isEnglish
                              ? (symptom["english"] as String)
                              : (symptom["tamil"] as String),
                          style:
                              AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                            color: AppTheme.lightTheme.colorScheme.primary,
                            fontSize: 10.sp,
                          ),
                        ),
                      ))
                  .toList(),
            ),
            SizedBox(height: 2.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  isEnglish ? "Tap to learn more" : "மேலும் அறிய தொடவும்",
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                CustomIconWidget(
                  iconName: 'arrow_forward_ios',
                  color: AppTheme.lightTheme.colorScheme.primary,
                  size: 16,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSeverityIndicator(String severity) {
    Color severityColor;
    String severityText;

    switch (severity.toLowerCase()) {
      case 'mild':
        severityColor = Colors.green;
        severityText = isEnglish ? "Mild" : "லேசான";
        break;
      case 'moderate':
        severityColor = Colors.orange;
        severityText = isEnglish ? "Moderate" : "மிதமான";
        break;
      case 'severe':
        severityColor = Colors.red;
        severityText = isEnglish ? "Severe" : "கடுமையான";
        break;
      default:
        severityColor = Colors.grey;
        severityText = isEnglish ? "Unknown" : "தெரியாத";
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
      decoration: BoxDecoration(
        color: severityColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: severityColor.withValues(alpha: 0.3),
        ),
      ),
      child: Text(
        severityText,
        style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
          color: severityColor,
          fontWeight: FontWeight.w600,
          fontSize: 10.sp,
        ),
      ),
    );
  }
}
