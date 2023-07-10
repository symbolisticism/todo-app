import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo/providers/list_items_provider.dart';

class NewItem extends ConsumerStatefulWidget {
  const NewItem({super.key});

  @override
  ConsumerState<NewItem> createState() => _NewItemState();
}

class _NewItemState extends ConsumerState<NewItem> {
  final _descriptionController = TextEditingController();
  String? _enteredDescription;

  void _showDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Invalid input'),
        content: const Text('Please enter a description.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Okay'),
          ),
        ],
      ),
    );
  }

  bool _validateInput() {
    _enteredDescription = _descriptionController.text.trim();
    final inputIsValid = _enteredDescription != null &&
        _enteredDescription!
            .isNotEmpty; // checked for null value in the first condition

    if (inputIsValid) return true;

    _showDialog();
    return false;
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // this property is necessary for making sure the keyboard
    // doesn't cover the input field
    final keyboardSpace = MediaQuery.of(context).viewInsets.bottom;
    return Padding(
      padding: EdgeInsets.fromLTRB(16, 16, 16, keyboardSpace + 16),
      child: SizedBox(
        // this makes the overlay take up most of the screen
        height: double.infinity,
        child: Column(
          children: [
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description',
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Cancel'),
                ),
                const SizedBox(width: 24),
                ElevatedButton(
                  onPressed: () {
                    if (_validateInput()) {
                      final provider = ref.watch(itemsProvider.notifier);
                      provider.addItem(null, null, _enteredDescription!);
                    }
                    Navigator.of(context).pop();
                  },
                  child: const Text('Add Item'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
