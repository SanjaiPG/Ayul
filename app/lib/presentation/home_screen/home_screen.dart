// File: lib/screens/home/home_screen.dart

import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../medicine_listing_screen/p1.dart';
import '../../core/app_export.dart';
import './widgets/body_parts_explorer_widget.dart';
import './widgets/educational_tips_widget.dart';
import './widgets/navigation_card_widget.dart';
import './widgets/offline_indicator_widget.dart';
import './widgets/quick_access_card_widget.dart';
import './widgets/disease_questionnaire_widget.dart';
import 'package:url_launcher/url_launcher.dart';

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

  // ✨ NEW: Dedicated entry for the "View All Diseases" card
  late final List<Map<String, dynamic>> _diseaseQuickAccess = [
    {
      "id": 99,
      "title":
          _currentLanguage == 'EN' ? "Explore Diseases" : "நோய்களை கண்டறியவும்",
      "subtitle": _currentLanguage == 'EN'
          ? "View a comprehensive list of all diseases"
          : "அனைத்து நோய்களின் விரிவான பட்டியலைப் பார்க்கவும்",
      "type": "disease",
      "isUtility": true, // Flag to distinguish it
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _tabController.addListener(() {
      setState(() {});
    });
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
    if (mounted) {
      setState(() {
        _isOffline = connectivityResult == ConnectivityResult.none;
      });
    }
  }

  void _setupConnectivityListener() {
    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      if (mounted) {
        setState(() {
          _isOffline = result == ConnectivityResult.none;
        });
      }
    });
  }

  void _toggleLanguage() {
    setState(() {
      _currentLanguage = _currentLanguage == 'EN' ? 'TA' : 'EN';
      // Re-initialize the utility list to update language
      _diseaseQuickAccess[0]["title"] =
          _currentLanguage == 'EN' ? "Explore Diseases" : "நோய்களை கண்டறியவும்";
      _diseaseQuickAccess[0]["subtitle"] = _currentLanguage == 'EN'
          ? "View a comprehensive list of all diseases"
          : "அனைத்து நோய்களின் விரிவான பட்டியலைப் பார்க்கவும்";
    });
  }

  Future<void> _onRefresh() async {
    setState(() {
      _isRefreshing = true;
    });
    await Future.delayed(const Duration(seconds: 2));
    setState(() {
      _isRefreshing = false;
    });

    if (!_isOffline && mounted) {
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

  void _navigateToDiseaseListing() {
    Navigator.pushNamed(context, '/disease-listing-screen');
  }

  void _onQuickAccessTap(Map<String, dynamic> item) {
    if (item['isUtility'] == true) {
      _navigateToDiseaseListing();
    } else if (item['type'] == 'medicine') {
      _navigateToMedicineDetail(item);
    } else {
      _navigateToDiseaseDetail(item);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
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
      padding: EdgeInsets.symmetric(horizontal: 4.w).copyWith(bottom: 2.h),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: AppTheme.lightTheme.colorScheme.shadow.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 1.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _currentLanguage == 'EN' ? 'Ayul' : 'ஆயுள்',
                    style: TextStyle(
                      fontSize: 22.sp,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.lightTheme.colorScheme.primary,
                      height: 1.2,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  InkWell(
                    onTap: _toggleLanguage,
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                      decoration: BoxDecoration(
                        color: AppTheme.lightTheme.scaffoldBackgroundColor,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: AppTheme.lightTheme.colorScheme.outline
                              .withOpacity(0.3),
                        ),
                      ),
                      child: Row(
                        children: [
                          CustomIconWidget(
                            iconName: 'language',
                            size: 16,
                            color: AppTheme.lightTheme.colorScheme.primary,
                          ),
                          SizedBox(width: 2.w),
                          Text(
                            _currentLanguage,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: AppTheme.lightTheme.colorScheme.primary,
                                fontSize: 11.sp),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
          SizedBox(height: 2.h),
        ],
      ),
    );
  }

  Widget _buildHomeTab() {
    return RefreshIndicator(
      onRefresh: _onRefresh,
      color: AppTheme.lightTheme.primaryColor,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
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
            EducationalTipsWidget(currentLanguage: _currentLanguage),
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
              ? 'Explore traditional Siddha medicines and ancient healing wisdom'
              : 'பாரம்பரிய சித்த மருந்துகள் மற்றும் பண்டைய குணப்படுத்தும் ஞானத்தை ஆராயுங்கள்',
          iconName: 'local_pharmacy',
          route: '/medicine-listing-screen',
          onTap: _navigateToSiddhaSection,
        ),
        NavigationCardWidget(
          title:
              _currentLanguage == 'EN' ? 'Acupuncture' : 'குத்தூசி மருத்துவம்',
          description: _currentLanguage == 'EN'
              ? 'Learn about acupuncture points, techniques and applications'
              : 'குத்தூசி புள்ளிகள், நுட்பங்கள் மற்றும் பயன்பாடுகளைப் பற்றி அறியுங்கள்',
          iconName: 'healing',
          route: '/medicine-listing-screen',
          onTap: _navigateToAcupunctureSection,
        ),
      ],
    );
  }

  Widget _buildQuickAccessSection() {
    final List<Map<String, dynamic>> allQuickAccessItems = [
      ..._diseaseQuickAccess,
    ];

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
            ],
          ),
        ),
        SizedBox(height: 1.h),
        SizedBox(
          height: 25.h,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.only(left: 4.w),
            itemCount: allQuickAccessItems.length,
            itemBuilder: (context, index) {
              final item = allQuickAccessItems[index];
              return QuickAccessCardWidget(
                title: item['title'],
                subtitle: item['subtitle'],
                imageUrl: item['image'],
                type: item['type'],
                iconData:
                    item['isUtility'] == true ? Icons.list_alt_rounded : null,
                onTap: () => _onQuickAccessTap(item),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSearchTab() {
    return p1();
  }

  Future<void> openPdfFromUrl(String url) async {
    final Uri pdfUri = Uri.parse(url);
    if (await canLaunchUrl(pdfUri)) {
      await launchUrl(pdfUri, mode: LaunchMode.externalApplication);
    } else {
      debugPrint('Could not launch $url');
    }
  }

  Widget _buildBooksTab() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w)
              .copyWith(top: 2.h, bottom: 1.h),
          child: Text(
            _currentLanguage == 'EN' ? 'Resource Library' : 'நூல் தொகுப்பு',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: AppTheme.lightTheme.colorScheme.onSurface,
            ),
          ),
        ),
        Expanded(
          child: ListView(
            padding: EdgeInsets.symmetric(horizontal: 2.w),
            children: [
              _buildBookCard(
                title: 'Siddha Fundamentals Vol. 1',
                author: 'Dr. John Doe',
                pdfUrl:
                    'https://drive.google.com/file/d/1X-grVKBKgSwkKMNuYYSRQCHGU2nwB-tN/view',
                iconData: Icons.medical_services_outlined,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                child: Divider(
                    color: AppTheme.lightTheme.colorScheme.outline
                        .withOpacity(0.1)),
              ),
              _buildBookCard(
                title: 'Acupuncture Points Atlas',
                author: 'Prof. Jane Smith',
                pdfUrl:
                    'https://drive.google.com/file/d/1X-grVKBKgSwkKMNuYYSRQCHGU2nwB-tN/view',
                iconData: Icons.pin_drop_outlined,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                child: Divider(
                    color: AppTheme.lightTheme.colorScheme.outline
                        .withOpacity(0.1)),
              ),
              _buildBookCard(
                title: 'Herbal Remedies for Modern Life',
                author: 'Ayul Research Team',
                pdfUrl:
                    'https://drive.google.com/file/d/1X-grVKBKgSwkKMNuYYSRQCHGU2nwB-tN/view',
                iconData: Icons.spa_outlined,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                child: Divider(
                    color: AppTheme.lightTheme.colorScheme.outline
                        .withOpacity(0.1)),
              ),
              SizedBox(height: 3.h),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBookCard({
    required String title,
    required String author,
    required String pdfUrl,
    required IconData iconData,
  }) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 0.5.h, horizontal: 2.w),
      elevation: 0,
      color: AppTheme.lightTheme.colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(
          color: AppTheme.lightTheme.colorScheme.outline.withOpacity(0.15),
          width: 1,
        ),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 0.5.h),
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppTheme.lightTheme.colorScheme.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Icon(
            iconData,
            color: AppTheme.lightTheme.colorScheme.primary,
            size: 24,
          ),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 13.sp,
            fontWeight: FontWeight.w600,
            color: AppTheme.lightTheme.colorScheme.onSurface,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(
          author,
          style: TextStyle(
            fontSize: 10.sp,
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
          ),
        ),
        trailing: PopupMenuButton<String>(
          onSelected: (String result) {
            if (result == 'open') {
              openPdfFromUrl(pdfUrl);
            }
          },
          itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
            PopupMenuItem<String>(
              value: 'open',
              child: Row(
                children: [
                  const Icon(Icons.open_in_new, size: 20),
                  SizedBox(width: 2.w),
                  Text(_currentLanguage == 'EN' ? 'Open' : 'திறக்க'),
                ],
              ),
            ),
          ],
          icon: Icon(
            Icons.more_vert,
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
          ),
        ),
        onTap: () => openPdfFromUrl(pdfUrl),
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
    return Container(
      padding: EdgeInsets.only(top: 1.h),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        border: Border(
          top: BorderSide(
            color: AppTheme.lightTheme.colorScheme.outline.withOpacity(0.2),
            width: 1,
          ),
        ),
      ),
      child: TabBar(
        controller: _tabController,
        indicator: BoxDecoration(
          color: AppTheme.lightTheme.primaryColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(50),
        ),
        indicatorPadding:
            EdgeInsets.symmetric(vertical: 0.8.h, horizontal: 4.w),
        indicatorSize: TabBarIndicatorSize.tab,
        labelColor: AppTheme.lightTheme.primaryColor,
        unselectedLabelColor: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
        labelStyle: TextStyle(fontSize: 10.sp, fontWeight: FontWeight.w600),
        unselectedLabelStyle:
            TextStyle(fontSize: 10.sp, fontWeight: FontWeight.w500),
        tabs: [
          _buildTab(
            iconName: 'home',
            label: _currentLanguage == 'EN' ? 'Home' : 'முகப்பு',
            index: 0,
          ),
          _buildTab(
            iconName: 'search',
            label: _currentLanguage == 'EN' ? 'Search' : 'தேடல்',
            index: 1,
          ),
          _buildTab(
            iconName: 'menu_book',
            label: _currentLanguage == 'EN' ? 'Books' : 'நூல்கள்',
            index: 2,
          ),
          _buildTab(
            iconName: 'healing',
            label: _currentLanguage == 'EN' ? 'Find' : 'கண்டறிய',
            index: 3,
          ),
        ],
      ),
    );
  }

  Tab _buildTab(
      {required String iconName, required String label, required int index}) {
    final isSelected = _tabController.index == index;
    return Tab(
      icon: CustomIconWidget(
        iconName: iconName,
        color: isSelected
            ? AppTheme.lightTheme.primaryColor
            : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
        size: 24,
      ),
      text: label,
      iconMargin: EdgeInsets.only(bottom: 0.5.h),
    );
  }
}
