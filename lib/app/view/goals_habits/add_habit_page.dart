import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:working_project/app/models/goal_model.dart';
import 'package:working_project/app/providers/habits_provider.dart';
import 'package:working_project/app/utils/shared_preferences.dart';
import 'package:working_project/app/view/goals_habits/habit_widgets/habit_form_widget.dart';

import '../../models/goal_model.dart';

class AddNewHabit extends StatefulWidget {
  AddNewHabit({this.goal});

  final GoalModel goal;

  @override
  _AddNewHabitState createState() => _AddNewHabitState();
}

class _AddNewHabitState extends State<AddNewHabit> {
  final TextEditingController _titleController = TextEditingController();

  final TextEditingController _importanceController = TextEditingController();

  final TextEditingController _noteController = TextEditingController();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final SharedPrefs prefs = SharedPrefs();

  @override
  Widget build(BuildContext context) {
    final HabitProvider habitProvider =
        Provider.of<HabitProvider>(context, listen: true);
    return Scaffold(
      appBar: AppBar(
        title: Text('Add new Habit'),
        backgroundColor: Colors.indigo,
      ),
      body: Container(
        child: Column(
          children: [
            Form(
              key: formKey,
              child: HabitFormWidget(
                titleController: _titleController,
                subtitleController: _noteController,
                importanceController: _importanceController,
                buttonText: 'Save',
                onSaved: () async {
                  final String userID = await prefs.readUserID();
                  await habitProvider
                      .addHabit(
                          goalID: widget.goal.goalID,
                          title: _titleController.text,
                          note: _noteController.text,
                          importance: _importanceController.text,
                          userID: userID)
                      .then(
                    (_) {
                      Navigator.of(context).pop();
                    },
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
