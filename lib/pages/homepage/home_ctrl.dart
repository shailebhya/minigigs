import 'dart:developer';

import 'package:confetti/confetti.dart';
import 'package:dio/dio.dart';
import 'package:easily/models/gig_model.dart';
import 'package:easily/services/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../auth/auth_ctrl.dart';

class HomeCtrl extends GetxController {
  final authCtrl = Get.put<AuthCtrl>(AuthCtrl());
  ScrollController gigsListScrollCtrl = ScrollController();
  List<GigModel> gigs = [];
  List<GigModel> ongoingGigs = [];
  List<GigModel> historyGigs = [];
  bool ongoingGigsLoading = false;
  int selectedCityIndex = 0;
  bool historyGigsLoading = false;
  bool acceptLoading = false;
  List<String> cities = [
    "Jamshedpur",
    "MIT Manipal",
    "VIT Vellore",
    "Jamshedpur",
    "MIT Manipal",
    "VIT Vellore",
    "Jamshedpur",
    "MIT Manipal",
    "VIT Vellore",
    "Jamshedpur",
    "MIT Manipal",
    "VIT Vellore",
    "Jamshedpur",
    "MIT Manipal",
    "VIT Vellore",
    "Jamshedpur",
    "MIT Manipal",
    "VIT Vellore"
  ];
  double rating = 0;
  Dio dio = Dio();
  RefreshController refreshController =
      RefreshController(initialRefresh: false);
  bool gigsLoading = false;
  Future getGigsPlease(context) async {
    debugPrint('in get gis please');
    await authCtrl.listenAccount(context);
    await getGigs(authCtrl.user.cityToSearch ?? 'Jamshedpur', frominit: true);
  }

  final ConfettiController controllerBottomCenter =
      ConfettiController(duration: const Duration(seconds: 2));
  getChats() {}
  addChat() {}

  getOngoingGigs() async {
    debugPrint("in get gigs ongoing");
    ongoingGigsLoading = true;
    String apiUrl = "$baseUrl/gigs/getOngoingGigs/${authCtrl.user.id}";
    debugPrint(apiUrl);
    try {
      var response = await dio.get(apiUrl);
      if (response.statusCode == 200 || response.statusCode == 201) {
        debugPrint(response.statusCode.toString());
        ongoingGigs = [];
        for (var json in response.data) {
          GigModel gig = GigModel.fromJson(json);
          ongoingGigs.add(gig);
        }
        debugPrint(ongoingGigs.toString());
        ongoingGigsLoading = false;
        update([ongoingListId]);
      }
    } catch (e) {
      debugPrint('error while getting ongoing gigs: ${e.toString()}');
    }
  }

  getHistoryGigs() async {
    debugPrint("in get gigs history");
    historyGigsLoading = true;
    String apiUrl = "$baseUrl/gigs/getGigHistory/${authCtrl.user.id}";
    debugPrint(apiUrl);
    try {
      var response = await dio.get(apiUrl);
      if (response.statusCode == 200 || response.statusCode == 201) {
        historyGigs = [];
        for (var json in response.data) {
          GigModel gig = GigModel.fromJson(json);
          historyGigs.add(gig);
        }
        historyGigsLoading = false;
        update([historyListId]);
        // debugPrint(response.data.toString());
      }
    } catch (e) {
      debugPrint('error while getting history gigs: ${e.toString()}');
    }
  }

  acceptGig(id) async {
    acceptLoading = true;
        update([jobDetailsId]);
    debugPrint("in accept Gig");
    String apiUrl = "$baseUrl/gigs/updateGig/accept/$id";
    debugPrint(apiUrl);
    try {
      var response =
          await dio.put(apiUrl, data: {"acceptedBy": authCtrl.user.toJson()});
      if (response.statusCode == 200 || response.statusCode == 201) {
         acceptLoading = false;
    // update([acceptGigTextId]);
        debugPrint('response status : 200');
        update([jobDetailsId]);
        debugPrint(response.data.toString());
        if (response.data['modifiedCount'] == 0) {
          Get.back();

          Get.snackbar("sorry",
              "this gig has been accepted by someone😅, please refresh and try again😁");
        } else {
          controllerBottomCenter.play();
          update([jobDetailsId]);
          Get.snackbar("success", "you have accepted this gig, lessgooo🥳");
        }
      } else {
        Get.snackbar("sorry",
            "this gig has been accepted by someone, please refresh and try again");
      }
    } catch (e) {
       acceptLoading = false;
        update([jobDetailsId]);
      debugPrint('error while accepting gig db: ${e.toString()}');
      Get.snackbar("sorry", "an error occurred ");
    }
  }

  getGigs(city,
      {fromRefresh = false, frominit = false, date = 1, id = 1}) async {
    debugPrint("in get gigs from init");
    if (date == 1) {
      gigsLoading = true;
      if (!frominit) {
        update([gigsListId]);
      }
    }
    String apiUrl = "$baseUrl/gigs/getGigs/$city/$date/$id";
    debugPrint(apiUrl);
    try {
      var response = await dio.get(apiUrl);
      if (response.statusCode == 200 || response.statusCode == 201) {
        List<GigModel> pagList = [];
        if (date == 1) {
          gigs = [];
        }
        // debugPrint('response status : 200');
        for (var json in response.data) {
          GigModel gig = GigModel.fromJson(json);
          pagList.add(gig);
        }
        gigs.addAll(pagList);
        gigsLoading = false;
        debugPrint(gigs.length.toString());

        // if (fromRefresh) {
        //   refreshController = RefreshController(initialRefresh: false);
        //   // refreshController.dispose();
        // }
        update([gigsListId]);
      }
    } catch (e) {
      debugPrint('error while getting gigs: ${e.toString()}');
    }
  }
}
