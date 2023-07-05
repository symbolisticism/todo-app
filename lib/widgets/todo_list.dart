import 'package:flutter/material.dart';
import 'package:todo/models/todo_item.dart';

class TodoList extends StatefulWidget {
  const TodoList({
    super.key,
    required this.listItems,
  });

  final List<TodoItem> listItems;

  @override
  State<TodoList> createState() => _TodoListState();
}

class _TodoListState extends State<TodoList> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.listItems.length,
      itemBuilder: (context, index) => ListTile(
        leading: Checkbox(
          value: widget.listItems[index].done,
          onChanged: (bool? value) {
            setState(() {
              if (value != null) {
                widget.listItems[index].done = value;
              } else {
                ScaffoldMessenger.of(context).clearSnackBars();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    duration: Duration(seconds: 3),
                    content: Text('Checkbox value was null.'),
                  ),
                );
              }
            });
          },
        ),
        title: Text(widget.listItems[index].description),
      ),
    );
  }
}
