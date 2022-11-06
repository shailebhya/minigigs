import 'dart:developer';
import 'dart:ui';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:easily/models/gig_model.dart';
import 'package:easily/models/review_model.dart';
import 'package:easily/pages/homepage/home_ctrl.dart';
import 'package:easily/pages/homepage/photo_viewer.dart';
import 'package:easily/widgets/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../chats/chat_page.dart';

class OngoingItemView extends StatefulWidget {
  GigModel gig;
  OngoingItemView(this.gig, {Key? key}) : super(key: key);

  @override
  State<OngoingItemView> createState() => _OngoingItemViewState();
}

class _OngoingItemViewState extends State<OngoingItemView> {
  final homeCtrl = Get.find<HomeCtrl>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    homeCtrl.rating = 3;
    homeCtrl.reviewCtrl = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: widget.gig.acceptedBy!.id != null
          ? FloatingActionButton.extended(
              backgroundColor: const Color.fromARGB(255, 108, 33, 229),
              onPressed: () async {
                if (widget.gig.createdBy != null) {
                  final channel = homeCtrl.authCtrl.client
                      .channel('messaging', id: widget.gig.id);
                  await channel.watch();
                  Get.to(() => ChatPage(widget.gig,
                      client: homeCtrl.authCtrl.client, channel: channel));
                }
              },
              icon: const Icon(Icons.chat_bubble),
              label: const Text("chat"))
          : null,
      appBar: AppBar(
        centerTitle: true,
        shadowColor: Colors.transparent,
        backgroundColor: Colors.white,
        actions: [
          Padding(
              padding: const EdgeInsets.only(right: 10.0),
              child: PopupMenuButton(
                  shape: Theme.of(context).floatingActionButtonTheme.shape,
                  color: Colors.red,
                  icon: const Icon(
                    Icons.more_vert_rounded,
                    color: Colors.black,
                  ),
                  itemBuilder: (context) => [
                        const PopupMenuItem(
                          value: 1,
                          child: Center(
                            child: Text(
                              "cancel gig",
                              style:
                                  TextStyle(fontSize: 18, color: Colors.white),
                            ),
                          ),
                        ),
                      ]))
        ],
        title: const Text(
          "details",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(20), topLeft: Radius.circular(20))),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20),
          child: ListView(children: [
            if (widget.gig.images!.isNotEmpty) ...[
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
                  autoPlayAnimationDuration: const Duration(milliseconds: 800),
                  autoPlayCurve: Curves.fastOutSlowIn,
                  enlargeCenterPage: true,
                  // onPageChanged: callbackFunction,
                  scrollDirection: Axis.horizontal,
                ),
                items: widget.gig.images!.map((i) {
                  return Builder(
                    builder: (BuildContext context) {
                      return InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => GalleryPhotoViewWrapper(
                                galleryItems: widget.gig.images!,
                                backgroundDecoration: const BoxDecoration(
                                  color: Colors.black,
                                ),
                                initialIndex: widget.gig.images!.indexOf(i),
                                scrollDirection: Axis.horizontal,
                              ),
                            ),
                          );
                        },
                        child: Container(
                            width: MediaQuery.of(context).size.width,
                            margin: const EdgeInsets.symmetric(horizontal: 5.0),
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    fit: BoxFit.fitHeight,
                                    image: NetworkImage(i ?? "")),
                                boxShadow: const [
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
                                ClipRect(
                                    child: BackdropFilter(
                                  filter: ImageFilter.blur(
                                      sigmaX: 10.0, sigmaY: 10.0),
                                  child: Container(
                                    width: 40.0,
                                    height: 20.0,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        color: Colors.grey.shade200
                                            .withOpacity(0.2)),
                                    child: Center(
                                      child: Text(
                                          '${widget.gig.images!.indexOf(i) + 1}',
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
                      );
                    },
                  );
                }).toList(),
              )
            ],
            const SizedBox(
              height: 20,
            ),
            Text(
              widget.gig.title ?? "",
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
            ),

            const SizedBox(
              height: 15,
            ),

            Row(
              children: [
                const Text("created by: "),
                Text(
                  widget.gig.createdBy!.username ?? "",
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
                Text(widget.gig.createdBy!.id == homeCtrl.authCtrl.user.id
                    ? "you pay: "
                    : "you'll earn: "),
                Text(
                  '\u{20B9}${widget.gig.baseAmount}',
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
                const Text("city: "),
                Text(
                  widget.gig.city ?? "",
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
                const Text("created at: "),
                Text(
                  DateFormat('HH:mm, dd MMM yy')
                      .format(DateTime.parse(widget.gig.createdAt!)),
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
                  DateFormat('HH:mm, dd MMM yy')
                      .format(DateTime.parse(widget.gig.deadline!)),
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 15),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              children: const [
                Text("location: "),
                Expanded(
                    child: Text("Manipal Institute Of Technology",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 15))),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              children: [
                const Text("type: "),
                Text(
                  widget.gig.type ?? "",
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 15),
                ),
              ],
            ),
            const SizedBox(
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
                  color: const Color.fromARGB(255, 242, 240, 242),
                  borderRadius: BorderRadius.circular(10)),
              child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("more info :",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w600)),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        widget.gig.description ?? "",
                        style: const TextStyle(fontSize: 18),
                      ),
                    ],
                  )),
            ),
            const SizedBox(
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
            widget.gig.impData!.isEmpty
                ? const SizedBox()
                : Container(
                    decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 242, 240, 242),
                        borderRadius: BorderRadius.circular(10)),
                    child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("imp data :",
                                style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.red,
                                    fontWeight: FontWeight.w600)),
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                              widget.gig.impData ?? "",
                              style: const TextStyle(fontSize: 18),
                            ),
                          ],
                        )),
                  ),
            //  const SizedBox(
            //     height: 20,
            //   ),
            const SizedBox(
              height: 10,
            ),
            if (widget.gig.acceptedBy!.id == homeCtrl.authCtrl.user.id ||
                widget.gig.createdBy!.id == homeCtrl.authCtrl.user.id &&
                    widget.gig.acceptedBy!.id != null) ...[
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
                                  "appreciate ${widget.gig.createdBy!.username} by rating them...",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                RatingBar.builder(
                                  itemSize: SizeConfig.screenHeight / 25,
                                  initialRating: 3,
                                  minRating: 1,
                                  direction: Axis.horizontal,
                                  allowHalfRating: true,
                                  itemCount: 5,
                                  itemPadding: const EdgeInsets.symmetric(
                                      horizontal: 4.0),
                                  itemBuilder: (context, _) => const Icon(
                                    Icons.star,
                                    color: Colors.amber,
                                  ),
                                  onRatingUpdate: (rating) {
                                    homeCtrl.rating = rating;
                                  },
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                                // Text('how was the experience?'),
                                TextFormField(
                                  // showCursor: true,
                                  controller: homeCtrl.reviewCtrl,
                                  maxLength: 300,
                                  minLines: 1,
                                  maxLines: 7,
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400),
                                  autovalidateMode: AutovalidateMode.always,
                                  decoration: const InputDecoration(
                                      // enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.black,width: 2),borderRadius: BorderRadius.all(Radius.circular(10))),
                                      focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.black, width: 1),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10))),
                                      hintText: "your feedback(optional)",
                                      hintStyle: TextStyle(fontSize: 13),
                                      fillColor: Colors.red,
                                      hintMaxLines: 2,
                                      labelText: 'feedback',
                                      labelStyle:
                                          TextStyle(color: Colors.black)),
                                  onSaved: (String? value) {
                                    // This optional block of code can be used to run
                                    // code when the user saves the form.
                                  },
                                  validator: (String? value) {
                                    return value!.contains('@')
                                        ? 'Do not use the @ char.'
                                        : null;
                                  },
                                ),
                                InkWell(
                                  onTap: () async {
                                    //** hello
                                    //*! close the messagin channel of this group
                                    // homeCtrl.authCtrl
                                    //     .updateUserDb({}, gig.createdBy!);
                                    //*!post review and complete the task

                                    await homeCtrl.completeGig(widget.gig);
                                    homeCtrl.postReview(
                                        widget.gig.createdBy!.id,
                                        widget.gig.id,
                                        widget.gig.acceptedBy!.id,
                                        widget.gig.acceptedBy!.username);
                                  },
                                  child: Material(
                                    elevation: 6,
                                    borderRadius: BorderRadius.circular(5),
                                    child: Container(
                                        width: SizeConfig.screenWidth / 5,
                                        decoration: BoxDecoration(
                                            border:
                                                Border.all(color: Colors.grey),
                                            color: Colors.black,
                                            borderRadius:
                                                BorderRadius.circular(5)),
                                        child: const Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: Center(
                                            child: Text(
                                              'submit',
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ),
                                        )),
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const [
                                    Icon(
                                      Icons.check_circle,
                                      color: Colors.green,
                                    ),
                                    SizedBox(
                                      width: 3,
                                    ),
                                    Text("thanks for the feedback!")
                                  ],
                                )
                              ],
                            ),
                          ),
                        );
                      });
                },
                child: Material(
                  elevation: 6,
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                      width: 150,
                      decoration: BoxDecoration(

                          // boxShadow: const [
                          //   BoxShadow(
                          //       color: Color.fromARGB(255, 248, 246, 246),
                          //       blurRadius: 4,
                          //       offset: Offset(0, 3),
                          //       spreadRadius: 5),
                          // ],

                          border: Border.all(color: Colors.grey),
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(20)),
                      child: const Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Center(
                            child: Text(
                          "completed",
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        )),
                      )),
                ),
              ),
            ],
            const SizedBox(
              height: 10,
            ),
          ]),
        ),
      ),
    );
  }
}
