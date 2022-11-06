import 'package:easily/pages/drawer/history/history_item.dart';
import 'package:easily/pages/drawer/history/history_item_view.dart';
import 'package:easily/pages/homepage/home_ctrl.dart';
import 'package:easily/services/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../widgets/size_config.dart';

class History extends StatefulWidget {
  const History({Key? key}) : super(key: key);

  @override
  State<History> createState() => _HistoryState();
}

class _HistoryState extends State<History> {
//if gig . accepted by someone and completed at is not null then status is ongoing
  final homeCtrl = Get.find<HomeCtrl>();
    RefreshController controller = RefreshController();

  @override
  void initState() {
    super.initState();
    homeCtrl.getHistoryGigs();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeCtrl>(
        id: historyListId,
        builder: (_) {
          return _.historyGigsLoading
              ? const Scaffold(
                  body: Center(
                      child: CircularProgressIndicator(
                    color: Colors.black,
                  )),
                )
              : Scaffold(
                  appBar: AppBar(
                    title: const Text("history",
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.w600)),
                    elevation: 0,
                    centerTitle: true,
                    backgroundColor: Colors.transparent,
                  ),
                  body: _.historyGigs.isEmpty
                      ? const Center(child: Text("let's make some history 😁"))
                      : SmartRefresher(
                         controller: controller,
                          onRefresh: () async => initState,
                          child: ListView.builder(
                              itemCount: _.historyGigs.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15.0, vertical: 15),
                                  child: InkWell(
                                      onTap: () {
                                        Get.to(() => const HistoryItemView());
                                      },
                                      child: const HistoryItem()),
                                );
                              }),
                        ),
                );
        });
  }
}
