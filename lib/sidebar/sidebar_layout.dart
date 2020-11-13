import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutteriezakat/block/navigation_bloc.dart';

import 'sidebar.dart';

class SideBarLayout extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: BlocProvider<NavigationBloc>(
        create : (context) => NavigationBloc(),
        child: Stack(
          children: <Widget>[
            BlocBuilder<NavigationBloc, NavigationStates>(
            builder: (context, navigationSatae ){
              return navigationSatae as Widget;

            },
            ),
            //SideBar(),
          ],
        ) ,
      ),


    );
  }

}