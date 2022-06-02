import 'package:easily/pages/auth/auth.dart';
import 'package:easily/pages/auth/auth_ctrl.dart';
import 'package:easily/widgets/size_config.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:liquid_swipe/liquid_swipe.dart';

import '../../homepage/homepage.dart';

class LoginPage extends StatelessWidget {
  LoginPage({Key? key}) : super(key: key);
  final authCtrl = Get.find<AuthCtrl>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(children: [
        Expanded(
            flex: 5,
            child: Padding(
              padding: const EdgeInsets.only(
                  left: 40.0, right: 40, top: 60, bottom: 60),
              child: Container(
                child: Builder(builder: (context) {
                  return LiquidSwipe(
                    slideIconWidget: const Icon(
                      Icons.chevron_left_sharp,
                      color: Colors.transparent,
                    ),
                    enableSideReveal: true,
                    pages: [
                      Container(
                        decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(20)),
                      ),
                      Container(
                        decoration: BoxDecoration(
                            color: Colors.grey[600],
                            borderRadius: BorderRadius.circular(20)),
                      )
                    ],
                  );
                }),
                decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(20)),
              ),
            )),
        Expanded(
            flex: 2,
            child: Container(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                        onTap: ()async =>await  authCtrl.googleLogin(),
                        child: Container(
                          width: SizeConfig.screenWidth / 1.5,
                          height: SizeConfig.screenHeight / 17,
                          decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(10)),
                          child: Center(
                              child: Text(
                            "sign in with google",
                            style: TextStyle(color: Colors.white, fontSize: 17),
                          )),
                        )),
                    InkWell(
                      onTap: () {
                        // Get.to(() =>
                        //     VerifyPhoneNumberScreen(phoneNumber: '+91 93347 41294'));
                      },
                      child: Container(
                        width: SizeConfig.screenWidth / 1.5,
                        height: SizeConfig.screenHeight / 17,
                        decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(10)),
                        child: Center(
                            child: Text(
                          "sign in with phone number",
                          style: TextStyle(color: Colors.white, fontSize: 17),
                        )),
                      ),
                    ),
                    Container(
                      height: SizeConfig.screenHeight / 12,
                    )
                  ]),
            ))
      ]),
    );
  }
}
