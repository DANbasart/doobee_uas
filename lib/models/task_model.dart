class Task {
  final String title;
  final String description;
  final DateTime? dateTime;
  final String? category;
  final int priority;

  Task({
    required this.title,
    required this.description,
    this.dateTime,
    this.category,
    this.priority = 1,
  });
}
