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

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'event': event,
        'fileURL': fileURL,
        'date': date,
        'description': description,
        'galleryOrder': galleryOrder,
        'eventsOrder': eventsOrder,
        'filesStorage': filesStorage,
      };

  FileRow copyWith({
    int? id,
    String? name,
    String? event,
    String? fileURL,
    String? date,
    String? description,
    int? galleryOrder,
    int? eventsOrder,
    double? filesStorage,
  }) {
    return FileRow(
      id: id ?? this.id,
      name: name ?? this.name,
      event: event ?? this.event,
      fileURL: fileURL ?? this.fileURL,
      date: date ?? this.date,
      description: description ?? this.description,
      galleryOrder: galleryOrder ?? this.galleryOrder,
      eventsOrder: eventsOrder ?? this.eventsOrder,
      filesStorage: filesStorage ?? this.filesStorage,
    );
  }
}
