import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../services/file_tracker_db.dart';
import '../models/temp_db.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:typed_data';
import '../services/file_photo_bucket_connect.dart';
import '../screens/admin_screen.dart';

// Track photos to be inserted, update database with this.
final fileTableInsert = StateProvider<List<FileRow>>((ref) => []);

// User file errot tracker
final userFileError = StateProvider<dynamic>((ref) => '');
final userFileData = StateProvider<List<dynamic>>((ref) => []);

class AddPhotos extends ConsumerStatefulWidget {
  const AddPhotos({super.key});

  @override
  ConsumerState<AddPhotos> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<AddPhotos> {
  final _focusNode1 = FocusNode();
  final _focusNode2 = FocusNode();
  final _focusNode3 = FocusNode();

  @override
  void dispose() {
    _focusNode1.dispose();
    _focusNode2.dispose();
    _focusNode3.dispose();

    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    // Clear state providers
    Future.microtask(() {
      ref.read(fileTableInsert.notifier).state = [];
      ref.read(userFileError.notifier).state = '';
      ref.read(userFileData.notifier).state = [];
    });
  }

  @override
  Widget build(BuildContext context) {
    FileRow newPhoto;
    String description = '';
    String event = '';
    String date = '';

    final userError = ref.watch(userFileError);
    final userData = ref.watch(userFileData);

    final labelTextStyle = Theme.of(context).textTheme.titleMedium?.copyWith(
        color: Theme.of(context).colorScheme.onPrimary, fontSize: 20);

    return LayoutBuilder(builder: (context, constraints) {
      final width = MediaQuery.of(context).size.width;
      final height = constraints.maxHeight;
      return Align(
          child: SizedBox(
              height: height * 0.8,
              width: width / 2,
              child: Card(
                child: Padding(
                  padding:
                      const EdgeInsetsDirectional.symmetric(horizontal: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ListTile(
                          leading: IconButton(
                              onPressed: () {
                                ref.read(adminPageChoice.notifier).state =
                                    'PhotoConfig'; // Return Back
                              },
                              icon: Icon(Icons.arrow_back))),
                      Container(
                        width: width / 3,
                        height: height / 4,
                        color: Theme.of(context).colorScheme.onSurface,
                        child: TextButton(
                            onPressed: () {
                              pickFile(ref);
                            },
                            child: userData.isEmpty
                                ? Text(
                                    'Add Photo (<10MB)',
                                    style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary),
                                  )
                                : Image.memory(userData[3])),
                      ),
                      SizedBox(
                        height: height / 20,
                        child: Text(
                          userError,
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.error),
                        ),
                      ),
                      TextField(
                        decoration: InputDecoration(
                            labelText: 'Event',
                            floatingLabelStyle: labelTextStyle,
                            labelStyle: labelTextStyle),
                        onChanged: (val) => event = val,
                        focusNode: _focusNode1,
                        onSubmitted: (_) =>
                            FocusScope.of(context).requestFocus(_focusNode2),
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context).colorScheme.onPrimary),
                        cursorColor: Theme.of(context).colorScheme.secondary,
                      ),
                      TextField(
                        decoration: InputDecoration(
                            labelText: 'Date',
                            floatingLabelStyle: labelTextStyle,
                            labelStyle: labelTextStyle),
                        onChanged: (val) => date = val,
                        focusNode: _focusNode2,
                        onSubmitted: (_) =>
                            FocusScope.of(context).requestFocus(_focusNode3),
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context).colorScheme.onPrimary),
                        cursorColor: Theme.of(context).colorScheme.secondary,
                      ),
                      TextField(
                        decoration: InputDecoration(
                            labelText: 'Description',
                            floatingLabelStyle: labelTextStyle,
                            labelStyle: labelTextStyle),
                        onChanged: (val) => description = val,
                        focusNode: _focusNode3,
                        onSubmitted: (_) => FocusScope.of(context).unfocus(),
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context).colorScheme.onPrimary),
                        cursorColor: Theme.of(context).colorScheme.secondary,
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue, // 🔵 Background color
                          foregroundColor: Colors.white, // ⚪ Text color
                          elevation: 4, // ✨ Shadow
                          shape: RoundedRectangleBorder(
                            // 🔲 Border radius
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: EdgeInsets.symmetric(
                              horizontal: 50, vertical: 20),
                          textStyle: labelTextStyle,
                        ),
                        onPressed: () {
                          if (event == '') {
                            ref.read(userFileError.notifier).state =
                                'Fill event field';
                          } else {
                            if (userData.isEmpty) {
                              ref.read(userFileError.notifier).state =
                                  'Add a photo';
                            } else {
                              newPhoto = FileRow(
                                  id: 0,
                                  name: userData[0],
                                  event: event,
                                  fileURL: userData[1],
                                  date: date,
                                  description: description,
                                  galleryOrder: -1,
                                  eventsOrder: -1,
                                  filesStorage: userData[2]);
                              fileTrackerInsert(newPhoto, ref);
                            }
                          }
                        },
                        child: Text('Submit'),
                      ),
                    ],
                  ),
                ),
              )));
    });
  }
}

// Check the user uploaded photo, if valid, upload to r2 and return fileURL.
Future<void> pickFile(ref) async {
  await Future.delayed(Duration(milliseconds: 50));
  final result = await FilePicker.platform.pickFiles(
    type: FileType.custom,
    allowedExtensions: ['jpg', 'png'], // your allowed types
    withData: true, // stores file in memory
  );

  if (result != null && result.files.isNotEmpty) {
    final file = result.files.first;

    // Access file name and extension
    final name = file.name;
    final extension = file.extension;

    // Get file size in bytes
    final sizeInMB = file.size / (1024 * 1024);
    // File data in memory
    final Uint8List? fileBytes = file.bytes;

    // Size check
    if (sizeInMB > 10) {
      ref.read(userFileError.notifier).state = 'File Too Big, Reduce To <10 mb';
    } else {
      if (!(extension == 'jpg' || extension == 'png')) {
        ref.read(userFileError.notifier).state = 'Wrong file format uploaded';
      } else {
        final usedStorage = await storageUsed();
        if (usedStorage + sizeInMB < 500) {
          final uploadResponse = await uploadFile(name, fileBytes!);
          if (uploadResponse[0] == 200) {
            ref.read(userFileData.notifier).state = [
              name,
              uploadResponse[1],
              sizeInMB,
              fileBytes
            ];
          } else {
            ref.read(userFileError.notifier).state =
                uploadResponse[1]; // Error Details
            ref.read(userFileData.notifier).state = [];
          }
        }else{
          //print('$sizeInMB + $usedStorage');
          ref.read(userFileError.notifier).state = 'Server max storage exceeded, delete some photos to clear space';
        }
      }
    }
  }
}

// File tracker insert
Future<void> fileTrackerInsert(FileRow newPhoto, WidgetRef ref) async {
  final response = await insertFile(newPhoto.toJson());
  if (response == 200) {
    ref.read(userFileError.notifier).state = 'File uploaded successfully';
    retrieveFiles(ref); // Update local databse
  } else {
    ref.read(userFileError.notifier).state = 'File Tracker error: $response';
  }
}
