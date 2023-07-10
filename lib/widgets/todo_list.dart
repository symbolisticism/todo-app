import 'package:flutter/material.dart';
import 'package:todo/models/todo_item.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo/providers/list_items_provider.dart';

class TodoList extends ConsumerStatefulWidget {
  const TodoList({
    super.key,
    required this.listItems,
  });

  final List<TodoItem> listItems;

  @override
  ConsumerState<TodoList> createState() => _TodoListState();
}

class _TodoListState extends ConsumerState<TodoList> {
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
          key: UniqueKey(), // ValueKey(widget.listItems[index].id),
          background: Container(
            color: Theme.of(context).colorScheme.error.withOpacity(0.75),
          ),
          onDismissed: (direction) {
            final item = widget.listItems[index];
            final provider = ref.watch(itemsProvider.notifier);

            // remove the item
            provider.removeItem(item.id);

            ScaffoldMessenger.of(context).clearSnackBars();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text('To-do item deleted'),
                duration: const Duration(seconds: 2),
                action: SnackBarAction(
                  label: 'UNDO',
                  onPressed: () {
                    setState(() {
                      // dummyData.insert(itemIndex, todoItem);
                      provider.addItem(
                        item.id,
                        item.done,
                        item.description,
                      );
                    });
                  },
                ),
              ),
            );
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
