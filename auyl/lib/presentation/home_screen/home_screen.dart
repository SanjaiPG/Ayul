import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/body_parts_explorer_widget.dart';
import './widgets/educational_tips_widget.dart';
import './widgets/language_toggle_widget.dart';
import './widgets/navigation_card_widget.dart';
import './widgets/offline_indicator_widget.dart';
import './widgets/quick_access_card_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late TabController _tabController;
  String _currentLanguage = 'EN';
  bool _isOffline = false;
  bool _isRefreshing = false;

  // Mock data for recent content
  final List<Map<String, dynamic>> _recentContent = [
    {
      "id": 1,
      "title": "Tulsi",
      "subtitle": "Holy Basil - Natural immunity booster",
      "type": "medicine",
      "image":
          "https://images.pexels.com/photos/4198015/pexels-photo-4198015.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
    },
    {
      "id": 2,
      "title": "Diabetes",
      "subtitle": "மதுமேகம் - Blood sugar management",
      "type": "disease",
      "image":
          "https://images.unsplash.com/photo-1576091160399-112ba8d25d1f?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
    },
    {
      "id": 3,
      "title": "Neem",
      "subtitle": "வேப்பம் - Natural antiseptic",
      "type": "medicine",
      "image":
          "https://images.pexels.com/photos/6627946/pexels-photo-6627946.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
    },
    {
      "id": 4,
      "title": "Arthritis",
      "subtitle": "கீல்வாதம் - Joint inflammation",
      "type": "disease",
      "image":
          "https://images.unsplash.com/photo-1559757175-0eb30cd8c063?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _checkConnectivity();
    _setupConnectivityListener();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _checkConnectivity() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    setState(() {
      _isOffline = connectivityResult == ConnectivityResult.none;
    });
  }

  void _setupConnectivityListener() {
    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      setState(() {
        _isOffline = result == ConnectivityResult.none;
      });
    });
  }

  Future<void> _onRefresh() async {
    setState(() {
      _isRefreshing = true;
    });

    // Simulate refresh delay
    await Future.delayed(Duration(seconds: 2));

    setState(() {
      _isRefreshing = false;
    });

    if (!_isOffline) {
      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_currentLanguage == 'EN'
              ? 'Content updated successfully'
              : 'உள்ளடக்கம் வெற்றிகரமாக புதுப்பிக்கப்பட்டது'),
          backgroundColor: AppTheme.lightTheme.colorScheme.tertiary,
        ),
      );
    }
  }

  void _onLanguageChanged(String language) {
    setState(() {
      _currentLanguage = language;
    });
  }

  void _navigateToSiddhaSection() {
    Navigator.pushNamed(context, '/medicine-listing-screen',
        arguments: {'type': 'siddha'});
  }

  void _navigateToAcupunctureSection() {
    Navigator.pushNamed(context, '/medicine-listing-screen',
        arguments: {'type': 'acupuncture'});
  }

  void _navigateToBodyPartsExplorer() {
    Navigator.pushNamed(context, '/body-parts-explorer-screen');
  }

  void _navigateToMedicineDetail(Map<String, dynamic> medicine) {
    Navigator.pushNamed(context, '/medicine-detail-screen',
        arguments: medicine);
  }

  void _navigateToDiseaseDetail(Map<String, dynamic> disease) {
    Navigator.pushNamed(context, '/disease-listing-screen', arguments: disease);
  }

  void _onQuickAccessTap(Map<String, dynamic> item) {
    if (item['type'] == 'medicine') {
      _navigateToMedicineDetail(item);
    } else {
      _navigateToDiseaseDetail(item);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            OfflineIndicatorWidget(isOffline: _isOffline),
            _buildHeader(),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildHomeTab(),
                  _buildSearchTab(),
                  _buildBooksTab(),
                  _buildFindDiseaseTab(),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color:
                AppTheme.lightTheme.colorScheme.shadow.withValues(alpha: 0.05),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _currentLanguage == 'EN' ? 'Ayul' : 'ஆயுள்',
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.lightTheme.primaryColor,
                ),
              ),
              Text(
                _currentLanguage == 'EN'
                    ? 'Traditional Medicine Learning'
                    : 'பாரம்பரிய மருத்துவ கல்வி',
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w400,
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
          LanguageToggleWidget(
            currentLanguage: _currentLanguage,
            onLanguageChanged: _onLanguageChanged,
          ),
        ],
      ),
    );
  }

  Widget _buildHomeTab() {
    return RefreshIndicator(
      onRefresh: _onRefresh,
      color: AppTheme.lightTheme.primaryColor,
      child: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 2.h),
            _buildNavigationCards(),
            SizedBox(height: 3.h),
            _buildQuickAccessSection(),
            SizedBox(height: 3.h),
            BodyPartsExplorerWidget(onTap: _navigateToBodyPartsExplorer),
            SizedBox(height: 2.h),
            _recentContent.isEmpty
                ? EducationalTipsWidget(currentLanguage: _currentLanguage)
                : SizedBox.shrink(),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }

  Widget _buildNavigationCards() {
    return Column(
      children: [
        NavigationCardWidget(
          title:
              _currentLanguage == 'EN' ? 'Siddha Medicine' : 'சித்த மருத்துவம்',
          description: _currentLanguage == 'EN'
              ? 'Explore traditional Siddha medicines, treatments and ancient healing wisdom'
              : 'பாரம்பரிய சித்த மருந்துகள், சிகிச்சைகள் மற்றும் பண்டைய குணப்படுத்தும் ஞானத்தை ஆராயுங்கள்',
          iconName: 'local_pharmacy',
          route: '/medicine-listing-screen',
          onTap: _navigateToSiddhaSection,
        ),
        NavigationCardWidget(
          title:
              _currentLanguage == 'EN' ? 'Acupuncture' : 'குத்தூசி மருத்துவம்',
          description: _currentLanguage == 'EN'
              ? 'Learn about acupuncture points, techniques and therapeutic applications'
              : 'குத்தூசி புள்ளிகள், நுட்பங்கள் மற்றும் சிகிச்சை பயன்பாடுகளைப் பற்றி அறியுங்கள்',
          iconName: 'healing',
          route: '/medicine-listing-screen',
          onTap: _navigateToAcupunctureSection,
        ),
      ],
    );
  }

  Widget _buildQuickAccessSection() {
    if (_recentContent.isEmpty) {
      return SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _currentLanguage == 'EN' ? 'Quick Access' : 'விரைவு அணுகல்',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.lightTheme.colorScheme.onSurface,
                ),
              ),
              TextButton(
                onPressed: () {
                  // Navigate to full recent list
                },
                child: Text(
                  _currentLanguage == 'EN' ? 'View All' : 'அனைத்தையும் பார்க்க',
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                    color: AppTheme.lightTheme.primaryColor,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 1.h),
        Container(
          height: 25.h,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            itemCount: _recentContent.length,
            itemBuilder: (context, index) {
              final item = _recentContent[index];
              return QuickAccessCardWidget(
                title: _currentLanguage == 'EN'
                    ? item['title']
                    : item[
                        'title'], // In real app, would have Tamil translations
                subtitle: item['subtitle'],
                imageUrl: item['image'],
                type: item['type'],
                onTap: () => _onQuickAccessTap(item),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSearchTab() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomIconWidget(
            iconName: 'search',
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            size: 64,
          ),
          SizedBox(height: 2.h),
          Text(
            _currentLanguage == 'EN' ? 'Search Feature' : 'தேடல் அம்சம்',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              color: AppTheme.lightTheme.colorScheme.onSurface,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            _currentLanguage == 'EN'
                ? 'Coming Soon - Search across medicines, diseases, and body parts'
                : 'விரைவில் வரும் - மருந்துகள், நோய்கள் மற்றும் உடல் பாகங்களில் தேடுங்கள்',
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w400,
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildBooksTab() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomIconWidget(
            iconName: 'menu_book',
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            size: 64,
          ),
          SizedBox(height: 2.h),
          Text(
            _currentLanguage == 'EN'
                ? 'Siddha Books Library'
                : 'சித்த நூல் நூலகம்',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              color: AppTheme.lightTheme.colorScheme.onSurface,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            _currentLanguage == 'EN'
                ? 'Coming Soon - Access traditional Siddha texts and references'
                : 'விரைவில் வரும் - பாரம்பரிய சித்த நூல்கள் மற்றும் குறிப்புகளை அணுகவும்',
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w400,
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildFindDiseaseTab() {
    return DiseaseQuestionnaireWidget(
      currentLanguage: _currentLanguage,
      onMedicineIdentified: (medicine) {
        _navigateToMedicineDetail(medicine);
      },
    );
  }

  Widget _buildBottomNavigationBar() {
    return TabBar(
      controller: _tabController,
      tabs: [
        Tab(
          icon: CustomIconWidget(
            iconName: 'home',
            color: _tabController.index == 0
                ? AppTheme.lightTheme.primaryColor
                : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            size: 24,
          ),
          text: _currentLanguage == 'EN' ? 'Home' : 'முகப்பு',
        ),
        Tab(
          icon: CustomIconWidget(
            iconName: 'search',
            color: _tabController.index == 1
                ? AppTheme.lightTheme.primaryColor
                : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            size: 24,
          ),
          text: _currentLanguage == 'EN' ? 'Search' : 'தேடல்',
        ),
        Tab(
          icon: CustomIconWidget(
            iconName: 'menu_book',
            color: _tabController.index == 2
                ? AppTheme.lightTheme.primaryColor
                : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            size: 24,
          ),
          text: _currentLanguage == 'EN' ? 'Books' : 'நூல்கள்',
        ),
        Tab(
          icon: CustomIconWidget(
            iconName: 'healing',
            color: _tabController.index == 3
                ? AppTheme.lightTheme.primaryColor
                : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            size: 24,
          ),
          text: _currentLanguage == 'EN' ? 'Find Disease' : 'நோயைக் கண்டறிய',
        ),
      ],
      labelColor: AppTheme.lightTheme.primaryColor,
      unselectedLabelColor: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
      indicatorColor: AppTheme.lightTheme.primaryColor,
      labelStyle: TextStyle(
        fontSize: 10.sp,
        fontWeight: FontWeight.w500,
      ),
      unselectedLabelStyle: TextStyle(
        fontSize: 10.sp,
        fontWeight: FontWeight.w400,
      ),
    );
  }
}

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
                Navigator.of(context).pop();
                widget.onMedicineIdentified(recommendedMedicine);
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
