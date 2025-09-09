import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/body_part_category_widget.dart';
import './widgets/body_part_info_card_widget.dart';
import './widgets/interactive_body_diagram_widget.dart';
import './widgets/search_bar_widget.dart';

class BodyPartsExplorerScreen extends StatefulWidget {
  const BodyPartsExplorerScreen({Key? key}) : super(key: key);

  @override
  State<BodyPartsExplorerScreen> createState() =>
      _BodyPartsExplorerScreenState();
}

class _BodyPartsExplorerScreenState extends State<BodyPartsExplorerScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  bool _isVisualMode = true;
  String _searchQuery = '';
  Map<String, dynamic>? _selectedBodyPart;
  final Map<String, bool> _expandedCategories = {
    'Head & Neck': false,
    'Torso': false,
    'Limbs': false,
    'Internal Organs': false,
  };

  // Mock data for body parts
  final List<Map<String, dynamic>> _bodyPartsData = [
    {
      'id': 'head_brain',
      'name': 'Brain',
      'nameTamil': 'மூளை',
      'category': 'Head & Neck',
      'description':
          'The brain is the central organ of the nervous system, controlling thoughts, memory, emotion, touch, motor skills, vision, breathing, temperature, and every process that regulates our body.',
      'image':
          'https://images.unsplash.com/photo-1559757148-5c350d0d3c56?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3',
      'diseaseCount': 12,
      'medicineCount': 18,
      'commonConditions': [
        'Headache',
        'Migraine',
        'Memory Loss',
        'Anxiety',
        'Depression'
      ],
    },
    {
      'id': 'head_eyes',
      'name': 'Eyes',
      'nameTamil': 'கண்கள்',
      'category': 'Head & Neck',
      'description':
          'The eyes are organs of vision that detect light and convert it into electro-chemical impulses in neurons. In Siddha medicine, eye health is closely connected to liver function.',
      'image':
          'https://images.unsplash.com/photo-1582719471384-894fbb16e074?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3',
      'diseaseCount': 8,
      'medicineCount': 15,
      'commonConditions': [
        'Dry Eyes',
        'Conjunctivitis',
        'Vision Problems',
        'Eye Strain'
      ],
    },
    {
      'id': 'head_ears',
      'name': 'Ears',
      'nameTamil': 'காதுகள்',
      'category': 'Head & Neck',
      'description':
          'The ears are organs responsible for hearing and balance. Traditional medicine emphasizes the connection between ear health and kidney function.',
      'image':
          'https://images.unsplash.com/photo-1576091160399-112ba8d25d1f?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3',
      'diseaseCount': 6,
      'medicineCount': 10,
      'commonConditions': [
        'Hearing Loss',
        'Ear Infection',
        'Tinnitus',
        'Earache'
      ],
    },
    {
      'id': 'torso_heart',
      'name': 'Heart',
      'nameTamil': 'இதயம்',
      'category': 'Torso',
      'description':
          'The heart is a muscular organ that pumps blood throughout the body. In Siddha medicine, heart health is fundamental to overall vitality and emotional well-being.',
      'image':
          'https://images.unsplash.com/photo-1628348068343-c6a848d2b6dd?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3',
      'diseaseCount': 15,
      'medicineCount': 25,
      'commonConditions': [
        'High Blood Pressure',
        'Chest Pain',
        'Palpitations',
        'Fatigue'
      ],
    },
    {
      'id': 'torso_lungs',
      'name': 'Lungs',
      'nameTamil': 'நுரையீரல்',
      'category': 'Torso',
      'description':
          'The lungs are respiratory organs that facilitate gas exchange. Traditional medicine views lung health as essential for maintaining life force and energy.',
      'image':
          'https://images.unsplash.com/photo-1559757175-0eb30cd8c063?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3',
      'diseaseCount': 10,
      'medicineCount': 20,
      'commonConditions': [
        'Cough',
        'Asthma',
        'Bronchitis',
        'Shortness of Breath'
      ],
    },
    {
      'id': 'torso_liver',
      'name': 'Liver',
      'nameTamil': 'கல்லீரல்',
      'category': 'Internal Organs',
      'description':
          'The liver is a vital organ that processes nutrients, filters toxins, and produces bile. In Siddha medicine, liver health affects digestion, emotions, and overall vitality.',
      'image':
          'https://images.unsplash.com/photo-1559757148-5c350d0d3c56?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3',
      'diseaseCount': 9,
      'medicineCount': 16,
      'commonConditions': [
        'Jaundice',
        'Fatty Liver',
        'Hepatitis',
        'Digestive Issues'
      ],
    },
    {
      'id': 'limbs_hands',
      'name': 'Hands',
      'nameTamil': 'கைகள்',
      'category': 'Limbs',
      'description':
          'The hands are complex structures with bones, muscles, tendons, and nerves that enable fine motor control and manipulation of objects.',
      'image':
          'https://images.unsplash.com/photo-1576091160550-2173dba999ef?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3',
      'diseaseCount': 7,
      'medicineCount': 12,
      'commonConditions': [
        'Arthritis',
        'Carpal Tunnel',
        'Joint Pain',
        'Stiffness'
      ],
    },
    {
      'id': 'limbs_feet',
      'name': 'Feet',
      'nameTamil': 'கால்கள்',
      'category': 'Limbs',
      'description':
          'The feet support body weight and enable locomotion. In traditional medicine, foot health reflects overall body balance and energy flow.',
      'image':
          'https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3',
      'diseaseCount': 8,
      'medicineCount': 14,
      'commonConditions': [
        'Foot Pain',
        'Plantar Fasciitis',
        'Swelling',
        'Numbness'
      ],
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
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
      appBar: _buildAppBar(),
      body: Stack(
        children: [
          Column(
            children: [
              _buildViewToggle(),
              SearchBarWidget(
                onSearchChanged: _handleSearchChanged,
                hintText: 'Search body parts, conditions...',
                hintTextTamil: 'உடல் பாகங்கள், நோய்கள் தேடுங்கள்...',
              ),
              Expanded(
                child: _isVisualMode ? _buildVisualMode() : _buildListMode(),
              ),
            ],
          ),
          if (_selectedBodyPart != null) _buildInfoCardOverlay(),
        ],
      ),
      floatingActionButton: _buildInfoButton(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Body Parts Explorer',
            style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          Text(
            'உடல் பாகங்கள் ஆராய்ச்சி',
            style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
              color: Colors.white.withValues(alpha: 0.8),
            ),
          ),
        ],
      ),
      backgroundColor: AppTheme.lightTheme.primaryColor,
      elevation: 0,
      leading: IconButton(
        onPressed: () => Navigator.pop(context),
        icon: CustomIconWidget(
          iconName: 'arrow_back',
          color: Colors.white,
          size: 24,
        ),
      ),
      actions: [
        IconButton(
          onPressed: _showLanguageToggle,
          icon: CustomIconWidget(
            iconName: 'language',
            color: Colors.white,
            size: 24,
          ),
        ),
        IconButton(
          onPressed: _showMoreOptions,
          icon: CustomIconWidget(
            iconName: 'more_vert',
            color: Colors.white,
            size: 24,
          ),
        ),
      ],
    );
  }

  Widget _buildViewToggle() {
    return Container(
      margin: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _isVisualMode = true),
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 2.h),
                decoration: BoxDecoration(
                  color: _isVisualMode
                      ? AppTheme.lightTheme.primaryColor
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomIconWidget(
                      iconName: 'visibility',
                      color: _isVisualMode
                          ? Colors.white
                          : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      size: 20,
                    ),
                    SizedBox(width: 2.w),
                    Text(
                      'Visual Mode',
                      style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                        color: _isVisualMode
                            ? Colors.white
                            : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _isVisualMode = false),
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 2.h),
                decoration: BoxDecoration(
                  color: !_isVisualMode
                      ? AppTheme.lightTheme.primaryColor
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomIconWidget(
                      iconName: 'list',
                      color: !_isVisualMode
                          ? Colors.white
                          : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      size: 20,
                    ),
                    SizedBox(width: 2.w),
                    Text(
                      'List Mode',
                      style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                        color: !_isVisualMode
                            ? Colors.white
                            : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVisualMode() {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      child: Column(
        children: [
          InteractiveBodyDiagramWidget(
            onBodyPartTap: _handleBodyPartTap,
            bodyParts: _getFilteredBodyParts(),
          ),
          SizedBox(height: 2.h),
          _buildLegend(),
          SizedBox(height: 2.h),
        ],
      ),
    );
  }

  Widget _buildListMode() {
    final categories = _groupBodyPartsByCategory();

    return ListView.builder(
      padding: EdgeInsets.symmetric(vertical: 1.h),
      itemCount: categories.keys.length,
      itemBuilder: (context, index) {
        final categoryName = categories.keys.elementAt(index);
        final categoryParts = categories[categoryName]!;

        return BodyPartCategoryWidget(
          categoryName: categoryName,
          categoryNameTamil: _getCategoryTamilName(categoryName),
          bodyParts: categoryParts,
          isExpanded: _expandedCategories[categoryName] ?? false,
          onToggle: () => _toggleCategory(categoryName),
          onBodyPartTap: _handleBodyPartTap,
        );
      },
    );
  }

  Widget _buildLegend() {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CustomIconWidget(
                iconName: 'info_outline',
                color: AppTheme.lightTheme.primaryColor,
                size: 20,
              ),
              SizedBox(width: 2.w),
              Text(
                'How to Use',
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          _buildLegendItem(
            'Tap any highlighted region to explore',
            'touch_app',
          ),
          _buildLegendItem(
            'Pinch to zoom in/out for detailed view',
            'zoom_in',
          ),
          _buildLegendItem(
            'Pan to navigate around the diagram',
            'pan_tool',
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(String text, String iconName) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 0.5.h),
      child: Row(
        children: [
          CustomIconWidget(
            iconName: iconName,
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            size: 16,
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Text(
              text,
              style: AppTheme.lightTheme.textTheme.bodySmall,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCardOverlay() {
    return Positioned.fill(
      child: Container(
        color: Colors.black.withValues(alpha: 0.5),
        child: Center(
          child: BodyPartInfoCardWidget(
            bodyPart: _selectedBodyPart!,
            onLearnMore: _navigateToBodyPartDetail,
            onClose: _closeInfoCard,
          ),
        ),
      ),
    );
  }

  Widget _buildInfoButton() {
    return FloatingActionButton(
      onPressed: _showInfoDialog,
      backgroundColor: AppTheme.lightTheme.colorScheme.tertiary,
      child: CustomIconWidget(
        iconName: 'help_outline',
        color: Colors.black,
        size: 24,
      ),
    );
  }

  void _handleSearchChanged(String query) {
    setState(() {
      _searchQuery = query.toLowerCase();
    });
  }

  void _handleBodyPartTap(Map<String, dynamic> bodyPart) {
    setState(() {
      _selectedBodyPart = bodyPart;
    });
  }

  void _closeInfoCard() {
    setState(() {
      _selectedBodyPart = null;
    });
  }

  void _navigateToBodyPartDetail() {
    Navigator.pushNamed(context, '/body-part-detail-screen');
  }

  void _toggleCategory(String categoryName) {
    setState(() {
      _expandedCategories[categoryName] =
          !(_expandedCategories[categoryName] ?? false);
    });
  }

  List<Map<String, dynamic>> _getFilteredBodyParts() {
    if (_searchQuery.isEmpty) return _bodyPartsData;

    return _bodyPartsData.where((bodyPart) {
      final name = (bodyPart['name'] as String).toLowerCase();
      final nameTamil = bodyPart['nameTamil'] as String;
      final description = (bodyPart['description'] as String).toLowerCase();
      final conditions =
          (bodyPart['commonConditions'] as List).join(' ').toLowerCase();

      return name.contains(_searchQuery) ||
          nameTamil.contains(_searchQuery) ||
          description.contains(_searchQuery) ||
          conditions.contains(_searchQuery);
    }).toList();
  }

  Map<String, List<Map<String, dynamic>>> _groupBodyPartsByCategory() {
    final filteredParts = _getFilteredBodyParts();
    final Map<String, List<Map<String, dynamic>>> grouped = {};

    for (final part in filteredParts) {
      final category = part['category'] as String;
      grouped[category] = grouped[category] ?? [];
      grouped[category]!.add(part);
    }

    return grouped;
  }

  String _getCategoryTamilName(String englishName) {
    switch (englishName) {
      case 'Head & Neck':
        return 'தலை மற்றும் கழுத்து';
      case 'Torso':
        return 'உடல் பகுதி';
      case 'Limbs':
        return 'கை கால்கள்';
      case 'Internal Organs':
        return 'உள் உறுப்புகள்';
      default:
        return englishName;
    }
  }

  void _showLanguageToggle() {
    // Language toggle functionality
  }

  void _showMoreOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              margin: EdgeInsets.only(top: 1.h),
              width: 10.w,
              height: 0.5.h,
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.outline
                    .withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'share',
                color: AppTheme.lightTheme.primaryColor,
                size: 24,
              ),
              title: Text('Share Diagram'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'download',
                color: AppTheme.lightTheme.primaryColor,
                size: 24,
              ),
              title: Text('Download Reference'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'settings',
                color: AppTheme.lightTheme.primaryColor,
                size: 24,
              ),
              title: Text('Settings'),
              onTap: () => Navigator.pop(context),
            ),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }

  void _showInfoDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Body Parts Explorer'),
        content: Text(
          'Explore human anatomy through interactive diagrams and detailed information about body parts, related diseases, and traditional medicines.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Got it'),
          ),
        ],
      ),
    );
  }
}
