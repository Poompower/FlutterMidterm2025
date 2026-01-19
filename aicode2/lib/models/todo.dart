class Todo {
  final int id;
  String title;
  String note;
  bool isDone;

  Todo({
    required this.id,
    required this.title,
    this.note = '',
    this.isDone = false,
  });
}
