
class NoteModel {
  final String text;
  final String timestamp; // e.g. "02:34"
  final DateTime createdAt;

  NoteModel({
    required this.text,
    required this.timestamp,
    required this.createdAt,
  });
}
