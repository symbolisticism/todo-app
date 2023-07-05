import 'package:flutter/material.dart';
import 'package:todo/data/dummy_data.dart';
import 'package:todo/widgets/todo_list.dart';

class Todo extends StatelessWidget {
  const Todo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('To Do List'),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: TodoList(listItems: dummyData),
    );
  }
}
