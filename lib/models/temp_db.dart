class FileRow {
  final int id;
  final String name;
  final String event;
  final String fileURL;
  final String date;
  final String description;
  final int galleryOrder;
  final int eventsOrder;
  final double filesStorage;

  FileRow({
    required this.id,
    required this.name,
    required this.event,
    required this.fileURL,
    required this.date,
    required this.description,
    required this.galleryOrder,
    required this.eventsOrder,
    required this.filesStorage,
  });

  factory FileRow.fromJson(Map<String, dynamic> json) {
    return FileRow(
      id: int.parse(json['id'].toString()),
      name: json['name'] ?? '',
      event: json['event'] ?? '',
      fileURL: json['fileURL'] ?? '',
      date: json['date'] ?? '',
      description: json['description'] ?? '',
      galleryOrder: json['galleryOrder'] ?? -1,
      eventsOrder: json['eventsOrder'] ?? -1,
      filesStorage: json['filesStorage'] ?? 0.0,
    );
  }
}
