// ignore_for_file: prefer_const_constructors

import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import '/screens/message_screen.dart';
import '/services/database_services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:scaffold_gradient_background/scaffold_gradient_background.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  GoogleSignIn googleSignIn = GoogleSignIn();
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  DataBaseServices dataBaseServices = DataBaseServices();
  // TextEditingController controller = TextEditingController();

  List<DocumentSnapshot>? chats;
  // bool textFieldActive = false;

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;
    return SafeArea(
      child: ScaffoldGradientBackground(
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            showGroupAddAlert(context);
          },
          backgroundColor: Color(0xff37007C),
          tooltip: "Add new group",
          child: Icon(
            CupertinoIcons.plus_bubble,
            color: Color(0xffFFF3B0),
            size: w * 0.07,
          ),
        ),
        gradient: const LinearGradient(
          colors: [
            Color(0xffFFF3B0),
            Color(0xffCA26FF),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          leading: Container(
            margin: EdgeInsets.only(
              left: w * 0.02,
              top: w * 0.01,
            ),
            child: CircleAvatar(
              radius: w * 0.058,
              backgroundColor: const Color(0xff37007C),
              child: CircleAvatar(
                radius: w * 0.052,
                backgroundImage:
                    NetworkImage('${firebaseAuth.currentUser!.photoURL}'),
              ),
            ),
          ),
          title: Text(
            'Welcome ${firebaseAuth.currentUser!.displayName!.substring(
              0,
              firebaseAuth.currentUser!.displayName!.indexOf(' '),
            )}',
            style: TextStyle(
              color: const Color(0xff37007C),
              fontSize: w * 0.07,
              fontWeight: FontWeight.w600,
              height: 2,
            ),
          ),
          elevation: 0,
          actions: [
            IconButton(
                onPressed: () {
                  googleSignIn.signOut();
                  firebaseAuth.signOut();
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    'login',
                    (route) => false,
                  );
                },
                icon: Icon(
                  Icons.logout_rounded,
                  color: const Color(0xff37007C),
                  size: w * 0.07,
                ))
          ],
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: firebaseFirestore
              .collection('chats')
              .orderBy('time', descending: true)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Text(
                  'Unable to load chats',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: w * 0.08,
                    color: Color(0xff37007C).withOpacity(0.4),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              );
            } else if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
              chats = snapshot.data?.docs;

              return Center(
                child: Column(
                  children: [
                    SizedBox(
                      height: h * 0.03,
                    ),
                    // Container(
                    //   padding: EdgeInsets.symmetric(
                    //     horizontal: textFieldActive ? w * 0.01 : w * 0.03,
                    //     vertical: h * 0.005,
                    //   ),
                    //   width: w * 0.95,
                    //   decoration: BoxDecoration(
                    //     color: Colors.white.withOpacity(0.3),
                    //     borderRadius: BorderRadius.all(
                    //       Radius.circular(
                    //         18,
                    //       ),
                    //     ),
                    //   ),
                    //   child: Row(
                    //     mainAxisAlignment: MainAxisAlignment.start,
                    //     crossAxisAlignment: CrossAxisAlignment.center,
                    //     children: [
                    //       Icon(
                    //         Icons.search,
                    //         color: const Color(0xff37007C),
                    //         size: w * 0.07,
                    //       ),
                    //       Container(
                    //         width: w * 0.8,
                    //         padding: EdgeInsets.symmetric(horizontal: w * 0.01),
                    //         child: TextFormField(
                    //           onChanged: (String s) {
                    //             // if (s.isEmpty) {
                    //             //   setState(() {
                    //             //     displayList = widget.chats;
                    //             //   });
                    //             // }
                    //             // widget.chats?.forEach((chatTile)
                    //             // {
                    //             //   if ('${chatTile['group']}'
                    //             //       .trim()
                    //             //       .toLowerCase()
                    //             //   //     .contains(s.trim().toLowerCase())) {
                    //             //   //   searchList?.add(chatTile);
                    //             //   // }
                    //             // });
                    //             // setState(() {
                    //             //   displayList = searchList;
                    //             //   textFieldActive = true;
                    //             // });
                    //           },
                    //           controller: controller,
                    //           cursorColor: Color(0xff37007C),
                    //           style: TextStyle(
                    //             color: Color(0xff37007C),
                    //             fontWeight: FontWeight.w500,
                    //           ),
                    //           decoration: InputDecoration(
                    //             hintText: 'Search community...',
                    //             hintStyle: TextStyle(
                    //               color:
                    //                   const Color(0xff37007C).withOpacity(0.4),
                    //               fontWeight: FontWeight.w500,
                    //             ),
                    //             border: InputBorder.none,
                    //           ),
                    //         ),
                    //       ),
                    //       if (textFieldActive)
                    //         GestureDetector(
                    //           onTap: () {
                    //             controller.clear();
                    //             setState(() {
                    //               textFieldActive = false;
                    //             });
                    //           },
                    //           child: Icon(
                    //             Icons.clear,
                    //             color: const Color(0xff37007C),
                    //             size: w * 0.055,
                    //           ),
                    //         ),
                    //     ],
                    //   ),
                    // ),
                    SizedBox(
                      height: h * 0.03,
                    ),
                    Expanded(
                      child: ListView.builder(
                          itemCount: chats
                              ?.length, //instead of chats we need to use displayList
                          itemBuilder: (context, index) {
                            int red = Random().nextInt(255);
                            int blue = Random().nextInt(255);
                            int green = Random().nextInt(255);
                            double overall = sqrt(0.299 * red * red +
                                0.587 * green * green +
                                0.114 * blue * blue);
                            String time = chats?[index]['time'];
                            return Container(
                              margin: EdgeInsets.only(
                                left: w * 0.03,
                                right: w * 0.04,
                                top: h * 0.015,
                              ),
                              child: ListTile(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => MessageScreen(
                                        groupName: chats?[index]['group'],
                                        groupId: chats?[index]['id'],
                                        color: Color.fromARGB(
                                          255,
                                          red,
                                          green,
                                          blue,
                                        ),
                                        overall: overall,
                                      ),
                                    ),
                                  );
                                },
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(
                                      12,
                                    ),
                                  ),
                                ),
                                tileColor: Color(0xffFFF3B0),
                                leading: CircleAvatar(
                                  backgroundColor: Color.fromARGB(
                                    255,
                                    red,
                                    green,
                                    blue,
                                  ),
                                  child: Text(
                                    '${chats?[index]['group']}'.substring(0, 1),
                                    style: TextStyle(
                                      color: overall > 127.5
                                          ? Colors.black
                                          : Colors.white,
                                      fontWeight: FontWeight.w600,
                                      fontSize: w * 0.06,
                                    ),
                                  ),
                                ),
                                title: Text(
                                  chats?[index]['group'],
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: w * 0.05,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                subtitle: Text(
                                  chats?[index]['last user'] == ""
                                      ? ''
                                      : chats?[index]['last user mail'] ==
                                              firebaseAuth.currentUser!.email
                                          ? 'You: ${chats?[index]['last message']}'
                                          : '${chats?[index]['last user']}: ${chats?[index]['last message']}',
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                trailing: Text(
                                  '${time.substring(24, 27).trim()} ${time.substring(8, 10).trim()}, ${time.substring(0, 4).trim()}\n${time.substring(12, 17).trim()} ${time.substring(21, 23).trim()}',
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: w * 0.03,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            );
                          }),
                    ),
                  ],
                ),
              );
              // print(chats);
            } else if (snapshot.hasData && snapshot.data!.docs.isEmpty) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Text(
                    'Create a new group to start chat',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: w * 0.08,
                      color: Color(0xff37007C).withOpacity(0.4),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              );
            } else {
              return Center(
                child: CircularProgressIndicator(
                  color: Color(0xff37007C),
                ),
              );
            }
          },
        ),
      ),
    );
  }

  showGroupAddAlert(BuildContext context) {
    TextEditingController groupNameController = TextEditingController();
    Widget okButton = TextButton(
      onPressed: () async {
        await dataBaseServices
            .addData(
              groupNameController.text,
              DateFormat('yyyy MM dd, hh:mm:ss a MMM E').format(DateTime.now()),
            )
            .then((value) => print('Done'));
        Navigator.pop(context);
      },
      child: Text(
        'Add',
        style: TextStyle(
          color: Color(0xff37007C),
        ),
      ),
    );
    AlertDialog alertDialog = AlertDialog(
      title: Text('New Community'),
      content: TextFormField(
        style: TextStyle(
          color: Color(0xff37007C),
        ),
        cursorColor: Color(0xff37007C),
        controller: groupNameController,
        decoration: InputDecoration(
          focusColor: Color(0xff37007C),
          hintText: 'Enter new community name',
          hintStyle: TextStyle(color: Color(0xff37007C).withOpacity(0.3)),
        ),
      ),
      actions: [
        okButton,
      ],
    );
    showDialog(context: context, builder: (context) => alertDialog);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    // controller.dispose();
    super.dispose();
  }
}
