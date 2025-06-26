import 'dart:convert';
import 'package:exposure_explorer_reshot/screens/admin_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import '../models/temp_db.dart';

const String baseUrl = 'https://exposure-explorers-file-db.navodiths.workers.dev';

// To temporarily store the db in memory
final fileTableProvider = StateProvider<List<FileRow>>((ref) => []);

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

Future<bool> deleteFileDB(int id) async {
  final res = await http.post(
    Uri.parse('$baseUrl/files-delete'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({'id': id}),
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

// Extract Event lists
Future<void>extractEventlist(WidgetRef ref) async{
  final res = await http.get(Uri.parse('$baseUrl/event-lists'));
  if (res.statusCode == 200){
    ref.read(eventsProvider.notifier).state =List<String>.from(jsonDecode(res.body));
  }else{
     throw Exception('Failed to retrieve files');
  }
}