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
    // TODO: implement initState
    super.initState();
    if (kIsWeb) {
      homeCtrl.getGigsPlease(context);
    } else {
      debugPrint('we are here');
      homeCtrl.getGigs(homeCtrl.authCtrl.user.cityToSearch ?? 'Jamshedpur',
          frominit: true);
      homeCtrl.authCtrl.isLoading = false;
    }
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
                        CircularProgressIndicator(color:Colors.black),
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
                    icon: Icon(
                      Icons.add,
                      color: Colors.white,
                    ),
                    backgroundColor: Colors.black,
                  ),
                  drawer: SideMenu(),
                  appBar: AppBar(
                    leading: InkWell(
                      onTap: () => _scaffoldKey.currentState!.openDrawer(),
                      child: Icon(
                        Icons.menu,
                        color: Colors.black,
                      ),
                    ),
                    actions: [
//                       Padding(
//                         padding: const EdgeInsets.symmetric(horizontal:10.0),
//                         child: SizedBox(
//                             height: 60,
//                             width: SizeConfig.screenWidth/5,
//                             child: DropdownSearch<String>(
//                                 popupElevation: 5,
//                                 mode: Mode.DIALOG,
//                                 popupTitle:const Center(child: Padding(
//                                   padding:  EdgeInsets.symmetric(vertical:10.0),
//                                   child: Text("select location",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),),
//                                 )),
//                                 items: homeCtrl.cities,
//                                 showSearchBox: true,
//                                 dropdownButtonBuilder:(_){
// return Text(
//    homeCtrl.authCtrl.user.cityToSearch??"",
//   style: TextStyle(
//         fontSize: 15,
//         color: Colors.black,
//      )
// ); } ,
//                                 dropdownSearchDecoration:
//                                     const InputDecoration(
//                                         border: InputBorder.none,
//                                         focusedBorder: OutlineInputBorder(
//                                             borderSide: BorderSide(
//                                                 color: Colors.black))),
//                                 // popupItemDisabled: (String s) => s.startsWith('I'),
//                                 onChanged: (String? s) {
//                                   homeCtrl.selectedCityIndex =
//                                       homeCtrl.cities.indexOf(s ?? '');
//                                   homeCtrl.getGigs(s);
//                                   if (_.user.id != null) {
//                                     homeCtrl.authCtrl.user.cityToSearch = s;
//                                     homeCtrl.authCtrl
//                                         .updateUserDb({'cityToSearch': s});
//                                   }
//                                 },
//                                 // selectedItem:
//                                 //     homeCtrl.authCtrl.user.cityToSearch ??
//                                 //         "Jamshedpur"
//                                         ),
//                           ),
//                       )
                      InkWell(
                          onTap: (() => showDialog<void>(
                            barrierDismissible: true,
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(   
                                  scrollable: true,  
                                  title:const Center(child: Text('select location')),
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
                                            padding: const EdgeInsets.symmetric(horizontal:10.0,vertical: 10),
                                            child: Text(homeCtrl.cities[index],style: const TextStyle(fontSize: 18),),
                                          );
                                        }),
                                      ),
                                    ),
                                  ),
                                );
                              })),
                          child: Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: Row(
                              children: [
                                Text(
                                  _.user.cityToSearch ?? 'jamshedpur',
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(color: Colors.black),
                                ),
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
                    title: Text(
                      "minigigs",
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                  ),
                  body: Container(
                    decoration: BoxDecoration(
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
                                ? Center(
                                    child: CircularProgressIndicator(color:Colors.black),
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
                                            child: JobCard(homeCtrl.gigs[index],
                                                hasImage: homeCtrl.gigs[index]
                                                    .images!.isNotEmpty)),
                                      );
                                    });
                          }),
                    ),
                  ),
                );
        });
  }
}
