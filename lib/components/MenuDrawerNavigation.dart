import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

Widget buildMenuDrawerNavigation() {
  final box = Hive.box('ahorrala_setting_box');
  final name = box.get('user_name') ?? 'Ahorrala.com';
  final email = box.get('user_email') ?? '';
  final avatar = box.get('user_avatar_image') ?? 'https://app.ahorrala.com/public/assets/images/ahorrala_logo_grande.webp';

  return Drawer(
    child: ListView(
      padding: EdgeInsets.zero,
      children: [
        DrawerHeader(
          decoration: BoxDecoration(
            color: Colors.green,
          ),
          child: Column(
            children: [
              Text(
                'Ahorrala',
                style: TextStyle(fontSize: 20),
              ),

              //display name
              Text(
                'Bienvenido/a seas!',
                style: TextStyle(fontSize: 17, color: Colors.white),
              ),
              Text(
                name,
                style: TextStyle(fontSize: 17, color: Colors.white),
              ),
              Text(
                email,
                style: TextStyle(fontSize: 17, color: Colors.white),
              ),
            ],
          ),
        ),
        ListTile(
          leading: Icon(Icons.person),
          title: const Text('Mi PErfil'),
          onTap: () {
            //Navigator.pop(context);
          },
        ),
        ListTile(
          leading: Icon(Icons.book),
          title: const Text(' My Course '),
          onTap: () {
            // Navigator.pop(context);
          },
        ),
        ListTile(
          leading: Icon(Icons.workspace_premium),
          title: const Text(' Go Premium '),
          onTap: () {
            // Navigator.pop(context);
          },
        ),
        ListTile(
          leading: Icon(Icons.video_label),
          title: const Text(' Saved Videos '),
          onTap: () {
            //Navigator.pop(context);
          },
        ),
        ListTile(
          leading: Icon(Icons.edit),
          title: const Text(' Edit Profile '),
          onTap: () {
            //Navigator.pop(context);
          },
        ),
        ListTile(
          leading: Icon(Icons.logout),
          title: const Text('LogOut'),
          onTap: () {
            //Navigator.pop(context);
          },
        ),
      ],
    ),
  );
}
