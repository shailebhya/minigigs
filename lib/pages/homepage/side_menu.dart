import 'package:easily/models/user_model.dart';
import 'package:easily/pages/auth/auth_ctrl.dart';
import 'package:easily/pages/drawer/history/history.dart';
import 'package:easily/pages/drawer/ongoing/ongoing.dart';
import 'package:easily/services/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../widgets/responsive.dart';
import '../../widgets/size_config.dart';
import '../drawer/profile/profile.dart';
// import 'package:flutter_svg/flutter_svg.dart';

class SideMenu extends StatefulWidget {
  SideMenu({
    Key? key,
  }) : super(key: key);

  @override
  State<SideMenu> createState() => _SideMenuState();
}

class _SideMenuState extends State<SideMenu> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<AuthCtrl>(
        id: sideMenuId,
        builder: (_) {
          return Drawer(
            elevation: Responsive.isDesktop(context) ? 0 : 16,
            child: ListView(
              children: [
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: InkWell(
                    onTap: () async {
                      _.user.id != null
                          ? Get.to(() => Profile())
                          : await _.googleLogin();
                    },
                    child: _.user.id != null
                        ? Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                                Expanded(
                                  flex: 1,
                                  child: CircleAvatar(
                                    backgroundColor: Colors.grey[200],
                                    radius: 75,
                                    child: Container(
                                        decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            image: DecorationImage(
                                                image:
                                                    NetworkImage(_.user.img!),
                                                fit: BoxFit.contain))),
                                    // backgroundImage:  _.user.img==null?null:NetworkImage(_.user.img!),
                                  ),
                                ),
                                SizedBox(
                                  width: 15,
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        _.user.username ?? "username",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 18),
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            !(_.user.rating! /
                                                        _.user.numberOfRatings!)
                                                    .isNaN
                                                ? "${_.user.rating! / _.user.numberOfRatings!}"
                                                : "0",
                                            style: TextStyle(fontSize: 16),
                                          ),
                                          Icon(
                                            Icons.star,
                                            size: 25,
                                            color: Color.fromARGB(
                                                255, 246, 222, 2),
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ])
                        : Center(
                            child: Text(
                              "login/signup",
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w600),
                            ),
                          ),
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Container(
                  height: SizeConfig.screenHeight,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(30),
                          topLeft: Radius.circular(30))),
                  child: Padding(
                    padding: const EdgeInsets.all(30.0),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (_.user.id != null) ...[
                            InkWell(
                              onTap: () {
                                Get.to(() => Ongoing());
                              },
                              child: Text(
                                "ongoing ",
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.w600),
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            InkWell(
                              onTap: () {
                                Get.to(() => History());
                              },
                              child: Text(
                                "history",
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.w600),
                              ),
                            ),
                          ],
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            "privacy policy",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w600),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            "suggestions",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w600),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            "about me",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w600),
                          ),
                          if (_.user.id != null) ...[
                            SizedBox(
                              height: 20,
                            ),
                            InkWell(
                              onTap: () {
                                // _.user = UserModel();
                                _.googleLogout();
                                setState(() {});
                              },
                              child: Text(
                                "log out",
                                style: TextStyle(
                                    color: Colors.red,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                          ],
                          SizedBox(
                            height: 20,
                          ),
                        ]),
                  ),
                )
              ],
            ),
          );
        });
  }
}

class Responsive0 {}

class DrawerListTile extends StatelessWidget {
  const DrawerListTile({
    Key? key,
    // For selecting those three line once press "Command+D"
    required this.title,
    required this.icon,
    required this.press,
  }) : super(key: key);

  final String title;
  final IconData icon;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: press,
      horizontalTitleGap: 0.0,
      leading: Icon(
        icon,
        color: Colors.black,
        size:
            Responsive.isDesktop(context) ? getProportionateScreenWidth(5) : 16,
      ),
      title: Text(
        title,
        style: const TextStyle(color: Colors.black),
      ),
    );
  }
}
