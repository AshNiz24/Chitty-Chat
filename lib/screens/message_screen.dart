// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '/services/database_services.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:scaffold_gradient_background/scaffold_gradient_background.dart';

class MessageScreen extends StatefulWidget {
  const MessageScreen(
      {Key? key,
      required this.groupId,
      required this.groupName,
      required this.color,
      required this.overall})
      : super(key: key);
  final String groupId;
  final String groupName;
  final Color color;
  final double overall;

  @override
  State<MessageScreen> createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  TextEditingController messageController = TextEditingController();
  DataBaseServices dataBaseServices = DataBaseServices();
  late ScrollController _scrollController;
  bool needsScroll = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    _scrollController = ScrollController(
        initialScrollOffset: MediaQuery.of(context).size.height);

    final w = MediaQuery.of(context).size.width;
    return SafeArea(
      child: ScaffoldGradientBackground(
        gradient: const LinearGradient(
          colors: [
            Color(0xffFFF3B0),
            Color(0xffCA26FF),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        appBar: AppBar(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(
                w * 0.05,
              ),
              bottomRight: Radius.circular(
                w * 0.05,
              ),
            ),
          ),
          toolbarHeight: h * 0.1,
          backgroundColor: Color(0xffFFF3B0),
          leading: Container(
            margin: EdgeInsets.only(
              left: w * 0.05,
            ),
            child: CircleAvatar(
              radius: w * 0.6,
              backgroundColor: widget.color,
              child: Text(
                widget.groupName.substring(0, 1),
                style: TextStyle(
                  color: widget.overall > 127.5 ? Colors.black : Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: w * 0.06,
                ),
              ),
            ),
          ),
          title: Text(
            widget.groupName,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: Colors.black,
              fontSize: w * 0.07,
              fontWeight: FontWeight.w500,
            ),
          ),
          leadingWidth: 60,
        ),
        body: StreamBuilder<QuerySnapshot>(
            stream: firebaseFirestore
                .collection('chats/${widget.groupId}/messages')
                .orderBy(
                  'Time',
                  descending: false,
                )
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Unable to load messages',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: w * 0.08,
                          color: Color(0xff37007C).withOpacity(0.4),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                );
              } else if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
                List? messages = snapshot.data?.docs;
                return Stack(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(
                              left: w * 0.015,
                              right: w * 0.015,
                              top: h * 0.015,
                            ),
                            child: ListView.separated(
                              controller: _scrollController,
                              itemBuilder: (context, index) {
                                return MessageBubble(
                                  username: snapshot.data?.docs[index]
                                      ['Username'],
                                  message: snapshot.data?.docs[index]
                                      ['Message'],
                                  dpURL: snapshot.data?.docs[index]
                                      ['Profile pic'],
                                  isMe: firebaseAuth.currentUser?.email ==
                                      snapshot.data?.docs[index]['Email'],
                                );
                              },
                              separatorBuilder: (context, index) {
                                return SizedBox(
                                  height: 10,
                                );
                              },
                              itemCount: messages!.length,
                            ),
                          ),
                        ),
                        Container(
                          // width: w * 0.7,
                          margin: EdgeInsets.only(
                            left: w * 0.04,
                            right: w * 0.04,
                            bottom: h * 0.02,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.all(
                              Radius.circular(
                                w * 0.03,
                              ),
                            ),
                          ),
                          child: Row(
                            children: [
                              Container(
                                // color: Colors.pink,
                                margin: EdgeInsets.only(
                                  left: w * 0.03,
                                  right: w * 0.01,
                                ),
                                width: w * 0.75,
                                child: TextFormField(
                                  controller: messageController,
                                  cursorColor: Color(0xff37007C),
                                  style: TextStyle(
                                    color: Color(0xff37007C),
                                    fontSize: w * 0.045,
                                    letterSpacing: 1,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: 'Type message...',
                                    hintStyle: TextStyle(
                                      color: Color(0xffF3C9FF),
                                      fontSize: w * 0.045,
                                      letterSpacing: 1,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                              IconButton(
                                onPressed: () async {
                                  String message = messageController.text;
                                  await dataBaseServices.addMessage(
                                    widget.groupId,
                                    message,
                                    DateFormat('yyyy MM dd, hh:mm:ss a MMM E')
                                        .format(DateTime.now()),
                                    widget.groupName,
                                  );
                                  print(
                                      DateFormat('yyyy MM dd, hh:mm:ss a MMM E')
                                          .format(DateTime.now()));
                                  _scrollController.animateTo(
                                    _scrollController.position.maxScrollExtent,
                                    duration: Duration(
                                      milliseconds: 200,
                                    ),
                                    curve: Curves.easeIn,
                                  );
                                  messageController.clear();
                                },
                                icon: Icon(
                                  Icons.send_rounded,
                                  size: w * 0.08,
                                  color: Color(0xff37007C),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    // if (_scrollController.position.pixels !=
                    //     _scrollController.position.maxScrollExtent)
                    //   Positioned(
                    //       left: w * 0.95,
                    //       top: h * 0.95,
                    //       child: GestureDetector(
                    //         child: CircleAvatar(
                    //           child: Icon(Icons.arrow_circle_down),
                    //         ),
                    //       ))
                  ],
                );
              } else if (snapshot.hasData && snapshot.data!.docs.isEmpty) {
                return Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        height: h * 0.02,
                      ),
                      Text(
                        'Start a conversation',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: w * 0.08,
                          color: Color(0xff37007C).withOpacity(0.4),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Container(
                        // width: w * 0.7,
                        margin: EdgeInsets.only(
                          left: w * 0.04,
                          right: w * 0.04,
                          bottom: h * 0.02,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.3),
                          borderRadius: BorderRadius.all(
                            Radius.circular(
                              w * 0.03,
                            ),
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              // color: Colors.pink,
                              margin: EdgeInsets.only(
                                left: w * 0.03,
                                right: w * 0.01,
                              ),
                              width: w * 0.75,
                              child: TextFormField(
                                controller: messageController,
                                cursorColor: Color(0xff37007C),
                                style: TextStyle(
                                  color: Color(0xff37007C),
                                  fontSize: w * 0.045,
                                  letterSpacing: 1,
                                  fontWeight: FontWeight.w500,
                                ),
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'Type message...',
                                  hintStyle: TextStyle(
                                    color: Color(0xffF3C9FF),
                                    fontSize: w * 0.045,
                                    letterSpacing: 1,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                            IconButton(
                              onPressed: () async {
                                await dataBaseServices.addMessage(
                                  widget.groupId,
                                  messageController.text,
                                  DateFormat('yyyy MM dd, hh:mm:ss a MMM E')
                                      .format(DateTime.now()),
                                  widget.groupName,
                                );
                                messageController.clear();
                              },
                              icon: Icon(
                                Icons.send_rounded,
                                size: w * 0.08,
                                color: Color(0xff37007C),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              } else {
                return Center(
                  child: CircularProgressIndicator(
                    color: Color(0xff650088),
                  ),
                );
              }
            }),
      ),
    );
  }
}

class MessageBubble extends StatelessWidget {
  final String? username;
  final String message;
  final String? dpURL;
  final bool isMe;
  const MessageBubble({
    Key? key,
    required this.username,
    required this.message,
    required this.dpURL,
    required this.isMe,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;
    return Row(
      mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Container(
          constraints: BoxConstraints(
            minWidth: w * 0.01,
            maxWidth: w * 0.5,
          ),
          padding: EdgeInsets.only(
            left: isMe ? w * 0.03 : w * 0.02,
            right: isMe ? w * 0.02 : w * 0.03,
            top: h * 0.005,
            bottom: h * 0.01,
          ),
          decoration: BoxDecoration(
            color: isMe ? Color(0xff650088) : Color(0xffF2CCFF),
            borderRadius: isMe
                ? BorderRadius.only(
                    // topLeft: Radius.circular(
                    //   w * 0.05,
                    // ),
                    bottomLeft: Radius.circular(
                      w * 0.05,
                    ),
                  )
                : BorderRadius.only(
                    // topRight: Radius.circular(
                    //   w * 0.05,
                    // ),
                    bottomRight: Radius.circular(
                      w * 0.05,
                    ),
                  ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: w * 0.03,
                    backgroundImage: NetworkImage(dpURL!),
                  ),
                  SizedBox(
                    width: w * 0.01,
                  ),
                  Flexible(
                    child: Text(
                      isMe ? 'You' : username!,
                      overflow: TextOverflow.ellipsis,
                      softWrap: true,
                      style: TextStyle(
                        color: isMe ? Color(0xffF8E5FF) : Color(0xff650088),
                        fontWeight: FontWeight.w600,
                        fontSize: w * 0.05,
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(
                height: h * 0.012,
              ),
              Text(
                message,
                style: TextStyle(
                  color: isMe
                      ?
                      // Color(0xffF8E5FF) :
                      Colors.white
                      : Color(0xff650088),
                  fontWeight: FontWeight.w400,
                  fontSize: w * 0.04,
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}
