import 'package:flutter/material.dart';
import 'package:todo/models/todo_item.dart';

class TodoList extends StatefulWidget {
  const TodoList({
    super.key,
    required this.listItems,
    required this.onRemoveItem,
  });

  final List<TodoItem> listItems;
  final void Function(TodoItem todoItem) onRemoveItem;

  @override
  State<TodoList> createState() => _TodoListState();
}

class _TodoListState extends State<TodoList> {
  @override
  Widget build(BuildContext context) {
    Widget content;

    if (widget.listItems.isEmpty) {
      content = const Center(
        child: Text(
          'No to-do items',
          style: TextStyle(fontSize: 24),
        ),
      );
    } else {
      content = ListView.builder(
        itemCount: widget.listItems.length,
        itemBuilder: (context, index) => Dismissible(
          key: ValueKey(widget.listItems[index]),
          background: Container(
            color: Theme.of(context).colorScheme.error.withOpacity(0.75),
          ),
          onDismissed: (direction) {
            widget.onRemoveItem(widget.listItems[index]);
          },
          child: ListTile(
            title: Text(widget.listItems[index].description),
            leading: Checkbox(
              value: widget.listItems[index].done,
              onChanged: (bool? value) {
                setState(
                  () {
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
                  },
                );
              },
            ),
          ),
        ),
      );
    }

    return content;
  }
}
