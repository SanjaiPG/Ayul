import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class TraditionalPerspectiveTabWidget extends StatelessWidget {
  final Map<String, dynamic> bodyPartData;
  final bool isEnglish;

  const TraditionalPerspectiveTabWidget({
    Key? key,
    required this.bodyPartData,
    required this.isEnglish,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final traditionalData =
        bodyPartData["traditionalPerspective"] as Map<String, dynamic>;

    return SingleChildScrollView(
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildEnergyChannelsSection(traditionalData),
          SizedBox(height: 3.h),
          _buildPressurePointsSection(traditionalData),
          SizedBox(height: 3.h),
          _buildDiagnosticMethodsSection(traditionalData),
          SizedBox(height: 3.h),
          _buildSiddhaViewSection(traditionalData),
          SizedBox(height: 3.h),
          _buildAcupunctureViewSection(traditionalData),
        ],
      ),
    );
  }

  Widget _buildEnergyChannelsSection(Map<String, dynamic> traditionalData) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: EdgeInsets.all(2.w),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.secondary
                    .withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: CustomIconWidget(
                iconName: 'waves',
                color: AppTheme.lightTheme.colorScheme.secondary,
                size: 24,
              ),
            ),
            SizedBox(width: 3.w),
            Expanded(
              child: Text(
                isEnglish
                    ? "Energy Channels & Flow"
                    : "ஆற்றல் வழிகள் மற்றும் ஓட்டம்",
                style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.secondary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 2.h),
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(4.w),
          decoration: BoxDecoration(
            color: AppTheme.lightTheme.colorScheme.secondary
                .withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: AppTheme.lightTheme.colorScheme.secondary
                  .withValues(alpha: 0.2),
            ),
          ),
          child: Text(
            isEnglish
                ? (traditionalData["energyFlow"]["english"] as String)
                : (traditionalData["energyFlow"]["tamil"] as String),
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPressurePointsSection(Map<String, dynamic> traditionalData) {
    final pressurePoints = traditionalData["pressurePoints"] as List;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: EdgeInsets.all(2.w),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.primary
                    .withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: CustomIconWidget(
                iconName: 'my_location',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 24,
              ),
            ),
            SizedBox(width: 3.w),
            Expanded(
              child: Text(
                isEnglish
                    ? "Acupuncture Pressure Points"
                    : "அக்குபஞ்சர் அழுத்த புள்ளிகள்",
                style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 2.h),
        ListView.separated(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: pressurePoints.length,
          separatorBuilder: (context, index) => SizedBox(height: 1.5.h),
          itemBuilder: (context, index) {
            final point = pressurePoints[index] as Map<String, dynamic>;
            return _buildPressurePointCard(point);
          },
        ),
      ],
    );
  }

  Widget _buildPressurePointCard(Map<String, dynamic> point) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 8.w,
                height: 8.w,
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.primary,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    point["code"] as String,
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isEnglish
                          ? (point["name"]["english"] as String)
                          : (point["name"]["tamil"] as String),
                      style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 0.5.h),
                    Text(
                      isEnglish
                          ? "Location: ${point["location"]["english"]}"
                          : "இடம்: ${point["location"]["tamil"]}",
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 1.5.h),
          Text(
            isEnglish ? "Benefits:" : "நன்மைகள்:",
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: AppTheme.lightTheme.colorScheme.primary,
            ),
          ),
          SizedBox(height: 0.5.h),
          Text(
            isEnglish
                ? (point["benefits"]["english"] as String)
                : (point["benefits"]["tamil"] as String),
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              height: 1.3,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDiagnosticMethodsSection(Map<String, dynamic> traditionalData) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: EdgeInsets.all(2.w),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.tertiary
                    .withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: CustomIconWidget(
                iconName: 'search',
                color: AppTheme.lightTheme.colorScheme.tertiary,
                size: 24,
              ),
            ),
            SizedBox(width: 3.w),
            Expanded(
              child: Text(
                isEnglish
                    ? "Traditional Diagnostic Methods"
                    : "பாரம்பரிய நோய் கண்டறிதல் முறைகள்",
                style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.tertiary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 2.h),
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(4.w),
          decoration: BoxDecoration(
            color: AppTheme.lightTheme.colorScheme.tertiary
                .withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: AppTheme.lightTheme.colorScheme.tertiary
                  .withValues(alpha: 0.2),
            ),
          ),
          child: Text(
            isEnglish
                ? (traditionalData["diagnosticMethods"]["english"] as String)
                : (traditionalData["diagnosticMethods"]["tamil"] as String),
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSiddhaViewSection(Map<String, dynamic> traditionalData) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: EdgeInsets.all(2.w),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.secondary
                    .withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: CustomIconWidget(
                iconName: 'healing',
                color: AppTheme.lightTheme.colorScheme.secondary,
                size: 24,
              ),
            ),
            SizedBox(width: 3.w),
            Expanded(
              child: Text(
                isEnglish
                    ? "Siddha Medicine Perspective"
                    : "சித்த மருத்துவ பார்வை",
                style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.secondary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 2.h),
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(4.w),
          decoration: BoxDecoration(
            color: AppTheme.lightTheme.colorScheme.secondary
                .withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: AppTheme.lightTheme.colorScheme.secondary
                  .withValues(alpha: 0.2),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                isEnglish
                    ? "Three Humors (Tridosha) Connection:"
                    : "முக்குற்ற தொடர்பு:",
                style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppTheme.lightTheme.colorScheme.secondary,
                ),
              ),
              SizedBox(height: 1.h),
              Text(
                isEnglish
                    ? (traditionalData["siddhaView"]["tridosha"]["english"]
                        as String)
                    : (traditionalData["siddhaView"]["tridosha"]["tamil"]
                        as String),
                style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  height: 1.4,
                ),
              ),
              SizedBox(height: 2.h),
              Text(
                isEnglish ? "Treatment Approach:" : "சிகிச்சை அணுகுமுறை:",
                style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppTheme.lightTheme.colorScheme.secondary,
                ),
              ),
              SizedBox(height: 1.h),
              Text(
                isEnglish
                    ? (traditionalData["siddhaView"]["treatmentApproach"]
                        ["english"] as String)
                    : (traditionalData["siddhaView"]["treatmentApproach"]
                        ["tamil"] as String),
                style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAcupunctureViewSection(Map<String, dynamic> traditionalData) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: EdgeInsets.all(2.w),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.primary
                    .withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: CustomIconWidget(
                iconName: 'acupuncture',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 24,
              ),
            ),
            SizedBox(width: 3.w),
            Expanded(
              child: Text(
                isEnglish ? "Acupuncture Perspective" : "அக்குபஞ்சர் பார்வை",
                style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 2.h),
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(4.w),
          decoration: BoxDecoration(
            color:
                AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: AppTheme.lightTheme.colorScheme.primary
                  .withValues(alpha: 0.2),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                isEnglish ? "Meridian System:" : "நாடி அமைப்பு:",
                style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppTheme.lightTheme.colorScheme.primary,
                ),
              ),
              SizedBox(height: 1.h),
              Text(
                isEnglish
                    ? (traditionalData["acupunctureView"]["meridianSystem"]
                        ["english"] as String)
                    : (traditionalData["acupunctureView"]["meridianSystem"]
                        ["tamil"] as String),
                style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  height: 1.4,
                ),
              ),
              SizedBox(height: 2.h),
              Text(
                isEnglish ? "Qi Flow Balance:" : "கி ஓட்ட சமநிலை:",
                style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppTheme.lightTheme.colorScheme.primary,
                ),
              ),
              SizedBox(height: 1.h),
              Text(
                isEnglish
                    ? (traditionalData["acupunctureView"]["qiFlow"]["english"]
                        as String)
                    : (traditionalData["acupunctureView"]["qiFlow"]["tamil"]
                        as String),
                style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
