import 'dart:ui';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:easily/models/gig_model.dart';
import 'package:easily/pages/homepage/home_ctrl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class OngoingItemView extends StatelessWidget {
  GigModel gig;
  OngoingItemView(this.gig, {Key? key}) : super(key: key);
  final homeCtrl = Get.find<HomeCtrl>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        shadowColor: Colors.transparent,
        backgroundColor: Colors.grey[50],
        actions: [
          Padding(
              padding: const EdgeInsets.only(right: 10.0),
              child: PopupMenuButton(
                  icon: Icon(
                    Icons.more_vert_rounded,
                    color: Colors.black,
                  ),
                  itemBuilder: (context) => [
                        PopupMenuItem(
                          child: Text(
                            "cancel gig",
                            style: TextStyle(fontSize: 18, color: Colors.red),
                          ),
                          value: 1,
                        ),
                      ]))
        ],
        title: Text(
          "details",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(20), topLeft: Radius.circular(20))),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20),
          child: ListView(children: [
            if (gig.images!.isNotEmpty) ...[
              CarouselSlider(
                options: CarouselOptions(
                  height: 200,
                  aspectRatio: 16 / 9,
                  viewportFraction: 0.8,
                  initialPage: 0,
                  enableInfiniteScroll: false,
                  reverse: false,
                  autoPlay: false,
                  autoPlayInterval: Duration(seconds: 3),
                  autoPlayAnimationDuration: Duration(milliseconds: 800),
                  autoPlayCurve: Curves.fastOutSlowIn,
                  enlargeCenterPage: true,
                  // onPageChanged: callbackFunction,
                  scrollDirection: Axis.horizontal,
                ),
                items: gig.images!.map((i) {
                  return Builder(
                    builder: (BuildContext context) {
                      return Container(
                          width: MediaQuery.of(context).size.width,
                          margin: EdgeInsets.symmetric(horizontal: 5.0),
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  fit: BoxFit.fitHeight,
                                  image: NetworkImage(i ?? "")),
                              boxShadow: [
                                BoxShadow(
                                    color: Color.fromARGB(255, 248, 246, 246),
                                    blurRadius: 4,
                                    offset: Offset(0, 3),
                                    spreadRadius: 5),
                              ],
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15)),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              new ClipRect(
                                  child: new BackdropFilter(
                                filter: new ImageFilter.blur(
                                    sigmaX: 10.0, sigmaY: 10.0),
                                child: new Container(
                                  width: 40.0,
                                  height: 20.0,
                                  decoration: new BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      color: Colors.grey.shade200
                                          .withOpacity(0.2)),
                                  child: new Center(
                                    child: new Text(
                                        '${gig.images!.indexOf(i) + 1}',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium),
                                  ),
                                ),
                              )),
                              SizedBox(
                                height: 5,
                              )
                            ],
                          ));
                    },
                  );
                }).toList(),
              )
            ],
            SizedBox(
              height: 20,
            ),
            Text(
              gig.title ?? "",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
            ),

            SizedBox(
              height: 15,
            ),

            Row(
              children: [
                Text("created by: "),
                Text(
                  gig.createdBy!.username ?? "",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Text(gig.createdBy!.id == homeCtrl.authCtrl.user.id
                    ? "you pay: "
                    : "you'll earn: "),
                Text(
                  '\u{20B9}' + gig.baseAmount.toString(),
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
              ],
            ),

            SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Text("city: "),
                Text(
                  gig.city ?? "",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Text("created at: "),
                Text(
                  DateFormat('dd, MMM HH:mm')
                      .format(DateTime.parse(gig.createdAt!)),
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Text("due at: "),
                Text(
                  DateFormat('dd, MMM HH:mm')
                      .format(DateTime.parse(gig.deadline!)),
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Text("location: "),
                Expanded(
                    child: Text("Manipal Institute Of Technology",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 15))),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Text("type: "),
                Text(
                  gig.type ?? "",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),

            //
            //
            //
            //
            //************show only if  this was the client************* */
            //
            //
            //
            //
            //
            //

            Container(
              decoration: BoxDecoration(
                  color: Color.fromARGB(255, 227, 224, 227),
                  borderRadius: BorderRadius.circular(20)),
              child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("more info :",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w600)),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        gig.description ?? "",
                        style: TextStyle(fontSize: 18),
                      ),
                    ],
                  )),
            ),
            SizedBox(
              height: 10,
            ),

            //
            //
            //
            //
            //************dont show imp info if user didnt create the order ************* */
            //
            //
            //
            //
            //
            //
            false
                ? SizedBox()
                : Container(
                    decoration: BoxDecoration(
                        color: Color.fromARGB(255, 227, 224, 227),
                        borderRadius: BorderRadius.circular(20)),
                    child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("imp data :",
                                style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.red,
                                    fontWeight: FontWeight.w600)),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              gig.impData ?? "",
                              style: TextStyle(fontSize: 18),
                            ),
                          ],
                        )),
                  ),
            SizedBox(
              height: 20,
            ),

            if (gig.createdBy!.id == homeCtrl.authCtrl.user.id) ...[
              InkWell(
                onTap: () {
                  showDialog(
                      context: context,
                      barrierDismissible: true,
                      builder: (context) {
                        return Center(
                          child: AlertDialog(
                            scrollable: true,
                            content: Column(
                              children: [
                                Text(
                                    "appreciate ${gig.createdBy!.username}'s work by rating"),
                                SizedBox(
                                  height: 10,
                                ),
                                RatingBar.builder(
                                  initialRating: 3,
                                  minRating: 1,
                                  direction: Axis.horizontal,
                                  allowHalfRating: true,
                                  itemCount: 5,
                                  itemPadding:
                                      EdgeInsets.symmetric(horizontal: 4.0),
                                  itemBuilder: (context, _) => Icon(
                                    Icons.star,
                                    color: Colors.amber,
                                  ),
                                  onRatingUpdate: (rating) {
                                    homeCtrl.rating = rating;
                                  },
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                InkWell(
                                  onTap: () {
                                    homeCtrl.authCtrl
                                        .updateUserDb({}, gig.createdBy!);
                                  },
                                  child: Container(
                                      decoration: BoxDecoration(
                                          boxShadow: [
                                            BoxShadow(
                                                color: Color.fromARGB(
                                                    255, 248, 246, 246),
                                                blurRadius: 4,
                                                offset: Offset(0, 3),
                                                spreadRadius: 5),
                                          ],
                                          border:
                                              Border.all(color: Colors.grey),
                                          color: Colors.black,
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          'submit',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      )),
                                )
                              ],
                            ),
                          ),
                        );
                      });
                },
                child: Container(
                    width: 150,
                    decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                              color: Color.fromARGB(255, 248, 246, 246),
                              blurRadius: 4,
                              offset: Offset(0, 3),
                              spreadRadius: 5),
                        ],
                        border: Border.all(color: Colors.grey),
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(20)),
                    child: const Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Center(
                          child: Text(
                        "completed",
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      )),
                    )),
              ),
            ],
            SizedBox(
              height: 10,
            ),
          ]),
        ),
      ),
    );
  }
}
