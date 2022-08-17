import 'dart:math';
import 'dart:ui';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:confetti/confetti.dart';
import 'package:easily/models/gig_model.dart';
import 'package:easily/pages/chats/chat_page.dart';
import 'package:easily/pages/homepage/home_ctrl.dart';
import 'package:easily/pages/homepage/photo_viewer.dart';
import 'package:easily/pages/profile2/profile2.dart';
import 'package:easily/services/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';

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
            floatingActionButton: FloatingActionButton.extended(onPressed: (){
              Share.share('check out my website https://minigigs.in');
            }, backgroundColor: favColor,icon: const Icon(Icons.share),label: const Text('share')),
            appBar: AppBar(
              
              centerTitle: true,
              shadowColor: Colors.transparent,
              backgroundColor: Colors.white,
              title: const Text(
                "details",
                style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              ),
            ),
            body: Stack(
              children: [
                Container(
                  decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(20),
                          topLeft: Radius.circular(20))),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15.0, vertical: 20),
                    child: ListView(children: [
                      if (widget.gigModel.images!.isNotEmpty) ...[
                        CarouselSlider(
                          options: CarouselOptions(
                            height: 200,
                            aspectRatio: 16 / 9,
                            viewportFraction: 0.8,
                            initialPage: 0,
                            enableInfiniteScroll: false,
                            reverse: false,
                            autoPlay: false,
                            autoPlayInterval: const Duration(seconds: 3),
                            autoPlayAnimationDuration:
                                const Duration(milliseconds: 800),
                            autoPlayCurve: Curves.fastOutSlowIn,
                            enlargeCenterPage: true,
                            // onPageChanged: callbackFunction,
                            scrollDirection: Axis.horizontal,
                          ),
                          items: widget.gigModel.images!.map((i) {
                            return Builder(
                              builder: (BuildContext context) {
                                return InkWell(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            GalleryPhotoViewWrapper(
                                          galleryItems: widget.gigModel.images!,
                                          backgroundDecoration:
                                              const BoxDecoration(
                                            color: Colors.black,
                                          ),
                                          initialIndex: widget.gigModel.images!
                                              .indexOf(i),
                                          scrollDirection: Axis.horizontal,
                                        ),
                                      ),
                                    );
                                  },
                                  child: Material(
                                    // elevation: 6,
                                    // borderRadius: BorderRadius.circular(15),
                                    child: Container(
                                        width: MediaQuery.of(context).size.width,
                                        margin: const EdgeInsets.symmetric(
                                            horizontal: 5.0),
                                        decoration: BoxDecoration(
                                            image: DecorationImage(
                                                fit: BoxFit.fitHeight,
                                                image: NetworkImage(i ?? "")),
                                            boxShadow: const [
                                              BoxShadow(
                                                  color: Color.fromARGB(
                                                      255, 248, 246, 246),
                                                  blurRadius: 4,
                                                  offset: Offset(0, 3),
                                                  spreadRadius: 5),
                                            ],
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(15)),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            ClipRect(
                                                child: BackdropFilter(
                                              filter: ImageFilter.blur(
                                                  sigmaX: 10.0, sigmaY: 10.0),
                                              child: Container(
                                                width: 40.0,
                                                height: 20.0,
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(5),
                                                    color: Colors.grey.shade200
                                                        .withOpacity(0.2)),
                                                child: Center(
                                                  child: Text(
                                                      '${widget.gigModel.images!.indexOf(i) + 1}',
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .bodyMedium),
                                                ),
                                              ),
                                            )),
                                            const SizedBox(
                                              height: 5,
                                            )
                                          ],
                                        )),
                                  ),
                                );
                              },
                            );
                          }).toList(),
                        )
                      ],
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: [
                          Expanded(
                            flex: 5,
                            child: Text(
                              widget.gigModel.title ?? "",
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 17),
                            ),
                          ),
                            Expanded(
                              flex: 1,
                              child: Row(
                              children: [
                                                            Text('report',style: TextStyle(fontSize: 10),),
                            SizedBox(width: 2,),
                                Icon(Icons.report_gmailerrorred,color: Colors.red,size: 15,),
                              ],
                                                      ),
                            )
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      InkWell(
                        onTap: () {
                          if (widget.gigModel.createdBy != null) {
                            Get.to(() =>
                                Profile2(widget.gigModel.createdBy!.id ?? ""));
                          }
                        },
                        child: Row(
                          children: [
                            CircleAvatar(
                                backgroundColor: Colors.blue[300],
                                radius: 20,
                                backgroundImage: NetworkImage(
                                    widget.gigModel.createdBy!.img ?? "")),
                            const SizedBox(width: 5),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.gigModel.createdBy!.username ??
                                      "loading...",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 15),
                                ),
                                Row(
                                  children: [
                                    Text(
                                      widget.gigModel.createdBy!.rating == 0
                                          ? '.'
                                          : ' ${(widget.gigModel.createdBy!.rating! / widget.gigModel.createdBy!.numberOfRatings!).toStringAsFixed(2)}',
                                      style: const TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const Icon(
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
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Row(
                        children: [
                          const Text("you get: "),
                          Text(
                            '\u{20B9}' + widget.gigModel.baseAmount.toString(),
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 15),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Row(
                        children: [
                          const Text("city: "),
                          Text(
                            widget.gigModel.city ?? "",
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 15),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                       Row(
                        children: [
                          const Text("posted at: "),
                          Text(
                            DateFormat('dd, MMM HH:mm').format(
                                DateTime.parse(widget.gigModel.createdAt!)),
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 15),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          const Text("due at: "),
                          Text(
                            DateFormat('dd, MMM HH:mm').format(
                                DateTime.parse(widget.gigModel.deadline!)),
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 15),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          const Text("location: "),
                          Expanded(
                              child: Text(widget.gigModel.location ?? "remote",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15))),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          const Text("type: "),
                          Text(
                            widget.gigModel.type ?? "misscl.",
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 15),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                        decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 227, 224, 227),
                            borderRadius: BorderRadius.circular(10)),
                        child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text("more info :",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600)),
                                const SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  widget.gigModel.description ?? "",
                                  style: const TextStyle(fontSize: 16),
                                ),
                              ],
                            )),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      widget.gigModel.acceptedBy!.id != _.authCtrl.user.id
                          ? const SizedBox()
                          : Container(
                              decoration: BoxDecoration(
                                  color:
                                      const Color.fromARGB(255, 227, 224, 227),
                                  borderRadius: BorderRadius.circular(10)),
                              child: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text("imp data :",
                                          style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.red,
                                              fontWeight: FontWeight.w600)),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        widget.gigModel.impData ?? "",
                                        style: const TextStyle(fontSize: 16),
                                      ),
                                    ],
                                  )),
                            ),
                      const SizedBox(
                        height: 10,
                      ),
                      if (_.authCtrl.user.id != null &&
                          widget.gigModel.acceptedBy!.id ==
                              _.authCtrl.user.id) ...[
                        InkWell(
                          onTap: () async {
                            if (widget.gigModel.createdBy != null) {
                              final channel = _.authCtrl.client
                                  .channel('messaging', id: widget.gigModel.id);
                              await channel.watch();
                              Get.to(() => ChatPage(widget.gigModel,
                                  client: _.authCtrl.client, channel: channel));
                            }
                          },
                          child: Container(
                              width: 150,
                              decoration: BoxDecoration(
                                  color:
                                      const Color.fromARGB(255, 108, 33, 229),
                                  borderRadius: BorderRadius.circular(20)),
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const [
                                    Icon(
                                      Icons.chat_bubble_outline,
                                      color: Colors.white,
                                      size: 18,
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      'chat',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 16),
                                    )
                                  ],
                                ),
                              )),
                        )
                      ],
                      const SizedBox(
                        height: 10,
                      ),
                      InkWell(
                          onTap: () async {
                            //confirmation alert to check it ..
                            //plese accept it only if you are very sure that yoyu can do ti
                            if (_.authCtrl.user.id != null) {
                              if (widget.gigModel.createdBy!.id ==
                                  _.authCtrl.user.id) {
                                Get.back();
                                Get.snackbar("well well well",
                                    "lets not try to accept our own gig 😅");
                                // Get.back();
                                return;
                              }
                              if (widget.gigModel.acceptedBy!.id ==
                                  _.authCtrl.user.id) {
                                _.controllerBottomCenter.play();
                                Get.snackbar("already accepted",
                                    "you have already accepted this gig, lessgooo🥳");
                              } else {
                                await _.acceptGig(widget.gigModel.id,
                                            widget.gigModel.createdBy!.id) ==
                                        true
                                    ? widget.gigModel.acceptedBy =
                                        _.authCtrl.user
                                    : null;
                              }
                            } else {
                              Get.back();
                              Get.snackbar("login required",
                                  "please login from the side menu");
                            }
                          },
                          child: Material(
                            elevation: 6,
                            borderRadius: BorderRadius.circular(20),
                            child: Container(
                                width: 150,
                                decoration: BoxDecoration(
                                    color: const Color.fromARGB(255, 0, 0, 0),
                                    borderRadius: BorderRadius.circular(20)),
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Center(
                                      child: _.acceptLoading
                                          ? const CircularProgressIndicator(
                                              strokeWidth: 2,
                                              color: Colors.white,
                                            )
                                          : Text(
                                              widget.gigModel.acceptedBy!.id ==
                                                      _.authCtrl.user.id
                                                  ? 'accepted🔒'
                                                  : "accept gig",
                                              style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 16),
                                            )),
                                )),
                          )),
                      SizedBox(
                        height: 10,
                      )
                    ]),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: ConfettiWidget(
                    confettiController: _.controllerBottomCenter,
                    blastDirection: -pi / 2,
                    emissionFrequency: 0.008,
                    numberOfParticles: 30,
                    maxBlastForce: 80,
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
