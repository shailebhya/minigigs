import 'dart:math';
import 'dart:ui';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:confetti/confetti.dart';
import 'package:easily/demo.dart';
import 'package:easily/models/gig_model.dart';
import 'package:easily/pages/auth/auth_ctrl.dart';
import 'package:easily/pages/chats/chat_page.dart';
import 'package:easily/pages/homepage/home_ctrl.dart';
import 'package:easily/services/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../widgets/responsive.dart';
import '../../widgets/size_config.dart';

class JobDetails extends StatefulWidget {
  GigModel gigModel;
  JobDetails(this.gigModel, {Key? key}) : super(key: key);

  @override
  State<JobDetails> createState() => _JobDetailsState();
}

class _JobDetailsState extends State<JobDetails> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeCtrl>(
        id: jobDetailsId,
        builder: (_) {
          return Scaffold(
            appBar: AppBar(
              centerTitle: true,
              shadowColor: Colors.transparent,
              backgroundColor: Colors.grey[50],
              title: Text(
                "Details",
                style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              ),
            ),
            body: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(20),
                          topLeft: Radius.circular(20))),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15.0, vertical: 20),
                    child: ListView(children: [
                      if (widget.gigModel.images!.isNotEmpty)...[CarouselSlider(
                        options: CarouselOptions(
                          height: 200,
                          aspectRatio: 16 / 9,
                          viewportFraction: 0.8,
                          initialPage: 0,
                          enableInfiniteScroll: false,
                          reverse: false,
                          autoPlay: false,
                          autoPlayInterval: Duration(seconds: 3),
                          autoPlayAnimationDuration:
                              Duration(milliseconds: 800),
                          autoPlayCurve: Curves.fastOutSlowIn,
                          enlargeCenterPage: true,
                          // onPageChanged: callbackFunction,
                          scrollDirection: Axis.horizontal,
                        ),
                        items: widget.gigModel.images!.map((i) {
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
                                            color: Color.fromARGB(
                                                255, 248, 246, 246),
                                            blurRadius: 4,
                                            offset: Offset(0, 3),
                                            spreadRadius: 5),
                                      ],
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(15)),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      new ClipRect(
                                          child: new BackdropFilter(
                                        filter: new ImageFilter.blur(
                                            sigmaX: 10.0, sigmaY: 10.0),
                                        child: new Container(
                                          width: 40.0,
                                          height: 20.0,
                                          decoration: new BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              color: Colors.grey.shade200
                                                  .withOpacity(0.2)),
                                          child: new Center(
                                            child: new Text(
                                                '${widget.gigModel.images!.indexOf(i)+1}',
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
                      )],
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        widget.gigModel.title ?? "",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 17),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          CircleAvatar(
                              backgroundColor: Colors.blue[300],
                              radius: 20,
                              backgroundImage: NetworkImage(
                                  widget.gigModel.createdBy!.img ?? "")),
                          SizedBox(width: 5),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.gigModel.createdBy!.username ??
                                    "loading...",
                                style: TextStyle(
                                    fontWeight: FontWeight.w600, fontSize: 15),
                              ),
                              Row(
                                children: [
                                  Text(
                                    widget.gigModel.createdBy!.rating == 0
                                        ? '.'
                                        : ' ${(widget.gigModel.createdBy!.rating! / widget.gigModel.createdBy!.numberOfRatings!).toStringAsFixed(2)}',
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Icon(
                                    Icons.star,
                                    size: 20,
                                    color: Color.fromARGB(255, 246, 222, 2),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Row(
                        children: [
                          Text("you get: "),
                          Text(
                            '\u{20B9}' + widget.gigModel.baseAmount.toString(),
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 15),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Row(
                        children: [
                          Text("city: "),
                          Text(
                            widget.gigModel.city ?? "",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 15),
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
                            DateFormat('dd, MMM HH:mm').format(
                                DateTime.parse(widget.gigModel.deadline!)),
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 15),
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
                              child: Text(widget.gigModel.location ?? "remote",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15))),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          Text("type: "),
                          Text(
                            widget.gigModel.type ?? "misscl.",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 15),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
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
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600)),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  widget.gigModel.description ?? "",
                                  style: TextStyle(fontSize: 18),
                                ),
                              ],
                            )),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      widget.gigModel.acceptedBy!.id == null
                          ? SizedBox()
                          : Container(
                              decoration: BoxDecoration(
                                  color: Color.fromARGB(255, 227, 224, 227),
                                  borderRadius: BorderRadius.circular(20)),
                              child: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                     const Text("imp data :",
                                          style: TextStyle(
                                              fontSize: 18,
                                              color: Colors.red,
                                              fontWeight: FontWeight.w600)),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                      widget.gigModel.impData??"",
                                        style: TextStyle(fontSize: 18),
                                      ),
                                    ],
                                  )),
                            ),
                      SizedBox(
                        height: 10,
                      ),
                      if( _.authCtrl.user.id != null &&   widget.gigModel.acceptedBy!.id ==
                                        _.authCtrl.user.id)...[ InkWell(
                                          onTap:()=> Get.to(()=>const ChatPage()),
                                          child: Container(
                                                                    width: 150,
                                                                    decoration: BoxDecoration(
                                                                        color: Color.fromARGB(255, 108, 33, 229),
                                                                        borderRadius: BorderRadius.circular(20)),
                                                                    child: Padding(
                                                                      padding: EdgeInsets.all(10.0),
                                                                      child: Row(
                                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                                        children:const [
                                                                         Icon(Icons.chat_bubble_outline,color: Colors.white,),SizedBox(width: 10,), Text(   'chat',
                                                                            style: TextStyle(
                                                                            color: Colors.white, fontSize: 21),
                                                                          )
                                                                        ],
                                                                      ),
                                                                    )),
                                        )],    const  SizedBox(
                        height: 10,
                      ),
                      InkWell(
                        onTap: () async {
                          //confirmation alert to check it ..
                          //plese accept it only if you are very sure that yoyu can do ti
                          if (_.authCtrl.user.id != null) {
                            if (widget.gigModel.acceptedBy!.id ==
                                _.authCtrl.user.id) {
                              _.controllerBottomCenter.play();
                              Get.snackbar("success",
                                  "you have already accepted this gig, lessgooo🥳");
                            } else {
                              await _.acceptGig(widget.gigModel.id);
                              widget.gigModel.acceptedBy = _.authCtrl.user;
                            }
                          } else {
                            Get.back();
                            Get.snackbar("login required",
                                "please login from the side menu");
                          }
                        },
                        child: Container(
                            width: 150,
                            decoration: BoxDecoration(
                                color: Color.fromARGB(255, 0, 0, 0),
                                borderRadius: BorderRadius.circular(20)),
                            child: Padding(
                              padding: EdgeInsets.all(10.0),
                              child: Center(
                                  child: Text(
                             _.authCtrl.user.id != null &&   widget.gigModel.acceptedBy!.id ==
                                        _.authCtrl.user.id
                                    ? 'accepted🔒'
                                    : "accept gig",
                                style:const TextStyle(
                                    color: Colors.white, fontSize: 18),
                              )),
                            )),
                      ),
                    ]),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: ConfettiWidget(
                    confettiController: _.controllerBottomCenter,
                    blastDirection: -pi / 2,
                    emissionFrequency: 0.01,
                    numberOfParticles: 30,
                    maxBlastForce: 120,
                    minBlastForce: 70,
                    gravity: 0.01,
                  ),
                ),
              ],
            ),
          );
        });
  }
}
