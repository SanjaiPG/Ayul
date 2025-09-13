import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/category_filter_chips_widget.dart';
import './widgets/context_menu_widget.dart';
import './widgets/disease_card_widget.dart';
import './widgets/disease_search_bar_widget.dart';
import './widgets/filter_bottom_sheet_widget.dart';

class DiseaseListingScreen extends StatefulWidget {
  const DiseaseListingScreen({Key? key}) : super(key: key);

  @override
  State<DiseaseListingScreen> createState() => _DiseaseListingScreenState();
}

class _DiseaseListingScreenState extends State<DiseaseListingScreen> {
  String _searchQuery = '';
  String _selectedCategory = 'All';
  Map<String, dynamic> _activeFilters = {
    'bodySystems': <String>[],
    'severities': <String>[],
    'sortBy': 'A-Z',
  };
  bool _isLoading = false;
  Map<String, dynamic>? _selectedDiseaseForMenu;

  final List<String> _categories = [
    'All',
    'Respiratory',
    'Digestive',
    'Skin',
    'Neurological',
    'Musculoskeletal',
    'Cardiovascular',
  ];

  final List<Map<String, dynamic>> _mockDiseases = [
    {
      "id": 1,
      "name": "Asthma",
      "tamilName": "இருமல் நோய்",
      "bodySystems": ["Respiratory"],
      "symptomCount": 8,
      "severity": "moderate",
      "medicineCount": 12,
      "keySymptoms": [
        "Shortness of breath",
        "Wheezing",
        "Chest tightness",
        "Persistent cough"
      ],
      "description":
          "A respiratory condition in which airways narrow and swell, making breathing difficult.",
    },
    {
      "id": 2,
      "name": "Gastritis",
      "tamilName": "வயிற்று அழற்சி",
      "bodySystems": ["Digestive"],
      "symptomCount": 6,
      "severity": "mild",
      "medicineCount": 8,
      "keySymptoms": ["Stomach pain", "Nausea", "Bloating", "Loss of appetite"],
      "description":
          "Inflammation of the stomach lining causing digestive discomfort.",
    },
    {
      "id": 3,
      "name": "Eczema",
      "tamilName": "தோல் அழற்சி",
      "bodySystems": ["Skin"],
      "symptomCount": 5,
      "severity": "mild",
      "medicineCount": 15,
      "keySymptoms": [
        "Itchy skin",
        "Red patches",
        "Dry skin",
        "Skin inflammation"
      ],
      "description":
          "A condition that makes skin red and itchy, commonly affecting children.",
    },
    {
      "id": 4,
      "name": "Migraine",
      "tamilName": "ஒற்றைத் தலைவலி",
      "bodySystems": ["Neurological"],
      "symptomCount": 7,
      "severity": "severe",
      "medicineCount": 10,
      "keySymptoms": [
        "Severe headache",
        "Nausea",
        "Light sensitivity",
        "Visual disturbances"
      ],
      "description":
          "A neurological condition characterized by recurrent headaches.",
    },
    {
      "id": 5,
      "name": "Arthritis",
      "tamilName": "மூட்டு வலி",
      "bodySystems": ["Musculoskeletal"],
      "symptomCount": 6,
      "severity": "moderate",
      "medicineCount": 18,
      "keySymptoms": [
        "Joint pain",
        "Stiffness",
        "Swelling",
        "Reduced mobility"
      ],
      "description":
          "Inflammation of one or more joints causing pain and stiffness.",
    },
    {
      "id": 6,
      "name": "Hypertension",
      "tamilName": "உயர் இரத்த அழுத்தம்",
      "bodySystems": ["Cardiovascular"],
      "symptomCount": 4,
      "severity": "severe",
      "medicineCount": 14,
      "keySymptoms": [
        "High blood pressure",
        "Headaches",
        "Dizziness",
        "Chest pain"
      ],
      "description":
          "A condition where blood pressure in arteries is persistently elevated.",
    },
    {
      "id": 7,
      "name": "Bronchitis",
      "tamilName": "மூச்சுக்குழாய் அழற்சி",
      "bodySystems": ["Respiratory"],
      "symptomCount": 5,
      "severity": "moderate",
      "medicineCount": 9,
      "keySymptoms": [
        "Persistent cough",
        "Mucus production",
        "Fatigue",
        "Shortness of breath"
      ],
      "description":
          "Inflammation of the lining of bronchial tubes in the lungs.",
    },
    {
      "id": 8,
      "name": "Peptic Ulcer",
      "tamilName": "வயிற்றுப் புண்",
      "bodySystems": ["Digestive"],
      "symptomCount": 7,
      "severity": "moderate",
      "medicineCount": 11,
      "keySymptoms": [
        "Stomach pain",
        "Heartburn",
        "Nausea",
        "Loss of appetite"
      ],
      "description":
          "Open sores that develop on the inside lining of stomach and upper small intestine.",
    },
  ];

  List<Map<String, dynamic>> get _filteredDiseases {
    List<Map<String, dynamic>> filtered = List.from(_mockDiseases);

    // Apply search filter
    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((disease) {
        final name = disease['name'].toString().toLowerCase();
        final tamilName = disease['tamilName'].toString().toLowerCase();
        final symptoms =
            (disease['keySymptoms'] as List).join(' ').toLowerCase();
        final query = _searchQuery.toLowerCase();

        return name.contains(query) ||
            tamilName.contains(query) ||
            symptoms.contains(query);
      }).toList();
    }

    // Apply category filter
    if (_selectedCategory != 'All') {
      filtered = filtered.where((disease) {
        final bodySystems = disease['bodySystems'] as List;
        return bodySystems.contains(_selectedCategory);
      }).toList();
    }

    // Apply advanced filters
    final List<String> bodySystemFilters =
        _activeFilters['bodySystems'] as List<String>;
    if (bodySystemFilters.isNotEmpty) {
      filtered = filtered.where((disease) {
        final bodySystems = disease['bodySystems'] as List;
        return bodySystemFilters.any((filter) => bodySystems.contains(filter));
      }).toList();
    }

    final List<String> severityFilters =
        _activeFilters['severities'] as List<String>;
    if (severityFilters.isNotEmpty) {
      filtered = filtered.where((disease) {
        final severity = disease['severity'].toString();
        return severityFilters
            .any((filter) => severity.toLowerCase() == filter.toLowerCase());
      }).toList();
    }

    // Apply sorting
    final String sortBy = _activeFilters['sortBy'] as String;
    switch (sortBy) {
      case 'A-Z':
        filtered.sort(
            (a, b) => a['name'].toString().compareTo(b['name'].toString()));
        break;
      case 'Z-A':
        filtered.sort(
            (a, b) => b['name'].toString().compareTo(a['name'].toString()));
        break;
      case 'Severity':
        final severityOrder = {'mild': 1, 'moderate': 2, 'severe': 3};
        filtered.sort((a, b) {
          final aSeverity =
              severityOrder[a['severity'].toString().toLowerCase()] ?? 0;
          final bSeverity =
              severityOrder[b['severity'].toString().toLowerCase()] ?? 0;
          return bSeverity.compareTo(aSeverity);
        });
        break;
      case 'Most Common':
        filtered.sort((a, b) =>
            (b['medicineCount'] as int).compareTo(a['medicineCount'] as int));
        break;
    }

    return filtered;
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
              // Search Bar
              DiseaseSearchBarWidget(
                onSearchChanged: (query) {
                  setState(() {
                    _searchQuery = query;
                  });
                },
                onFilterPressed: _showFilterBottomSheet,
              ),

              // Category Filter Chips
              CategoryFilterChipsWidget(
                categories: _categories,
                selectedCategory: _selectedCategory,
                onCategorySelected: (category) {
                  setState(() {
                    _selectedCategory = category;
                  });
                },
              ),

              // Disease List
              Expanded(
                child: _isLoading
                    ? _buildLoadingState()
                    : _filteredDiseases.isEmpty
                        ? _buildEmptyState()
                        : RefreshIndicator(
                            onRefresh: _refreshDiseases,
                            color: AppTheme.lightTheme.colorScheme.primary,
                            child: ListView.builder(
                              padding: EdgeInsets.only(bottom: 2.h),
                              itemCount: _filteredDiseases.length,
                              itemBuilder: (context, index) {
                                final disease = _filteredDiseases[index];
                                return DiseaseCardWidget(
                                  disease: disease,
                                  onTap: () =>
                                      _navigateToDiseaseDetail(disease),
                                  onLongPress: () => _showContextMenu(disease),
                                );
                              },
                            ),
                          ),
              ),
            ],
          ),

          // Context Menu Overlay
          if (_selectedDiseaseForMenu != null)
            ContextMenuWidget(
              disease: _selectedDiseaseForMenu!,
              onAddToWatchlist: () => _addToWatchlist(_selectedDiseaseForMenu!),
              onShare: () => _shareDisease(_selectedDiseaseForMenu!),
              onViewTreatments: () => _viewTreatments(_selectedDiseaseForMenu!),
              onDismiss: () {
                setState(() {
                  _selectedDiseaseForMenu = null;
                });
              },
            ),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: Text(
        'Diseases',
        style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.w600,
          color: AppTheme.lightTheme.colorScheme.onPrimary,
        ),
      ),
      backgroundColor: AppTheme.lightTheme.colorScheme.primary,
      foregroundColor: AppTheme.lightTheme.colorScheme.onPrimary,
      elevation: 0,
      actions: [
        IconButton(
          onPressed: () {
            // Navigate to global search
            Fluttertoast.showToast(
              msg: "Global search feature coming soon",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
            );
          },
          icon: CustomIconWidget(
            iconName: 'search',
            color: AppTheme.lightTheme.colorScheme.onPrimary,
            size: 6.w,
          ),
        ),
        IconButton(
          onPressed: () {
            // Toggle language
            Fluttertoast.showToast(
              msg: "Language toggle feature coming soon",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
            );
          },
          icon: CustomIconWidget(
            iconName: 'language',
            color: AppTheme.lightTheme.colorScheme.onPrimary,
            size: 6.w,
          ),
        ),
      ],
    );
  }

  Widget _buildLoadingState() {
    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      itemCount: 6,
      itemBuilder: (context, index) {
        return Container(
          margin: EdgeInsets.only(bottom: 2.h),
          height: 20.h,
          decoration: BoxDecoration(
            color: AppTheme.lightTheme.colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 8,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.all(4.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 2.h,
                      width: 60.w,
                      decoration: BoxDecoration(
                        color: Colors.grey.withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    SizedBox(height: 1.h),
                    Container(
                      height: 1.5.h,
                      width: 40.w,
                      decoration: BoxDecoration(
                        color: Colors.grey.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ],
                ),
              ),
              Spacer(),
              Container(
                height: 6.h,
                decoration: BoxDecoration(
                  color: Colors.grey.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(12),
                    bottomRight: Radius.circular(12),
                  ),
                ),
              ),
            ],
          ),
        );
      },
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
              'No diseases found',
              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: AppTheme.lightTheme.colorScheme.onSurface,
              ),
            ),
            SizedBox(height: 1.h),
            Text(
              _searchQuery.isNotEmpty
                  ? 'Try adjusting your search terms or filters'
                  : 'No diseases match your current filters',
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 3.h),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _searchQuery = '';
                  _selectedCategory = 'All';
                  _activeFilters = {
                    'bodySystems': <String>[],
                    'severities': <String>[],
                    'sortBy': 'A-Z',
                  };
                });
              },
              child: Text('Clear Filters'),
            ),
          ],
        ),
      ),
    );
  }

  void _showFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => FilterBottomSheetWidget(
        currentFilters: _activeFilters,
        onFiltersApplied: (filters) {
          setState(() {
            _activeFilters = filters;
          });
        },
      ),
    );
  }

  void _showContextMenu(Map<String, dynamic> disease) {
    setState(() {
      _selectedDiseaseForMenu = disease;
    });
  }

  Future<void> _refreshDiseases() async {
    setState(() {
      _isLoading = true;
    });

    // Simulate API call
    await Future.delayed(Duration(seconds: 1));

    setState(() {
      _isLoading = false;
    });

    Fluttertoast.showToast(
      msg: "Disease database updated",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
    );
  }

  void _navigateToDiseaseDetail(Map<String, dynamic> disease) {
    // Navigate to disease detail screen
    Fluttertoast.showToast(
      msg: "Navigating to ${disease['name']} details",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
    );
    // Navigator.pushNamed(context, '/disease-detail-screen', arguments: disease);
  }

  void _addToWatchlist(Map<String, dynamic> disease) {
    Fluttertoast.showToast(
      msg: "${disease['name']} added to watchlist",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
    );
  }

  void _shareDisease(Map<String, dynamic> disease) {
    Fluttertoast.showToast(
      msg: "Sharing ${disease['name']} information",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
    );
  }

  void _viewTreatments(Map<String, dynamic> disease) {
    Fluttertoast.showToast(
      msg: "Viewing treatments for ${disease['name']}",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
    );
    // Navigator.pushNamed(context, '/medicine-listing-screen', arguments: {'diseaseId': disease['id']});
  }
}
