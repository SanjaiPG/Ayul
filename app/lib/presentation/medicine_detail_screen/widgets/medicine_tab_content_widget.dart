import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class MedicineTabContentWidget extends StatelessWidget {
  final String tabType;
  final Map<String, dynamic> medicineData;
  final Function(String) onDiseaseCardTap;

  const MedicineTabContentWidget({
    Key? key,
    required this.tabType,
    required this.medicineData,
    required this.onDiseaseCardTap,
    required String currentLanguage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    switch (tabType) {
      case 'overview':
        return _buildOverviewTab();
      case 'usage':
        return _buildUsageTab();
      case 'diseases':
        return _buildDiseasesTab();
      case 'precautions':
        return _buildPrecautionsTab();
      default:
        return _buildOverviewTab();
    }
  }

  // Each tab builder uses a ListView for consistent scrolling behavior.
  Widget _buildOverviewTab() {
    return ListView(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      children: [
        _buildSectionHeader('Description'),
        SizedBox(height: 1.h),
        Text(
          medicineData['description'] ?? 'No description available.',
          style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
            height: 1.6,
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
          ),
        ),
        SizedBox(height: 3.h),
        _buildSectionHeader('Properties'),
        SizedBox(height: 1.h),
        _buildPropertiesCard(),
        SizedBox(height: 3.h),
        if (medicineData['scientificName'] != null) ...[
          _buildSectionHeader('Scientific Classification'),
          SizedBox(height: 1.h),
          _buildInfoCard(
              'biotech', 'Scientific Name', medicineData['scientificName']),
          if (medicineData['family'] != null)
            _buildInfoCard('family_restroom', 'Family', medicineData['family']),
          if (medicineData['parts_used'] != null)
            _buildInfoCard('grass', 'Parts Used', medicineData['parts_used']),
        ],
      ],
    );
  }

  Widget _buildUsageTab() {
    return ListView(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      children: [
        _buildSectionHeader('Dosage'),
        SizedBox(height: 1.h),
        _buildDosageCard(),
        SizedBox(height: 3.h),
        _buildSectionHeader('Preparation Instructions'),
        SizedBox(height: 1.h),
        _buildPreparationSteps(),
        SizedBox(height: 3.h),
        _buildSectionHeader('Administration'),
        SizedBox(height: 1.h),
        _buildAdministrationInfo(),
      ],
    );
  }

  Widget _buildDiseasesTab() {
    final relatedDiseases = medicineData['relatedDiseases'] as List? ?? [];
    if (relatedDiseases.isEmpty) {
      // Updated empty state design
      return Center(
        child: Padding(
          padding: EdgeInsets.all(8.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 12.w,
                backgroundColor: AppTheme.lightTheme.colorScheme.surfaceVariant,
                child: CustomIconWidget(
                  iconName: 'vaccines',
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  size: 48,
                ),
              ),
              SizedBox(height: 2.h),
              Text(
                'No Related Diseases',
                style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppTheme.lightTheme.colorScheme.onSurface,
                ),
              ),
              SizedBox(height: 1.h),
              Text(
                'This medicine has no specified related diseases in our records.',
                textAlign: TextAlign.center,
                style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      );
    }
    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      itemCount: relatedDiseases.length,
      itemBuilder: (context, index) {
        final disease = relatedDiseases[index] as Map<String, dynamic>;
        return _buildDiseaseCard(disease);
      },
    );
  }

  Widget _buildPrecautionsTab() {
    return ListView(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      children: [
        _buildSectionHeader('Contraindications'),
        SizedBox(height: 1.h),
        _buildWarningCard(
          'warning',
          'Not Recommended If...',
          medicineData['contraindications'] ??
              'No specific contraindications listed.',
          const Color(0xFFD32F2F), // Red
        ),
        SizedBox(height: 3.h),
        _buildSectionHeader('Possible Side Effects'),
        SizedBox(height: 1.h),
        _buildWarningCard(
          'report_problem',
          'Be Aware Of...',
          medicineData['sideEffects'] ??
              'No known side effects when used as directed.',
          const Color(0xFFFFA000), // Orange
        ),
        SizedBox(height: 3.h),
        _buildSectionHeader('General Precautions'),
        SizedBox(height: 1.h),
        _buildPrecautionsList(),
      ],
    );
  }

  // --- Reusable Component Widgets ---

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
        fontWeight: FontWeight.w600,
        color: AppTheme.lightTheme.colorScheme.primary,
      ),
    );
  }

  Widget _buildPropertiesCard() {
    final properties =
        medicineData['properties'] as Map<String, dynamic>? ?? {};
    return Card(
      elevation: 0,
      color: AppTheme.lightTheme.colorScheme.surfaceVariant.withOpacity(0.5),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(4.w),
        child: Column(
          children: properties.entries.map((entry) {
            return Padding(
              padding: EdgeInsets.symmetric(vertical: 0.5.h),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 2,
                    child: Text(
                      entry.key,
                      style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                  Text(': ', style: AppTheme.lightTheme.textTheme.bodyMedium),
                  Expanded(
                    flex: 3,
                    child: Text(
                      entry.value.toString(),
                      style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onSurface,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildInfoCard(String iconName, String label, String value) {
    return Card(
      elevation: 0,
      margin: EdgeInsets.only(bottom: 1.h),
      color: AppTheme.lightTheme.colorScheme.surfaceVariant.withOpacity(0.5),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(3.w),
        child: Row(
          children: [
            CustomIconWidget(
              iconName: iconName,
              color: AppTheme.lightTheme.colorScheme.primary,
              size: 20,
            ),
            SizedBox(width: 3.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  SizedBox(height: 0.5.h),
                  Text(
                    value,
                    style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onSurface,
                      fontWeight: FontWeight.w500,
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

  Widget _buildDosageCard() {
    final dosage = medicineData['dosage'] as Map<String, dynamic>? ?? {};
    return Card(
      elevation: 0,
      color: AppTheme.lightTheme.colorScheme.tertiaryContainer.withOpacity(0.5),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(4.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              dosage['adult'] ??
                  '1-2 grams twice daily or as directed by physician',
              style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onTertiaryContainer,
                fontWeight: FontWeight.w500,
                height: 1.5,
              ),
            ),
            if (dosage['children'] != null) ...[
              SizedBox(height: 1.h),
              Text(
                'Children: ${dosage['children']}',
                style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onTertiaryContainer
                      .withOpacity(0.8),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildPreparationSteps() {
    final steps = medicineData['preparation'] as List? ?? [];
    return Column(
      children: steps.asMap().entries.map((entry) {
        int index = entry.key;
        String step = entry.value.toString();
        return Padding(
          padding: EdgeInsets.only(bottom: 2.h),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 3.5.w,
                backgroundColor: AppTheme.lightTheme.colorScheme.primary,
                child: Text(
                  '${index + 1}',
                  style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: Text(
                  step,
                  style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                    height: 1.5,
                    color: AppTheme.lightTheme.colorScheme.onSurface,
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildAdministrationInfo() {
    return Card(
      elevation: 0,
      color: AppTheme.lightTheme.colorScheme.surfaceVariant.withOpacity(0.5),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(4.w),
        child: Column(
          children: [
            _buildAdminItem('schedule', 'Best Time',
                medicineData['bestTime'] ?? 'Before meals'),
            _buildAdminItem('timelapse', 'Duration',
                medicineData['duration'] ?? 'As prescribed by physician'),
            _buildAdminItem('blender', 'With',
                medicineData['takeWith'] ?? 'Warm water or honey'),
            _buildAdminItem('inventory_2', 'Storage',
                medicineData['storage'] ?? 'Store in cool, dry place'),
          ],
        ),
      ),
    );
  }

  Widget _buildAdminItem(String iconName, String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 1.5.h),
      child: Row(
        children: [
          CustomIconWidget(
            iconName: iconName,
            color: AppTheme.lightTheme.colorScheme.primary,
            size: 20,
          ),
          SizedBox(width: 3.w),
          Text(
            label,
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w500,
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
          ),
          const Spacer(),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurface,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDiseaseCard(Map<String, dynamic> disease) {
    return Card(
      elevation: 0,
      margin: EdgeInsets.only(bottom: 2.h),
      color: AppTheme.lightTheme.colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: AppTheme.lightTheme.colorScheme.outline.withOpacity(0.2),
        ),
      ),
      child: InkWell(
        onTap: () => onDiseaseCardTap(disease['id'].toString()),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: EdgeInsets.all(4.w),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      disease['name'] ?? 'Unknown Disease',
                      style:
                          AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppTheme.lightTheme.colorScheme.onSurface,
                      ),
                    ),
                    if (disease['tamilName'] != null) ...[
                      SizedBox(height: 0.5.h),
                      Text(
                        disease['tamilName'],
                        style:
                            AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                          color: AppTheme.lightTheme.colorScheme.primary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                    SizedBox(height: 1.h),
                    Text(
                      disease['description'] ?? 'No description available',
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              SizedBox(width: 3.w),
              Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWarningCard(
      String iconName, String title, String content, Color warningColor) {
    return Card(
      elevation: 0,
      color: warningColor.withOpacity(0.1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: warningColor.withOpacity(0.3)),
      ),
      child: Padding(
        padding: EdgeInsets.all(4.w),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomIconWidget(
              iconName: iconName,
              color: warningColor,
              size: 24,
            ),
            SizedBox(width: 3.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold, color: warningColor),
                  ),
                  SizedBox(height: 1.h),
                  Text(
                    content,
                    style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onSurface,
                      height: 1.5,
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

  Widget _buildPrecautionsList() {
    final precautions = [
      'Consult a qualified Siddha practitioner before use',
      'Pregnant and nursing women should avoid unless prescribed',
      'Keep out of reach of children',
      'Discontinue use if any adverse reactions occur',
      'Do not exceed recommended dosage',
      'Store in original container away from direct sunlight'
    ];
    return Column(
      children: precautions.map((precaution) {
        return Padding(
          padding: EdgeInsets.only(bottom: 2.h),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(top: 0.8.h),
                child: CircleAvatar(
                  radius: 0.8.w,
                  backgroundColor:
                      AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: Text(
                  precaution,
                  style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurface,
                    height: 1.5,
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
