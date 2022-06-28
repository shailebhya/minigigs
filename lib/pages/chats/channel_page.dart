import 'package:easily/models/gig_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

class ChannelPage extends StatelessWidget {
  GigModel gigModel;
   ChannelPage(this.gigModel,{Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      appBar: StreamChannelHeader(centerTitle: true,title:Text(gigModel.title??"")),
      body: Column(children:const [
        Expanded(child: StreamMessageListView(showConnectionStateTile: true,),),StreamMessageInput()
      ]),
    );
  }
}
