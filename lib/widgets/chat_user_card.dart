import 'package:cached_network_image/cached_network_image.dart';
import 'package:flash_we_chat/api/apis.dart';
import 'package:flash_we_chat/helper/my_date_util.dart';
import 'package:flash_we_chat/models/chat_user.dart';
import 'package:flash_we_chat/widgets/dialogs/profile_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../main.dart';
import '../models/message.dart';
import '../screens/chat_Screen.dart';

//card to represent a single user in home screen
class ChatUserCard extends StatefulWidget {
  final ChatUser user;
  const ChatUserCard({super.key, required this.user});

  @override
  State<ChatUserCard> createState() => _ChatUserCardState();
}

class _ChatUserCardState extends State<ChatUserCard> {
  Message? _message;
  @override
  //last message info (if null --> no message)

  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: mq.width * .04, vertical: 4),
      elevation: 0.5,
      // color: Color.fromARGB(255, 131, 214, 253),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: InkWell(
          //for navigating to chat screen
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => ChatScreen(user: widget.user)));
          },
          child: StreamBuilder(
            stream: APIs.getlastMessages(widget.user),
            builder: (context, snapshot) {
              final data = snapshot.data?.docs;
              final list =
                  data?.map((e) => Message.fromJson(e.data())).toList() ?? [];
              if (list.isNotEmpty) {
                _message = list[0];
              }

              return ListTile(
                  //user profile picture
                  // leading: const CircleAvatar(child: Icon(CupertinoIcons.person)),
                  leading: InkWell(
                    onTap: () {
                      showDialog(context: context, builder: (_)=> ProfileDialog(user: widget.user,));
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(mq.height * .3),
                      child: CachedNetworkImage(
                        height: mq.height * .055,
                        width: mq.height * .055,
                        imageUrl: widget.user.image,
                        // placeholder: (context, url) => CircularProgressIndicator(),
                        errorWidget: (context, url, error) => const CircleAvatar(
                          child: Icon(CupertinoIcons.person),
                        ),
                      ),
                    ),
                  ),
                  //user name
                  title: Text(widget.user.name),
                  //last msg
                  subtitle: Text(
                    _message != null
                        ? _message!.type == Type.image
                            ? 'image'
                            : _message!.msg
                        : widget.user.about,
                    maxLines: 1,
                  ),
                  //last msg time
                  trailing: _message == null
                      ? null
                      : _message!.read.isEmpty &&
                              _message!.fromID != APIs.user.uid
                          ?
                          //show for unread message
                          Container(
                              height: 15,
                              width: 15,
                              decoration: BoxDecoration(
                                  color: Colors.greenAccent.shade400,
                                  borderRadius: BorderRadius.circular(10)),
                            )
                          // trailing: Text(
                          //   '12:00 PM',
                          //   style: TextStyle(color: Colors.black54),
                          // ),
                          : Text(
                              MyDateUtil.getFormattedTime(
                                  context: context, time: _message!.sent),
                              style: TextStyle(color: Colors.black54),
                            ));
            },
          )),
    );
  }
}
