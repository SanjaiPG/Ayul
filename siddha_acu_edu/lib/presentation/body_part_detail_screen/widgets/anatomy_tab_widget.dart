import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class AnatomyTabWidget extends StatelessWidget {
  final Map<String, dynamic> bodyPartData;
  final bool isEnglish;

  const AnatomyTabWidget({
    Key? key,
    required this.bodyPartData,
    required this.isEnglish,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildAnatomyImage(),
          SizedBox(height: 3.h),
          _buildStructureSection(),
          SizedBox(height: 3.h),
          _buildFunctionSection(),
          SizedBox(height: 3.h),
          _buildTraditionalPerspectiveSection(),
          SizedBox(height: 3.h),
          _buildRelatedSystemsSection(),
        ],
      ),
    );
  }

  Widget _buildAnatomyImage() {
    return Container(
      width: double.infinity,
      height: 25.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.outline,
          width: 1,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: CustomImageWidget(
          imageUrl: bodyPartData["anatomyImage"] as String,
          width: double.infinity,
          height: 25.h,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildStructureSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          isEnglish ? "Structure & Composition" : "அமைப்பு மற்றும் கூறுகள்",
          style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
            color: AppTheme.lightTheme.colorScheme.primary,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 1.h),
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(4.w),
          decoration: BoxDecoration(
            color: AppTheme.lightTheme.colorScheme.surface,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: AppTheme.lightTheme.colorScheme.outline
                  .withValues(alpha: 0.3),
            ),
          ),
          child: Text(
            isEnglish
                ? (bodyPartData["structure"]["english"] as String)
                : (bodyPartData["structure"]["tamil"] as String),
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFunctionSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          isEnglish ? "Primary Functions" : "முக்கிய செயல்பாடுகள்",
          style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
            color: AppTheme.lightTheme.colorScheme.primary,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 1.h),
        ...(bodyPartData["functions"] as List)
            .map((function) => Padding(
                  padding: EdgeInsets.only(bottom: 1.h),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: 0.5.h, right: 2.w),
                        width: 1.w,
                        height: 1.w,
                        decoration: BoxDecoration(
                          color: AppTheme.lightTheme.colorScheme.primary,
                          shape: BoxShape.circle,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          isEnglish
                              ? (function["english"] as String)
                              : (function["tamil"] as String),
                          style: AppTheme.lightTheme.textTheme.bodyMedium,
                        ),
                      ),
                    ],
                  ),
                ))
            .toList(),
      ],
    );
  }

  Widget _buildTraditionalPerspectiveSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          isEnglish
              ? "Traditional Medicine Perspective"
              : "பாரம்பரிய மருத்துவ பார்வை",
          style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
            color: AppTheme.lightTheme.colorScheme.secondary,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 1.h),
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(4.w),
          decoration: BoxDecoration(
            color: AppTheme.lightTheme.colorScheme.secondary
                .withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(8),
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
                    ? "Energy Flow & Channels:"
                    : "ஆற்றல் ஓட்டம் மற்றும் வழிகள்:",
                style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppTheme.lightTheme.colorScheme.secondary,
                ),
              ),
              SizedBox(height: 0.5.h),
              Text(
                isEnglish
                    ? (bodyPartData["traditionalPerspective"]["energyFlow"]
                        ["english"] as String)
                    : (bodyPartData["traditionalPerspective"]["energyFlow"]
                        ["tamil"] as String),
                style: AppTheme.lightTheme.textTheme.bodyMedium,
              ),
              SizedBox(height: 2.h),
              Text(
                isEnglish ? "Diagnostic Methods:" : "நோய் கண்டறிதல் முறைகள்:",
                style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppTheme.lightTheme.colorScheme.secondary,
                ),
              ),
              SizedBox(height: 0.5.h),
              Text(
                isEnglish
                    ? (bodyPartData["traditionalPerspective"]
                        ["diagnosticMethods"]["english"] as String)
                    : (bodyPartData["traditionalPerspective"]
                        ["diagnosticMethods"]["tamil"] as String),
                style: AppTheme.lightTheme.textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRelatedSystemsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          isEnglish ? "Related Organ Systems" : "தொடர்புடைய உறுப்பு அமைப்புகள்",
          style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
            color: AppTheme.lightTheme.colorScheme.primary,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 1.h),
        Wrap(
          spacing: 2.w,
          runSpacing: 1.h,
          children: (bodyPartData["relatedSystems"] as List)
              .map((system) => Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                    decoration: BoxDecoration(
                      color: AppTheme.lightTheme.colorScheme.primary
                          .withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: AppTheme.lightTheme.colorScheme.primary
                            .withValues(alpha: 0.3),
                      ),
                    ),
                    child: Text(
                      isEnglish
                          ? (system["english"] as String)
                          : (system["tamil"] as String),
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.primary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ))
              .toList(),
        ),
      ],
    );
  }
}
