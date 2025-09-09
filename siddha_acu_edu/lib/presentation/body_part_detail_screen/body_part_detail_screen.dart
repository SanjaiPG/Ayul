import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/anatomy_tab_widget.dart';
import './widgets/body_part_header_widget.dart';
import './widgets/common_conditions_tab_widget.dart';
import './widgets/traditional_perspective_tab_widget.dart';
import './widgets/treatments_tab_widget.dart';

class BodyPartDetailScreen extends StatefulWidget {
  const BodyPartDetailScreen({Key? key}) : super(key: key);

  @override
  State<BodyPartDetailScreen> createState() => _BodyPartDetailScreenState();
}

class _BodyPartDetailScreenState extends State<BodyPartDetailScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  bool _isEnglish = true;

  // Mock data for body part details
  final Map<String, dynamic> _bodyPartData = {
    "id": 1,
    "name": {"english": "Heart", "tamil": "இதயம்"},
    "category": {
      "english": "Cardiovascular System",
      "tamil": "இதய ரத்த ஓட்ட அமைப்பு"
    },
    "shortDescription": {
      "english":
          "The heart is a muscular organ that pumps blood throughout the body, supplying oxygen and nutrients to tissues.",
      "tamil":
          "இதயம் ஒரு தசை உறுப்பு ஆகும், இது உடல் முழுவதும் இரத்தத்தை செலுத்தி, திசுக்களுக்கு ஆக்ஸிஜன் மற்றும் ஊட்டச்சத்துக்களை வழங்குகிறது."
    },
    "thumbnailImage":
        "https://images.unsplash.com/photo-1559757148-5c350d0d3c56?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
    "anatomyImage":
        "https://images.unsplash.com/photo-1559757175-0eb30cd8c063?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
    "structure": {
      "english":
          "The heart consists of four chambers: two atria (upper chambers) and two ventricles (lower chambers). The heart wall is made up of three layers: the epicardium (outer layer), myocardium (middle muscular layer), and endocardium (inner layer). The heart is surrounded by a protective sac called the pericardium.",
      "tamil":
          "இதயம் நான்கு அறைகளைக் கொண்டுள்ளது: இரண்டு ஏட்ரியா (மேல் அறைகள்) மற்றும் இரண்டு வென்ட்ரிக்கிள்கள் (கீழ் அறைகள்). இதய சுவர் மூன்று அடுக்குகளால் ஆனது: எபிகார்டியம் (வெளிப்புற அடுக்கு), மயோகார்டியம் (நடுத்தர தசை அடுக்கு), மற்றும் எண்டோகார்டியம் (உள் அடுக்கு)."
    },
    "functions": [
      {
        "english": "Pumps oxygenated blood to all body tissues",
        "tamil":
            "அனைத்து உடல் திசுக்களுக்கும் ஆக்ஸிஜன் நிறைந்த இரத்தத்தை செலுத்துகிறது"
      },
      {
        "english": "Returns deoxygenated blood to the lungs for oxygenation",
        "tamil": "ஆக்ஸிஜன் இல்லாத இரத்தத்தை நுரையீரலுக்கு திருப்பி அனுப்புகிறது"
      },
      {
        "english": "Maintains blood pressure and circulation",
        "tamil": "இரத்த அழுத்தம் மற்றும் ரத்த ஓட்டத்தை பராமரிக்கிறது"
      },
      {
        "english": "Regulates heart rate based on body's needs",
        "tamil":
            "உடலின் தேவைகளின் அடிப்படையில் இதய துடிப்பை ஒழுங்குபடுத்துகிறது"
      }
    ],
    "relatedSystems": [
      {"english": "Respiratory System", "tamil": "சுவாச அமைப்பு"},
      {"english": "Circulatory System", "tamil": "ரத்த ஓட்ட அமைப்பு"},
      {"english": "Nervous System", "tamil": "நரம்பு மண்டலம்"},
      {"english": "Endocrine System", "tamil": "நாளமில்லா சுரப்பி அமைப்பு"}
    ],
    "commonConditions": [
      {
        "id": 1,
        "name": {
          "english": "Coronary Artery Disease",
          "tamil": "கரோனரி தமனி நோய்"
        },
        "description": {
          "english":
              "A condition where the coronary arteries become narrowed or blocked, reducing blood flow to the heart muscle.",
          "tamil":
              "கரோனரி தமனிகள் குறுகி அல்லது அடைக்கப்பட்டு, இதய தசைக்கு இரத்த ஓட்டம் குறையும் நிலை."
        },
        "severity": "severe",
        "symptoms": [
          {"english": "Chest pain", "tamil": "மார்பு வலி"},
          {"english": "Shortness of breath", "tamil": "மூச்சுத் திணறல்"},
          {"english": "Fatigue", "tamil": "களைப்பு"}
        ]
      },
      {
        "id": 2,
        "name": {"english": "Hypertension", "tamil": "உயர் இரத்த அழுத்தம்"},
        "description": {
          "english":
              "High blood pressure that puts extra strain on the heart and blood vessels.",
          "tamil":
              "இதயம் மற்றும் இரத்த நாளங்களில் கூடுதல் அழுத்தம் ஏற்படுத்தும் உயர் இரத்த அழுத்தம்."
        },
        "severity": "moderate",
        "symptoms": [
          {"english": "Headaches", "tamil": "தலைவலி"},
          {"english": "Dizziness", "tamil": "தலைசுற்றல்"},
          {"english": "Nosebleeds", "tamil": "மூக்கில் இரத்தம்"}
        ]
      },
      {
        "id": 3,
        "name": {"english": "Arrhythmia", "tamil": "இதய துடிப்பு கோளாறு"},
        "description": {
          "english":
              "Irregular heartbeat patterns that can affect the heart's ability to pump blood effectively.",
          "tamil":
              "இதயத்தின் இரத்தத்தை திறம்பட செலுத்தும் திறனை பாதிக்கும் ஒழுங்கற்ற இதய துடிப்பு முறைகள்."
        },
        "severity": "mild",
        "symptoms": [
          {"english": "Palpitations", "tamil": "இதய படபடப்பு"},
          {"english": "Chest flutter", "tamil": "மார்பு படபடப்பு"},
          {"english": "Weakness", "tamil": "பலவீனம்"}
        ]
      }
    ],
    "treatments": [
      {
        "id": 1,
        "name": {
          "english": "Arjuna Bark Extract",
          "tamil": "அர்ஜுன மரப்பட்டை சாறு"
        },
        "type": "Herbal Medicine",
        "description": {
          "english":
              "A powerful cardiotonic herb that strengthens heart muscles and improves cardiac function.",
          "tamil":
              "இதய தசைகளை வலுப்படுத்தி இதய செயல்பாட்டை மேம்படுத்தும் சக்திவாய்ந்த இதய வலுவூட்டி மூலிகை."
        },
        "usage": {
          "english":
              "Take 500mg twice daily with warm water after meals. Continue for 3 months under medical supervision.",
          "tamil":
              "உணவுக்குப் பிறகு வெதுவெதுப்பான நீருடன் 500mg இரண்டு முறை எடுத்துக் கொள்ளவும். மருத்துவ கண்காணிப்பில் 3 மாதங்கள் தொடரவும்."
        },
        "effectiveness": 4,
        "treatsConditions": [
          {"english": "Heart weakness", "tamil": "இதய பலவீனம்"},
          {"english": "High blood pressure", "tamil": "உயர் இரத்த அழுத்தம்"},
          {"english": "Chest pain", "tamil": "மார்பு வலி"}
        ]
      },
      {
        "id": 2,
        "name": {"english": "Pushkarmool Churna", "tamil": "புஷ்கர மூல சூரணம்"},
        "type": "Powder Medicine",
        "description": {
          "english":
              "A traditional Siddha formulation that supports respiratory and cardiovascular health.",
          "tamil":
              "சுவாச மற்றும் இதய ஆரோக்கியத்தை ஆதரிக்கும் பாரம்பரிய சித்த மருந்து கலவை."
        },
        "usage": {
          "english":
              "Mix 1 teaspoon with honey and take twice daily before meals.",
          "tamil":
              "1 தேக்கரண்டியை தேனுடன் கலந்து உணவுக்கு முன் இரண்டு முறை எடுத்துக் கொள்ளவும்."
        },
        "effectiveness": 3,
        "treatsConditions": [
          {"english": "Breathing difficulties", "tamil": "சுவாச கஷ்டம்"},
          {"english": "Heart palpitations", "tamil": "இதய படபடப்பு"},
          {"english": "Anxiety", "tamil": "பதட்டம்"}
        ]
      }
    ],
    "traditionalPerspective": {
      "energyFlow": {
        "english":
            "In traditional medicine, the heart is considered the seat of consciousness and emotions. Energy flows through specific channels called nadis, with the heart chakra (Anahata) being central to emotional and physical well-being.",
        "tamil":
            "பாரம்பரிய மருத்துவத்தில், இதயம் உணர்வு மற்றும் உணர்ச்சிகளின் இருப்பிடமாக கருதப்படுகிறது. நாடிகள் எனப்படும் குறிப்பிட்ட வழிகள் வழியாக ஆற்றல் பாய்கிறது."
      },
      "diagnosticMethods": {
        "english":
            "Traditional diagnosis involves pulse examination (Nadi Pariksha), observation of tongue, eyes, and complexion, along with assessment of emotional state and sleep patterns.",
        "tamil":
            "பாரம்பரிய நோய் கண்டறிதலில் நாடி பரிசோதனை, நாக்கு, கண்கள் மற்றும் நிறத்தை கவனித்தல், உணர்ச்சி நிலை மற்றும் தூக்க முறைகளை மதிப்பீடு செய்தல் ஆகியவை அடங்கும்."
      },
      "pressurePoints": [
        {
          "code": "PC6",
          "name": {
            "english": "Neiguan (Inner Pass)",
            "tamil": "நெய்குவான் (உள் கடவு)"
          },
          "location": {
            "english": "2 finger widths above wrist crease, between tendons",
            "tamil":
                "மணிக்கட்டு மடிப்புக்கு மேல் 2 விரல் அகலம், தசைநாண்களுக்கு இடையில்"
          },
          "benefits": {
            "english":
                "Relieves chest pain, palpitations, and anxiety. Helps regulate heart rhythm.",
            "tamil":
                "மார்பு வலி, படபடப்பு மற்றும் பதட்டத்தை நீக்குகிறது. இதய துடிப்பை ஒழுங்குபடுத்த உதவுகிறது."
          }
        },
        {
          "code": "HE7",
          "name": {
            "english": "Shenmen (Spirit Gate)",
            "tamil": "ஷென்மென் (ஆத்ம வாயில்)"
          },
          "location": {
            "english": "Wrist crease, pinky side, in depression next to tendon",
            "tamil":
                "மணிக்கட்டு மடிப்பு, சிறுவிரல் பக்கம், தசைநாண் அருகே உள்ள குழியில்"
          },
          "benefits": {
            "english":
                "Calms the mind, reduces anxiety, and supports emotional balance.",
            "tamil":
                "மனதை அமைதிப்படுத்துகிறது, பதட்டத்தை குறைக்கிறது மற்றும் உணர்ச்சி சமநிலையை ஆதரிக்கிறது."
          }
        }
      ],
      "siddhaView": {
        "tridosha": {
          "english":
              "The heart is primarily governed by Pitta dosha (fire element) which controls circulation and metabolism. Imbalance in Vata affects heart rhythm, while Kapha imbalance can cause congestion.",
          "tamil":
              "இதயம் முக்கியமாக பித்த தோஷத்தால் (நெருப்பு உறுப்பு) நிர்வகிக்கப்படுகிறது, இது ரத்த ஓட்டம் மற்றும் வளர்சிதை மாற்றத்தை கட்டுப்படுத்துகிறது."
        },
        "treatmentApproach": {
          "english":
              "Siddha treatment focuses on balancing the three humors through specific herbal formulations, dietary modifications, and lifestyle practices including yoga and meditation.",
          "tamil":
              "சித்த சிகிச்சை குறிப்பிட்ட மூலிகை கலவைகள், உணவு மாற்றங்கள் மற்றும் யோகா மற்றும் தியானம் உள்ளிட்ட வாழ்க்கை முறை நடைமுறைகள் மூலம் மூன்று குணங்களை சமநிலைப்படுத்துவதில் கவனம் செலுத்துகிறது."
        }
      },
      "acupunctureView": {
        "meridianSystem": {
          "english":
              "The heart meridian runs from the heart to the little finger, connecting with lung and small intestine meridians. It governs blood circulation and emotional stability.",
          "tamil":
              "இதய நாடி இதயத்திலிருந்து சிறுவிரல் வரை ஓடுகிறது, நுரையீரல் மற்றும் சிறுகுடல் நாடிகளுடன் இணைக்கிறது."
        },
        "qiFlow": {
          "english":
              "Proper Qi flow through the heart meridian ensures emotional balance and physical vitality. Blockages can manifest as chest pain, insomnia, or emotional disturbances.",
          "tamil":
              "இதய நாடி வழியாக சரியான கி ஓட்டம் உணர்ச்சி சமநிலை மற்றும் உடல் வீரியத்தை உறுதி செய்கிறது."
        }
      }
    }
  };

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _toggleLanguage() {
    setState(() {
      _isEnglish = !_isEnglish;
    });
  }

  void _navigateToCondition(String conditionId) {
    Navigator.pushNamed(context, '/disease-listing-screen');
  }

  void _navigateToMedicine(String medicineId) {
    Navigator.pushNamed(context, '/medicine-detail-screen');
  }

  void _navigateToRelatedDiseases() {
    Navigator.pushNamed(context, '/disease-listing-screen');
  }

  void _navigateToStudySystem() {
    Navigator.pushNamed(context, '/body-parts-explorer-screen');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: Column(
        children: [
          BodyPartHeaderWidget(
            bodyPartData: _bodyPartData,
            isEnglish: _isEnglish,
            onLanguageToggle: _toggleLanguage,
          ),
          _buildTabBar(),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                AnatomyTabWidget(
                  bodyPartData: _bodyPartData,
                  isEnglish: _isEnglish,
                ),
                CommonConditionsTabWidget(
                  bodyPartData: _bodyPartData,
                  isEnglish: _isEnglish,
                  onConditionTap: _navigateToCondition,
                ),
                TreatmentsTabWidget(
                  bodyPartData: _bodyPartData,
                  isEnglish: _isEnglish,
                  onMedicineTap: _navigateToMedicine,
                ),
                TraditionalPerspectiveTabWidget(
                  bodyPartData: _bodyPartData,
                  isEnglish: _isEnglish,
                ),
              ],
            ),
          ),
          _buildBottomActionButtons(),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      color: AppTheme.lightTheme.colorScheme.surface,
      child: TabBar(
        controller: _tabController,
        isScrollable: true,
        tabAlignment: TabAlignment.start,
        labelColor: AppTheme.lightTheme.colorScheme.primary,
        unselectedLabelColor: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
        indicatorColor: AppTheme.lightTheme.colorScheme.primary,
        indicatorWeight: 3,
        labelStyle: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle:
            AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
          fontWeight: FontWeight.w400,
        ),
        tabs: [
          Tab(
            text: _isEnglish ? "Anatomy" : "உடலியல்",
          ),
          Tab(
            text: _isEnglish ? "Conditions" : "நிலைகள்",
          ),
          Tab(
            text: _isEnglish ? "Treatments" : "சிகிச்சைகள்",
          ),
          Tab(
            text: _isEnglish ? "Traditional" : "பாரம்பரியம்",
          ),
        ],
      ),
    );
  }

  Widget _buildBottomActionButtons() {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color:
                AppTheme.lightTheme.colorScheme.shadow.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: _navigateToRelatedDiseases,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.lightTheme.colorScheme.primary,
                  foregroundColor: AppTheme.lightTheme.colorScheme.onPrimary,
                  padding: EdgeInsets.symmetric(vertical: 2.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomIconWidget(
                      iconName: 'medical_services',
                      color: AppTheme.lightTheme.colorScheme.onPrimary,
                      size: 20,
                    ),
                    SizedBox(width: 2.w),
                    Text(
                      _isEnglish
                          ? "View Related Diseases"
                          : "தொடர்புடைய நோய்களைப் பார்க்கவும்",
                      style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(width: 3.w),
            Expanded(
              child: OutlinedButton(
                onPressed: _navigateToStudySystem,
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppTheme.lightTheme.colorScheme.primary,
                  side: BorderSide(
                    color: AppTheme.lightTheme.colorScheme.primary,
                    width: 1.5,
                  ),
                  padding: EdgeInsets.symmetric(vertical: 2.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomIconWidget(
                      iconName: 'school',
                      color: AppTheme.lightTheme.colorScheme.primary,
                      size: 20,
                    ),
                    SizedBox(width: 2.w),
                    Text(
                      _isEnglish
                          ? "Study This System"
                          : "இந்த அமைப்பைப் படிக்கவும்",
                      style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
