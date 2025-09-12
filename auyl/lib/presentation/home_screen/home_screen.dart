// File: lib/screens/home/home_screen.dart

import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/body_parts_explorer_widget.dart';
import './widgets/educational_tips_widget.dart';
import './widgets/language_toggle_widget.dart';
import './widgets/navigation_card_widget.dart';
import './widgets/offline_indicator_widget.dart';
import './widgets/quick_access_card_widget.dart';
import './widgets/disease_questionnaire_widget.dart'; // 👈 Import the new widget

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late TabController _tabController;
  String _currentLanguage = 'EN';
  bool _isOffline = false;
  bool _isRefreshing = false;

  // Mock data for recent content
  final List<Map<String, dynamic>> _recentContent = [
    {
      "id": 1,
      "title": "Tulsi",
      "subtitle": "Holy Basil - Natural immunity booster",
      "type": "medicine",
      "image":
          "https://images.pexels.com/photos/4198015/pexels-photo-4198015.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
    },
    {
      "id": 2,
      "title": "Diabetes",
      "subtitle": "மதுமேகம் - Blood sugar management",
      "type": "disease",
      "image":
          "https://images.unsplash.com/photo-1576091160399-112ba8d25d1f?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
    },
    {
      "id": 3,
      "title": "Neem",
      "subtitle": "வேப்பம் - Natural antiseptic",
      "type": "medicine",
      "image":
          "https://images.pexels.com/photos/6627946/pexels-photo-6627946.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
    },
    {
      "id": 4,
      "title": "Arthritis",
      "subtitle": "கீல்வாதம் - Joint inflammation",
      "type": "disease",
      "image":
          "https://images.unsplash.com/photo-1559757175-0eb30cd8c063?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _checkConnectivity();
    _setupConnectivityListener();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _checkConnectivity() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    setState(() {
      _isOffline = connectivityResult == ConnectivityResult.none;
    });
  }

  void _setupConnectivityListener() {
    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      setState(() {
        _isOffline = result == ConnectivityResult.none;
      });
    });
  }

  Future<void> _onRefresh() async {
    setState(() {
      _isRefreshing = true;
    });

    // Simulate refresh delay
    await Future.delayed(Duration(seconds: 2));

    setState(() {
      _isRefreshing = false;
    });

    if (!_isOffline) {
      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_currentLanguage == 'EN'
              ? 'Content updated successfully'
              : 'உள்ளடக்கம் வெற்றிகரமாக புதுப்பிக்கப்பட்டது'),
          backgroundColor: AppTheme.lightTheme.colorScheme.tertiary,
        ),
      );
    }
  }

  void _onLanguageChanged(String language) {
    setState(() {
      _currentLanguage = language;
    });
  }

  void _navigateToSiddhaSection() {
    Navigator.pushNamed(context, '/medicine-listing-screen',
        arguments: {'type': 'siddha'});
  }

  void _navigateToAcupunctureSection() {
    Navigator.pushNamed(context, '/medicine-listing-screen',
        arguments: {'type': 'acupuncture'});
  }

  void _navigateToBodyPartsExplorer() {
    Navigator.pushNamed(context, '/body-parts-explorer-screen');
  }

  void _navigateToMedicineDetail(Map<String, dynamic> medicine) {
    Navigator.pushNamed(context, '/medicine-detail-screen',
        arguments: medicine);
  }

  void _navigateToDiseaseDetail(Map<String, dynamic> disease) {
    Navigator.pushNamed(context, '/disease-listing-screen', arguments: disease);
  }

  void _onQuickAccessTap(Map<String, dynamic> item) {
    if (item['type'] == 'medicine') {
      _navigateToMedicineDetail(item);
    } else {
      _navigateToDiseaseDetail(item);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            OfflineIndicatorWidget(isOffline: _isOffline),
            _buildHeader(),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildHomeTab(),
                  _buildSearchTab(),
                  _buildBooksTab(),
                  _buildFindDiseaseTab(),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color:
                AppTheme.lightTheme.colorScheme.shadow.withValues(alpha: 0.05),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _currentLanguage == 'EN' ? 'Ayul' : 'ஆயுள்',
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.lightTheme.primaryColor,
                ),
              ),
              Text(
                _currentLanguage == 'EN'
                    ? 'Traditional Medicine Learning'
                    : 'பாரம்பரிய மருத்துவ கல்வி',
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w400,
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
          LanguageToggleWidget(
            currentLanguage: _currentLanguage,
            onLanguageChanged: _onLanguageChanged,
          ),
        ],
      ),
    );
  }

  Widget _buildHomeTab() {
    return RefreshIndicator(
      onRefresh: _onRefresh,
      color: AppTheme.lightTheme.primaryColor,
      child: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 2.h),
            _buildNavigationCards(),
            SizedBox(height: 3.h),
            _buildQuickAccessSection(),
            SizedBox(height: 3.h),
            BodyPartsExplorerWidget(onTap: _navigateToBodyPartsExplorer),
            SizedBox(height: 2.h),
            _recentContent.isEmpty
                ? EducationalTipsWidget(currentLanguage: _currentLanguage)
                : SizedBox.shrink(),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }

  Widget _buildNavigationCards() {
    return Column(
      children: [
        NavigationCardWidget(
          title:
              _currentLanguage == 'EN' ? 'Siddha Medicine' : 'சித்த மருத்துவம்',
          description: _currentLanguage == 'EN'
              ? 'Explore traditional Siddha medicines, treatments and ancient healing wisdom'
              : 'பாரம்பரிய சித்த மருந்துகள், சிகிச்சைகள் மற்றும் பண்டைய குணப்படுத்தும் ஞானத்தை ஆராயுங்கள்',
          iconName: 'local_pharmacy',
          route: '/medicine-listing-screen',
          onTap: _navigateToSiddhaSection,
        ),
        NavigationCardWidget(
          title:
              _currentLanguage == 'EN' ? 'Acupuncture' : 'குத்தூசி மருத்துவம்',
          description: _currentLanguage == 'EN'
              ? 'Learn about acupuncture points, techniques and therapeutic applications'
              : 'குத்தூசி புள்ளிகள், நுட்பங்கள் மற்றும் சிகிச்சை பயன்பாடுகளைப் பற்றி அறியுங்கள்',
          iconName: 'healing',
          route: '/medicine-listing-screen',
          onTap: _navigateToAcupunctureSection,
        ),
      ],
    );
  }

  Widget _buildQuickAccessSection() {
    if (_recentContent.isEmpty) {
      return SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _currentLanguage == 'EN' ? 'Quick Access' : 'விரைவு அணுகல்',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.lightTheme.colorScheme.onSurface,
                ),
              ),
              TextButton(
                onPressed: () {
                  // Navigate to full recent list
                },
                child: Text(
                  _currentLanguage == 'EN' ? 'View All' : 'அனைத்தையும் பார்க்க',
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                    color: AppTheme.lightTheme.primaryColor,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 1.h),
        Container(
          height: 25.h,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            itemCount: _recentContent.length,
            itemBuilder: (context, index) {
              final item = _recentContent[index];
              return QuickAccessCardWidget(
                title: _currentLanguage == 'EN' ? item['title'] : item['title'],
                subtitle: item['subtitle'],
                imageUrl: item['image'],
                type: item['type'],
                onTap: () => _onQuickAccessTap(item),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSearchTab() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomIconWidget(
            iconName: 'search',
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            size: 64,
          ),
          SizedBox(height: 2.h),
          Text(
            _currentLanguage == 'EN' ? 'Search Feature' : 'தேடல் அம்சம்',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              color: AppTheme.lightTheme.colorScheme.onSurface,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            _currentLanguage == 'EN'
                ? 'Coming Soon - Search across medicines, diseases, and body parts'
                : 'விரைவில் வரும் - மருந்துகள், நோய்கள் மற்றும் உடல் பாகங்களில் தேடுங்கள்',
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w400,
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildBooksTab() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomIconWidget(
            iconName: 'menu_book',
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            size: 64,
          ),
          SizedBox(height: 2.h),
          Text(
            _currentLanguage == 'EN'
                ? 'Siddha Books Library'
                : 'சித்த நூல் நூலகம்',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              color: AppTheme.lightTheme.colorScheme.onSurface,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            _currentLanguage == 'EN'
                ? 'Coming Soon - Access traditional Siddha texts and references'
                : 'விரைவில் வரும் - பாரம்பரிய சித்த நூல்கள் மற்றும் குறிப்புகளை அணுகவும்',
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w400,
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildFindDiseaseTab() {
    return DiseaseQuestionnaireWidget(
      currentLanguage: _currentLanguage,
      onMedicineIdentified: (medicine) {
        _navigateToMedicineDetail(medicine);
      },
    );
  }

  Widget _buildBottomNavigationBar() {
    return TabBar(
      controller: _tabController,
      tabs: [
        Tab(
          icon: CustomIconWidget(
            iconName: 'home',
            color: _tabController.index == 0
                ? AppTheme.lightTheme.primaryColor
                : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            size: 24,
          ),
          text: _currentLanguage == 'EN' ? 'Home' : 'முகப்பு',
        ),
        Tab(
          icon: CustomIconWidget(
            iconName: 'search',
            color: _tabController.index == 1
                ? AppTheme.lightTheme.primaryColor
                : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            size: 24,
          ),
          text: _currentLanguage == 'EN' ? 'Search' : 'தேடல்',
        ),
        Tab(
          icon: CustomIconWidget(
            iconName: 'menu_book',
            color: _tabController.index == 2
                ? AppTheme.lightTheme.primaryColor
                : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            size: 24,
          ),
          text: _currentLanguage == 'EN' ? 'Books' : 'நூல்கள்',
        ),
        Tab(
          icon: CustomIconWidget(
            iconName: 'healing',
            color: _tabController.index == 3
                ? AppTheme.lightTheme.primaryColor
                : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            size: 24,
          ),
          text: _currentLanguage == 'EN' ? 'Find Disease' : 'நோயைக் கண்டறிய',
        ),
      ],
      labelColor: AppTheme.lightTheme.primaryColor,
      unselectedLabelColor: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
      indicatorColor: AppTheme.lightTheme.primaryColor,
      labelStyle: TextStyle(
        fontSize: 10.sp,
        fontWeight: FontWeight.w500,
      ),
      unselectedLabelStyle: TextStyle(
        fontSize: 10.sp,
        fontWeight: FontWeight.w400,
      ),
    );
  }
}
