import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../core/app_export.dart';
import '../widgets/custom_error_widget.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();

//   await Firebase.initializeApp(
//     options: DefaultFirebaseOptions.currentPlatform,
//   );

//   bool _hasShownError = false;

//   // 🚨 CRITICAL: Custom error handling - DO NOT REMOVE
//   ErrorWidget.builder = (FlutterErrorDetails details) {
//     if (!_hasShownError) {
//       _hasShownError = true;

//       // Reset flag after 3 seconds to allow error widget on new screens
//       Future.delayed(Duration(seconds: 5), () {
//         _hasShownError = false;
//       });

//       return CustomErrorWidget(
//         errorDetails: details,
//       );
//     }
//     return SizedBox.shrink();
//   };

//   // 🚨 CRITICAL: Device orientation lock - DO NOT REMOVE
//   Future.wait([
//     SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
//   ]).then((value) {
//     runApp(MyApp());
//   });
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Sizer(builder: (context, orientation, screenType) {
//       return MaterialApp(
//         title: 'Ayul',
//         theme: AppTheme.lightTheme,
//         darkTheme: AppTheme.darkTheme,
//         themeMode: ThemeMode.light,
//         // 🚨 CRITICAL: NEVER REMOVE OR MODIFY
//         builder: (context, child) {
//           return MediaQuery(
//             data: MediaQuery.of(context).copyWith(
//               textScaler: TextScaler.linear(1.0),
//             ),
//             child: child!,
//           );
//         },
//         // 🚨 END CRITICAL SECTION
//         debugShowCheckedModeBanner: false,
//         routes: AppRoutes.routes,
//         initialRoute: AppRoutes.initial,
//       );
//     });
//   }
// }

import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'firebase_options.dart'; // Make sure to import your Firebase config file

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Firestore Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home:
          FirestoreExample(), // Use the FirestoreExample widget to display data
    );
  }
}

class FirestoreExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Reference to your Firestore collection
    CollectionReference users = FirebaseFirestore.instance.collection('name');

    return Scaffold(
      appBar: AppBar(
        title: Text('Firestore Data'),
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: users
            .doc('iDtgVNuYYytgqEyyO0pC')
            .get(), // Use your document ID here
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
                child: Text('Something went wrong: ${snapshot.error}'));
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return Center(child: Text('Document not found'));
          }

          // Get the data from the document
          var userData = snapshot.data!.data() as Map<String, dynamic>;
          var name = userData['name'];
          var age = userData['age'];

          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Name: $name'),
                Text('Age: $age'),
              ],
            ),
          );
        },
      ),
    );
  }
}
