// import 'package:flash_we_chat/widgets/chat_user_card.dart';
import 'package:flash_we_chat/auth/profile_screen%20copy.dart';
import 'package:flash_we_chat/auth/view_profile_screen.dart';
import 'package:flash_we_chat/models/chat_user.dart';
import 'package:flash_we_chat/widgets/chat_user_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../api/apis.dart';
import '../main.dart';

//home screen --where all available contacts are shown
class MyHomePage extends StatefulWidget {
  const MyHomePage({
    super.key,
  });

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  //for storing all users
  List<ChatUser> _list = [];
  //for storing searched items
  final List<ChatUser> _searchList = [];
  //for storing search status
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    APIs.getSelfInfo();

    //for updating user active status according to lifecycle events
    //resume= active or online
    //pause = inactive or offline.
    SystemChannels.lifecycle.setMessageHandler((message) {
      if (APIs.auth.currentUser != null) {
        if (message.toString().contains('resume')) {
          APIs.updateActiveStatus(true);
        }
        if (message.toString().contains('pause')) {
          APIs.updateActiveStatus(false);
        }
      }

      return Future.value(message);
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      //for hiding keyboard when a tap is detected on screen
      onTap: () => FocusScope.of(context).unfocus(),
      child: WillPopScope(
        //if search is on & back button is pressed then close search
        //or else simple close current screen on back button click
        onWillPop: () {
          if (_isSearching) {
            setState(() {
              _isSearching = !_isSearching;
            });
            return Future.value(false);
          } else {
            return Future.value(true);
          }
        },
        child: Scaffold(
            appBar: AppBar(
              leading: Icon(Icons.home),
              // centerTitle: true,
              elevation: 1,
              backgroundColor: Colors.white,

              title: _isSearching
                  ? TextField(
                      decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Name,Email, .....'),
                      autofocus: true,
                      style: TextStyle(fontSize: 17, letterSpacing: 0.5),

                      //when search text changes then updated search list
                      onChanged: (val) {
                        //search logic
                        _searchList.clear();
                        for (var i in _list) {
                          if (i.name
                                  .toLowerCase()
                                  .contains(val.toLowerCase()) ||
                              i.email
                                  .toLowerCase()
                                  .contains(val.toLowerCase())) {
                            _searchList.add(i);
                          }
                          setState(() {
                            _searchList;
                          });
                        }
                      },
                    )
                  : Text(
                      'Flash Chat',
                      style: TextStyle(color: Colors.black),
                    ),

              actions: [
                IconButton(
                    onPressed: () {
                      setState(() {
                        _isSearching = !_isSearching;
                      });
                    },
                    icon: Icon(_isSearching
                        ? CupertinoIcons.clear_circled_solid
                        : Icons.search)),

                //more feature button
                IconButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => ProfileScreen(user: APIs.me)));
                    },
                    icon: Icon(Icons.more_vert))
              ],
            ),

            //floating button to add new user
            floatingActionButton: Padding(
                padding: EdgeInsets.only(bottom: 10),
                child: FloatingActionButton(
                  onPressed: () async {
                    // sign out Function
                    // _signOut() async{
                    await APIs.auth.signOut();
                    await GoogleSignIn().signOut();
                  },
                  child: Icon(Icons.add_comment),
                  backgroundColor: Colors.amber,
                )),

            //for fetching the data from firestore.
            body: StreamBuilder(
                stream: APIs.getAllUsers(),
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    //if data is loading
                    case ConnectionState.waiting:
                    case ConnectionState.none:
                      return const Center(child: CircularProgressIndicator());

                    //if some or all data is loaded then show it
                    case ConnectionState.active:
                    case ConnectionState.done:
                      final data = snapshot.data?.docs;
                      // log('Data : ${jsonEncode(i.data())}'); //here json use to convert the data in json format.
                      _list = data
                              ?.map((e) => ChatUser.fromJson(e.data()))
                              .toList() ??
                          [];

                      if (_list.isNotEmpty) {
                        return ListView.builder(
                            padding: EdgeInsets.only(top: mq.height * .01),
                            itemCount: _isSearching
                                ? _searchList.length
                                : _list.length, //this multiply card
                            physics:
                                BouncingScrollPhysics(), //this bounce the scroll.
                            itemBuilder: (context, index) {
                              // return ChatUserCard();
                              return ChatUserCard(
                                  user: _isSearching
                                      ? _searchList[index]
                                      : _list[index]);
                              // return Text('Name: ${list[index]} ');
                            });
                      } else {
                        return const Center(
                          child: Text(
                            'No Connection Found!',
                            style: TextStyle(fontSize: 20),
                          ),
                        );
                      }
                  }
                })),
      ),
    );
  }
}
