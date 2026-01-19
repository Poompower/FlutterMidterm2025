class Todo {
  final String id;
  final String title;
  final String description;
  bool isCompleted;
  Todo({
    required this.id, 
    required this.title, 
    required this.description,
    this.isCompleted = false
    });
     Map<String, Object?> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'isCompleted': isCompleted ? 1 : 0,
    };
  }

  factory Todo.fromMap(Map<String, Object?> map) {
    return Todo(
      id: map['id'] as String,
      title: map['title'] as String,
      description: map['description'] as String,
      isCompleted: (map['isCompleted'] as int) == 1,
    );
  }
}

