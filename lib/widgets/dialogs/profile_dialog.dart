import 'package:cached_network_image/cached_network_image.dart';
import 'package:flash_we_chat/auth/view_profile_screen.dart';
import 'package:flash_we_chat/models/chat_user.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../main.dart';

class ProfileDialog extends StatelessWidget {
  const ProfileDialog({super.key, required this.user});
  final ChatUser user;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: EdgeInsets.zero,
      backgroundColor: Colors.white.withOpacity(.9),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      content: SizedBox(
        width: mq.width * .6,
        height: mq.height * .35,
        child: Stack(children: [
          Positioned(
            left: mq.width * .06,
            top: mq.height * .065,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(mq.height * .25),
              child: CachedNetworkImage(
                width: mq.height * .27,
                height: mq.height * 0.27,
                fit: BoxFit.cover,
                imageUrl: user.image,
                // placeholder: (context, url) => CircularProgressIndicator(),
                errorWidget: (context, url, error) => const CircleAvatar(
                  child: Icon(CupertinoIcons.person),
                ),
              ),
            ),
          ),
          Positioned(
            left: mq.width * .04,
            top: mq.height * .02,
            width: mq.width * .55,
            child: Text(user.name,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
          ),
          Positioned(
            right: 8,
            top: 6,
            child: MaterialButton(
                onPressed: () {
                  //it remove current screen
                  Navigator.pop(context);
                  //it move to profile screen
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => ViewProfileScreen(user: user)));
                },
                minWidth: 0,
                padding: EdgeInsets.all(0),
                shape: const CircleBorder(),
                child: Icon(
                  Icons.info_outline,
                  color: Colors.blue,
                  size: 30,
                )),
          )
        ]),
      ),
    );
  }
}
