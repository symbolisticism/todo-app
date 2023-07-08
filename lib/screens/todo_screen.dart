import 'package:flutter/material.dart';
import 'package:todo/data/dummy_data.dart';
import 'package:todo/models/todo_item.dart';
import 'package:todo/widgets/new_item.dart';
import 'package:todo/widgets/todo_list.dart';

class Todo extends StatefulWidget {
  const Todo({super.key});

  @override
  State<Todo> createState() => _TodoState();
}

class _TodoState extends State<Todo> {
  static const List<Icon> filterIcons = [
    Icon(Icons.arrow_upward),
    Icon(Icons.arrow_downward),
  ];

  Icon dropdownValue = filterIcons.first;

  void _showBottomOverlay(BuildContext context) {
    showModalBottomSheet(
      useSafeArea: true,
      isScrollControlled: true,
      context: context,
      builder: (ctx) => NewItem(onAddItem: _addItem),
    );
  }

  void _addItem(TodoItem todoItem) {
    setState(
      () {
        dummyData.add(todoItem);
      },
    );
  }

  void _removeItem(TodoItem todoItem) {
    final itemIndex = dummyData.indexOf(todoItem);
    setState(() {
      dummyData.remove(todoItem);
    });

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('To-do item deleted'),
        duration: const Duration(seconds: 2),
        action: SnackBarAction(
          label: 'UNDO',
          onPressed: () {
            setState(() {
              dummyData.insert(itemIndex, todoItem);
            });
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('To Do List'),
        actions: [
          DropdownButton<Icon>(
            value: dropdownValue,
            onChanged: (Icon? icon) {
              setState(() {
                dropdownValue = icon!;
                if (icon.icon == Icons.arrow_upward) {
                  dummyData
                      .sort((a, b) => a.id.compareTo(b.id));
                } else {
                  dummyData
                      .sort((b, a) => a.id.compareTo(b.id));
                }
              });
            },
            items: filterIcons.map<DropdownMenuItem<Icon>>((Icon icon) {
              return DropdownMenuItem<Icon>(
                value: icon,
                child: icon,
              );
            }).toList(),
          ),
          const SizedBox(width: 48),
          IconButton(
            onPressed: () => _showBottomOverlay(context),
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: TodoList(
        listItems: dummyData,
        onRemoveItem: _removeItem,
      ),
    );
  }
}
