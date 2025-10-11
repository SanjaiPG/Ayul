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
  String _currentLanguage = 'english';
  Map<String, dynamic>? _medicineData;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Get the medicine data passed from the previous screen
    if (_medicineData == null) {
      final args = ModalRoute.of(context)?.settings.arguments;
      if (args != null && args is Map<String, dynamic>) {
        setState(() {
          _medicineData = _transformMedicineData(args);
        });
      }
    }
  }

  // Transform Firestore data to match the expected format
  Map<String, dynamic> _transformMedicineData(
      Map<String, dynamic> firestoreData) {
    return {
      "id": firestoreData['id'] ?? '',
      "englishName": firestoreData['Name'] ?? 'Unknown Medicine',
      "tamilName": firestoreData['Name_Tamil'] ?? '',
      "pronunciation": firestoreData['Pronunciation'] ?? '',
      "images": _parseImages(firestoreData['Image']),
      "description": firestoreData['Description'] ?? 'No description available',
      "description_tamil": firestoreData['Description_Tamil'] ?? '',
      "scientificName": firestoreData['Scientific_Name'] ?? 'N/A',
      "parts_used": firestoreData['Parts_Used'] ?? 'N/A',
      "parts_used_tamil": firestoreData['Parts_Used_Tamil'] ?? '',
      "dosage": _parseDosage(firestoreData),
      "dosage_tamil": firestoreData['Dosage_Tamil'] ?? '',
      "relatedDiseases": firestoreData['Related_Diseases'] ?? [],
    };
  }

  List<String> _parseImages(dynamic imageData) {
    if (imageData == null) return [];

    if (imageData is String) {
      if (imageData.isEmpty) return [];
      if (imageData.contains(',')) {
        return imageData
            .split(',')
            .map((e) => e.trim())
            .where((e) => e.isNotEmpty)
            .toList();
      }
      return [imageData];
    }

    if (imageData is List) {
      return imageData
          .map((e) => e.toString())
          .where((e) => e.isNotEmpty)
          .toList();
    }

    return [];
  }

  Map<String, dynamic> _parseDosage(Map<String, dynamic> data) {
    final dosageStr = data['Dosage'] ?? '';

    return {
      "adult": dosageStr.isNotEmpty ? dosageStr : "As prescribed",
      "children": data['Dosage_Children'] ?? "Consult practitioner",
    };
  }

  List<String> _parsePreparation(dynamic preparationData) {
    if (preparationData == null) return [];

    if (preparationData is String) {
      if (preparationData.isEmpty) return [];
      return preparationData
          .split(RegExp(r'[.\n]'))
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .toList();
    }

    if (preparationData is List) {
      return preparationData
          .map((e) => e.toString())
          .where((e) => e.isNotEmpty)
          .toList();
    }

    return [];
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_medicineData == null) {
      return Scaffold(
        backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
        appBar: AppBar(
          backgroundColor: AppTheme.lightTheme.primaryColor,
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: CustomIconWidget(
              iconName: 'arrow_back',
              color: AppTheme.lightTheme.colorScheme.onPrimary,
              size: 6.w,
            ),
          ),
        ),
        body: Center(
          child: CircularProgressIndicator(
            color: AppTheme.lightTheme.primaryColor,
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: CustomScrollView(
        slivers: [
          _buildSliverAppBar(),
          SliverToBoxAdapter(
            child: MedicineHeaderWidget(
              englishName: _medicineData!['englishName'],
              tamilName: _medicineData!['tamilName'],
              pronunciation: _medicineData!['pronunciation'],
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
                tabs: [
                  Tab(
                      text: _currentLanguage == 'english'
                          ? 'Overview'
                          : 'கண்ணோட்டம்'),
                  Tab(
                      text:
                          _currentLanguage == 'english' ? 'Usage' : 'பயன்பாடு'),
                  Tab(
                      text: _currentLanguage == 'english'
                          ? 'Diseases'
                          : 'நோய்கள்'),
                  Tab(
                      text: _currentLanguage == 'english'
                          ? 'Precautions'
                          : 'முன்னெச்சரிக்கைகள்'),
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
                    medicineData: _medicineData!,
                    currentLanguage: _currentLanguage,
                    onDiseaseCardTap: _navigateToDisease),
                MedicineTabContentWidget(
                    tabType: 'usage',
                    medicineData: _medicineData!,
                    currentLanguage: _currentLanguage,
                    onDiseaseCardTap: _navigateToDisease),
                MedicineTabContentWidget(
                    tabType: 'diseases',
                    medicineData: _medicineData!,
                    currentLanguage: _currentLanguage,
                    onDiseaseCardTap: _navigateToDisease),
                MedicineTabContentWidget(
                    tabType: 'precautions',
                    medicineData: _medicineData!,
                    currentLanguage: _currentLanguage,
                    onDiseaseCardTap: _navigateToDisease),
              ],
            ),
          ),
        ],
      ),
    );
  }

  SliverAppBar _buildSliverAppBar() {
    final images = (_medicineData!['images'] as List).cast<String>();

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
        background: images.isNotEmpty
            ? MedicineImageGalleryWidget(
                imageUrls: images,
                medicineName: _medicineData!['englishName'],
              )
            : Container(
                color: Colors.grey[200],
                child: Center(
                  child: Icon(
                    Icons.image_not_supported,
                    size: 15.w,
                    color: Colors.grey[400],
                  ),
                ),
              ),
      ),
    );
  }

  void _shareMedicine() {
    final medicineName = _currentLanguage == 'english'
        ? _medicineData!['englishName']
        : _medicineData!['tamilName'];

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _currentLanguage == 'english'
              ? 'Sharing $medicineName...'
              : '$medicineName பகிர்கிறது...',
        ),
      ),
    );
  }

  void _toggleLanguage() {
    setState(() {
      _currentLanguage = _currentLanguage == 'english' ? 'tamil' : 'english';
    });
  }

  void _navigateToDisease(String diseaseId) {
    Navigator.pushNamed(
      context,
      '/disease-detail-screen',
      arguments: {'diseaseId': diseaseId},
    );
  }
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
