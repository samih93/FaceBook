import 'package:flutter/material.dart';

class UsersScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _refreshData,
        child: ListView.builder(
          padding: EdgeInsets.all(20.0),
          itemBuilder: (context, index) => Text('$index'),
          itemCount: 10,
        ),
      ),
    );
  }

  Future _refreshData() async {
    await Future.delayed(Duration(seconds: 3));
    print('refreshed');
  }
}
