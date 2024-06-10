class Task {
  String title;
  String description;
  DateTime deadline;
  DateTime? reminderTime; // Thêm trường reminderTime để lưu thời gian hẹn giờ

  Task({
    required this.title,
    required this.description,
    required this.deadline,
    this.reminderTime,
  });
}
