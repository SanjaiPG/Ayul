import 'package:flutter/material.dart';
import '../presentation/disease_dictionary/disease_dictionary.dart';
import '../presentation/home_dashboard/home_dashboard.dart';
import '../presentation/disease_detail/disease_detail.dart';
import '../presentation/body_explorer/body_explorer.dart';

class AppRoutes {
  // TODO: Add your routes here
  static const String initial = '/';
  static const String diseaseDictionary = '/disease-dictionary';
  static const String homeDashboard = '/home-dashboard';
  static const String diseaseDetail = '/disease-detail';
  static const String bodyExplorer = '/body-explorer';

  static Map<String, WidgetBuilder> routes = {
    initial: (context) => const HomeDashboard(),
    diseaseDictionary: (context) => const DiseaseDictionary(),
    homeDashboard: (context) => const HomeDashboard(),
    diseaseDetail: (context) => const DiseaseDetail(),
    bodyExplorer: (context) => const BodyExplorer(),
    // TODO: Add your other routes here
  };
}
