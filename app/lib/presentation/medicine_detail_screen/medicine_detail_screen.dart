import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
// Note: The bottom actions widget import is no longer needed.
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
  String _currentLanguage = 'english';

  // Mock medicine data (remains the same)
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
        "Neem is a powerful medicinal plant widely used in Siddha medicine for its antibacterial, antifungal, and anti-inflammatory properties. Known as the 'village pharmacy', every part of the neem tree has therapeutic value...",
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
        "Avoid during pregnancy and breastfeeding. Not recommended for children below 5 years. People with low blood sugar should use with caution...",
    "sideEffects":
        "Excessive consumption may cause nausea, vomiting, or diarrhea. May cause skin irritation in sensitive individuals...",
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
      body: CustomScrollView(
        slivers: [
          _buildSliverAppBar(),
          SliverToBoxAdapter(
            child: MedicineHeaderWidget(
              englishName: _medicineData['englishName'],
              tamilName: _medicineData['tamilName'],
              pronunciation: _medicineData['pronunciation'],
              onShareTap: _shareMedicine,
            ),
          ),
          SliverPersistentHeader(
            delegate: _SliverAppBarDelegate(
              TabBar(
                controller: _tabController,
                isScrollable: true,
                tabAlignment: TabAlignment.start,
                labelColor: AppTheme.lightTheme.colorScheme.primary,
                unselectedLabelColor:
                    AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                indicatorColor: AppTheme.lightTheme.colorScheme.primary,
                indicatorWeight: 3,
                labelStyle: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
                tabs: const [
                  Tab(text: 'Overview'),
                  Tab(text: 'Usage'),
                  Tab(text: 'Diseases'),
                  Tab(text: 'Precautions'),
                ],
              ),
            ),
            pinned: true,
          ),
          SliverFillRemaining(
            child: TabBarView(
              controller: _tabController,
              children: [
                MedicineTabContentWidget(
                    tabType: 'overview',
                    medicineData: _medicineData,
                    onDiseaseCardTap: _navigateToDisease),
                MedicineTabContentWidget(
                    tabType: 'usage',
                    medicineData: _medicineData,
                    onDiseaseCardTap: _navigateToDisease),
                MedicineTabContentWidget(
                    tabType: 'diseases',
                    medicineData: _medicineData,
                    onDiseaseCardTap: _navigateToDisease),
                MedicineTabContentWidget(
                    tabType: 'precautions',
                    medicineData: _medicineData,
                    onDiseaseCardTap: _navigateToDisease),
              ],
            ),
          ),
        ],
      ),
    );
  }

  SliverAppBar _buildSliverAppBar() {
    return SliverAppBar(
      systemOverlayStyle: SystemUiOverlayStyle.light,
      expandedHeight: 35.h,
      pinned: true,
      stretch: true,
      backgroundColor: AppTheme.lightTheme.colorScheme.surface,
      elevation: 2,
      shadowColor: Colors.black.withOpacity(0.1),
      foregroundColor: AppTheme.lightTheme.colorScheme.primary,
      leading: Padding(
        padding: EdgeInsets.all(2.w),
        child: InkWell(
          onTap: () => Navigator.pop(context),
          customBorder: const CircleBorder(),
          child: CircleAvatar(
            backgroundColor:
                AppTheme.lightTheme.colorScheme.surface.withOpacity(0.8),
            child: CustomIconWidget(
              iconName: 'arrow_back',
              color: AppTheme.lightTheme.colorScheme.primary,
              size: 24,
            ),
          ),
        ),
      ),
      actions: [
        Padding(
          padding: EdgeInsets.all(2.w),
          child: GestureDetector(
            onTap: _toggleLanguage,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.surface.withOpacity(0.8),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  CustomIconWidget(
                      iconName: 'language',
                      color: AppTheme.lightTheme.colorScheme.primary,
                      size: 16),
                  SizedBox(width: 1.w),
                  Text(
                    _currentLanguage == 'english' ? 'EN' : 'TA',
                    style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.primary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        stretchModes: const [StretchMode.zoomBackground, StretchMode.fadeTitle],
        background: MedicineImageGalleryWidget(
          imageUrls: (_medicineData['images'] as List).cast<String>(),
          medicineName: _medicineData['englishName'],
        ),
      ),
    );
  }

  // Action handlers remain the same
  void _shareMedicine() {/* ... */}
  void _toggleLanguage() {
    setState(() {
      _currentLanguage = _currentLanguage == 'english' ? 'tamil' : 'english';
    }); /* ... */
  }

  void _navigateToDisease(String diseaseId) {/* ... */}
}

// Helper class to make the TabBar sticky
class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate(this._tabBar);

  final TabBar _tabBar;

  @override
  double get minExtent => _tabBar.preferredSize.height;
  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: AppTheme.lightTheme.scaffoldBackgroundColor,
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}
