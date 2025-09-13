import 'package:flutter/material.dart';
import '../presentation/medicine_detail_screen/medicine_detail_screen.dart';
import '../presentation/body_part_detail_screen/body_part_detail_screen.dart';
import '../presentation/disease_listing_screen/disease_listing_screen.dart';
import '../presentation/home_screen/home_screen.dart';
import '../presentation/medicine_listing_screen/medicine_listing_screen.dart';
import '../presentation/body_parts_explorer_screen/body_parts_explorer_screen.dart';

class AppRoutes {
  // TODO: Add your routes here
  static const String initial = '/';
  static const String medicineDetail = '/medicine-detail-screen';
  static const String bodyPartDetail = '/body-part-detail-screen';
  static const String diseaseListing = '/disease-listing-screen';
  static const String home = '/home-screen';
  static const String medicineListing = '/medicine-listing-screen';
  static const String bodyPartsExplorer = '/body-parts-explorer-screen';

  static Map<String, WidgetBuilder> routes = {
    initial: (context) => const HomeScreen(),
    medicineDetail: (context) => const MedicineDetailScreen(),
    bodyPartDetail: (context) => const BodyPartDetailScreen(),
    diseaseListing: (context) => const DiseaseListingScreen(),
    home: (context) => const HomeScreen(),
    medicineListing: (context) => const MedicineListingScreen(),
    bodyPartsExplorer: (context) => const BodyPartsExplorerScreen(),
    // TODO: Add your other routes here
  };
}
