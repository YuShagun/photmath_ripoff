import 'package:flutter/material.dart';

import 'about.dart';
import 'history_screen.dart';

class AppDrawer extends StatelessWidget {

  const AppDrawer({Key key}) : super(key: key);

  Widget drawerContent(BuildContext context) => ListView(
    children: <Widget>[
      DrawerHeader(
        decoration: BoxDecoration(
          color: Colors.blueGrey,
        ),
        child: Text(
          'MathPhoto',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
          ),
        ),
      ),
      ListTile(
        title: Text(
          'History',
          style: TextStyle(
            fontSize: 18,
          ),
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => HistoryScreen()
            ),
          );
        },
      ),
      ListTile(
        title: Text(
          'About',
          style: TextStyle(
            fontSize: 18,
          ),
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Scaffold(
                appBar: AppBar(
                  title: Text('About'),
                ),
                body: AboutDialogContent(),
              ),
            ),
          );
        },
      ),
    ],
  );

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: drawerContent(context),
      elevation: 1,
    );
  }
}