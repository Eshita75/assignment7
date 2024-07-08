import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:assignment7/ui/controller/auth_controller.dart';
import 'package:assignment7/ui/screens/update_profile_screen.dart';

import '../screens/authentication/sign_in_screen.dart';
import '../utility/app_colors.dart';

AppBar ProfileAppBar(context, [bool fromUpdateProfile = false]) {
  return AppBar(
    backgroundColor: AppColors.themeColor,

    leading: GestureDetector(
      onTap: () {
        if(fromUpdateProfile){
          return;
        }
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return UpdateProfileScreen();
            },
          ),
        );
      },
      child:  Padding(
        padding: EdgeInsets.all(8.0),
        child: CircleAvatar(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(50),
            child: Image.memory(
              base64Decode(AuthController.userData?.photo ?? ''),
            ),
          ),
        ),
      ),
    ),



    title: GestureDetector(
      onTap: () {
        if(fromUpdateProfile){
          return;
        }
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return UpdateProfileScreen();
            },
          ),
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AuthController.userData?.fullName ?? '',
            //AuthController.userData?.fullName ?? '',
            style: TextStyle(fontSize: 16, color: Colors.white),
          ),
          Text(
            AuthController.userData?.email ?? '',
            style: TextStyle(
                fontSize: 12,
                color: Colors.white,
                fontWeight: FontWeight.w500),
          ),
        ],
      ),
    ),

    actions: [
      IconButton(onPressed: () async {
        await AuthController.clearAllData();
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const SignInScreen()),
              (route) => false,
        );
      }, icon: const Icon(Icons.logout))
    ],
  );
}