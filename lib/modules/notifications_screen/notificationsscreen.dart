import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Lottie.asset('assets/lottie/notifications.json',
              width: 150, height: 150),
          SizedBox(
            height: 10,
          ),
          Text("Your Notifications",
              style:
                  TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
          Text("No Notifications to show at the moment",
              style: TextStyle(color: Colors.grey)),
          Text("Check back Later", style: TextStyle(color: Colors.grey)),
        ]),
      ),
    );
  }
}
