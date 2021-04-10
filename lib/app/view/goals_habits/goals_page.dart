import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:working_project/app/models/goal_model.dart';
import 'package:working_project/app/models/user_model.dart';
import 'package:working_project/app/providers/auth_provider.dart';
import 'package:working_project/app/providers/goal_provider.dart';
import 'package:working_project/app/view/goals_habits/edit_goal_page.dart';
import 'package:working_project/app/view/goals_habits/habits_page.dart';
import 'package:working_project/app/view/journal/journal_page.dart';
import 'package:working_project/app/view/todo/todo_page.dart';

import 'add_goal_page.dart';

//TODO Fix Scrolling
class GoalPage extends StatefulWidget {
  @override
  _GoalPageState createState() => _GoalPageState();
}

class _GoalPageState extends State<GoalPage> {
  void showSnackBar(BuildContext context, String text, Color color) {
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(text),
        backgroundColor: color,
      ),
    );
  }

  Future<void> _refreshScreenForChanges() async {
    final UserModel userModel =
        Provider.of<AuthProvider>(context, listen: false).userModel;
    Provider.of<GoalProvider>(context, listen: false).readGoal(
      userID: userModel.userID,
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _refreshScreenForChanges();
  }

  @override
  Widget build(BuildContext context) {
    final UserModel userModel =
        Provider.of<AuthProvider>(context, listen: true).userModel;
    final GoalProvider goalProvider =
        Provider.of<GoalProvider>(context, listen: true);
    final List<GoalModel> goals =
        Provider.of<GoalProvider>(context, listen: true).goalModels;
    //ui
    return Scaffold(
        appBar: AppBar(
          title: Text('Goal maker'),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute<void>(
                builder: (BuildContext context) => AddNewGoal(),
                fullscreenDialog: true),
          ),
          child: Icon(Icons.add),
          backgroundColor: Colors.indigo,
        ),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                child: Text(
                  'Providers App',
                  style: TextStyle(color: Colors.white),
                ),
                decoration: BoxDecoration(
                  color: Colors.indigo,
                ),
              ),
              ListTile(
                title: Text(
                  'My Goals and Habits',
                  style:
                      TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                ),
              ),
              ListTile(
                title: Text('My todo'),
                onTap: () => Navigator.push(context,
                    CupertinoPageRoute(builder: (context) => TodoPage())),
              ),
              ListTile(
                title: Text('My journal'),
                onTap: () => Navigator.push(
                    context,
                    CupertinoPageRoute<void>(
                        builder: (BuildContext context) => JournalPage(),
                        fullscreenDialog: true)),
              ),
            ],
          ),
        ),
        body: WillPopScope(
          onWillPop: null,
          child: RefreshIndicator(
            onRefresh: () => _refreshScreenForChanges(),
            child: ListView(
              children: [
                ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: goals.length,
                  itemBuilder: (context, int index) {
                    final GoalModel goal = goals[index];
                    var date = DateTime.parse(goal.date);
                    var formattedDate =
                        '${date.day}/${date.month}/${date.year}';
                    return ClipRRect(
                      child: Slidable(
                        actionPane: SlidableDrawerActionPane(),
                        key: Key(goal.goalID.toString()),
                        actions: [
                          IconSlideAction(
                              color: Colors.deepOrangeAccent,
                              //edit function call
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => EditGoal(
                                        goal: goal,
                                      ),
                                    ));
                              },
                              caption: 'Edit',
                              icon: Icons.edit)
                        ],
                        secondaryActions: [
                          IconSlideAction(
                            color: Colors.red,
                            caption: 'Delete',
                            //delete function call
                            onTap: () {
                              goalProvider.deleteGoal(
                                  goalID: goal.goalID,
                                  userID: userModel.userID);
                              _refreshScreenForChanges();
                              showSnackBar(context, 'Deleted ${goal.goalTitle}',
                                  Colors.red);
                            },
                            icon: Icons.delete,
                          )
                        ],
                        child: ListTile(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => HabitsPage(
                                  goal: goal,
                                ),
                              ),
                            );
                          },
                          title: Text(goal.goalTitle,
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.indigo)),
                          subtitle: Text('Due date: $formattedDate'),
                          trailing: Icon(Icons.arrow_forward_ios),
                        ),
                      ),
                    );
                  },
                )
              ],
            ),
          ),
        ));
  }
}
