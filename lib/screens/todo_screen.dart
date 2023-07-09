import 'package:flutter/material.dart';
import 'package:todo/data/dummy_data.dart';
import 'package:todo/models/todo_item.dart';
import 'package:todo/widgets/new_item.dart';
import 'package:todo/widgets/todo_list.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo/providers/list_items_provider.dart';

class Todo extends ConsumerStatefulWidget {
  const Todo({super.key});

  @override
  ConsumerState<Todo> createState() => _TodoState();
}

class _TodoState extends ConsumerState<Todo> {
  late Future<void> _itemsFuture;

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
        // dummyData.add(todoItem);
        final provider = ref.watch(itemsProvider.notifier);
        provider.addItem(null, null, todoItem.description);
      },
    );
  }

  void _removeItem(TodoItem todoItem) {
    // final itemIndex = dummyData.indexOf(todoItem);
    final provider = ref.watch(itemsProvider.notifier);
    Future<int> count;

    setState(() {
      // dummyData.remove(todoItem);
      count = provider.removeItem(todoItem.id);
      print('Items deleted: $count');
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
              // dummyData.insert(itemIndex, todoItem);
              provider.addItem(
                todoItem.id,
                todoItem.done,
                todoItem.description,
              );
            });
          },
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _itemsFuture = ref.read(itemsProvider.notifier).loadItems();
  }

  @override
  Widget build(BuildContext context) {
    final userItems = ref.watch(itemsProvider);

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
                  dummyData.sort((a, b) => a.id.compareTo(b.id));
                } else {
                  dummyData.sort((b, a) => a.id.compareTo(b.id));
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
      // body: TodoList(
      //   listItems: dummyData,
      //   onRemoveItem: _removeItem,
      // ),
      body: FutureBuilder(
        future: _itemsFuture,
        builder: (context, snapshot) =>
            snapshot.connectionState == ConnectionState.waiting
                ? const Center(child: CircularProgressIndicator())
                : TodoList(listItems: userItems, onRemoveItem: _removeItem),
      ),
    );
  }
}
