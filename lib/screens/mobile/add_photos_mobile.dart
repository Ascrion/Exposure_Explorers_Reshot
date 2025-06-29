import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../services/file_tracker_db.dart';
import '../../models/temp_db.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:typed_data';
import '../../services/file_photo_bucket_connect.dart';
import 'admin_screen_mobile.dart';
import 'home_page_mobile.dart';

// Track photos to be inserted, update database with this.
final fileTableInsert = StateProvider<List<FileRow>>((ref) => []);
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
  final _focusNode4 = FocusNode();
  final _focusNode5 = FocusNode();

  final TextEditingController eventController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController galleryOrderController = TextEditingController();
  final TextEditingController eventsOrderController = TextEditingController();

  @override
  void dispose() {
    _focusNode1.dispose();
    _focusNode2.dispose();
    _focusNode3.dispose();
    _focusNode4.dispose();
    _focusNode5.dispose();
    eventController.dispose();
    dateController.dispose();
    descriptionController.dispose();
    galleryOrderController.dispose();
    eventsOrderController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
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
    int? galleryOrder;
    int? eventsOrder;

    final userError = ref.watch(userFileError);
    final userData = ref.watch(userFileData);

    final labelTextStyle = Theme.of(context).textTheme.titleMedium?.copyWith(
        color: Theme.of(context).colorScheme.onPrimary, fontSize: 20);

    return LayoutBuilder(builder: (context, constraints) {
      final width = MediaQuery.of(context).size.width;
      final height = constraints.maxHeight;
      return Align(
        alignment: Alignment.center,
          child: SizedBox(
              height: height*0.95,
              width: width / 1.2,
              child: Card(
                child: Padding(
                  padding:
                      const EdgeInsetsDirectional.symmetric(horizontal: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ListTile(
                          leading: IconButton(
                              onPressed: () {
                                ref.read(adminPageChoice.notifier).state =
                                    'PhotoConfig';
                              },
                              icon: Icon(Icons.arrow_back))),
                      Container(
                        width: width*iconScale,
                        height: height*0.2,
                        color: Theme.of(context).colorScheme.onSurface,
                        child: TextButton(
                            onPressed: () {
                              ref.read(userFileError.notifier).state =
                                  'Hint: Use browser autofill if adding photos from same event/date.';
                              pickFile(ref);
                            },
                            child: userData.isEmpty
                                ? Text(
                                    'Add Photo (<20MB)',
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
                      AutofillGroup(
                        child: Column(
                          children: [
                            TextField(
                              controller: eventController,
                              autofillHints: const [AutofillHints.givenName],
                              decoration: InputDecoration(
                                  labelText: 'Event/TEAM/HOF',
                                  floatingLabelStyle: labelTextStyle,
                                  labelStyle: labelTextStyle),
                              onChanged: (val) => event = val,
                              focusNode: _focusNode1,
                              onSubmitted: (_) => FocusScope.of(context)
                                  .requestFocus(_focusNode2),
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onPrimary),
                              cursorColor:
                                  Theme.of(context).colorScheme.secondary,
                            ),
                            TextField(
                              controller: dateController,
                              autofillHints: const [AutofillHints.birthdayDay],
                              decoration: InputDecoration(
                                  labelText: 'Date / Position(TEAM)',
                                  floatingLabelStyle: labelTextStyle,
                                  labelStyle: labelTextStyle),
                              onChanged: (val) => date = val,
                              focusNode: _focusNode2,
                              onSubmitted: (_) => FocusScope.of(context)
                                  .requestFocus(_focusNode3),
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onPrimary),
                              cursorColor:
                                  Theme.of(context).colorScheme.secondary,
                            ),
                            TextField(
                              controller: descriptionController,
                              autofillHints: const [AutofillHints.impp],
                              decoration: InputDecoration(
                                  labelText: 'Description',
                                  floatingLabelStyle: labelTextStyle,
                                  labelStyle: labelTextStyle),
                              onChanged: (val) => description = val,
                              focusNode: _focusNode3,
                              onSubmitted: (_) => FocusScope.of(context)
                                  .requestFocus(_focusNode4),
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onPrimary),
                              cursorColor:
                                  Theme.of(context).colorScheme.secondary,
                            ),
                            TextField(
                              controller: galleryOrderController,
                              decoration: InputDecoration(
                                  labelText:
                                      'Gallery # (Keep blank to exclude image from gallery)',
                                  floatingLabelStyle: labelTextStyle,
                                  labelStyle: labelTextStyle),
                              onChanged: (val) =>
                                  galleryOrder = int.tryParse(val),
                              focusNode: _focusNode4,
                              onSubmitted: (_) => FocusScope.of(context)
                                  .requestFocus(_focusNode5),
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onPrimary),
                              cursorColor:
                                  Theme.of(context).colorScheme.secondary,
                            ),
                            TextField(
                              controller: eventsOrderController,
                              decoration: InputDecoration(
                                  labelText: 'Events #',
                                  floatingLabelStyle: labelTextStyle,
                                  labelStyle: labelTextStyle),
                              onChanged: (val) =>
                                  eventsOrder = int.tryParse(val),
                              focusNode: _focusNode5,
                              onSubmitted: (_) =>
                                  FocusScope.of(context).unfocus(),
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onPrimary),
                              cursorColor:
                                  Theme.of(context).colorScheme.secondary,
                            ),
                          ],
                        ),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                                                fixedSize: Size(width*0.6*iconScale, height*0.01*iconScale),
                          textStyle: labelTextStyle,
                        ),
                        onPressed: () {
                          event = eventController.text;
                          date = dateController.text;
                          description = descriptionController.text;
                          galleryOrder =
                              int.tryParse(galleryOrderController.text);
                          eventsOrder =
                              int.tryParse(eventsOrderController.text);

                          if (event == '') {
                            ref.read(userFileError.notifier).state =
                                'Fill event field';
                          } else if (userData.isEmpty) {
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
                                galleryOrder: galleryOrder ?? -1,
                                eventsOrder: eventsOrder ?? -1,
                                filesStorage: userData[2]);
                            // Clear image and details on successful addition
                            fileTrackerInsert(newPhoto, ref).then((_) {
                              eventController.clear();
                              dateController.clear();
                              descriptionController.clear();
                              galleryOrderController.clear();
                              eventsOrderController.clear();
                              ref.read(userFileData.notifier).state = [];
                            });
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

// File selection + upload logic
Future<void> pickFile(ref) async {
  await Future.delayed(Duration(milliseconds: 50));
  final result = await FilePicker.platform.pickFiles(
    type: FileType.custom,
    allowedExtensions: ['jpg', 'png'],
    withData: true,
  );

if (result != null && result.files.isNotEmpty) {
  final file = result.files.first;
  final name = file.name;
  final extension = file.extension;
  final sizeInMB = file.size / (1024 * 1024);
  final Uint8List? fileBytes = file.bytes;

  //  File size check
  if (sizeInMB > 20) {
    ref.read(userFileError.notifier).state = 'File Too Big, Reduce To <20 mb';
    return;
  }

  //  File extension check
  if (extension != 'jpg' && extension != 'png') {
    ref.read(userFileError.notifier).state = 'Wrong file format uploaded';
    return;
  }

  //  Duplicate file check
  final currentNames = ref.watch(fileNames);
  if (currentNames.contains(name)) {
    ref.read(userFileError.notifier).state = 'File already exists';
    return;
  }

  // Server max file count check
  if (currentNames.length>50) {
    ref.read(userFileError.notifier).state = 'Max files treshold crosse, delete some photos to clear space';
    return;
  }

  // Server storage check
  final usedStorage = await storageUsed();
  if (usedStorage + sizeInMB >= 500) {
    ref.read(userFileError.notifier).state =
        'Server max storage exceeded, delete some photos to clear space';
    return;
  }

  // Upload file
  final uploadResponse = await uploadFile(name, fileBytes!);

  if (uploadResponse[0] == 200) {
    ref.read(userFileData.notifier).state = [
      name,
      uploadResponse[1], // file URL
      sizeInMB,
      fileBytes
    ];
  } else {
    ref.read(userFileError.notifier).state = uploadResponse[1];
    ref.read(userFileData.notifier).state = [];
  }
}

}

// Insert file record to database
Future<void> fileTrackerInsert(FileRow newPhoto, WidgetRef ref) async {
  final response = await insertFile(newPhoto.toJson());
  if (response == 200) {
    ref.read(userFileError.notifier).state = 'File uploaded successfully';
    retrieveFiles(ref);
  } else {
    ref.read(userFileError.notifier).state = 'File Tracker error: $response';
  }
}
