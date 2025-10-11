import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/filter_bottom_sheet.dart';
import './widgets/filter_chips_row.dart';
import './widgets/medicine_card.dart';
import './widgets/medicine_search_bar.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

class p1 extends StatefulWidget {
  const p1({Key? key}) : super(key: key);

  @override
  State<p1> createState() => _p1State();
}

class _p1State extends State<p1> {
  String _currentLanguage = 'English';
  String _searchQuery = '';
  List<Map<String, dynamic>> _activeFilters = [];
  Map<String, dynamic> _currentFilters = {};
  bool _isLoading = false;

  List<Map<String, dynamic>> _allMedicines = [];
  List<Map<String, dynamic>> _filteredMedicines = [];

  // Check if there's any active search or filter
  bool get _hasActiveSearchOrFilter {
    return _searchQuery.isNotEmpty || _activeFilters.isNotEmpty;
  }

  Future<void> _fetchMedicines() async {
    setState(() => _isLoading = true);

    try {
      final snapshot =
          await FirebaseFirestore.instance.collection('SiddhaMedicines').get();

      _allMedicines = snapshot.docs.map((doc) {
        return {
          'id': doc.id,
          'Name': doc['Name'] ?? '',
          'Name_Tamil': doc['Name_Tamil'] ?? '',
          'Description': doc['Description'] ?? '',
          'Description_Tamil': doc['Description_Tamil'] ?? '',
          'Dosage': doc['Dosage'] ?? '',
          'Dosage_Tamil': doc['Dosage_Tamil'] ?? '',
          'Image': doc['Image'] ?? '',
          'Parts_Used': doc['Parts_Used'] ?? '',
          'Parts_Used_Tamil': doc['Parts_Used_Tamil'] ?? '',
          'Possible_Side_Effects': doc['Possible_Side_Effects'] ?? '',
          'Possible_Side_Effects_Tamil':
              doc['Possible_Side_Effects_Tamil'] ?? '',
          'Precautions': doc['Precautions'] ?? '',
          'Precautions_Tamil': doc['Precautions_Tamil'] ?? '',
          'Scientific_Name': doc['Scientific_Name'] ?? '',
          'Type_Of_Medicine': doc['Type_Of_Medicine'] ?? '',
          'Type_Of_Medicine_Tamil': doc['Type_Of_Medicine_Tamil'] ?? '',
        };
      }).toList();

      // Don't populate filtered medicines at start
      _filteredMedicines = [];

      // Debug: Print the fetched data
      print('Fetched ${_allMedicines.length} medicines');
      if (_allMedicines.isNotEmpty) {
        print('First medicine: ${_allMedicines[0]}');
      }
    } catch (e) {
      print('Error fetching medicines: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading medicines: $e')),
      );
    }

    setState(() => _isLoading = false);
  }

  @override
  void initState() {
    super.initState();
    _fetchMedicines();
  }

  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query;
      _filterMedicines();
    });
  }

  void _onVoiceSearch() {
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

    if (typeFilters.isNotEmpty) _currentFilters['medicineTypes'] = typeFilters;
    if (systemFilters.isNotEmpty)
      _currentFilters['bodySystems'] = systemFilters;
  }

  void _filterMedicines() {
    setState(() {
      // If no search query and no filters, show nothing
      if (!_hasActiveSearchOrFilter) {
        _filteredMedicines = [];
        return;
      }

      _filteredMedicines = _allMedicines.where((medicine) {
        // Search filter - use correct field names
        if (_searchQuery.isNotEmpty) {
          final searchLower = _searchQuery.toLowerCase();
          final name = (medicine['Name'] ?? '').toString().toLowerCase();
          final nameTamil =
              (medicine['Name_Tamil'] ?? '').toString().toLowerCase();
          final description =
              (medicine['Description'] ?? '').toString().toLowerCase();
          final descriptionTamil =
              (medicine['Description_Tamil'] ?? '').toString().toLowerCase();

          if (!name.contains(searchLower) &&
              !nameTamil.contains(searchLower) &&
              !description.contains(searchLower) &&
              !descriptionTamil.contains(searchLower)) {
            return false;
          }
        }

        // Type filter - use correct field name
        if (_currentFilters['medicineTypes'] != null) {
          final types = _currentFilters['medicineTypes'] as List<String>;
          final medicineType =
              (medicine['Type_Of_Medicine'] ?? '').toString().toLowerCase();
          if (!types.any((type) => type.toLowerCase() == medicineType)) {
            return false;
          }
        }

        // Body system filter - if your Firestore has this field, adjust accordingly
        if (_currentFilters['bodySystems'] != null) {
          final systems = _currentFilters['bodySystems'] as List<String>;
          // Adjust this field name if you have a body system field in Firestore
          final bodySystem =
              (medicine['BodySystem'] ?? '').toString().toLowerCase();
          if (bodySystem.isNotEmpty &&
              !systems.any((system) => system.toLowerCase() == bodySystem)) {
            return false;
          }
        }

        return true;
      }).toList();

      // Sorting
      if (_currentFilters['sortBy'] != null) {
        final sortBy = _currentFilters['sortBy'] as String;
        switch (sortBy) {
          case 'name_asc':
            _filteredMedicines.sort((a, b) => (a['Name'] ?? '')
                .toString()
                .compareTo((b['Name'] ?? '').toString()));
            break;
          case 'name_desc':
            _filteredMedicines.sort((a, b) => (b['Name'] ?? '')
                .toString()
                .compareTo((a['Name'] ?? '').toString()));
            break;
          case 'popularity':
            break;
        }
      }

      print('Filtered medicines count: ${_filteredMedicines.length}');
    });
  }

  String _getTamilName(String type) {
    final map = {
      'herbal': 'மூலிகை',
      'mineral': 'கனிம',
      'animal': 'விலங்கு',
      'compound': 'கலவை',
    };
    return map[type.toLowerCase()] ?? type;
  }

  String _getTamilSystemName(String system) {
    final map = {
      'respiratory': 'சுவாச',
      'digestive': 'செரிமான',
      'nervous': 'நரம்பு',
      'circulatory': 'இரத்த ஓட்ட',
      'musculoskeletal': 'தசை எலும்பு',
    };
    return map[system.toLowerCase()] ?? system;
  }

  int _getMedicineCountByType(String type) {
    return _allMedicines
        .where((m) =>
            (m['Type_Of_Medicine'] ?? '').toString().toLowerCase() ==
            type.toLowerCase())
        .length;
  }

  int _getMedicineCountBySystem(String system) {
    return _allMedicines
        .where((m) =>
            (m['BodySystem'] ?? '').toString().toLowerCase() ==
            system.toLowerCase())
        .length;
  }

  void _onMedicineTap(Map<String, dynamic> medicine) {
    Navigator.pushNamed(context, '/medicine-detail-screen',
        arguments: medicine);
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
                iconName: 'share',
                color: AppTheme.lightTheme.primaryColor,
                size: 6.w,
              ),
              title: Text(_currentLanguage == 'Tamil' ? 'பகிர்' : 'Share'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(_currentLanguage == 'Tamil'
                        ? 'பகிர்வு விரைவில் வரும்'
                        : 'Share feature coming soon'),
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
              title: Text(_currentLanguage == 'Tamil'
                  ? 'தொடர்புடைய நோய்கள்'
                  : 'View Related Diseases'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/disease-listing-screen',
                    arguments: {
                      'medicineId': medicine['id'],
                      'medicineName': medicine['Name'],
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
    await _fetchMedicines();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          MedicineSearchBar(
            onSearchChanged: _onSearchChanged,
            onVoiceSearch: _onVoiceSearch,
            currentLanguage: _currentLanguage,
          ),
          FilterChipsRow(
            activeFilters: _activeFilters,
            onFilterRemoved: _onFilterRemoved,
            currentLanguage: _currentLanguage,
          ),
          Expanded(
            child: _isLoading
                ? Center(
                    child: CircularProgressIndicator(
                      color: AppTheme.lightTheme.primaryColor,
                    ),
                  )
                : !_hasActiveSearchOrFilter
                    ? _buildInitialState()
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
                                  onLongPress: _onMedicineLongPress,
                                );
                              },
                            ),
                          ),
          ),
        ],
      ),
    );
  }

  Widget _buildInitialState() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(8.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomIconWidget(
              iconName: 'search',
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 20.w,
            ),
            SizedBox(height: 3.h),
            Text(
              _currentLanguage == 'Tamil'
                  ? 'மருந்துகளைத் தேட ஆரம்பிக்கவும்'
                  : 'Start searching for medicines',
              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 1.h),
            Text(
              _currentLanguage == 'Tamil'
                  ? 'மேலே உள்ள தேடல் பட்டையைப் பயன்படுத்தவும் அல்லது வடிகட்டிகளைப் பயன்படுத்தவும்'
                  : 'Use the search bar above or apply filters',
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ],
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