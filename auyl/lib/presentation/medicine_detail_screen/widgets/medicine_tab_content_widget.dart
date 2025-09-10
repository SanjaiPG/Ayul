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

  Widget _buildOverviewTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Description
          _buildSectionHeader('Description'),
          SizedBox(height: 1.h),
          Text(
            medicineData['description'] ?? 'No description available.',
            style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
              height: 1.6,
              color: AppTheme.lightTheme.colorScheme.onSurface,
            ),
          ),

          SizedBox(height: 3.h),

          // Properties
          _buildSectionHeader('Properties'),
          SizedBox(height: 1.h),
          _buildPropertiesGrid(),

          SizedBox(height: 3.h),

          // Scientific Classification
          if (medicineData['scientificName'] != null) ...[
            _buildSectionHeader('Scientific Classification'),
            SizedBox(height: 1.h),
            _buildInfoCard('Scientific Name', medicineData['scientificName']),
            if (medicineData['family'] != null)
              _buildInfoCard('Family', medicineData['family']),
            if (medicineData['parts_used'] != null)
              _buildInfoCard('Parts Used', medicineData['parts_used']),
          ],
        ],
      ),
    );
  }

  Widget _buildUsageTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Dosage
          _buildSectionHeader('Dosage'),
          SizedBox(height: 1.h),
          _buildDosageCard(),

          SizedBox(height: 3.h),

          // Preparation
          _buildSectionHeader('Preparation Instructions'),
          SizedBox(height: 1.h),
          _buildPreparationSteps(),

          SizedBox(height: 3.h),

          // Administration
          _buildSectionHeader('Administration'),
          SizedBox(height: 1.h),
          _buildAdministrationInfo(),
        ],
      ),
    );
  }

  Widget _buildDiseasesTab() {
    final relatedDiseases = medicineData['relatedDiseases'] as List? ?? [];

    return relatedDiseases.isEmpty
        ? Center(
            child: Padding(
              padding: EdgeInsets.all(4.w),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomIconWidget(
                    iconName: 'medical_services',
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    size: 48,
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    'No related diseases found',
                    style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          )
        : ListView.builder(
            padding: EdgeInsets.all(4.w),
            itemCount: relatedDiseases.length,
            itemBuilder: (context, index) {
              final disease = relatedDiseases[index] as Map<String, dynamic>;
              return _buildDiseaseCard(disease);
            },
          );
  }

  Widget _buildPrecautionsTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Contraindications
          _buildSectionHeader('Contraindications'),
          SizedBox(height: 1.h),
          _buildWarningCard(
            medicineData['contraindications'] ??
                'No specific contraindications listed.',
            Colors.red,
          ),

          SizedBox(height: 3.h),

          // Side Effects
          _buildSectionHeader('Possible Side Effects'),
          SizedBox(height: 1.h),
          _buildWarningCard(
            medicineData['sideEffects'] ??
                'No known side effects when used as directed.',
            Colors.orange,
          ),

          SizedBox(height: 3.h),

          // General Precautions
          _buildSectionHeader('General Precautions'),
          SizedBox(height: 1.h),
          _buildPrecautionsList(),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
        fontWeight: FontWeight.w600,
        color: AppTheme.lightTheme.colorScheme.primary,
      ),
    );
  }

  Widget _buildPropertiesGrid() {
    final properties =
        medicineData['properties'] as Map<String, dynamic>? ?? {};

    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
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
    );
  }

  Widget _buildInfoCard(String label, String value) {
    return Container(
      margin: EdgeInsets.only(bottom: 1.h),
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
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
              value,
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurface,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDosageCard() {
    final dosage = medicineData['dosage'] as Map<String, dynamic>? ?? {};

    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.tertiary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color:
              AppTheme.lightTheme.colorScheme.tertiary.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CustomIconWidget(
                iconName: 'medication',
                color: AppTheme.lightTheme.colorScheme.tertiary,
                size: 20,
              ),
              SizedBox(width: 2.w),
              Text(
                'Recommended Dosage',
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppTheme.lightTheme.colorScheme.onTertiaryContainer,
                ),
              ),
            ],
          ),
          SizedBox(height: 1.h),
          Text(
            dosage['adult'] ??
                '1-2 grams twice daily or as directed by physician',
            style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onTertiaryContainer,
            ),
          ),
          if (dosage['children'] != null) ...[
            SizedBox(height: 1.h),
            Text(
              'Children: ${dosage['children']}',
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onTertiaryContainer,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildPreparationSteps() {
    final steps = medicineData['preparation'] as List? ??
        [
          'Take the prescribed amount of medicine',
          'Mix with warm water or honey as directed',
          'Consume on empty stomach for better absorption',
          'Follow the timing as advised by physician'
        ];

    return Column(
      children: steps.asMap().entries.map((entry) {
        int index = entry.key;
        String step = entry.value.toString();

        return Container(
          margin: EdgeInsets.only(bottom: 2.h),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 6.w,
                height: 6.w,
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.primary,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    '${index + 1}',
                    style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onPrimary,
                      fontWeight: FontWeight.w600,
                    ),
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
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildAdminItem(
              'Best Time', medicineData['bestTime'] ?? 'Before meals'),
          _buildAdminItem('Duration',
              medicineData['duration'] ?? 'As prescribed by physician'),
          _buildAdminItem(
              'With', medicineData['takeWith'] ?? 'Warm water or honey'),
          _buildAdminItem(
              'Storage', medicineData['storage'] ?? 'Store in cool, dry place'),
        ],
      ),
    );
  }

  Widget _buildAdminItem(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 1.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 20.w,
            child: Text(
              label,
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          Text(': ', style: AppTheme.lightTheme.textTheme.bodyMedium),
          Expanded(
            child: Text(
              value,
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
    return GestureDetector(
      onTap: () => onDiseaseCardTap(disease['id'].toString()),
      child: Container(
        margin: EdgeInsets.only(bottom: 2.h),
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
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 12.w,
              height: 12.w,
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.primary
                    .withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: CustomIconWidget(
                  iconName: 'medical_services',
                  color: AppTheme.lightTheme.colorScheme.primary,
                  size: 24,
                ),
              ),
            ),
            SizedBox(width: 3.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    disease['name'] ?? 'Unknown Disease',
                    style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppTheme.lightTheme.colorScheme.onSurface,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (disease['tamilName'] != null) ...[
                    SizedBox(height: 0.5.h),
                    Text(
                      disease['tamilName'],
                      style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.primary,
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                  SizedBox(height: 0.5.h),
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
            CustomIconWidget(
              iconName: 'arrow_forward_ios',
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWarningCard(String content, Color warningColor) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: warningColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: warningColor.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomIconWidget(
            iconName: 'warning',
            color: warningColor,
            size: 20,
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Text(
              content,
              style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurface,
                height: 1.5,
              ),
            ),
          ),
        ],
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
        return Container(
          margin: EdgeInsets.only(bottom: 1.h),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.only(top: 1.h),
                width: 1.w,
                height: 1.w,
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  shape: BoxShape.circle,
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: Text(
                  precaution,
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
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
