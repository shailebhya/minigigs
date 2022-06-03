import 'dart:developer';

import 'package:beamer/beamer.dart';
import 'package:dio/dio.dart';
import 'package:easily/models/user_model.dart';
import 'package:easily/pages/homepage/homepage.dart';
import 'package:easily/services/constants.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hive/hive.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';

import '../../widgets/dialog.dart';

class AuthCtrl extends GetxController {
  bool hasInternet = false;
  UserModel user =
      UserModel(superuser: false, rating: 0, numberOfRatings: 0, reviews: []);
  final GoogleSignIn googleSignIn = GoogleSignIn();
  bool? isAuth;
  // final dlCtrl = Get.put<DynamicLinkCtrl>(DynamicLinkCtrl());
  Dio dio = Dio();
  Box<UserModel?>? userBox;
  bool isLoading = true;
  Map<String, dynamic>? userJson;
  String todayDate = DateFormat("dd-MM-yyyy").format(DateTime.now());
  bool appIsDown = true;

  googleLogout() async {
    user =
        UserModel(superuser: false, rating: 0, numberOfRatings: 0, reviews: []);
    userBox!.delete(0);
    // debugPrint(userBox.toString());
    await googleSignIn.disconnect();
  }

  googleLogin() async {
    await googleSignIn.signIn();
  }

  createUserDb(GoogleSignInAccount gUser) async {
    debugPrint("in create User Db");

    // logger.d("in createUserDb");
    String apiUrl = "$baseUrl/users/createUser";
    debugPrint(apiUrl);

    user.id = gUser.id;
    user.email = gUser.email;
    user.username = gUser.displayName;
    user.superuser = false;
    user.img = gUser.photoUrl;
    user.fullname = gUser.displayName;
    user.joinedOn = DateTime.now().toIso8601String();
    try {
      var response = await dio.post(apiUrl, data: user.toJson());
      // logger.d("createUserDb: response.statusCode: ${response.statusCode}");
      if (response.statusCode == 200 || response.statusCode == 201) {
        debugPrint('response status : 200');
        user = UserModel.fromJson(response.data);
        if (kIsWeb) {
          isLoading = false;
          update([homePageId]);
        }
        await userBox!.containsKey(0)
            ? userBox!.putAt(0, user)
            : userBox!.add(user);
        debugPrint(userBox!.getAt(0)!.id!.toString());
        return response;
      }
    } catch (e) {
      debugPrint('error while creating user db: ${e.toString()}');
    }
  }

  updateUserDb(data,UserModel user) async {
    debugPrint("in updt User Db");
    String apiUrl = "$baseUrl/users/updateUser/${user.id}";
    try {
      var response = await dio.put(apiUrl, data: data);
      if (response.statusCode == 200 || response.statusCode == 201) {
        debugPrint('response status : 200');
        await userBox!.containsKey(0)
            ? userBox!.putAt(0, user)
            : userBox!.add(user);
      }
    } catch (e) {
      // logger.e('error while creating user db: ${e.toString()}');
    }
  }

  Future getUserDb(GoogleSignInAccount gUser) async {
    debugPrint("in get User Db");
    var url = "$baseUrl/users/getUser/${gUser.id}";
    try {
      var response = await dio.get(url);
      // logger.d(
      //     'above try catch: af response.body:in getUSerdb1 ${response.data}');
      if (response.statusCode == 200) {
        debugPrint('response status : 200');
        // print(response.data);
        var userJson = response.data;
        return userJson;
      } else {
        debugPrint('something went wrong');
        return null;
      }
    } catch (e) {
      debugPrint("error in getiuser  $e");
      return null;
    }
  }

  checkUserInDb(context) async {
    debugPrint('in checkUserInDb');
    final GoogleSignInAccount? gUser = googleSignIn.currentUser;
    // if (!await getBaseUrl()) return;
    if (gUser != null) {
      userJson = (await getUserDb(gUser));
    }

    if (userJson == null) {
      await createUserDb(gUser!);
    } else {
      //deserialize user
      user = UserModel.fromJson(userJson!);
      if (kIsWeb) {
        isLoading = false;
        update([homePageId]);
      }
      // if (!kIsWeb) {
      await storeUserDataInHive(context);
      // } else {
      //   Get.back();
      // } //Check This
    }
  }

  storeUserDataInHive(context) async {
    debugPrint("In store User Data In Hive" + user.toString());
     userBox!.containsKey(0)
        ? userBox!.putAt(0, user)
        : userBox!.add(user);

    // logger.d("user data stored in hive. Now nav to Home Page");
    Get.to(() => HomePage());
    // Beamer.of(context).beamToNamed('/home');
  }

  handleSignIn(GoogleSignInAccount? account, context) async {
    debugPrint("in handle Sign In Account");
    if (account != null) {
      debugPrint("Account = ${account.displayName}");
      await checkUserInDb(context);

      isAuth = true;
      update([authPageId]);
      update([sideMenuId]);

      if (kIsWeb) {
        isLoading = false;
        update([homePageId]);
        
      }
    } else {
      // if (kIsWeb) {
      isLoading = false;
      update([homePageId]);

      // }
      debugPrint("account logged out");
      isAuth = false;
      update([authPageId]);
                  update([sideMenuId]);

    }
  }

  listenAccount(context) async {
    debugPrint("in listen account");
    googleSignIn.onCurrentUserChanged.listen((account) {
      debugPrint("hello inside the on current use chagen listennn");
      handleSignIn(account!, context);
    }, onError: (err) {
      if (kIsWeb) {
        isLoading = false;
        update([homePageId]);
      }
      debugPrint("Error signing in : $err");
    }); //Reauthenticate when app is opened!!
    await googleSignIn
        .signInSilently(suppressErrors: false, reAuthenticate: true)
        .then((account) {
      debugPrint(
          "inside sing in silently error is here ig" + account.toString());
      handleSignIn(account, context);
    }).catchError((err) {
      debugPrint("in listen account ERROR : $err");
      if (kIsWeb) {
        isLoading = false;
        update([homePageId]);
      }
      isAuth = false;
      update([authPageId]);
    });
  }

  Future checkInitialData() async {
    // debugPrint("in check Initial Data");
    // await FirebaseDatabase.instance
    //     .ref()
    //     .child("appDown")
    //     .once()
    //     .then((DatabaseEvent snapshot) {
    //   appIsDown = snapshot.snapshot.value as bool;
    //   debugPrint(snapshot.snapshot.value.runtimeType.toString());
    //   // serverUrl = snapshot?.value;
    //   debugPrint('appIsDown : $appIsDown');
    // }).onError((error, stackTrace) {
    //   debugPrint("Error while getting appIsDown: $error");
    // });
  }

  void checkUserMethod(context) async {
    debugPrint("in checkUserMethod()");
    var userData = await getUserDataFromHive();
    if (userData == null) {
      debugPrint("User Data is Nulll in Hive Going to Listen account");
      // await checkInternet();
      await listenAccount(context);
      // Get.to(() => const AuthPage());
    } else {
      debugPrint("user is Loggedin. => showing homepage");
      debugPrint("userId of current Users" + user.id!);
      // dlCtrl.initDynamicLinks();
      Get.to(() => HomePage());
    }
  }

  getUserDataFromHive() {
    debugPrint("in get user data from hive db");
    try {
      if (userBox != null) {
        debugPrint(userBox!.values.toString());
        user = userBox!.getAt(0)!;
        return userBox;
      } else if (userBox == null) {
        return null;
      }
    } catch (e) {
      // logger.d(e);
      return null;
    }
  }

  @override
  void onInit() {
    super.onInit();
    // checkInitialData();
    userBox = Hive.box<UserModel>(userBoxName);
    checkUserMethod(context);

    if (!kIsWeb) {
      // here is the problem
      InternetConnectionChecker().onStatusChange.listen((status) {
        hasInternet = status == InternetConnectionStatus.connected;
        debugPrint("Internet is Working : " + hasInternet.toString());
        // if (hasInternet == false) Get.to(() => const NoInternet());
      });
    }
  }
}
