class ArchiveDocument {
  ArchiveDocument({
    required this.name,
    required this.number,
    required this.category,
    required this.date,
    this.origin = '',
    this.location = '',
    this.description = '',
  });

  String name;
  String number;
  String category;
  DateTime date;
  String origin;
  String location;
  String description;
}
