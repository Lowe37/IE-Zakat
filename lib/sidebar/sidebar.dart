import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutteriezakat/sign_in.dart';
import 'package:rxdart/rxdart.dart';
import 'package:flutteriezakat/block/navigation_bloc.dart';
import 'package:flutteriezakat/sidebar/menu.dart';
import 'package:flutteriezakat/services/auth.dart';
import 'package:flutteriezakat/database.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutteriezakat/shared/loading.dart';
//import 'package:image_picker/image_picker.dart';
import 'dart:io';

class SideBar extends StatefulWidget {
  _SideBarState createState() => _SideBarState();
}

class _SideBarState extends State<SideBar>
    with SingleTickerProviderStateMixin<SideBar> {

  /*Future<File> imageFile;

  pickImageFromGallery(ImageSource source) {
    setState(() {
      imageFile = ImagePicker.pickImage(source: source);
    });
  }*/

  /*Widget showImage() {
    return FutureBuilder<File>(
      future: imageFile,
      builder: (BuildContext context, AsyncSnapshot<File> snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            snapshot.data != null) {
          return Image.file(
            snapshot.data,
            width: 300,
            height: 300,
          );
        } else if (snapshot.error != null) {
          return const Text(
            'Error Picking Image',
            textAlign: TextAlign.center,
          );
        } else {
          return const Text(
            'No Image Selected',
            textAlign: TextAlign.center,
          );
        }
      },
    );
  }*/

  //final AuthService _auth = AuthService();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  AnimationController _animationController;
  StreamController<bool> isSidebarOpenedStreamController;
  Stream<bool> isSidebarOpenedStream;
  StreamSink<bool> isSidebarOpenedSink;

  bool loading = false;

//  final bool isSidebarOpened = true;
  final _animationDuration = const Duration(milliseconds: 500);

  @override
  void initState() {
    super.initState();
    _animationController =
        AnimationController(vsync: this, duration: _animationDuration);
    isSidebarOpenedStreamController = PublishSubject<bool>();
    isSidebarOpenedStream = isSidebarOpenedStreamController.stream;
    isSidebarOpenedSink = isSidebarOpenedStreamController.sink;
  }

  @override
  void dispose() {
    _animationController.dispose();
    isSidebarOpenedStreamController.close();
    isSidebarOpenedSink.close();
    super.dispose();
  }

  void onIconPressed() {
    final animationStatus = _animationController.status;
    final isAnimationCompleted = animationStatus == AnimationStatus.completed;

    if (isAnimationCompleted) {
      isSidebarOpenedSink.add(false);
      _animationController.reverse();
    } else {
      isSidebarOpenedSink.add(true);
      _animationController.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    final screenWidth = MediaQuery.of(context).size.width;

    return StreamProvider<QuerySnapshot>.value(
      value: DBservice().users,
      child: StreamBuilder<bool>(
          initialData: false,
          stream: isSidebarOpenedStream,
          builder: (context, isSideBarOpenedAsync) {
            return loading ? Loading() : AnimatedPositioned(
              duration: _animationDuration,
              top: 0,
              bottom: 0,
              left: isSideBarOpenedAsync.data ? 0 : -screenWidth,
              right: isSideBarOpenedAsync.data ? 100 : screenWidth - 40, //adjust sidebar size
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      color: Colors.green,
                      child: Column(
                        children: <Widget>[
                          SizedBox(
                            height: 50,
                          ),
                          ListTile(
                            title: Text(
                              ".......",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w800),
                            ),
                            subtitle: Text(
                              ".............",
                              style: TextStyle(
                                color: Color(0xFF1BB5FD),
                              ),
                            ),
                            leading: FlatButton(
                              onPressed: () {
                                //pickImageFromGallery(ImageSource.gallery);
                              },
                              child: CircleAvatar(
                                child: Icon(
                                  Icons.perm_identity,
                                  color: Colors.white,
                                ),
                                radius: 30,
                              ),
                            ),
                          ),
                          Divider(
                            height: 64,
                            thickness: 0.5,
                            color: Colors.white.withOpacity(0.3),
                            indent: 32,
                            endIndent: 32,
                          ),
                          Menubar(
                            icon: Icons.home,
                            title: "Zakat",
                            onTap: () {
                              onIconPressed();
                              BlocProvider.of<NavigationBloc>(context)
                                  .add(NavigationEvents.HomePageClickedEvent);
                            },
                          ),
                          Menubar(
                            icon: Icons.monetization_on,
                            title: "Balance Tracker",
                            onTap: () {
                              onIconPressed();
                              BlocProvider.of<NavigationBloc>(context)
                                  .add(NavigationEvents.BalanceClickedEvent);
                            },
                          ),
                          Menubar(
                            icon: Icons.people,
                            title: "Account",
                            onTap: () {
                              onIconPressed();
                              BlocProvider.of<NavigationBloc>(context)
                                  .add(NavigationEvents.AccountClickedEvent);
                            },
                          ),
                          Menubar(
                            icon: Icons.settings,
                            title: "Setting",
                          ),
                          Menubar(
                            icon: Icons.question_answer,
                            title: "FAQ",
                          ),
                          Divider(
                            height: 64,
                            thickness: 0.5,
                            color: Colors.white.withOpacity(0.3),
                            indent: 32,
                            endIndent: 32,
                          ),
                          Menubar(
                            icon: Icons.close,
                            title: "Logout",
                            onTap: () {
                              _auth.signOut();
                              Navigator.push(context, MaterialPageRoute(builder: (context) {
                                return LoginPage();
                              }));
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  Align(
                      alignment: Alignment(0, -0.9),
                      child: GestureDetector(
                          onTap: () {
                            onIconPressed();
                          },
                          child: ClipPath(
                            clipper: CustomMenuClipper(),
                            child: Container(
                              width: 35,
                              height: 110,
                              color: Colors.green,
                              alignment: Alignment.centerLeft,
                              child: AnimatedIcon(
                                progress: _animationController.view,
                                icon: AnimatedIcons.menu_close,
                                color: Colors.white,
                                size: 25,
                              ),
                            ),
                          )))
                ],
              ),
            );
          }),
    );
  }
}

class CustomMenuClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Paint paint = Paint();
    paint.color = Colors.white;

    final width = size.width;
    final heigth = size.height;

    Path path = Path();
    path.moveTo(0, 0);
    path.quadraticBezierTo(0, 8, 10, 16);
    path.quadraticBezierTo(width - 1, heigth / 2 - 20, width, heigth / 2);
    path.quadraticBezierTo(width + 1, heigth / 2 + 20, 10, heigth - 16);
    path.quadraticBezierTo(0, heigth - 8, 0, heigth);

    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}
