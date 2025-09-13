import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/filter_bottom_sheet.dart';
import './widgets/filter_chips_row.dart';
import './widgets/medicine_card.dart';
import './widgets/medicine_search_bar.dart';

class MedicineListingScreen extends StatefulWidget {
  const MedicineListingScreen({Key? key}) : super(key: key);

  @override
  State<MedicineListingScreen> createState() => _MedicineListingScreenState();
}

class _MedicineListingScreenState extends State<MedicineListingScreen> {
  String _currentLanguage = 'English';
  String _searchQuery = '';
  List<Map<String, dynamic>> _activeFilters = [];
  Map<String, dynamic> _currentFilters = {};
  bool _isLoading = false;

  // Mock data for medicines
  final List<Map<String, dynamic>> _allMedicines = [
    {
      'id': '1',
      'name': 'Ashwagandha',
      'tamilName': 'அஸ்வகந்தா',
      'description':
          'A powerful adaptogenic herb used for stress relief and energy enhancement.',
      'tamilDescription':
          'மன அழுத்தம் குறைக்கவும் ஆற்றல் அதிகரிக்கவும் பயன்படும் சக்திவாய்ந்த மூலிகை.',
      'image':
          'https://images.pexels.com/photos/4021775/pexels-photo-4021775.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
      'relatedDiseases': 12,
      'isBookmarked': false,
      'category': 'herbal',
      'bodySystem': 'nervous',
      'preparation': 'powder',
    },
    {
      'id': '2',
      'name': 'Triphala',
      'tamilName': 'திரிபலா',
      'description':
          'A traditional Ayurvedic formulation of three fruits for digestive health.',
      'tamilDescription':
          'செரிமான ஆரோக்கியத்திற்கான மூன்று பழங்களின் பாரம்பரிய ஆயுர்வேத கலவை.',
      'image':
          'https://images.pexels.com/photos/4021775/pexels-photo-4021775.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
      'relatedDiseases': 8,
      'isBookmarked': true,
      'category': 'compound',
      'bodySystem': 'digestive',
      'preparation': 'powder',
    },
    {
      'id': '3',
      'name': 'Brahmi',
      'tamilName': 'பிரம்மி',
      'description':
          'A brain tonic herb that enhances memory and cognitive function.',
      'tamilDescription':
          'நினைவாற்றல் மற்றும் அறிவாற்றல் செயல்பாட்டை மேம்படுத்தும் மூளை டானிக் மூலிகை.',
      'image':
          'https://images.pexels.com/photos/7195133/pexels-photo-7195133.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
      'relatedDiseases': 15,
      'isBookmarked': false,
      'category': 'herbal',
      'bodySystem': 'nervous',
      'preparation': 'oil',
    },
    {
      'id': '4',
      'name': 'Turmeric',
      'tamilName': 'மஞ்சள்',
      'description':
          'A golden spice with powerful anti-inflammatory and healing properties.',
      'tamilDescription':
          'சக்திவாய்ந்த அழற்சி எதிர்ப்பு மற்றும் குணப்படுத்தும் பண்புகளைக் கொண்ட தங்க மசாலா.',
      'image':
          'https://images.pexels.com/photos/4198015/pexels-photo-4198015.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
      'relatedDiseases': 20,
      'isBookmarked': true,
      'category': 'herbal',
      'bodySystem': 'circulatory',
      'preparation': 'powder',
    },
    {
      'id': '5',
      'name': 'Neem',
      'tamilName': 'வேப்பம்',
      'description':
          'A versatile medicinal tree with antibacterial and antifungal properties.',
      'tamilDescription':
          'பாக்டீரியா எதிர்ப்பு மற்றும் பூஞ்சை எதிர்ப்பு பண்புகளைக் கொண்ட பல்துறை மருத்துவ மரம்.',
      'image':
          'https://images.pexels.com/photos/6207734/pexels-photo-6207734.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
      'relatedDiseases': 18,
      'isBookmarked': false,
      'category': 'herbal',
      'bodySystem': 'respiratory',
      'preparation': 'decoction',
    },
    {
      'id': '6',
      'name': 'Ginger',
      'tamilName': 'இஞ்சி',
      'description':
          'A warming spice excellent for digestion and respiratory health.',
      'tamilDescription':
          'செரிமானம் மற்றும் சுவாச ஆரோக்கியத்திற்கு சிறந்த வெப்பமூட்டும் மசாலா.',
      'image':
          'https://images.pexels.com/photos/1022385/pexels-photo-1022385.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
      'relatedDiseases': 10,
      'isBookmarked': false,
      'category': 'herbal',
      'bodySystem': 'digestive',
      'preparation': 'decoction',
    },
  ];

  List<Map<String, dynamic>> _filteredMedicines = [];

  @override
  void initState() {
    super.initState();
    _filteredMedicines = List.from(_allMedicines);
  }

  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query;
      _filterMedicines();
    });
  }

  void _onVoiceSearch() {
    // Voice search functionality would be implemented here
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _currentLanguage == 'Tamil'
              ? 'குரல் தேடல் விரைவில் வரும்'
              : 'Voice search coming soon',
        ),
      ),
    );
  }

  void _onFilterRemoved(String filterId) {
    setState(() {
      _activeFilters.removeWhere((filter) => filter['id'] == filterId);
      _updateCurrentFilters();
      _filterMedicines();
    });
  }

  void _onFiltersApplied(Map<String, dynamic> filters) {
    setState(() {
      _currentFilters = filters;
      _updateActiveFilters();
      _filterMedicines();
    });
  }

  void _updateActiveFilters() {
    _activeFilters.clear();

    // Add medicine type filters
    if (_currentFilters['medicineTypes'] != null) {
      final types = _currentFilters['medicineTypes'] as List<String>;
      for (String type in types) {
        _activeFilters.add({
          'id': 'type_$type',
          'name': type.toUpperCase(),
          'tamilName': _getTamilName(type),
          'count': _getMedicineCountByType(type),
        });
      }
    }

    // Add body system filters
    if (_currentFilters['bodySystems'] != null) {
      final systems = _currentFilters['bodySystems'] as List<String>;
      for (String system in systems) {
        _activeFilters.add({
          'id': 'system_$system',
          'name': system.toUpperCase(),
          'tamilName': _getTamilSystemName(system),
          'count': _getMedicineCountBySystem(system),
        });
      }
    }
  }

  void _updateCurrentFilters() {
    _currentFilters.clear();

    final typeFilters = _activeFilters
        .where((f) => f['id'].toString().startsWith('type_'))
        .map((f) => f['id'].toString().replaceFirst('type_', ''))
        .toList();

    final systemFilters = _activeFilters
        .where((f) => f['id'].toString().startsWith('system_'))
        .map((f) => f['id'].toString().replaceFirst('system_', ''))
        .toList();

    if (typeFilters.isNotEmpty) {
      _currentFilters['medicineTypes'] = typeFilters;
    }
    if (systemFilters.isNotEmpty) {
      _currentFilters['bodySystems'] = systemFilters;
    }
  }

  void _filterMedicines() {
    setState(() {
      _filteredMedicines = _allMedicines.where((medicine) {
        // Search filter
        if (_searchQuery.isNotEmpty) {
          final searchLower = _searchQuery.toLowerCase();
          final nameMatch =
              medicine['name'].toString().toLowerCase().contains(searchLower);
          final tamilNameMatch = medicine['tamilName']
              .toString()
              .toLowerCase()
              .contains(searchLower);
          final descMatch = medicine['description']
              .toString()
              .toLowerCase()
              .contains(searchLower);

          if (!nameMatch && !tamilNameMatch && !descMatch) {
            return false;
          }
        }

        // Type filter
        if (_currentFilters['medicineTypes'] != null) {
          final types = _currentFilters['medicineTypes'] as List<String>;
          if (!types.contains(medicine['category'])) {
            return false;
          }
        }

        // Body system filter
        if (_currentFilters['bodySystems'] != null) {
          final systems = _currentFilters['bodySystems'] as List<String>;
          if (!systems.contains(medicine['bodySystem'])) {
            return false;
          }
        }

        return true;
      }).toList();

      // Apply sorting
      if (_currentFilters['sortBy'] != null) {
        final sortBy = _currentFilters['sortBy'] as String;
        switch (sortBy) {
          case 'name_asc':
            _filteredMedicines.sort((a, b) => a['name'].compareTo(b['name']));
            break;
          case 'name_desc':
            _filteredMedicines.sort((a, b) => b['name'].compareTo(a['name']));
            break;
          case 'popularity':
            _filteredMedicines.sort(
                (a, b) => b['relatedDiseases'].compareTo(a['relatedDiseases']));
            break;
        }
      }
    });
  }

  String _getTamilName(String type) {
    final map = {
      'herbal': 'மூலிகை',
      'mineral': 'கனிம',
      'animal': 'விலங்கு',
      'compound': 'கலவை',
    };
    return map[type] ?? type;
  }

  String _getTamilSystemName(String system) {
    final map = {
      'respiratory': 'சுவாச',
      'digestive': 'செரிமான',
      'nervous': 'நரம்பு',
      'circulatory': 'இரத்த ஓட்ட',
      'musculoskeletal': 'தசை எலும்பு',
    };
    return map[system] ?? system;
  }

  int _getMedicineCountByType(String type) {
    return _allMedicines.where((m) => m['category'] == type).length;
  }

  int _getMedicineCountBySystem(String system) {
    return _allMedicines.where((m) => m['bodySystem'] == system).length;
  }

  void _onMedicineTap(Map<String, dynamic> medicine) {
    Navigator.pushNamed(context, '/medicine-detail-screen',
        arguments: medicine);
  }

  void _onBookmarkToggle(Map<String, dynamic> medicine) {
    setState(() {
      final index = _allMedicines.indexWhere((m) => m['id'] == medicine['id']);
      if (index != -1) {
        _allMedicines[index]['isBookmarked'] =
            !_allMedicines[index]['isBookmarked'];
        _filterMedicines();
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          medicine['isBookmarked'] == true
              ? (_currentLanguage == 'Tamil'
                  ? 'புத்தகக்குறியிலிருந்து அகற்றப்பட்டது'
                  : 'Removed from bookmarks')
              : (_currentLanguage == 'Tamil'
                  ? 'புத்தகக்குறியில் சேர்க்கப்பட்டது'
                  : 'Added to bookmarks'),
        ),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _onMedicineLongPress(Map<String, dynamic> medicine) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: EdgeInsets.all(4.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: CustomIconWidget(
                iconName: medicine['isBookmarked'] == true
                    ? 'bookmark_remove'
                    : 'bookmark_add',
                color: AppTheme.lightTheme.primaryColor,
                size: 6.w,
              ),
              title: Text(
                medicine['isBookmarked'] == true
                    ? (_currentLanguage == 'Tamil'
                        ? 'புத்தகக்குறியிலிருந்து அகற்று'
                        : 'Remove from Favorites')
                    : (_currentLanguage == 'Tamil'
                        ? 'புத்தகக்குறியில் சேர்'
                        : 'Add to Favorites'),
              ),
              onTap: () {
                Navigator.pop(context);
                _onBookmarkToggle(medicine);
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'share',
                color: AppTheme.lightTheme.primaryColor,
                size: 6.w,
              ),
              title: Text(
                _currentLanguage == 'Tamil' ? 'பகிர்' : 'Share',
              ),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      _currentLanguage == 'Tamil'
                          ? 'பகிர்வு விரைவில் வரும்'
                          : 'Share feature coming soon',
                    ),
                  ),
                );
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'local_hospital',
                color: AppTheme.lightTheme.primaryColor,
                size: 6.w,
              ),
              title: Text(
                _currentLanguage == 'Tamil'
                    ? 'தொடர்புடைய நோய்கள்'
                    : 'View Related Diseases',
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/disease-listing-screen',
                    arguments: {
                      'medicineId': medicine['id'],
                      'medicineName': medicine['name'],
                    });
              },
            ),
          ],
        ),
      ),
    );
  }

  void _toggleLanguage() {
    setState(() {
      _currentLanguage = _currentLanguage == 'English' ? 'Tamil' : 'English';
    });
  }

  void _showFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => FilterBottomSheet(
        currentFilters: _currentFilters,
        onFiltersApplied: _onFiltersApplied,
        currentLanguage: _currentLanguage,
      ),
    );
  }

  Future<void> _onRefresh() async {
    setState(() {
      _isLoading = true;
    });

    // Simulate refresh delay
    await Future.delayed(Duration(seconds: 1));

    setState(() {
      _isLoading = false;
      _filteredMedicines = List.from(_allMedicines);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: AppTheme.lightTheme.primaryColor,
        foregroundColor: AppTheme.lightTheme.colorScheme.onPrimary,
        title: Text(
          _currentLanguage == 'Tamil' ? 'மருந்துகள்' : 'Medicines',
          style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: CustomIconWidget(
            iconName: 'arrow_back',
            color: AppTheme.lightTheme.colorScheme.onPrimary,
            size: 6.w,
          ),
        ),
        actions: [
          IconButton(
            onPressed: _toggleLanguage,
            icon: CustomIconWidget(
              iconName: 'language',
              color: AppTheme.lightTheme.colorScheme.onPrimary,
              size: 6.w,
            ),
          ),
          IconButton(
            onPressed: () {
              // Global search functionality
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    _currentLanguage == 'Tamil'
                        ? 'உலகளாவிய தேடல் விரைவில் வரும்'
                        : 'Global search coming soon',
                  ),
                ),
              );
            },
            icon: CustomIconWidget(
              iconName: 'search',
              color: AppTheme.lightTheme.colorScheme.onPrimary,
              size: 6.w,
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          MedicineSearchBar(
            onSearchChanged: _onSearchChanged,
            onVoiceSearch: _onVoiceSearch,
            currentLanguage: _currentLanguage,
          ),

          // Filter Chips
          FilterChipsRow(
            activeFilters: _activeFilters,
            onFilterRemoved: _onFilterRemoved,
            currentLanguage: _currentLanguage,
          ),

          // Medicine List
          Expanded(
            child: _isLoading
                ? Center(
                    child: CircularProgressIndicator(
                      color: AppTheme.lightTheme.primaryColor,
                    ),
                  )
                : _filteredMedicines.isEmpty
                    ? _buildEmptyState()
                    : RefreshIndicator(
                        onRefresh: _onRefresh,
                        color: AppTheme.lightTheme.primaryColor,
                        child: ListView.builder(
                          padding: EdgeInsets.only(bottom: 10.h),
                          itemCount: _filteredMedicines.length,
                          itemBuilder: (context, index) {
                            return MedicineCard(
                              medicine: _filteredMedicines[index],
                              currentLanguage: _currentLanguage,
                              onTap: _onMedicineTap,
                              onBookmark: _onBookmarkToggle,
                              onLongPress: _onMedicineLongPress,
                            );
                          },
                        ),
                      ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showFilterBottomSheet,
        backgroundColor: AppTheme.lightTheme.primaryColor,
        child: CustomIconWidget(
          iconName: 'filter_list',
          color: AppTheme.lightTheme.colorScheme.onPrimary,
          size: 6.w,
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(8.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomIconWidget(
              iconName: 'search_off',
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 20.w,
            ),
            SizedBox(height: 3.h),
            Text(
              _currentLanguage == 'Tamil'
                  ? 'மருந்துகள் கிடைக்கவில்லை'
                  : 'No medicines found',
              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 1.h),
            Text(
              _currentLanguage == 'Tamil'
                  ? 'வேறு தேடல் சொற்களை முயற்சிக்கவும் அல்லது வடிகட்டிகளை அழிக்கவும்'
                  : 'Try different search terms or clear filters',
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 3.h),
            if (_activeFilters.isNotEmpty)
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _activeFilters.clear();
                    _currentFilters.clear();
                    _filterMedicines();
                  });
                },
                child: Text(
                  _currentLanguage == 'Tamil'
                      ? 'வடிகட்டிகளை அழிக்க'
                      : 'Clear Filters',
                ),
              ),
          ],
        ),
      ),
    );
  }
}
