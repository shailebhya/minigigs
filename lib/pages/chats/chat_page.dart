import 'package:easily/models/gig_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import 'channel_page.dart';

class ChatPage extends StatelessWidget {
  GigModel gigModel;
  ChatPage(this.gigModel,{Key? key, required this.client, required this.channel})
      : super(key: key);
  final StreamChatClient client;
  final Channel channel;

  @override
  Widget build(BuildContext context) {
    final themeData = ThemeData(primarySwatch: Colors.red);

    final defaultTheme = StreamChatThemeData.fromTheme(themeData);

    // final colorTheme = defaultTheme.colorTheme;

    final customTheme = defaultTheme.merge(StreamChatThemeData(
      channelPreviewTheme: StreamChannelPreviewThemeData(
          avatarTheme: StreamAvatarThemeData(
        borderRadius: BorderRadius.circular(8),
      )),
    ));
    return StreamChat(
      client: client,
      streamChatThemeData: customTheme,
      child: StreamChannel(
        channel: channel,
        child: ChannelPage(gigModel),
      ),
    );
  }
}
