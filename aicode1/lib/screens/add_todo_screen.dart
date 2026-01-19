import 'package:flutter/material.dart';

class AddTodoScreen extends StatefulWidget {
  final String? initialTitle; // ถ้ามี = edit
  const AddTodoScreen({super.key, this.initialTitle});

  @override
  State<AddTodoScreen> createState() => _AddTodoScreenState();
}

class _AddTodoScreenState extends State<AddTodoScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.initialTitle ?? '');
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    Navigator.pop(context, _titleController.text.trim());
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.initialTitle != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? 'Edit To-do' : 'Add To-do'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _titleController,
                autofocus: true,
                decoration: const InputDecoration(
                  labelText: 'Title',
                  hintText: 'เช่น ทำการบ้าน Mobile',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  final v = value?.trim() ?? '';
                  if (v.isEmpty) return 'ห้ามเว้นว่าง';
                  if (v.length < 2) return 'สั้นไป (อย่างน้อย 2 ตัวอักษร)';
                  if (v.length > 50) return 'ยาวไป (ไม่เกิน 50 ตัวอักษร)';
                  return null;
                },
                onFieldSubmitted: (_) => _submit(),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: _submit,
                  child: Text(isEdit ? 'Save' : 'Add'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
