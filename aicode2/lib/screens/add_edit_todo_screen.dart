import 'package:flutter/material.dart';
import '../models/todo.dart';

class AddEditTodoScreen extends StatefulWidget {
  final Todo? editing;

  const AddEditTodoScreen({super.key, this.editing});

  @override
  State<AddEditTodoScreen> createState() => _AddEditTodoScreenState();
}

class _AddEditTodoScreenState extends State<AddEditTodoScreen> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _titleController;
  late final TextEditingController _noteController;

  final FocusNode _titleFocus = FocusNode();
  final FocusNode _noteFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.editing?.title ?? '');
    _noteController = TextEditingController(text: widget.editing?.note ?? '');
  }

  @override
  void dispose() {
    _titleController.dispose();
    _noteController.dispose();
    _titleFocus.dispose();
    _noteFocus.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    final title = _titleController.text.trim();
    final note = _noteController.text.trim();

    if (widget.editing == null) {
      final todo = Todo(
        id: DateTime.now().millisecondsSinceEpoch,
        title: title,
        note: note,
      );
      Navigator.pop(context, todo); // return data
    } else {
      widget.editing!
        ..title = title
        ..note = note;
      Navigator.pop(context, widget.editing); // return data
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.editing != null;

    return Scaffold(
      appBar: AppBar(title: Text(isEdit ? 'Edit To-do' : 'Add To-do')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _titleController,
                focusNode: _titleFocus,
                decoration: const InputDecoration(
                  labelText: 'Title',
                  hintText: 'เช่น ทำการบ้าน Flutter',
                  border: OutlineInputBorder(),
                ),
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_noteFocus);
                },
                validator: (value) {
                  final v = value?.trim() ?? '';
                  if (v.isEmpty) return 'ห้ามเว้นว่าง';
                  if (v.length < 2) return 'สั้นไป (อย่างน้อย 2 ตัวอักษร)';
                  if (v.length > 50) return 'ยาวไป (ไม่เกิน 50 ตัวอักษร)';
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _noteController,
                focusNode: _noteFocus,
                decoration: const InputDecoration(
                  labelText: 'Note (optional)',
                  hintText: 'รายละเอียดเพิ่มเติม',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
                textInputAction: TextInputAction.done,
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
