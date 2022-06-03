import 'package:easily/firebase_options.dart';
import 'package:easily/models/user_model.dart';
import 'package:easily/pages/auth/auth.dart';
import 'package:easily/pages/homepage/homepage.dart';
import 'package:easily/services/constants.dart';
import 'package:easily/widgets/job_card.dart';
import 'package:easily/widgets/size_config.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (!kIsWeb) {
    final document = await getApplicationDocumentsDirectory();
    Hive.init(document.path);
  }
  Hive.registerAdapter(UserModelAdapter());
  await Hive.openBox<UserModel>(userBoxName);
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'minigigs',
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}
