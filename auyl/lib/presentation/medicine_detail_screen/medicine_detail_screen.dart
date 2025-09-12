import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/medicine_header_widget.dart';
import './widgets/medicine_image_gallery_widget.dart';
import './widgets/medicine_tab_content_widget.dart';

class MedicineDetailScreen extends StatefulWidget {
  const MedicineDetailScreen({Key? key}) : super(key: key);

  @override
  State<MedicineDetailScreen> createState() => _MedicineDetailScreenState();
}

class _MedicineDetailScreenState extends State<MedicineDetailScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  bool _isInStudyList = false;
  String _currentLanguage = 'english';

  // Mock medicine data
  final Map<String, dynamic> _medicineData = {
    "id": "med_001",
    "englishName": "Neem",
    "tamilName": "வேம்பு",
    "pronunciation": "Vem-bu",
    "images": [
      "https://images.pexels.com/photos/6627946/pexels-photo-6627946.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
      "https://images.pexels.com/photos/7195133/pexels-photo-7195133.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
      "https://images.pexels.com/photos/6627945/pexels-photo-6627945.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1"
    ],
    "description":
        "Neem is a powerful medicinal plant widely used in Siddha medicine for its antibacterial, antifungal, and anti-inflammatory properties. Known as the 'village pharmacy', every part of the neem tree has therapeutic value. It is particularly effective in treating skin disorders, diabetes, and digestive issues. The bitter compounds in neem help purify blood and boost immunity.",
    "scientificName": "Azadirachta indica",
    "family": "Meliaceae",
    "parts_used": "Leaves, bark, seeds, oil",
    "properties": {
      "Taste": "Bitter (Kaippu)",
      "Potency": "Cold (Thandappam)",
      "Post-digestive effect": "Pungent (Karppu)",
      "Action": "Blood purifier, Anti-microbial"
    },
    "dosage": {
      "adult": "2-4 grams of leaf powder twice daily",
      "children": "1-2 grams once daily (above 5 years)"
    },
    "preparation": [
      "Wash fresh neem leaves thoroughly",
      "Dry the leaves in shade for 3-4 days",
      "Grind dried leaves into fine powder",
      "Store in airtight container",
      "Mix prescribed amount with warm water or honey before consumption"
    ],
    "bestTime": "Early morning on empty stomach",
    "duration": "15-30 days or as prescribed",
    "takeWith": "Warm water, honey, or buttermilk",
    "storage": "Store in cool, dry place away from direct sunlight",
    "contraindications":
        "Avoid during pregnancy and breastfeeding. Not recommended for children below 5 years. People with low blood sugar should use with caution as neem can lower glucose levels.",
    "sideEffects":
        "Excessive consumption may cause nausea, vomiting, or diarrhea. May cause skin irritation in sensitive individuals. Long-term use in high doses may affect fertility.",
    "relatedDiseases": [
      {
        "id": "dis_001",
        "name": "Diabetes Mellitus",
        "tamilName": "நீரிழிவு நோய்",
        "description":
            "Chronic condition characterized by high blood sugar levels"
      },
      {
        "id": "dis_002",
        "name": "Eczema",
        "tamilName": "சொறி சிரங்கு",
        "description": "Inflammatory skin condition causing itching and rashes"
      },
      {
        "id": "dis_003",
        "name": "Acne",
        "tamilName": "முகப்பரு",
        "description": "Common skin condition affecting hair follicles"
      },
      {
        "id": "dis_004",
        "name": "Digestive Disorders",
        "tamilName": "செரிமான கோளாறுகள்",
        "description": "Various conditions affecting the digestive system"
      }
    ]
  };

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: Column(
        children: [
          // Custom App Bar with back button
          _buildCustomAppBar(),

          // Scrollable content
          Expanded(
            child: CustomScrollView(
              slivers: [
                // Image Gallery
                SliverToBoxAdapter(
                  child: MedicineImageGalleryWidget(
                    imageUrls: (_medicineData['images'] as List).cast<String>(),
                    medicineName: _medicineData['englishName'],
                  ),
                ),

                // Medicine Header
                SliverToBoxAdapter(
                  child: MedicineHeaderWidget(
                    englishName: _medicineData['englishName'],
                    tamilName: _medicineData['tamilName'],
                    pronunciation: _medicineData['pronunciation'],
                    onShareTap: _shareMedicine,
                  ),
                ),

                // Tab Bar
                SliverToBoxAdapter(
                  child: _buildTabBar(),
                ),

                // Tab Content
                SliverFillRemaining(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      MedicineTabContentWidget(
                        tabType: 'overview',
                        medicineData: _medicineData,
                        onDiseaseCardTap: _navigateToDisease,
                      ),
                      MedicineTabContentWidget(
                        tabType: 'usage',
                        medicineData: _medicineData,
                        onDiseaseCardTap: _navigateToDisease,
                      ),
                      MedicineTabContentWidget(
                        tabType: 'diseases',
                        medicineData: _medicineData,
                        onDiseaseCardTap: _navigateToDisease,
                      ),
                      MedicineTabContentWidget(
                        tabType: 'precautions',
                        medicineData: _medicineData,
                        onDiseaseCardTap: _navigateToDisease,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Bottom Action
        ],
      ),
    );
  }

  Widget _buildCustomAppBar() {
    return Container(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top,
        left: 4.w,
        right: 4.w,
        bottom: 1.h,
      ),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              padding: EdgeInsets.all(2.w),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: CustomIconWidget(
                iconName: 'arrow_back',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 24,
              ),
            ),
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Text(
              'Medicine Details',
              style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
                color: AppTheme.lightTheme.colorScheme.onSurface,
              ),
            ),
          ),
          // Language Toggle
          GestureDetector(
            onTap: _toggleLanguage,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
              decoration: BoxDecoration(
                color:
                    AppTheme.lightTheme.colorScheme.tertiary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color:
                      AppTheme.lightTheme.colorScheme.tertiary.withOpacity(0.3),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomIconWidget(
                    iconName: 'language',
                    color: AppTheme.lightTheme.colorScheme.tertiary,
                    size: 16,
                  ),
                  SizedBox(width: 1.w),
                  Text(
                    _currentLanguage == 'english' ? 'EN' : 'TA',
                    style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.tertiary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      color: AppTheme.lightTheme.colorScheme.surface,
      child: TabBar(
        controller: _tabController,
        isScrollable: true,
        tabAlignment: TabAlignment.start,
        labelColor: AppTheme.lightTheme.colorScheme.primary,
        unselectedLabelColor: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
        indicatorColor: AppTheme.lightTheme.colorScheme.primary,
        indicatorWeight: 3,
        labelStyle: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle:
            AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
          fontWeight: FontWeight.w400,
        ),
        tabs: const [
          Tab(text: 'Overview'),
          Tab(text: 'Usage'),
          Tab(text: 'Diseases'),
          Tab(text: 'Precautions'),
        ],
      ),
    );
  }

  void _shareMedicine() {
    HapticFeedback.lightImpact();

    final String shareText = '''
${_medicineData['englishName']} (${_medicineData['tamilName']})

${_medicineData['description']}

Scientific Name: ${_medicineData['scientificName']}
Family: ${_medicineData['family']}

Shared from Siddha Acu Edu App
''';

    // In a real app, you would use the share_plus package
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Medicine details copied to clipboard'),
        duration: Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _toggleLanguage() {
    setState(() {
      _currentLanguage = _currentLanguage == 'english' ? 'tamil' : 'english';
    });

    HapticFeedback.lightImpact();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Language switched to ${_currentLanguage == 'english' ? 'English' : 'Tamil'}',
        ),
        duration: const Duration(seconds: 1),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _navigateToDisease(String diseaseId) {
    HapticFeedback.lightImpact();

    // Navigate to disease detail screen
    // Navigator.pushNamed(context, '/disease-detail-screen', arguments: diseaseId);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Navigating to disease details...'),
        duration: Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _viewRelatedDiseases() {
    HapticFeedback.mediumImpact();

    // Switch to diseases tab
    _tabController.animateTo(2);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Showing related diseases'),
        duration: Duration(seconds: 1),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _toggleStudyList() {
    setState(() {
      _isInStudyList = !_isInStudyList;
    });

    HapticFeedback.lightImpact();

    ScaffoldMessenger.of((context)).showSnackBar(
      SnackBar(
        content: Text(
          _isInStudyList ? 'Added to study list' : 'Removed from study list',
        ),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
