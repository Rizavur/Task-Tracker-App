import 'package:flutter/material.dart';
import 'package:task_tracker_app/screens/add_new_task.dart';
import 'package:task_tracker_app/screens/view_tasks.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _currentIndex = 0;

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

    return Scaffold(
      appBar: AppBar(
        title: Text("Task Tracker"),
        backgroundColor: Colors.black,
        centerTitle: true,
      ),
      body: _children.elementAt(_currentIndex),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: 'Add New Task',
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
