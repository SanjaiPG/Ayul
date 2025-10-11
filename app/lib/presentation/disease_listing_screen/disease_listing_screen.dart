import 'package:flutter/material.dart';
import 'package:siddha_acu_edu/presentation/medicine_listing_screen/widgets/filter_chips_row.dart'
    as medicine;
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/disease_card.dart';
import './widgets/disease_search_bar.dart';
import './widgets/filter_chips_row.dart'; // optional reuse of existing widget
import 'package:cloud_firestore/cloud_firestore.dart';

class DiseaseListingScreen extends StatefulWidget {
  const DiseaseListingScreen({Key? key}) : super(key: key);

  @override
  State<DiseaseListingScreen> createState() => _DiseaseListingScreenState();
}

class _DiseaseListingScreenState extends State<DiseaseListingScreen> {
  String _currentLanguage = 'English';
  String _searchQuery = '';
  bool _isLoading = false;

  List<Map<String, dynamic>> _allDiseases = [];
  List<Map<String, dynamic>> _filteredDiseases = [];

  // You can reuse FilterChipsRow by passing an empty list for now
  List<Map<String, dynamic>> _activeFilters = [];

  // ADD HELPER METHOD HERE
  dynamic _getField(
      Map<String, dynamic> data, List<String> possibleFieldNames) {
    for (String fieldName in possibleFieldNames) {
      if (data.containsKey(fieldName)) {
        return data[fieldName];
      }
    }
    return ''; // Default empty string if no field found
  }

  Future<void> _fetchDiseases() async {
    setState(() => _isLoading = true);

    try {
      final snapshot =
          await FirebaseFirestore.instance.collection('Diseases').get();

      // DEBUG: Print all available fields from first document
      if (snapshot.docs.isNotEmpty) {
        print('Available fields in first document:');
        snapshot.docs.first.data().forEach((key, value) {
          print('$key: $value');
        });
      }

      _allDiseases = snapshot.docs.map((doc) {
        final data = doc.data();
        return {
          'id': doc.id,
          'name': data['name'] ?? '',
          'Name_Tamil': _getField(
              data, ['Name_Tamil', 'name_tamil', 'nameTamil', 'tamil_name']),
          'description': data['description'] ?? '',
          'Description_Tamil': _getField(data, [
            'Description_Tamil',
            'description_tamil',
            'descriptionTamil',
            'tamil_description'
          ]),
          'medicines': data['medicines'] ?? '',
          'Medicines_Tamil': _getField(data, [
            'Medicines_Tamil',
            'medicines_tamil',
            'medicinesTamil',
            'tamil_medicines'
          ]),
          'treatments': data['treatments'] ?? '',
          'Treatments_Tamil': _getField(data, [
            'Treatments_Tamil',
            'treatments_tamil',
            'treatmentsTamil',
            'tamil_treatments'
          ]),
        };
      }).toList();

      _filteredDiseases = List.from(_allDiseases);

      // debug
      print('Fetched ${_allDiseases.length} diseases');
      if (_allDiseases.isNotEmpty) print('First disease: ${_allDiseases[0]}');
    } catch (e) {
      print('Error fetching diseases: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading diseases: $e')),
        );
      }
    }

    setState(() => _isLoading = false);
  }

  @override
  void initState() {
    super.initState();
    _fetchDiseases();
  }

  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query;
      _filterDiseases();
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

  void _onDiseaseTap(Map<String, dynamic> disease) {
    Navigator.pushNamed(context, '/disease-detail-screen', arguments: disease);
  }

  void _onDiseaseLongPress(Map<String, dynamic> disease) {
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
                  ? 'மருத்துவ குறிப்புகள்'
                  : 'View Medical Notes'),
              onTap: () {
                Navigator.pop(context);
                // Implement navigation if you have a specific screen
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

  void _showFilterPlaceholder() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: EdgeInsets.all(4.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              _currentLanguage == 'Tamil' ? 'வடிகட்டிகள்' : 'Filters',
              style: AppTheme.lightTheme.textTheme.titleMedium,
            ),
            SizedBox(height: 2.h),
            Text(
              _currentLanguage == 'Tamil'
                  ? 'வடிகட்டிகள் விரைவில் வரும்'
                  : 'Filters coming soon',
              style: AppTheme.lightTheme.textTheme.bodyMedium
                  ?.copyWith(height: 1.4),
            ),
            SizedBox(height: 2.h),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: Text(_currentLanguage == 'Tamil' ? 'மீட்க' : 'Close'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _onRefresh() async {
    await _fetchDiseases();
  }

  void _filterDiseases() {
    setState(() {
      _filteredDiseases = _allDiseases.where((d) {
        if (_searchQuery.isNotEmpty) {
          final q = _searchQuery.toLowerCase();

          // Check all possible fields safely
          final searchableFields = [
            d['name']?.toString().toLowerCase() ?? '',
            d['Name_Tamil']?.toString().toLowerCase() ?? '',
            d['description']?.toString().toLowerCase() ?? '',
            d['Description_Tamil']?.toString().toLowerCase() ?? '',
            d['medicines']?.toString().toLowerCase() ?? '',
            d['Medicines_Tamil']?.toString().toLowerCase() ?? '',
            d['treatments']?.toString().toLowerCase() ?? '',
            d['Treatments_Tamil']?.toString().toLowerCase() ?? '',
          ];

          // Return true if any field contains the query
          return searchableFields.any((field) => field.contains(q));
        }
        return true;
      }).toList();

      print('Filtered diseases: ${_filteredDiseases.length}');
    });
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
                  ? 'நோய்கள் கிடைக்கவில்லை'
                  : 'No diseases found',
              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 1.h),
            Text(
              _currentLanguage == 'Tamil'
                  ? 'வேறு தேடல் சொற்களை முயற்சிக்கவும்'
                  : 'Try different search terms',
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: AppTheme.lightTheme.primaryColor,
        foregroundColor: AppTheme.lightTheme.colorScheme.onPrimary,
        title: Text(
          _currentLanguage == 'Tamil' ? 'நோய்கள்' : 'Diseases',
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
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(_currentLanguage == 'Tamil'
                      ? 'உலகளாவிய தேடல் விரைவில் வரும்'
                      : 'Global search coming soon'),
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
          DiseaseSearchBar(
            onSearchChanged: _onSearchChanged,
            onVoiceSearch: _onVoiceSearch,
            currentLanguage: _currentLanguage,
          ),
          // Reuse the FilterChipsRow if you want to show active filter chips (we pass empty for now)
          FilterChipsRow(
            activeFilters: _activeFilters,
            onFilterRemoved: (id) {},
            currentLanguage: _currentLanguage,
          ),
          Expanded(
            child: _isLoading
                ? Center(
                    child: CircularProgressIndicator(
                      color: AppTheme.lightTheme.primaryColor,
                    ),
                  )
                : _filteredDiseases.isEmpty
                    ? _buildEmptyState()
                    : RefreshIndicator(
                        onRefresh: _onRefresh,
                        color: AppTheme.lightTheme.primaryColor,
                        child: ListView.builder(
                          padding: EdgeInsets.only(bottom: 10.h),
                          itemCount: _filteredDiseases.length,
                          itemBuilder: (context, index) {
                            return DiseaseCard(
                              disease: _filteredDiseases[index],
                              currentLanguage: _currentLanguage,
                              onTap: _onDiseaseTap,
                              onLongPress: _onDiseaseLongPress,
                            );
                          },
                        ),
                      ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showFilterPlaceholder,
        backgroundColor: AppTheme.lightTheme.primaryColor,
        child: CustomIconWidget(
          iconName: 'filter_list',
          color: AppTheme.lightTheme.colorScheme.onPrimary,
          size: 6.w,
        ),
      ),
    );
  }
}
