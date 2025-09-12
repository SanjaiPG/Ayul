import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class MedicineImageGalleryWidget extends StatefulWidget {
  final List<String> imageUrls;
  final String medicineName;

  const MedicineImageGalleryWidget({
    Key? key,
    required this.imageUrls,
    required this.medicineName,
  }) : super(key: key);

  @override
  State<MedicineImageGalleryWidget> createState() =>
      _MedicineImageGalleryWidgetState();
}

class _MedicineImageGalleryWidgetState
    extends State<MedicineImageGalleryWidget> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40.h, // Slightly increased height for better visual
      width: double.infinity,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Image Gallery
          PageView.builder(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            itemCount: widget.imageUrls.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () => _showFullScreenImage(context, index),
                child: Hero(
                  tag: 'medicine_image_${widget.medicineName}_$index',
                  child: CustomImageWidget(
                    imageUrl: widget.imageUrls[index],
                    width: double.infinity,
                    height: 40.h,
                    fit: BoxFit.cover,
                  ),
                ),
              );
            },
          ),
          // Gradient Overlay
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 15.h,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Colors.black.withOpacity(0.5),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          // Page Indicators
          if (widget.imageUrls.length > 1)
            Positioned(
              bottom: 2.h,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  widget.imageUrls.length,
                  (index) => AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeOutCubic,
                    margin: EdgeInsets.symmetric(horizontal: 1.w),
                    width: _currentIndex == index ? 4.w : 2.w,
                    height: 2.w,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: _currentIndex == index
                          ? Colors.white
                          : Colors.white.withOpacity(0.5),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  void _showFullScreenImage(BuildContext context, int initialIndex) {
    // Full screen viewer remains the same
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => _FullScreenImageViewer(
          imageUrls: widget.imageUrls,
          initialIndex: initialIndex,
          medicineName: widget.medicineName,
        ),
      ),
    );
  }
}

class _FullScreenImageViewer extends StatefulWidget {
  final List<String> imageUrls;
  final int initialIndex;
  final String medicineName;

  const _FullScreenImageViewer({
    Key? key,
    required this.imageUrls,
    required this.initialIndex,
    required this.medicineName,
  }) : super(key: key);

  @override
  State<_FullScreenImageViewer> createState() => _FullScreenImageViewerState();
}

class _FullScreenImageViewerState extends State<_FullScreenImageViewer> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
  /* ... */
}
