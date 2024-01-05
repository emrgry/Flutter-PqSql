import 'package:flutter/material.dart';
import 'package:pg_sql_app/Advertisement/advertisements.dart';
import '../Login/auth_screen.dart';
import '../helpers/custom_route.dart';
import 'package:provider/provider.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          AppBar(
            title: Text('Menu'),
            automaticallyImplyLeading: false,
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.account_box),
            title: Text('Profile'),
            onTap: () {
              Navigator.of(context).pushReplacementNamed('/profile');
            },
          ),
          ListTile(
            leading: Icon(Icons.shop),
            title: Text('Advertisements'),
            onTap: () {
              Navigator.of(context).pushReplacementNamed('/');
            },
          ),
          ListTile(
            leading: Icon(Icons.add_chart_rounded),
            title: Text('Publish Advertisements'),
            onTap: () {
              Navigator.of(context).pushReplacementNamed('/add-advertisement');
            },
          ),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text('Logout'),
            onTap: () {
              Navigator.of(context).pushReplacementNamed('/auth');
            },
          ),
        ],
      ),
    );
  }
}
