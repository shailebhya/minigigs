import 'package:easily/models/gig_model.dart';
import 'package:easily/pages/homepage/home_ctrl.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../widgets/responsive.dart';
import '../../../widgets/size_config.dart';

class OngoingItem extends StatelessWidget {
  GigModel gig;
  OngoingItem(this.gig, {Key? key}) : super(key: key);
  final homeCtrl = Get.find<HomeCtrl>();
// show imp info only if created by you
  @override
  Widget build(BuildContext context) {
    return Container(
      // height: 110,
      width: Responsive.isDesktop(context)
          ? getProportionateScreenWidth(100)
          : getProportionateScreenWidth(200),
      decoration: BoxDecoration(
          // border: Border(bottom: BorderSide(color: Colors.green)),
          boxShadow: const [
            BoxShadow(
                color: Color.fromARGB(255, 248, 246, 246),
                blurRadius: 4,
                offset: Offset(0, 3),
                spreadRadius: 5),
          ], color: Colors.white, borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(
            gig.title ?? "",
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            children: [
              Text("due at: "),
              Text(
                DateFormat('HH:mm, dd MMM ')
                    .format(DateTime.parse(gig.deadline!)),
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          //if created by some other person then show  this
          Row(
            children: [
              Text("created at: "),
              Text(
                DateFormat('HH:mm, dd MMM ')
                    .format(DateTime.parse(gig.createdAt!)),
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            children: [
              Text("created by: "),
              Text(
                gig.createdBy!.id == homeCtrl.authCtrl.user.id
                    ? 'you'
                    : gig.createdBy!.username ?? "",
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Center(
            child: Container(
              // width: SizeConfig.screenWidth * 0.8,
              height: 1,
              color: true
                  ? Colors.green.withOpacity(0.5)
                  : Colors.red.withOpacity(0.5),
            ),
          )
        ]),
      ),
    );
  }
}
