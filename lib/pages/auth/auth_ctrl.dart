import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:easily/models/user_model.dart';
import 'package:easily/services/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart' as stream;

class AuthCtrl extends GetxController {
  bool hasInternet = false;
  final client = stream.StreamChatClient(apiKey, logLevel: stream.Level.INFO);
  UserModel user =
      UserModel(superuser: false, rating: 0, numberOfRatings: 0, reviews: []);
  final GoogleSignIn googleSignIn = GoogleSignIn();
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
    onInit();
  }

  googleLogin() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );
    await handleSignIn(googleUser, context);
    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
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
        isLoading = false;
        update([homePageId]);
        update([sideMenuId]);
        if (userBox == null) log('userbox is null');
      else{  userBox!.containsKey(0)
            ? userBox!.putAt(0, user)
            : userBox!.put(0, user);}
        // debugPrint(userBox!.getAt(0)!.id!.toString());
        // return response;
        await client.connectUser(stream.User(name: user.username,id: user.id!), user.token!);

      }
    } catch (e) {
      debugPrint('error while creating user db: ${e.toString()}');
    }
  }

  updateUserDb(data, UserModel user) async {
    debugPrint("in updt User Db");
    String apiUrl = "$baseUrl/users/updateUser/${user.id}";
    try {
      var response = await dio.put(apiUrl, data: data);
      if (response.statusCode == 200 || response.statusCode == 201) {
        debugPrint('response status : 200');
        userBox!.containsKey(0)
            ? userBox!.putAt(0, user)
            : userBox!.put(0, user);
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

  checkUserInDb(account, context) async {
    debugPrint('in checkUserInDb');
    if (account != null) {
      userJson = (await getUserDb(account));
    }
    if (userJson == null) {
      await createUserDb(account!);
    } else {
      user = UserModel.fromJson(userJson!);
      isLoading = false;
      update([sideMenuId]);
      update([homePageId]);
      await storeUserDataInHive(context);
                await client.connectUser(stream.User(name: user.username,id: user.id??""), user.token??"");

    }
  }

  storeUserDataInHive(context) async {
    debugPrint("In store User Data In Hive$user");
    userBox!.containsKey(0) ? userBox!.putAt(0, user) : userBox!.put(0, user);
    // logger.d("user data stored in hive. Now nav to Home Page");
    // Get.to(() => HomePage());
    // Beamer.of(context).beamToNamed('/home');
  }

  handleSignIn(GoogleSignInAccount? account, context) async {
    debugPrint("in handle sign In Account");
    if (account != null) {
      debugPrint("Account = ${account.displayName}");
      await checkUserInDb(account, context);
      isLoading = false;
      update([sideMenuId]);
      update([homePageId]);
    } else {
      debugPrint("account logged out");
      // isAuth = false;
      isLoading = false;
      update([homePageId]);
      update([sideMenuId]);
    }
  }

  // listenAccount(context) async {
  //   googleSignIn.onCurrentUserChanged.listen((account) {
  //     debugPrint("listening to account");
  //     handleSignIn(account!, context);
  //   }, onError: (err) {
  //     debugPrint("Error in listening account : $err");
  //   }); //Reauthenticate when app is opened!!
  //   await googleSignIn
  //       .signInSilently(suppressErrors: false, reAuthenticate: true)
  //       .then((account) {
  //     debugPrint(" " + account.toString());
  //     handleSignIn(account, context);
  //   }).catchError((err) {
  //     debugPrint("in listen account ERROR : $err");
  // isAuth = false;
  //     isLoading = false;
  //     update([authPageId]);
  //     update([homePageId]);
  //   });
  // }

  Future checkInitialData() async {}

  void checkUserMethod(context) async {
    debugPrint("in checkUserMethod()");
    UserModel? userData = await getUserDataFromHive();
    if (userData == null) {
      debugPrint("user account data not found internally");
      isLoading = false;
      update([homePageId]);
      update([sideMenuId]);
      // await listenAccount(context);
    } else {
      isLoading = false;
      update([homePageId]);
      update([sideMenuId]);
      debugPrint('data is present internally');
      // debugPrint(userData.toJson().toString());
      debugPrint("userId of current User${user.id!}");
          await client.connectUser(stream.User(name: user.username,id: user.id??""), user.token??"");

    }
  }

  getUserDataFromHive() {
    debugPrint("in get user data from internal db");
    try {
      if (userBox != null) {
        debugPrint(userBox!.values.toString());
        user = userBox!.getAt(0)!;
        return user;
      } else if (userBox == null) {
        debugPrint('nothing is stored internally');
        return null;
      }
    } catch (e) {
      debugPrint('some error in getting data internally');
      return null;
    }
  }

  @override
  void onInit() {
    super.onInit();
    userBox = Hive.box<UserModel>(userBoxName);
    checkUserMethod(context);
    // if (!kIsWeb) {
    //   // here is the problem
    //   InternetConnectionChecker().onStatusChange.listen((status) {
    //     hasInternet = status == InternetConnectionStatus.connected;
    //     debugPrint("Internet is Working : " + hasInternet.toString());
    //     // if (hasInternet == false) Get.to(() => const NoInternet());
    //   });
    // }
  }
}
