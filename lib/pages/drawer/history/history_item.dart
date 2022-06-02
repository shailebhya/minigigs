import 'package:flutter/material.dart';

import '../../../widgets/responsive.dart';
import '../../../widgets/size_config.dart';

class HistoryItem extends StatelessWidget {
  const HistoryItem({Key? key}) : super(key: key);
// show imp info only if created by you
  @override
  Widget build(BuildContext context) {
    return Container(
      // height: 110,
      width: Responsive.isDesktop(context)
          ? getProportionateScreenWidth(100)
          : getProportionateScreenWidth(200),
      decoration: BoxDecoration(boxShadow: [
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
            "Brands.Cop Landing Page idea ",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            "completed on : 20 Jun ",
            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
          ),
          SizedBox(
            height: 10,
          ),
          //if created by some other person then show  this
          Text(
            "you earned: Rs.100",
            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            "created by: you",
            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
          ),
        ]),
      ),
    );
  }
}
