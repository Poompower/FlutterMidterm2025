import 'package:flutter/material.dart';

class AddEditTodoScreen extends StatefulWidget {
  final String? initialTitle;
  final String? initialDescription;

  const AddEditTodoScreen({
    super.key,
    this.initialTitle,
    this.initialDescription,
  });

  @override
  State<AddEditTodoScreen> createState() => _AddEditTodoScreenState();
}

class _AddEditTodoScreenState extends State<AddEditTodoScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  bool _isSubmitting = false;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_isSubmitting) return; // กันซ้ำทันที
    if (!_formKey.currentState!.validate()) return;

    _isSubmitting = true; // สำคัญ: ตั้งก่อน setState
    setState(() {}); // เพื่อให้ปุ่ม disabled

    final title = _titleController.text.trim();
    final desc = _descriptionController.text.trim();

    Navigator.pop(context, {'title': title, 'description': desc});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add/Edit Todo')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  icon: Icon(Icons.title_sharp),
                  hintText: 'Enter the Topic',
                  labelText: 'Title',
                ),
                onSaved: (String? value) {},
                validator: (String? value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Pls enter some Title';
                  }
                  return null;
                },

              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  icon: Icon(Icons.description),
                  hintText: 'Enter the description',
                  labelText: 'Description',
                ),

                validator: (String? value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Pls enter some Description';
                  }
                  return null;
                },

              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _isSubmitting ? null : _submit,
                child: Text(_isSubmitting ? 'Saving...' : 'Add'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _titleController.text = widget.initialTitle ?? '';
    _descriptionController.text = widget.initialDescription ?? '';
  }
}
