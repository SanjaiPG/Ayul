import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class EducationalTipsWidget extends StatelessWidget {
  final String currentLanguage;

  const EducationalTipsWidget({
    Key? key,
    required this.currentLanguage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final tips = _getTips();

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
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
                iconName: 'lightbulb',
                color: AppTheme.lightTheme.colorScheme.tertiary,
                size: 24,
              ),
              SizedBox(width: 2.w),
              Text(
                currentLanguage == 'EN' ? 'Did You Know?' : 'தெரியுமா?',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.lightTheme.colorScheme.onSurface,
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          ...tips
              .map((tip) => Padding(
                    padding: EdgeInsets.only(bottom: 2.h),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 6,
                          height: 6,
                          margin: EdgeInsets.only(top: 1.h, right: 3.w),
                          decoration: BoxDecoration(
                            color: AppTheme.lightTheme.primaryColor,
                            shape: BoxShape.circle,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            tip,
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w400,
                              color: AppTheme
                                  .lightTheme.colorScheme.onSurfaceVariant,
                              height: 1.4,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ))
              .toList(),
        ],
      ),
    );
  }

  List<String> _getTips() {
    if (currentLanguage == 'EN') {
      return [
        'Siddha medicine is one of the oldest medical systems in the world, originating in Tamil Nadu.',
        'Acupuncture involves inserting thin needles into specific points on the body to promote healing.',
        'Traditional medicine focuses on treating the root cause rather than just symptoms.',
        'Many modern medicines have their origins in traditional herbal remedies.',
      ];
    } else {
      return [
        'சித்த மருத்துவம் உலகின் மிகப் பழமையான மருத்துவ முறைகளில் ஒன்றாகும்.',
        'குத்தூசி மருத்துவம் உடலின் குறிப்பிட்ட புள்ளிகளில் மெல்லிய ஊசிகளை செலுத்தும் சிகிச்சை முறையாகும்.',
        'பாரம்பரிய மருத்துவம் அறிகுறிகளை மட்டும் அல்லாமல் நோயின் மூல காரணத்தை குணப்படுத்துகிறது.',
        'பல நவீன மருந்துகள் பாரம்பரிய மூலிகை மருந்துகளில் இருந்து உருவாக்கப்பட்டவை.',
      ];
    }
  }
}
