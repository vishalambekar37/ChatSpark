import 'package:cached_network_image/cached_network_image.dart';
import 'package:flash_we_chat/helper/my_date_util.dart';
import 'package:flash_we_chat/models/chat_user.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../main.dart';

//View profile screen to view profile screen of user.

class ViewProfileScreen extends StatefulWidget {
  final ChatUser user;
  const ViewProfileScreen({super.key, required this.user});

  @override
  State<ViewProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ViewProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      //for hiding keyboard
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            widget.user.name,
            style: TextStyle(color: Colors.black),
          ),
        ),
        floatingActionButton: //user about
            Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Joined On : ',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: Colors.black87)),
            Text(
              MyDateUtil.getLastmessageTime(
                  context: context,
                  time: widget.user.createdAt,
                  showYear: true),
              style: const TextStyle(color: Colors.black54, fontSize: 15),
            ),
          ],
        ),
        //for fetching the data from firestore.
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: mq.width * .05),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  width: mq.width,
                  height: mq.height * .03,
                ),

                //user profile picture
                ClipRRect(
                  borderRadius: BorderRadius.circular(mq.height * .1),
                  child: CachedNetworkImage(
                    height: mq.height * .2,
                    width: mq.height * .2,
                    fit: BoxFit.cover,
                    imageUrl: widget.user.image,
                    // placeholder: (context, url) => CircularProgressIndicator(),
                    errorWidget: (context, url, error) => const CircleAvatar(
                      child: Icon(CupertinoIcons.person),
                    ),
                  ),
                ),

                SizedBox(
                  width: mq.width,
                  height: mq.height * .03,
                ),

                Text(
                  widget.user.email,
                  style: const TextStyle(color: Colors.black87, fontSize: 16),
                ),

                SizedBox(
                  width: mq.width,
                  height: mq.height * .02,
                ),
                //user about
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('About : ',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            color: Colors.black87)),
                    Text(
                      widget.user.about,
                      style:
                          const TextStyle(color: Colors.black54, fontSize: 15),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
