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
      // 🌟 CRITICAL FIX: Setting Scaffold background to transparent
      // allows the global background image (set in main.dart) to show through.
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Column(
          children: [
            OfflineIndicatorWidget(isOffline: _isOffline),
            // ✨ New Professional Header Widget
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

  // ✨ START: New Professional Header Widget
  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w).copyWith(bottom: 2.h),
      decoration: BoxDecoration(
        // NOTE: The header uses colorScheme.surface, which is fine,
        // as it adds a necessary contrast bar at the top.
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
          //fake search box
        ],
      ),
    );
  }
  // ✨ END: New Professional Header Widget

  Widget _buildHomeTab() {
    return RefreshIndicator(
      onRefresh: _onRefresh,
      color: AppTheme.lightTheme.primaryColor,
      child: SingleChildScrollView(
        // Set transparent color for the content wrapper if needed,
        // but the Scaffold is the main fix.
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
            _recentContent.isEmpty
                ? EducationalTipsWidget(currentLanguage: _currentLanguage)
                : const SizedBox.shrink(),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }

  Widget _buildNavigationCards() {
    // ... This widget remains unchanged
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
    // ... This widget remains unchanged
    if (_recentContent.isEmpty) {
      return const SizedBox.shrink();
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
                onPressed: () {},
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
        SizedBox(
          height: 25.h,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.only(left: 4.w),
            itemCount: _recentContent.length,
            itemBuilder: (context, index) {
              final item = _recentContent[index];
              return QuickAccessCardWidget(
                title: item['title'],
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
    // ... This widget remains unchanged
    return p1();
  }

// Your Books Tab Action Handlers
  Future<void> openPdfFromUrl(String url) async {
    final Uri pdfUri = Uri.parse(url);
    if (await canLaunchUrl(pdfUri)) {
      await launchUrl(pdfUri, mode: LaunchMode.externalApplication);
    } else {
      // In a real app, you'd show a SnackBar or Dialog here
      debugPrint('Could not launch $url');
    }
  }

  Future<void> downloadPdf(String url, String filename) async {
    // For a simple app, launching the URL effectively triggers a download/view
    // depending on the browser/system settings. For actual file download,
    // you would use a package like dio or flutter_file_downloader.
    final Uri pdfUri = Uri.parse(url);
    if (await canLaunchUrl(pdfUri)) {
      await launchUrl(pdfUri, mode: LaunchMode.externalApplication);
    } else {
      debugPrint('Could not launch $url');
    }
  }

// ✨ START: REDESIGNED Books Tab Widget
  Widget _buildBooksTab() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Professional Section Header
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
              // Example Book Card 1
              _buildBookCard(
                title: 'Siddha Fundamentals Vol. 1',
                author: 'Dr. John Doe',
                pdfUrl:
                    'https://drive.google.com/file/d/1X-grVKBKgSwkKMNuYYSRQCHGU2nwB-tN/view',
                iconData: Icons.medical_services_outlined,
              ),
              // Divider for visual separation
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                child: Divider(
                    color: AppTheme.lightTheme.colorScheme.outline
                        .withOpacity(0.1)),
              ),

              // Example Book Card 2
              _buildBookCard(
                title: 'Acupuncture Points Atlas',
                author: 'Prof. Jane Smith',
                pdfUrl:
                    'https://drive.google.com/file/d/1X-grVKBKgSwkKMNuYYSRQCHGU2nwB-tN/view',
                iconData: Icons.pin_drop_outlined,
              ),
              // Divider for visual separation
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                child: Divider(
                    color: AppTheme.lightTheme.colorScheme.outline
                        .withOpacity(0.1)),
              ),

              // Example Book Card 3
              _buildBookCard(
                title: 'Herbal Remedies for Modern Life',
                author: 'Ayul Research Team',
                pdfUrl:
                    'https://drive.google.com/file/d/1X-grVKBKgSwkKMNuYYSRQCHGU2nwB-tN/view',
                iconData: Icons.spa_outlined,
              ),
              // Divider for visual separation
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                child: Divider(
                    color: AppTheme.lightTheme.colorScheme.outline
                        .withOpacity(0.1)),
              ),

              // Add some padding at the bottom
              SizedBox(height: 3.h),
            ],
          ),
        ),
      ],
    );
  }

// Helper widget to build individual book cards (REDESIGNED)
  Widget _buildBookCard({
    required String title,
    required String author,
    required String pdfUrl,
    required IconData iconData,
  }) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 0.5.h, horizontal: 2.w),
      elevation: 0, // Use subtle elevation or none for a modern flat look
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
        // Leading Icon/Thumbnail
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

        // Book Details (Title and Author)
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

        // Trailing Action Button
        trailing: PopupMenuButton<String>(
          onSelected: (String result) {
            if (result == 'open') {
              openPdfFromUrl(pdfUrl);
            } else if (result == 'download') {
              downloadPdf(pdfUrl, '$title.pdf');
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
            PopupMenuItem<String>(
              value: 'download',
              child: Row(
                children: [
                  const Icon(Icons.download, size: 20),
                  SizedBox(width: 2.w),
                  Text(_currentLanguage == 'EN' ? 'Download' : 'பதிவிறக்க'),
                ],
              ),
            ),
          ],
          icon: Icon(
            Icons.more_vert,
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
          ),
        ),

        // Make the whole tile tappable to open the PDF (as a default action)
        onTap: () => openPdfFromUrl(pdfUrl),
      ),
    );
  }
// ✨ END: REDESIGNED Books Tab Widget

  Widget _buildFindDiseaseTab() {
    // ... This widget remains unchanged
    return DiseaseQuestionnaireWidget(
      currentLanguage: _currentLanguage,
      onMedicineIdentified: (medicine) {
        _navigateToMedicineDetail(medicine);
      },
    );
  }

  Widget _buildBottomNavigationBar() {
    // ... This widget remains unchanged
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
    // ... This widget remains unchanged
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
