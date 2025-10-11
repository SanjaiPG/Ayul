import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../../../../core/app_export.dart';
// Assuming AppRoutes is located here based on common structure
import '../../../routes/app_routes.dart';
// The actual screen import is not strictly necessary here since we use named routes,
// but included for completeness if using MaterialPageRoute in future.
// import '../../medicine_detail_screen/medicine_detail_screen.dart';

class DiseaseQuestionnaireWidget extends StatefulWidget {
  final String currentLanguage;
  final Function(Map<String, dynamic>) onMedicineIdentified;

  const DiseaseQuestionnaireWidget({
    Key? key,
    required this.currentLanguage,
    required this.onMedicineIdentified,
  }) : super(key: key);

  @override
  _DiseaseQuestionnaireWidgetState createState() =>
      _DiseaseQuestionnaireWidgetState();
}

class _DiseaseQuestionnaireWidgetState
    extends State<DiseaseQuestionnaireWidget> {
  int _currentQuestionIndex = 0;
  List<int?> _answers = List.filled(10, null);

  // Sample questions
  final List<Map<String, dynamic>> _questions = [
    {
      'question_en': 'Do you experience frequent headaches?',
      'question_ta': 'நீங்கள் அடிக்கடி தலைவலி அனுபவிக்கிறீர்களா?',
      'options_en': ['Never', 'Rarely', 'Sometimes', 'Often', 'Always'],
      'options_ta': [
        'ஒருபோதும்',
        'அரிதாக',
        'சில நேரங்களில்',
        'அடிக்கடி',
        'எப்போதும்'
      ],
    },
    {
      'question_en': 'How is your appetite?',
      'question_ta': 'உங்கள் பசி எப்படி இருக்கிறது?',
      'options_en': ['Very poor', 'Poor', 'Normal', 'Good', 'Very good'],
      'options_ta': ['மிக மோசமான', 'மோசமான', 'சாதாரண', 'நல்ல', 'மிக நல்ல'],
    },
    {
      'question_en': 'Do you have difficulty sleeping?',
      'question_ta': 'உங்களுக்கு தூக்கம் வருவதில் சிரமம் உள்ளதா?',
      'options_en': ['Never', 'Rarely', 'Sometimes', 'Often', 'Always'],
      'options_ta': [
        'ஒருபோதும்',
        'அரிதாக',
        'சில நேரங்களில்',
        'அடிக்கடி',
        'எப்போதும்'
      ],
    },
    {
      'question_en': 'How often do you feel tired or fatigued?',
      'question_ta': 'எத்தனை முறை சோர்வாக அல்லது களைப்பாக உணர்கிறீர்கள்?',
      'options_en': ['Never', 'Rarely', 'Sometimes', 'Often', 'Always'],
      'options_ta': [
        'ஒருபோதும்',
        'அரிதாக',
        'சில நேரங்களில்',
        'அடிக்கடி',
        'எப்போதும்'
      ],
    },
    {
      'question_en': 'Do you experience joint pain?',
      'question_ta': 'நீங்கள் மூட்டு வலி அனுபவிக்கிறீர்களா?',
      'options_en': ['Never', 'Rarely', 'Sometimes', 'Often', 'Always'],
      'options_ta': [
        'ஒருபோதும்',
        'அரிதாக',
        'சில நேரங்களில்',
        'அடிக்கடி',
        'எப்போதும்'
      ],
    },
    {
      'question_en': 'How is your digestion?',
      'question_ta': 'உங்கள் செரிமானம் எப்படி இருக்கிறது?',
      'options_en': ['Very poor', 'Poor', 'Normal', 'Good', 'Very good'],
      'options_ta': ['மிக மோசமான', 'மோசமான', 'சாதாரண', 'நல்ல', 'மிக நல்ல'],
    },
    {
      'question_en': 'Do you experience mood swings?',
      'question_ta': 'நீங்கள் மன அமைப்பில் மாற்றங்கள் அனுபவிக்கிறீர்களா?',
      'options_en': ['Never', 'Rarely', 'Sometimes', 'Often', 'Always'],
      'options_ta': [
        'ஒருபோதும்',
        'அரிதாக',
        'சில நேரங்களில்',
        'அடிக்கடி',
        'எப்போதும்'
      ],
    },
    {
      'question_en': 'How is your stress level?',
      'question_ta': 'உங்கள் மன அழுத்த நிலை எப்படி இருக்கிறது?',
      'options_en': ['Very low', 'Low', 'Moderate', 'High', 'Very high'],
      'options_ta': ['மிக குறைந்த', 'குறைந்த', 'மிதமான', 'அதிக', 'மிக அதிக'],
    },
    {
      'question_en': 'Do you have skin problems?',
      'question_ta': 'உங்களுக்கு தோல் பிரச்சினைகள் உள்ளனவா?',
      'options_en': ['Never', 'Rarely', 'Sometimes', 'Often', 'Always'],
      'options_ta': [
        'ஒருபோதும்',
        'அரிதாக',
        'சில நேரங்களில்',
        'அடிக்கடி',
        'எப்போதும்'
      ],
    },
    {
      'question_en': 'How would you describe your overall health?',
      'question_ta': 'உங்கள் ஒட்டுமொத்த ஆரோக்கியத்தை எவ்வாறு விவரிப்பீர்கள்?',
      'options_en': ['Very poor', 'Poor', 'Fair', 'Good', 'Excellent'],
      'options_ta': ['மிக மோசமான', 'மோசமான', 'நல்லது அல்ல', 'நல்ல', 'சிறந்த'],
    },
  ];

  void _answerQuestion(int answerIndex) {
    setState(() {
      _answers[_currentQuestionIndex] = answerIndex;
    });

    if (_currentQuestionIndex < _questions.length - 1) {
      setState(() {
        _currentQuestionIndex++;
      });
    } else {
      // All questions answered, show results
      _showResults();
    }
  }

  void _goToPreviousQuestion() {
    if (_currentQuestionIndex > 0) {
      setState(() {
        _currentQuestionIndex--;
      });
    }
  }

  void _showResults() {
    // Simple algorithm to determine a condition based on answers
    // This is a mock implementation - in a real app, this would be more sophisticated
    int totalScore = _answers.fold(0, (sum, answer) => sum + (answer ?? 0));

    Map<String, dynamic> recommendedMedicine;

    if (totalScore < 15) {
      recommendedMedicine = {
        "id": 1,
        "title": "Tulsi",
        "subtitle": "Holy Basil - Natural immunity booster",
        "type": "medicine",
        "image":
            "https://images.pexels.com/photos/4198015/pexels-photo-4198015.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
        "description":
            "Tulsi, also known as Holy Basil, is a sacred plant in Hinduism and is widely used in Ayurvedic medicine. It is known for its adaptogenic properties, helping the body cope with stress, and is a powerful immunity booster.",
        "properties": {
          "Taste": "Bitter, pungent",
          "Energy": "Heating",
          "Post-Digestive Effect": "Pungent",
          "Dosha": "Balances Kapha and Vata, may increase Pitta in excess"
        },
        "scientificName": "Ocimum tenuiflorum",
        "family": "Lamiaceae",
        "parts_used": "Leaves, seeds, whole plant",
        "dosage": {
          "adult": "500-1000 mg twice daily",
          "children": "250-500 mg twice daily (for children above 5 years)"
        },
        "preparation": [
          "Fresh leaves can be chewed daily",
          "Dried powder can be taken with honey or water",
          "Can be brewed as tea with ginger and honey"
        ],
        "bestTime": "Morning on empty stomach",
        "duration": "Can be taken continuously",
        "takeWith": "Water or honey",
        "storage": "Store in airtight container in cool, dry place",
        "contraindications":
            "Not recommended for people with excessive Pitta conditions",
        "sideEffects": "Generally safe, may cause dryness in excess",
        "relatedDiseases": [
          {
            "id": 201,
            "name": "Common Cold",
            "tamilName": "சளி",
            "description":
                "Respiratory infection causing runny nose, cough, and fever"
          },
          {
            "id": 202,
            "name": "Stress",
            "tamilName": "மன அழுத்தம்",
            "description":
                "Physical or emotional tension affecting overall health"
          }
        ]
      };
    } else if (totalScore < 25) {
      recommendedMedicine = {
        "id": 2,
        "title": "Ashwagandha",
        "subtitle": "Winter Cherry - Stress reliever and vitality booster",
        "type": "medicine",
        "image":
            "https://images.unsplash.com/photo-1599837565318-67429bdde3c5?auto=format&fit=crop&q=80",
        "description":
            "Ashwagandha is a powerful adaptogen that helps the body manage stress. It is known for its rejuvenating properties and is often used to improve vitality, stamina, and overall well-being.",
        "properties": {
          "Taste": "Bitter, astringent",
          "Energy": "Heating",
          "Post-Digestive Effect": "Sweet",
          "Dosha": "Balances Vata and Kapha, may increase Pitta in excess"
        },
        "scientificName": "Withania somnifera",
        "family": "Solanaceae",
        "parts_used": "Roots, leaves",
        "dosage": {
          "adult": "300-500 mg twice daily",
          "children": "Not recommended for children under 12"
        },
        "preparation": [
          "Powder can be taken with milk or ghee",
          "Can be consumed as capsules or tablets",
          "Often prepared as a decoction with other herbs"
        ],
        "bestTime": "Morning and evening with meals",
        "duration": "Can be taken for 3-6 months continuously",
        "takeWith": "Milk, ghee, or water",
        "storage": "Store in airtight container away from moisture",
        "contraindications":
            "Not recommended during pregnancy or for people with excessive Pitta",
        "sideEffects": "May cause drowsiness in some individuals",
        "relatedDiseases": [
          {
            "id": 203,
            "name": "Anxiety",
            "tamilName": "கவலை",
            "description":
                "Excessive worry and nervousness affecting daily life"
          },
          {
            "id": 204,
            "name": "Fatigue",
            "tamilName": "சோர்வு",
            "description": "Persistent tiredness and lack of energy"
          }
        ]
      };
    } else if (totalScore < 35) {
      recommendedMedicine = {
        "id": 3,
        "title": "Turmeric",
        "subtitle": "Golden Spice - Anti-inflammatory and antioxidant",
        "type": "medicine",
        "image":
            "https://images.unsplash.com/photo-1558618666-fcd25c85cd64?auto=format&fit=crop&q=80",
        "description":
            "Turmeric is a bright yellow spice known for its powerful anti-inflammatory and antioxidant properties. It contains curcumin, which has been extensively studied for its health benefits.",
        "properties": {
          "Taste": "Bitter, pungent",
          "Energy": "Heating",
          "Post-Digestive Effect": "Pungent",
          "Dosha": "Balances Kapha, may increase Pitta in excess"
        },
        "scientificName": "Curcuma longa",
        "family": "Zingiberaceae",
        "parts_used": "Rhizome",
        "dosage": {
          "adult": "500-1000 mg twice daily",
          "children": "250-500 mg twice daily (for children above 5 years)"
        },
        "preparation": [
          "Powder can be mixed with warm milk (golden milk)",
          "Can be added to food during cooking",
          "Often taken with black pepper to enhance absorption"
        ],
        "bestTime": "With meals",
        "duration": "Can be taken continuously",
        "takeWith": "Milk, water, or with food",
        "storage": "Store in airtight container away from light",
        "contraindications": "Not recommended for people with gallstones",
        "sideEffects": "May cause stomach upset in some individuals",
        "relatedDiseases": [
          {
            "id": 205,
            "name": "Arthritis",
            "tamilName": "கீல்வாதம்",
            "description": "Joint inflammation causing pain and stiffness"
          },
          {
            "id": 206,
            "name": "Digestive Issues",
            "tamilName": "செரிமான பிரச்சினைகள்",
            "description":
                "Problems with digestion including bloating and discomfort"
          }
        ]
      };
    } else {
      recommendedMedicine = {
        "id": 4,
        "title": "Neem",
        "subtitle": "Indian Lilac - Blood purifier and skin health",
        "type": "medicine",
        "image":
            "https://images.pexels.com/photos/6627946/pexels-photo-6627946.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
        "description":
            "Neem is known for its powerful blood-purifying properties and is widely used for skin conditions. It has antibacterial, antiviral, and antifungal properties that make it effective for various health issues.",
        "properties": {
          "Taste": "Bitter",
          "Energy": "Cooling",
          "Post-Digestive Effect": "Pungent",
          "Dosha": "Balances Pitta and Kapha, may increase Vata in excess"
        },
        "scientificName": "Azadirachta indica",
        "family": "Meliaceae",
        "parts_used": "Leaves, bark, seeds, oil",
        "dosage": {
          "adult": "500-1000 mg twice daily",
          "children": "250-500 mg twice daily (for children above 5 years)"
        },
        "preparation": [
          "Leaves can be consumed as juice or powder",
          "Oil can be applied topically for skin conditions",
          "Can be taken as capsules or tablets"
        ],
        "bestTime": "Morning on empty stomach",
        "duration": "Can be taken for 2-3 months continuously",
        "takeWith": "Water or honey",
        "storage": "Store in airtight container in cool, dry place",
        "contraindications":
            "Not recommended during pregnancy or for people with excessive Vata",
        "sideEffects": "May cause dryness and constipation in excess",
        "relatedDiseases": [
          {
            "id": 207,
            "name": "Skin Disorders",
            "tamilName": "தோல் நோய்கள்",
            "description":
                "Various conditions affecting the skin including acne and eczema"
          },
          {
            "id": 208,
            "name": "Diabetes",
            "tamilName": "மதுமேகம்",
            "description":
                "Metabolic disorder characterized by high blood sugar levels"
          }
        ]
      };
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            widget.currentLanguage == 'EN'
                ? 'Assessment Results'
                : 'மதிப்பீட்டு முடிவுகள்',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: AppTheme.lightTheme.primaryColor,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.currentLanguage == 'EN'
                    ? 'Recommended Medicine:'
                    : 'பரிந்துரைக்கப்பட்ட மருந்து:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 8),
              Text(recommendedMedicine['title']),
              SizedBox(height: 8),
              Text(
                recommendedMedicine['subtitle'],
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              ),
              SizedBox(height: 16),
              Text(
                widget.currentLanguage == 'EN'
                    ? 'Based on your responses, we recommend this traditional medicine. Always consult with a practitioner before use.'
                    : 'உங்கள் பதில்களின் அடிப்படையில், இந்த பாரம்பரிய மருந்தை பரிந்துரைக்கிறோம். பயன்படுத்துவதற்கு முன் எப்போதும் ஒரு வைத்தியரைக் கலந்தாலோசிக்கவும்.',
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                // Reset questionnaire
                setState(() {
                  _currentQuestionIndex = 0;
                  _answers = List.filled(10, null);
                });
              },
              child: Text(widget.currentLanguage == 'EN'
                  ? 'Restart'
                  : 'மீண்டும் தொடங்க'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog

                // *** FIX APPLIED: Using the correct route name from AppRoutes ***
                Navigator.pushNamed(
                  context,
                  AppRoutes.medicineListing, // Correct route name
                  arguments: recommendedMedicine,
                );

                // The original logic using the callback is replaced by direct navigation.
                // If the parent widget still needs the data, uncomment the line below.
                // widget.onMedicineIdentified(recommendedMedicine);
              },
              child: Text(widget.currentLanguage == 'EN'
                  ? 'Learn More'
                  : 'மேலும் அறிக'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.lightTheme.primaryColor,
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.currentLanguage == 'EN'
                ? 'Health Assessment'
                : 'ஆரோக்கிய மதிப்பீடு',
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.w600,
              color: AppTheme.lightTheme.colorScheme.onSurface,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            widget.currentLanguage == 'EN'
                ? 'Answer a few questions about your health condition'
                : 'உங்கள் ஆரோக்கிய நிலை பற்றி சில கேள்விகளுக்கு பதிலளிக்கவும்',
            style: TextStyle(
              fontSize: 14.sp,
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
          ),
          SizedBox(height: 2.h),
          LinearProgressIndicator(
            value: (_currentQuestionIndex + 1) / _questions.length,
            backgroundColor: AppTheme.lightTheme.colorScheme.surfaceVariant,
            color: AppTheme.lightTheme.primaryColor,
          ),
          SizedBox(height: 2.h),
          Text(
            '${_currentQuestionIndex + 1}/${_questions.length}',
            style: TextStyle(
              fontSize: 12.sp,
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
          ),
          SizedBox(height: 3.h),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.currentLanguage == 'EN'
                      ? _questions[_currentQuestionIndex]['question_en']
                      : _questions[_currentQuestionIndex]['question_ta'],
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                    color: AppTheme.lightTheme.colorScheme.onSurface,
                  ),
                ),
                SizedBox(height: 3.h),
                Expanded(
                  child: ListView.builder(
                    itemCount: widget.currentLanguage == 'EN'
                        ? _questions[_currentQuestionIndex]['options_en'].length
                        : _questions[_currentQuestionIndex]['options_ta']
                            .length,
                    itemBuilder: (context, index) {
                      return Card(
                        margin: EdgeInsets.only(bottom: 2.h),
                        child: ListTile(
                          title: Text(
                            widget.currentLanguage == 'EN'
                                ? _questions[_currentQuestionIndex]
                                    ['options_en'][index]
                                : _questions[_currentQuestionIndex]
                                    ['options_ta'][index],
                            style: TextStyle(fontSize: 14.sp),
                          ),
                          trailing: _answers[_currentQuestionIndex] == index
                              ? Icon(Icons.check_circle,
                                  color: AppTheme.lightTheme.primaryColor)
                              : null,
                          onTap: () => _answerQuestion(index),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          if (_currentQuestionIndex > 0)
            ElevatedButton(
              onPressed: _goToPreviousQuestion,
              child:
                  Text(widget.currentLanguage == 'EN' ? 'Previous' : 'முந்தைய'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.lightTheme.colorScheme.surfaceVariant,
                foregroundColor:
                    AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                minimumSize: Size(double.infinity, 6.h),
              ),
            ),
        ],
      ),
    );
  }
}
