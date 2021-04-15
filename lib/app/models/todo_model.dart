import 'package:flutter/material.dart';

class TodoModel {
  final String title;
  final String description;
  final String date;
  final bool isCompleted;
  final userID;
  final todoID;

  TodoModel(
      {@required this.title,
      this.description,
      this.isCompleted = false,
      @required this.date,
      @required this.userID,
      @required this.todoID});

  factory TodoModel.fromDocument(Map<String, dynamic> data) {
    return TodoModel(
      title: data['title'],
      date: data['date'],
      description: data['description'],
      userID: data['user_id'],
      todoID: data['todo_id'],
      isCompleted: data['isCompleted'],
    );
  }
}
