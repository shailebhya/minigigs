import 'package:easily/pages/auth/auth_ctrl.dart';
import 'package:easily/services/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../demo.dart';
import '../../profile2/review_card.dart';

class Profile extends StatelessWidget {
  const Profile({Key? key}) : super(key: key);
  // final authCtrl = Get.<AuthCtrl>find();
  @override
  Widget build(BuildContext context) {
    return GetBuilder<AuthCtrl>(
        id: profilePageId,
        builder: (_) {
          return Scaffold(
            appBar: AppBar(
                title: Text(
                  "my profile",
                  style: TextStyle(color: Colors.black),
                ),
                centerTitle: true,
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent),
            body: Padding(
              padding: const EdgeInsets.all(15.0),
              child: ListView(children: [
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.grey[200],
                          radius: 85,
                          child: Container(
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                      image: NetworkImage(_.user.img!),
                                      fit: BoxFit.contain))),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Flexible(
                              child: Text(
                                _.user.username ?? "username",
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    fontWeight: FontWeight.w600, fontSize: 20),
                              ),
                            ),
                            Flexible(
                                child: Tooltip(
                                    message: _.user.phoneNumber == null
                                        ? "unverified"
                                        : "verified",
                                    child: Icon(
                                      Icons.verified,
                                      color: _.user.phoneNumber == null
                                          ? Colors.grey
                                          : Colors.green,
                                    ))),

                            // Icon(Icons.mode_edit_outlined)
                          ],
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if (!(_.user.rating! / _.user.numberOfRatings!)
                                .isNaN) ...[
                              Text(
                                "${_.user.rating! / _.user.numberOfRatings!}",
                                style: TextStyle(fontSize: 16),
                              ),
                              Icon(
                                Icons.star,
                                size: 25,
                                color: Color.fromARGB(255, 246, 222, 2),
                              )
                            ] else
                              Text("no ratings yet"),
                          ],
                        ),
                      ]),
                ),
                SizedBox(
                  height: 15,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(30)),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40.0, vertical: 35),
                      child: Column(children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "full name : ",
                              style: TextStyle(
                                  fontWeight: FontWeight.w600, fontSize: 16),
                            ),
                            Expanded(
                              child: Text(
                                _.user.username ?? "",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "email addr. : ",
                              style: TextStyle(
                                  fontWeight: FontWeight.w600, fontSize: 16),
                            ),
                            Expanded(
                              child: Text(
                                _.user.email ?? "abc@gmail.com",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                            ),
                          ],
                        ),
                        // SizedBox(
                        //   height: 15,
                        // ),
                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.center,
                        //   children: [
                        //     Text(
                        //       "verified : ",
                        //       style: TextStyle(
                        //           fontWeight: FontWeight.w600, fontSize: 16),
                        //     ),
                        //     Expanded(
                        //       child: Text(
                        //         "true",
                        //         style: TextStyle(
                        //             fontWeight: FontWeight.bold, fontSize: 16),
                        //       ),
                        //     ),
                        //   ],
                        // ),
                        SizedBox(
                          height: 15,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "phone number : ",
                              style: TextStyle(
                                  fontWeight: FontWeight.w600, fontSize: 16),
                            ),
                            Expanded(
                              child: _.user.phoneNumber == null
                                  ? ConstrainedBox(
                                      constraints: BoxConstraints.tightFor(
                                          width: 30, height: 30),
                                      child: ElevatedButton(
                                          style: ButtonStyle(
                                              backgroundColor:
                                                  MaterialStateProperty.all(
                                                      Colors.black)),
                                          child: Text('add',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16)),
                                          onPressed: () {
                                            // Navigator.push(
                                            //   context,
                                            //   MaterialPageRoute(
                                            //     builder: (_) =>
                                            //         VerifyPhoneNumberScreen(
                                            //             phoneNumber:
                                            //                 '+919334741294'),
                                            //   ),
                                            // );
                                          }),
                                    )
                                  : Text(
                                      _.user.phoneNumber ?? "123456789",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16),
                                    ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "joined on : ",
                              style: TextStyle(
                                  fontWeight: FontWeight.w600, fontSize: 16),
                            ),
                            Expanded(
                              child: Text(
                                DateFormat('dd MMM yyyy')
                                    .format(DateTime.parse(_.user.joinedOn!)),
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Text(
                          _.user.phoneNumber == null
                              ? "note: get your profile verified by addding your ph. number!"
                              : "your profile is verified!",
                          style:const  TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 10),
                        )
                      ]),
                    ),
                  ),
                ),
                const  SizedBox(
                          height: 15,
                        ),
                         Row(mainAxisAlignment: MainAxisAlignment.center,
                           children: [
                             const Text(
                  "ratings & reviews",
                  style: TextStyle(fontSize: 20, color: Colors.grey),
                ),
                           ],
                         ),   const  SizedBox(
                          height: 10,
                        ),
                Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: 10,
                  itemBuilder: (context, index) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(vertical: 7.0),
                      child: ReviewCard(),
                    );
                  }),
            )
              ]),
            ),
          );
        });
  }
}
