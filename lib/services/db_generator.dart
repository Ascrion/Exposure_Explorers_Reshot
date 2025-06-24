import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<Database> initDB() async {
  final dbPath = await getDatabasesPath();
  return openDatabase(
    join(dbPath, 'event_photos.db'),
    onCreate: (db, version) {
      return db.execute(
  '''CREATE TABLE photos(
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT,
    fileID TEXT,
    event TEXT,
    dateOfAddition TEXT,
    description TEXT,
    galleryOrder INTEGER,
    eventsOrder INTEGER,
    UNIQUE(name, event) ON CONFLICT REPLACE
  )'''
);

    },
    version: 1,
  );
}

Future<void> insertPhotoToCloud({
  required String fileID,
  required String name,
  required String event,
  String? dateOfAddition,
  String? description,
  int? galleryOrder,
  int? eventsOrder,
}) async {
  final response = await http.post(
    Uri.parse("https://photo-db.navodiths.workers.dev/insert-photo"),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({
      'fileID': fileID,
      'name': name,
      'event': event,
      'dateOfAddition': dateOfAddition,
      'description': description ?? '',
      'galleryOrder': galleryOrder ?? -1,
      'eventsOrder': eventsOrder ?? -1,
    }),
  );

  if (response.statusCode != 200) {
    throw Exception('Failed to insert photo: ${response.body}');
  }
}




void dbCreator(WidgetRef ref, Map<String, String> eventFolderMaps, String apiKey) async {

  for (var eventName in eventFolderMaps.keys) {
    if (eventName == 'Team' || eventName == 'Hall Of Fame') continue;

    final eventFolderID = eventFolderMaps[eventName];

    final response = await http.get(Uri.parse(
      "https://www.googleapis.com/drive/v3/files?q='$eventFolderID'+in+parents and mimeType='application/vnd.google-apps.folder'&key=$apiKey",
    ));

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      final List<Map<String, dynamic>> folders = (decoded['files'] as List).cast<Map<String, dynamic>>();

      final heroFolder = folders.firstWhere(
        (f) => f['name'].toString().toLowerCase() == 'hero',
        orElse: () => {},
      );

      if (heroFolder.isEmpty) continue;

      final heroFolderId = heroFolder['id'];

      final heroResponse = await http.get(Uri.parse(
        "https://www.googleapis.com/drive/v3/files?q='$heroFolderId'+in+parents&key=$apiKey",
      ));

      if (heroResponse.statusCode == 200) {
        final heroDecoded = jsonDecode(heroResponse.body);
        final List<Map<String, dynamic>> heroFiles = (heroDecoded['files'] as List).cast<Map<String, dynamic>>();

        for (var file in heroFiles) {
          final fileID = file['id'];
          final name = file['name'];
          final createdTime = file['createdTime']; // ISO 8601 format

          await insertPhotoToCloud(name: name, fileID: fileID, event: eventName, dateOfAddition: createdTime,galleryOrder:-1,eventsOrder: -1,description: '');
        }
      }
    }
  }
}

final photoMetadataProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  final response = await http.get(
    Uri.parse("https://photo-db.navodiths.workers.dev/get-photos"),
    headers: {"Accept": "application/json"},
  );

  if (response.statusCode == 200) {
    final List<dynamic> data = jsonDecode(response.body);
    return data.cast<Map<String, dynamic>>(); // Stored in memory
  } else {
    throw Exception("Failed to fetch photos");
  }
});