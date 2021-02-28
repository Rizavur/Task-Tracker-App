import 'package:flutter/material.dart';
import 'package:task_tracker_app/screens/add_new_task.dart';
import 'package:task_tracker_app/screens/view_tasks.dart';
import 'package:task_tracker_app/services/auth_service.dart';

import 'loading.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _currentIndex = 0;
  bool loading = false;

  // User user = AuthService().user as User;

  @override
  Widget build(BuildContext context) {

    final List<Widget> _children = [
      AddNewTask(),
      ViewTasks()
    ];

    void _onTabTapped(int index) {
      setState(() {
        _currentIndex = index;
      });
    }

    return loading ? Loading() : Scaffold(
      appBar: AppBar(
        title: Text(
          "Task Tracker",
          style: TextStyle(
            fontFamily: 'Dosis',
            fontSize: 28.0
          ),
        ),
        backgroundColor: Colors.black,
        centerTitle: true,
        elevation: 0,
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.logout,
              color: Colors.greenAccent,
            ),
            onPressed: () async {
              setState(() => loading = true);
              dynamic result = await AuthService().signOut();
              if (result == null) {
                setState(() => loading = false);
              }
            },
          )
        ],
      ),
      body: _children.elementAt(_currentIndex),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black,
        selectedItemColor: Colors.greenAccent,
        unselectedItemColor: Colors.grey[700],
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'View Tasks',
          ),
        ],
      ),
    );
  }
}
