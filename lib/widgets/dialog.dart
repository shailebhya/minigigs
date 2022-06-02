import 'package:easily/widgets/size_config.dart';
import 'package:flutter/material.dart';

class CustomDialogBox extends StatefulWidget {
  final String title, descriptions, text;
  // final Image img;
  const CustomDialogBox(this.title, this.descriptions, this.text, {Key? key})
      : super(key: key);

  @override
  _CustomDialogBoxState createState() => _CustomDialogBoxState();
}

class _CustomDialogBoxState extends State<CustomDialogBox> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: const RoundedRectangleBorder(
          // borderRadius: BorderRadius.circular(Constants.padding),
          ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: contentBox(context),
    );
  }

  contentBox(context) {
    return Container(
      padding: EdgeInsets.all(20),
      // padding: EdgeInsets.only(
      //     left: Constants.padding,
      //     top:  Constants.padding,
      //     right: Constants.padding,
      //     bottom: Constants.padding),
      // margin: EdgeInsets.only(top: Constants.avatarRadius),
      decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: const [
            BoxShadow(
                color: Colors.grey, offset: Offset(0, 10), blurRadius: 10),
          ]),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            widget.title,
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
          ),
          SizedBox(
            height: 15,
          ),
          Text(
            widget.descriptions,
            style: TextStyle(fontSize: 14),
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: 22,
          ),
          // Align(
          //   alignment: Alignment.bottomRight,
          //   child: ElevatedButton(
          //       onPressed: () {
          //         // Navigator.of(context).pop();
          //       },
          //       child: Text(
          //         widget.text,
          //         style: TextStyle(fontSize: 18),
          //       )),
          // ),
        ],
      ),
    );
  }
}

class Constants {
  Constants._();
  static double padding = SizeConfig.screenHeight / 10;
  static double avatarRadius = SizeConfig.screenWidth / 10;
}
