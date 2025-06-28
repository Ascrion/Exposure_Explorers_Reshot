import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import '../models/temp_db.dart';

const String baseUrl = 'https://exposure-explorers-file-db.navodiths.workers.dev';

// To temporarily store the db in memory
final fileTableProvider = StateProvider<List<FileRow>>((ref) => []);
final galleryProvider = StateProvider<List<FileRow>>((ref) => []);
final eventsProvider = StateProvider<List<FileRow>>((ref) => []);
final teamProvider = StateProvider<List<FileRow>>((ref) => []);
final hofProvider = StateProvider<List<FileRow>>((ref) => []);

Future<int> insertFile(Map<String, dynamic> file) async {
  final res = await http.post(
    Uri.parse('$baseUrl/files-insert'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode(file),
  );
  return res.statusCode;
}

// Modified retrieve function to store table locally
Future<void> retrieveFiles(ref) async {
  final res = await http.get(Uri.parse('$baseUrl/files-retrieve'));
  if (res.statusCode == 200) {
    final List<dynamic> jsonList = jsonDecode(res.body);
    ref.read(fileTableProvider.notifier).state = jsonList.map((e) => FileRow.fromJson(e)).toList();
  } else {
    throw Exception('Failed to retrieve files');
  }
}

Future<void> retrieveFilesGallery(ref) async {
  final res = await http.get(Uri.parse('$baseUrl/files-retrieve-gallery'));
  if (res.statusCode == 200) {
    final List<dynamic> jsonList = jsonDecode(res.body);
    ref.read(galleryProvider.notifier).state = jsonList.map((e) => FileRow.fromJson(e)).toList();
  } else {
    throw Exception('Failed to retrieve files');
  }
}

Future<void> retrieveFilesEvents(ref) async {
  final res = await http.get(Uri.parse('$baseUrl/files-retrieve-events'));
  if (res.statusCode == 200) {
    final List<dynamic> jsonList = jsonDecode(res.body);
    ref.read(eventsProvider.notifier).state = jsonList.map((e) => FileRow.fromJson(e)).toList();
  } else {
    throw Exception('Failed to retrieve files');
  }
}

Future<void> retrieveFilesTeam(ref) async {
  final res = await http.get(Uri.parse('$baseUrl/files-retrieve-team'));
  if (res.statusCode == 200) {
    final List<dynamic> jsonList = jsonDecode(res.body);
    ref.read(teamProvider.notifier).state = jsonList.map((e) => FileRow.fromJson(e)).toList();
  } else {
    throw Exception('Failed to retrieve files');
  }
}

Future<void> retrieveFilesHOF(ref) async {
  final res = await http.get(Uri.parse('$baseUrl/files-retrieve-hof'));
  if (res.statusCode == 200) {
    final List<dynamic> jsonList = jsonDecode(res.body);
    ref.read(hofProvider.notifier).state = jsonList.map((e) => FileRow.fromJson(e)).toList();
  } else {
    throw Exception('Failed to retrieve files');
  }
}

Future<bool> updateFileDB(FileRow file) async {
  //final payload = jsonEncode(file.toJson());
  //print('Sending JSON: $payload');
  final res = await http.post(
    Uri.parse('$baseUrl/files-update'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode(file.toJson()), 
  );
  //print(res.body);
  return res.statusCode == 200;
}

Future<bool> deleteFileDB(String name) async {
  final res = await http.post(
    Uri.parse('$baseUrl/files-delete'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({'name': name}),
  );
  return res.statusCode == 200;
}

Future<double> storageUsed() async {
  final res = await http.get(Uri.parse('$baseUrl/storage-used'));

  if (res.statusCode == 200) {
    final result = json.decode(res.body);
    return (result['total'] ?? 0).toDouble(); // Ensures it's a double
  } else {
    return 500.00; // Prevent new uploads to avoid storage ovverruns
  }
}