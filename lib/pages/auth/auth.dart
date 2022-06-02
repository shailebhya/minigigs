import 'package:easily/demo.dart';
import 'package:easily/pages/auth/auth_ctrl.dart';
import 'package:easily/pages/auth/pages/login.dart';
import 'package:easily/pages/homepage/homepage.dart';
import 'package:easily/services/constants.dart';
import 'package:easily/widgets/responsive.dart';
import 'package:easily/widgets/size_config.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:liquid_swipe/liquid_swipe.dart';

class AuthPage extends StatelessWidget {
  AuthPage({Key? key}) : super(key: key);
  final authCtrl = Get.put<AuthCtrl>(AuthCtrl());

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return GetBuilder<AuthCtrl>(
        id: authPageId,
        builder: (_) {
          return !Responsive.isMobile(context)
              ? const Scaffold(
                  body: Center(
                  child: Text(
                    "only mobile devices are supported currently \n,please switch to a mobile device",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 30,
                        fontWeight: FontWeight.bold),
                  ),
                ))
              : authCtrl.isAuth == null
                  ? Scaffold(
                      body: Center(
                          child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        CircularProgressIndicator(),
                        SelectableText("Logging You In ...")
                      ],
                    )))
                  : authCtrl.isAuth!
                      ? HomePage()
                      : LoginPage();
        });
  }
}
