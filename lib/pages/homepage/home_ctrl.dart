import 'package:confetti/confetti.dart';
import 'package:dio/dio.dart';
import 'package:easily/models/gig_model.dart';
import 'package:easily/models/review_model.dart';
import 'package:easily/services/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../auth/auth_ctrl.dart';

class HomeCtrl extends GetxController {
  final authCtrl = Get.put<AuthCtrl>(AuthCtrl());
  ScrollController gigsListScrollCtrl = ScrollController();
  TextEditingController reviewCtrl = TextEditingController();
  ReviewModel reviewModel = ReviewModel(likes: []);
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
    "Pune",
    "mumbai",
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

     getGig(String id) async {
    debugPrint("in get single gig");
    var url = "$baseUrl/gigs/getSingleGig/$id";
    try {
      var response = await dio.get(url);
      if (response.statusCode == 200) {
        debugPrint('response status : 200');
        // print(response.data);
        return GigModel.fromJson(response.data);
      } else {
        debugPrint('something went wrong');
        return null;
      }
    } catch (e) {
      debugPrint("error in getiuser  $e");
      return null;
    }
  }


  Future completeGig(GigModel gig) async {
    debugPrint("in update Gig");
    String apiUrl = "$baseUrl/gigs/updateGig/complete/${gig.id}";
    try {
      var response = await dio
          .put(apiUrl, data: {"completedAt": DateTime.now().toString()});
      if (response.statusCode == 200 || response.statusCode == 201) {
        debugPrint('response status : 200');
        Get.snackbar('awesome!🎉', 'you have successfully completed the gig!');
      } else {
        Get.back();
        Get.snackbar("sorryy!!", 'some error occured!😭, please try again');
      }
    } catch (e) {
      Get.back();
      Get.snackbar("sorryy!!", 'some error occured!😭, please try again');
      // debugPrint('error while creating user db: ${e.toString()}');
    }
  }

  Future getGigsPlease() async {
    debugPrint('in get gis please');
    // await authCtrl.listenAccount(context);
    await getGigs(authCtrl.user.cityToSearch ?? cities[selectedCityIndex],
        frominit: true);
  }

  final ConfettiController controllerBottomCenter =
      ConfettiController(duration: const Duration(microseconds: 10));

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

  Future postReview(hostId, gigId, userId, username) async {
    reviewModel = ReviewModel(likes: []);
    debugPrint('posting your review');
    String apiUrl = "$baseUrl/reviews/postReview";
    debugPrint(apiUrl);
    reviewModel.date = DateTime.now().toString();
    reviewModel.desc = reviewCtrl.text;
    reviewModel.likesNum = 0;
    reviewModel.receiverId = hostId;
    reviewModel.rating = rating;
    reviewModel.gigId = gigId;
    reviewModel.userid = userId;
    reviewModel.username = username;
    try {
      var response = await dio.post(apiUrl, data: reviewModel.toJson());
      if (response.statusCode == 200 || response.statusCode == 201) {
        debugPrint('review succesfully posted');
      }
    } catch (e) {
      debugPrint('error while posting the review: ${e.toString()}');
    }
  }

  Future updateReview() async {
    debugPrint('posting your review');
    String apiUrl = "$baseUrl/reviews/postReview";
    debugPrint(apiUrl);
    try {
      var response = await dio.post(apiUrl, data: {});
      if (response.statusCode == 200 || response.statusCode == 201) {
        debugPrint('review succesfully posted');
      }
    } catch (e) {
      debugPrint('error while posting the review: ${e.toString()}');
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

  Future<bool?> acceptGig(id, p1) async {
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
          return false;
        } else {
          controllerBottomCenter.play();
          update([jobDetailsId]);
          final channel =
              authCtrl.client.channel('messaging', id: id, extraData: {
            "members": [p1, authCtrl.user.id]
          });
          await channel.watch();
          // channel.watch();
          // await channel.addMembers([ authCtrl.user.id!]);
          Get.snackbar("success", "you have accepted this gig, lessgooo🥳");
          return true;
        }
      } else {
        Get.snackbar("sorry",
            "this gig has been accepted by someone, please refresh and try again");
        return false;
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
    selectedCityIndex = cities.indexOf(city);
    debugPrint(apiUrl);
    try {
      var response = await dio.get(apiUrl);
      //to deal with first time not able to fetch list 
      if (response.data.runtimeType != List) {
         await getGigs(authCtrl.user.cityToSearch ?? cities[selectedCityIndex],);
      }
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

  @override
  void onInit() {
    super.onInit();
    if (authCtrl.user.cityToSearch != null) {
      selectedCityIndex = cities.indexOf(authCtrl.user.cityToSearch!);
    }
  }
}
