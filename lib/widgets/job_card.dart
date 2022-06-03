import 'package:easily/models/gig_model.dart';
import 'package:easily/widgets/responsive.dart';
import 'package:easily/widgets/size_config.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;

class JobCard extends StatelessWidget {
  bool hasImage;
  GigModel gigModel;
  JobCard(this.gigModel, {this.hasImage = false, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
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
        padding: const EdgeInsets.all(15.0),
        child: Column(children: [
          if (hasImage) ...[
            Container(
              height: 150,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      fit: BoxFit.contain,
                      image: NetworkImage(gigModel.images![0]!)),
                  boxShadow: [
                    BoxShadow(
                        color: Color.fromARGB(255, 248, 246, 246),
                        blurRadius: 10,
                        offset: Offset(5, 5),
                        spreadRadius: 4),
                  ],
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15)),
            ),
            SizedBox(
              height: 15,
            ),
          ],
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                  child: Text(
                gigModel.title ?? "loading...",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              )),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                      DateTime.parse(gigModel.deadline!).day ==
                              DateTime.now().day
                          ? "due at"
                          : "due on",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: Colors.red[400])),
                  Text(
                      DateTime.parse(gigModel.deadline!).day ==
                              DateTime.now().day
                          ? DateFormat('HH:mm')
                              .format(DateTime.parse(gigModel.deadline!))
                          : DateFormat('dd, MMM')
                              .format(DateTime.parse(gigModel.deadline!)),
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: Colors.red[400]))
                ],
              )
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            children: [
              Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.amber[50]),
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Text(
                      gigModel.type ?? "",
                      style: TextStyle(color: Colors.amber[500]),
                    ),
                  )),
              if (gigModel.isRemote ?? false) ...[
                SizedBox(
                  width: 10,
                ),
                Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.green[50]),
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Text(
                        "remote",
                        style: TextStyle(color: Colors.green[500]),
                      ),
                    ))
              ]
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                flex: 3,
                child: Text(
                  "you earn: \u{20B9}${gigModel.baseAmount}",
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
              Flexible(
                flex: 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Flexible(
                          flex: 5,
                          child: Text(
                            gigModel.createdBy!.username!.substring(0, 11) +
                                '...',
                            // overflow: TextOverflow.fade,
                            style: TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 12),
                          ),
                        ),
                        gigModel.createdBy!.phoneNumber != null
                            ? SizedBox()
                            : Flexible(
                                flex: 1,
                                child: Tooltip(
                                    message: "unverified",
                                    child: Icon(
                                      Icons.verified,
                                      size: 13,
                                      color: gigModel.createdBy!.phoneNumber ==
                                              null
                                          ? Colors.grey
                                          : Colors.green,
                                    ))),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          gigModel.createdBy!.rating == 0
                              ? '.'
                              : ' ${(gigModel.createdBy!.rating! / gigModel.createdBy!.numberOfRatings!).toStringAsFixed(2)}',
                          style: TextStyle(
                              fontSize: 12, fontWeight: FontWeight.bold),
                        ),
                        Icon(
                          Icons.star,
                          size: 14,
                          color: Colors.yellow,
                        )
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
          Text(
            "posted ${timeago.format(DateTime.parse(gigModel.createdAt!))}",
            style: TextStyle(fontWeight: FontWeight.w200, fontSize: 11),
          ),
        ]),
      ),
    );
  }
}
