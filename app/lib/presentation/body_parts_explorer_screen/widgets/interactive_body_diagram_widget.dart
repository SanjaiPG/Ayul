import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class InteractiveBodyDiagramWidget extends StatefulWidget {
  final Function(Map<String, dynamic>) onBodyPartTap;
  final List<Map<String, dynamic>> bodyParts;

  const InteractiveBodyDiagramWidget({
    Key? key,
    required this.onBodyPartTap,
    required this.bodyParts,
  }) : super(key: key);

  @override
  State<InteractiveBodyDiagramWidget> createState() =>
      _InteractiveBodyDiagramWidgetState();
}

class _InteractiveBodyDiagramWidgetState
    extends State<InteractiveBodyDiagramWidget> {
  final TransformationController _transformationController =
      TransformationController();
  String? _hoveredBodyPart;

  @override
  void dispose() {
    _transformationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 70.h,
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          children: [
            InteractiveViewer(
              transformationController: _transformationController,
              minScale: 0.5,
              maxScale: 3.0,
              constrained: false,
              child: Container(
                width: 100.w,
                height: 70.h,
                child: Stack(
                  children: [
                    // Background body diagram
                    Positioned.fill(
                      child: CustomImageWidget(
                        imageUrl:
                            "https://images.unsplash.com/photo-1559757148-5c350d0d3c56?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
                        width: double.infinity,
                        height: double.infinity,
                        fit: BoxFit.contain,
                      ),
                    ),
                    // Interactive body part regions
                    ..._buildInteractiveRegions(),
                  ],
                ),
              ),
            ),
            // Zoom controls
            Positioned(
              bottom: 2.h,
              right: 4.w,
              child: _buildZoomControls(),
            ),
            // Reset view button
            Positioned(
              bottom: 2.h,
              left: 4.w,
              child: _buildResetButton(),
            ),
            // Hover tooltip
            if (_hoveredBodyPart != null)
              Positioned(
                top: 2.h,
                left: 4.w,
                child: _buildHoverTooltip(),
              ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildInteractiveRegions() {
    return [
      // Head region
      _buildInteractiveRegion(
        top: 8.h,
        left: 42.w,
        width: 16.w,
        height: 12.h,
        bodyPartName: 'Head',
        bodyPartData: widget.bodyParts.firstWhere(
          (part) => (part['name'] as String).toLowerCase().contains('head'),
          orElse: () => _getDefaultBodyPart('Head'),
        ),
      ),
      // Neck region
      _buildInteractiveRegion(
        top: 18.h,
        left: 45.w,
        width: 10.w,
        height: 6.h,
        bodyPartName: 'Neck',
        bodyPartData: widget.bodyParts.firstWhere(
          (part) => (part['name'] as String).toLowerCase().contains('neck'),
          orElse: () => _getDefaultBodyPart('Neck'),
        ),
      ),
      // Chest region
      _buildInteractiveRegion(
        top: 24.h,
        left: 40.w,
        width: 20.w,
        height: 15.h,
        bodyPartName: 'Chest',
        bodyPartData: widget.bodyParts.firstWhere(
          (part) => (part['name'] as String).toLowerCase().contains('chest'),
          orElse: () => _getDefaultBodyPart('Chest'),
        ),
      ),
      // Abdomen region
      _buildInteractiveRegion(
        top: 39.h,
        left: 42.w,
        width: 16.w,
        height: 12.h,
        bodyPartName: 'Abdomen',
        bodyPartData: widget.bodyParts.firstWhere(
          (part) => (part['name'] as String).toLowerCase().contains('abdomen'),
          orElse: () => _getDefaultBodyPart('Abdomen'),
        ),
      ),
      // Left arm region
      _buildInteractiveRegion(
        top: 26.h,
        left: 25.w,
        width: 12.w,
        height: 25.h,
        bodyPartName: 'Left Arm',
        bodyPartData: widget.bodyParts.firstWhere(
          (part) => (part['name'] as String).toLowerCase().contains('arm'),
          orElse: () => _getDefaultBodyPart('Left Arm'),
        ),
      ),
      // Right arm region
      _buildInteractiveRegion(
        top: 26.h,
        left: 63.w,
        width: 12.w,
        height: 25.h,
        bodyPartName: 'Right Arm',
        bodyPartData: widget.bodyParts.firstWhere(
          (part) => (part['name'] as String).toLowerCase().contains('arm'),
          orElse: () => _getDefaultBodyPart('Right Arm'),
        ),
      ),
      // Left leg region
      _buildInteractiveRegion(
        top: 51.h,
        left: 38.w,
        width: 10.w,
        height: 18.h,
        bodyPartName: 'Left Leg',
        bodyPartData: widget.bodyParts.firstWhere(
          (part) => (part['name'] as String).toLowerCase().contains('leg'),
          orElse: () => _getDefaultBodyPart('Left Leg'),
        ),
      ),
      // Right leg region
      _buildInteractiveRegion(
        top: 51.h,
        left: 52.w,
        width: 10.w,
        height: 18.h,
        bodyPartName: 'Right Leg',
        bodyPartData: widget.bodyParts.firstWhere(
          (part) => (part['name'] as String).toLowerCase().contains('leg'),
          orElse: () => _getDefaultBodyPart('Right Leg'),
        ),
      ),
    ];
  }

  Widget _buildInteractiveRegion({
    required double top,
    required double left,
    required double width,
    required double height,
    required String bodyPartName,
    required Map<String, dynamic> bodyPartData,
  }) {
    final isHovered = _hoveredBodyPart == bodyPartName;

    return Positioned(
      top: top,
      left: left,
      child: GestureDetector(
        onTap: () => widget.onBodyPartTap(bodyPartData),
        child: MouseRegion(
          onEnter: (_) => setState(() => _hoveredBodyPart = bodyPartName),
          onExit: (_) => setState(() => _hoveredBodyPart = null),
          child: AnimatedContainer(
            duration: Duration(milliseconds: 200),
            width: width,
            height: height,
            decoration: BoxDecoration(
              color: isHovered
                  ? AppTheme.lightTheme.primaryColor.withValues(alpha: 0.3)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(8),
              border: isHovered
                  ? Border.all(
                      color: AppTheme.lightTheme.primaryColor,
                      width: 2,
                    )
                  : null,
            ),
            child: isHovered
                ? Center(
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 2.w, vertical: 0.5.h),
                      decoration: BoxDecoration(
                        color: AppTheme.lightTheme.primaryColor,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        bodyPartName,
                        style:
                            AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  )
                : null,
          ),
        ),
      ),
    );
  }

  Widget _buildZoomControls() {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            onPressed: _zoomIn,
            icon: CustomIconWidget(
              iconName: 'zoom_in',
              color: AppTheme.lightTheme.primaryColor,
              size: 24,
            ),
            style: IconButton.styleFrom(
              backgroundColor:
                  AppTheme.lightTheme.primaryColor.withValues(alpha: 0.1),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
              ),
            ),
          ),
          Container(
            width: 1,
            height: 1,
            color:
                AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.2),
          ),
          IconButton(
            onPressed: _zoomOut,
            icon: CustomIconWidget(
              iconName: 'zoom_out',
              color: AppTheme.lightTheme.primaryColor,
              size: 24,
            ),
            style: IconButton.styleFrom(
              backgroundColor:
                  AppTheme.lightTheme.primaryColor.withValues(alpha: 0.1),
              shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.vertical(bottom: Radius.circular(12)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResetButton() {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: IconButton(
        onPressed: _resetView,
        icon: CustomIconWidget(
          iconName: 'center_focus_strong',
          color: AppTheme.lightTheme.primaryColor,
          size: 24,
        ),
        style: IconButton.styleFrom(
          backgroundColor:
              AppTheme.lightTheme.primaryColor.withValues(alpha: 0.1),
        ),
      ),
    );
  }

  Widget _buildHoverTooltip() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.inverseSurface,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Text(
        'Tap $_hoveredBodyPart to explore',
        style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
          color: AppTheme.lightTheme.colorScheme.onInverseSurface,
        ),
      ),
    );
  }

  void _zoomIn() {
    final currentScale = _transformationController.value.getMaxScaleOnAxis();
    if (currentScale < 3.0) {
      _transformationController.value = Matrix4.identity()
        ..scale(currentScale * 1.2);
    }
  }

  void _zoomOut() {
    final currentScale = _transformationController.value.getMaxScaleOnAxis();
    if (currentScale > 0.5) {
      _transformationController.value = Matrix4.identity()
        ..scale(currentScale * 0.8);
    }
  }

  void _resetView() {
    _transformationController.value = Matrix4.identity();
  }

  Map<String, dynamic> _getDefaultBodyPart(String name) {
    return {
      'id': name.toLowerCase().replaceAll(' ', '_'),
      'name': name,
      'nameTamil': _getTamilName(name),
      'description':
          'Detailed information about $name and its functions in traditional medicine.',
      'image':
          'https://images.unsplash.com/photo-1559757148-5c350d0d3c56?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3',
      'diseaseCount': 5,
      'medicineCount': 8,
      'commonConditions': ['General pain', 'Inflammation', 'Stiffness'],
    };
  }

  String _getTamilName(String englishName) {
    switch (englishName.toLowerCase()) {
      case 'head':
        return 'தலை';
      case 'neck':
        return 'கழுத்து';
      case 'chest':
        return 'மார்பு';
      case 'abdomen':
        return 'வயிறு';
      case 'left arm':
      case 'right arm':
        return 'கை';
      case 'left leg':
      case 'right leg':
        return 'கால்';
      default:
        return englishName;
    }
  }
}
