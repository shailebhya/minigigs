import 'package:easily/pages/homepage/home_ctrl.dart';
import 'package:easily/services/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../widgets/size_config.dart';
import 'ongoing_item.dart';
import 'ongoing_item_view.dart';

class Ongoing extends StatefulWidget {
  const Ongoing({Key? key}) : super(key: key);

  @override
  State<Ongoing> createState() => _OngoingState();
}

class _OngoingState extends State<Ongoing> {
  final homeCtrl = Get.find<HomeCtrl>();
    RefreshController controller = RefreshController();

//if gig . accepted by someone and completed at is null then status is ongoing
  @override
  void initState() {
    super.initState();
    homeCtrl.getOngoingGigs();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeCtrl>(
        id: ongoingListId,
        builder: (_) {
          return _.ongoingGigsLoading
              ? Scaffold(
                  backgroundColor: Colors.white,
                  appBar: AppBar(
                    title: Text("ongoing",
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.w600)),
                    elevation: 0,
                    centerTitle: true,
                    backgroundColor: Colors.transparent,
                  ),
                  body: Center(child: CircularProgressIndicator()))
              : Scaffold(
                  backgroundColor: Colors.white,
                  appBar: AppBar(
                    title: const Text("ongoing",
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.w600)),
                    elevation: 0,
                    centerTitle: true,
                    backgroundColor: Colors.transparent,
                  ),
                  body: _.ongoingGigs.isEmpty
                      ? const Center(
                          child: Text("let's create a gig or find one!"))
                      : SmartRefresher(
                         controller:controller,
                          onRefresh: () async => initState,
                          child: ListView.builder(
                              itemCount: _.ongoingGigs.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15.0, vertical: 15),
                                  child: InkWell(
                                      onTap: () {
                                        Get.to(() => OngoingItemView(
                                            _.ongoingGigs[index]));
                                      },
                                      child: OngoingItem(_.ongoingGigs[index])),
                                );
                              }),
                        ),
                );
        });
  }
}
