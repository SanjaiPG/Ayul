import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class DiseaseSearchBar extends StatefulWidget {
  final Function(String) onSearchChanged;
  final VoidCallback onVoiceSearch;
  final String currentLanguage;

  const DiseaseSearchBar({
    Key? key,
    required this.onSearchChanged,
    required this.onVoiceSearch,
    required this.currentLanguage,
  }) : super(key: key);

  @override
  State<DiseaseSearchBar> createState() => _DiseaseSearchBarState();
}

class _DiseaseSearchBarState extends State<DiseaseSearchBar> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      widget.onSearchChanged(_searchController.text);
      setState(() {}); // update clear icon visibility
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
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
      child: TextField(
        controller: _searchController,
        onChanged: widget.onSearchChanged,
        decoration: InputDecoration(
          hintText: widget.currentLanguage == 'Tamil'
              ? 'நோய்களைத் தேடுங்கள்...'
              : 'Search diseases...',
          hintStyle: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
          ),
          prefixIcon: Padding(
            padding: EdgeInsets.all(3.w),
            child: CustomIconWidget(
              iconName: 'search',
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 5.w,
            ),
          ),
          suffixIcon: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (_searchController.text.isNotEmpty)
                GestureDetector(
                  onTap: () {
                    _searchController.clear();
                    widget.onSearchChanged('');
                  },
                  child: Padding(
                    padding: EdgeInsets.all(2.w),
                    child: CustomIconWidget(
                      iconName: 'clear',
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      size: 4.w,
                    ),
                  ),
                ),
              GestureDetector(
                onTap: widget.onVoiceSearch,
                child: Padding(
                  padding: EdgeInsets.all(3.w),
                  child: CustomIconWidget(
                    iconName: 'mic',
                    color: AppTheme.lightTheme.primaryColor,
                    size: 5.w,
                  ),
                ),
              ),
            ],
          ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
        ),
      ),
    );
  }
}
