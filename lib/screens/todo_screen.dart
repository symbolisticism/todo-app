import 'package:flutter/material.dart';
import 'package:todo/data/dummy_data.dart';
import 'package:todo/widgets/new_item.dart';
import 'package:todo/widgets/todo_list.dart';

class Todo extends StatefulWidget {
  const Todo({super.key});

  @override
  State<Todo> createState() => _TodoState();
}

class _TodoState extends State<Todo> {
  void _showBottomOverlay(BuildContext context) {
    showModalBottomSheet(
      useSafeArea: true,
      isScrollControlled: true,
      context: context,
      builder: (ctx) => const NewItem(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('To Do List'),
        actions: [
          IconButton(
            onPressed: () => _showBottomOverlay(context),
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: TodoList(listItems: dummyData),
    );
  }
}
