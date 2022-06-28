import 'package:easily/pages/add_job/add_job.dart';
import 'package:easily/pages/auth/auth_ctrl.dart';
import 'package:easily/pages/homepage/job_details.dart';
import 'package:easily/pages/homepage/side_menu.dart';
import 'package:easily/widgets/job_card.dart';
import 'package:easily/widgets/size_config.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../services/constants.dart';
import 'home_ctrl.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final homeCtrl = Get.put<HomeCtrl>(HomeCtrl());

  @override
  void initState() {
    super.initState();
    debugPrint(homeCtrl.authCtrl.user.cityToSearch);
    homeCtrl.getGigsPlease();
    homeCtrl.gigsListScrollCtrl.addListener(() {
      if (homeCtrl.gigsListScrollCtrl.position.pixels >=
          homeCtrl.gigsListScrollCtrl.position.maxScrollExtent) {
        homeCtrl.getGigs(homeCtrl.cities[homeCtrl.selectedCityIndex],
            id: homeCtrl.gigs.last.id, date: homeCtrl.gigs.last.createdAt);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return GetBuilder<AuthCtrl>(
        id: homePageId,
        builder: (_) {
          return _.isLoading
              ? Scaffold(
                  body: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        CircularProgressIndicator(color: Colors.black),
                        SelectableText("Logging You In ...")
                      ],
                    ),
                  ),
                )
              : Scaffold(
                  key: _scaffoldKey,
                  floatingActionButton: FloatingActionButton.extended(
                    label: Text(
                      "new",
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () {
                      if (_.user.id != null) {
                        Get.to(() => AddJob());
                      } else {
                        Get.snackbar(
                            "login required", "please login to create a gig",
                            snackPosition: SnackPosition.BOTTOM);
                      }
                    },
                    icon: const Icon(
                      Icons.add,
                      color: Colors.white,
                    ),
                    backgroundColor: Colors.black,
                  ),
                  drawer: SideMenu(),
                  appBar: AppBar(
                    leading: InkWell(
                      onTap: () => _scaffoldKey.currentState!.openDrawer(),
                      child: const Icon(
                        Icons.menu,
                        color: Colors.black,
                      ),
                    ),
                    actions: [
                      InkWell(
                          onTap: (() => showDialog<void>(
                              barrierDismissible: true,
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  scrollable: true,
                                  title: const Center(
                                      child: Text('select location')),
                                  content: Container(
                                      height: 300,
                                      width: 300,
                                      child: Align(
                                        alignment: Alignment.topCenter,
                                        child: Scrollbar(
                                          thumbVisibility: true,
                                          child: ListView.builder(
                                              itemCount: homeCtrl.cities.length,
                                              shrinkWrap: true,
                                              itemBuilder: (context, index) {
                                                return Padding(
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      horizontal: 10.0,
                                                      vertical: 10),
                                                  child: InkWell(
                                                      onTap: () async {
                                                        Navigator.pop(context);
                                                        homeCtrl.selectedCityIndex =
                                                            homeCtrl.cities
                                                                .indexOf(homeCtrl
                                                                        .cities[
                                                                    index]);
                                                        debugPrint(homeCtrl
                                                            .selectedCityIndex
                                                            .toString());
                                                        homeCtrl.getGigs(
                                                            homeCtrl
                                                                .cities[index]);
                                                        setState(() {});

                                                        if (_.user.id != null) {
                                                          homeCtrl.authCtrl.user
                                                                  .cityToSearch =
                                                              homeCtrl.cities[
                                                                  index];
                                                          await homeCtrl
                                                              .authCtrl
                                                              .updateUserDb(
                                                                  {
                                                                'cityToSearch':
                                                                    homeCtrl.cities[
                                                                        index]
                                                              },
                                                                  homeCtrl
                                                                      .authCtrl
                                                                      .user);
                                                          debugPrint(homeCtrl
                                                              .authCtrl
                                                              .user
                                                              .cityToSearch);
                                                        }
                                                      },
                                                      child: Text(
                                                        homeCtrl.cities[index],
                                                        style: const TextStyle(
                                                            fontSize: 18),
                                                      )),
                                                );
                                              }),
                                        ),
                                      )),
                                );
                              })),
                          child: Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: Row(
                              children: [
                                GetBuilder<HomeCtrl>(
                                    id: gigsListId,
                                    builder: (_) {
                                      return Text(
                                        homeCtrl
                                            .cities[homeCtrl.selectedCityIndex],
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                            color: Colors.black),
                                      );
                                    }),
                                const Icon(
                                  Icons.location_on_rounded,
                                  color: Colors.black,
                                ),
                              ],
                            ),
                          ))
                    ],
                    centerTitle: true,
                    shadowColor: Colors.transparent,
                    backgroundColor: Colors.grey[50],
                    title: const Text(
                      "minigigs",
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                  ),
                  body: Container(
                    decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                            topRight: Radius.circular(20),
                            topLeft: Radius.circular(20))),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GetBuilder<HomeCtrl>(
                          id: gigsListId,
                          builder: (_) {
                            return _.gigsLoading
                                ? const Center(
                                    child: CircularProgressIndicator(
                                        color: Colors.black),
                                  )
                                : homeCtrl.gigs.isEmpty
                                    ? const Center(
                                        child: Text(
                                          "well, aren't you lucky,\nbecome the first person to post a gig in this city!",
                                          style: TextStyle(fontSize: 28),
                                          textAlign: TextAlign.center,
                                        ),
                                      )
                                    : ListView.builder(
                                        controller: _.gigsListScrollCtrl,
                                        itemCount: homeCtrl.gigs.length,
                                        itemBuilder: (context, index) {
                                          return Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 10.0, vertical: 15),
                                            child: InkWell(
                                                onTap: () {
                                                  Get.to(() => JobDetails(
                                                      homeCtrl.gigs[index]));
                                                },
                                                child: JobCard(
                                                    homeCtrl.gigs[index],
                                                    hasImage: homeCtrl
                                                        .gigs[index]
                                                        .images!
                                                        .isNotEmpty)),
                                          );
                                        });
                          }),
                    ),
                  ),
                );
        });
  }
}
