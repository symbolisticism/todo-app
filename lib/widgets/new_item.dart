import 'package:flutter/material.dart';

class NewItem extends StatefulWidget {
  const NewItem({super.key});

  @override
  State<NewItem> createState() => _NewItemState();
}

class _NewItemState extends State<NewItem> {
  final _formKey = GlobalKey<FormState>();
  final _descriptionController = TextEditingController();
  String? _enteredDescription;

  void _addItem() {}

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Row(
                  children: [
                    TextFormField(
                      maxLength: 25,
                      decoration: const InputDecoration(
                        label: Text('Description'),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Description must be 1 or more characters long.';
                        }
                        return null;
                      },
                      onSaved: (newValue) {
                        _enteredDescription = newValue;
                      },
                    )
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
