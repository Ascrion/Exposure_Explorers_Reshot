import 'package:exposure_explorer_reshot/models/temp_db.dart';
import 'package:exposure_explorer_reshot/screens/edit_photos.dart';
import 'package:exposure_explorer_reshot/services/file_photo_bucket_connect.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../services/file_tracker_db.dart';
import '../screens/add_photos.dart';

// To choose setting pane
final adminPageChoice = StateProvider<String>((ref) => '');

// Tracks files to be deleted (id needed for file tracker and name needed for r2 connect [id,name])
final deletePhotoList = StateProvider<List<List<dynamic>>>((ref) => []);

// Provide file to be edited to edit Page
final editingRowProvider = StateProvider<FileRow>((ref) => FileRow(
    id: -1,
    name: '',
    event: '',
    fileURL: '',
    date: '',
    description: '',
    galleryOrder: -1,
    eventsOrder: -1,
    filesStorage: 1));

class AdminPage extends ConsumerWidget {
  const AdminPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mainheaderTextStyle = Theme.of(context)
        .textTheme
        .headlineMedium
        ?.copyWith(color: Theme.of(context).colorScheme.onPrimary);
    return Scaffold(
        appBar: AppBar(
            title: Text('Welcome Dear Admin', style: mainheaderTextStyle)),
        body: SizedBox(child: PageSelector()));
  }
}

// Page redirect as on Tap cannot return funcions
class PageSelector extends ConsumerWidget {
  const PageSelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final headerTextStyle = Theme.of(context)
        .textTheme
        .labelLarge
        ?.copyWith(color: Theme.of(context).colorScheme.onPrimary);
    final subheaderTextStyle = Theme.of(context)
        .textTheme
        .labelMedium
        ?.copyWith(color: Theme.of(context).colorScheme.secondary);
    final bodyTextStyle = Theme.of(context)
        .textTheme
        .bodyMedium
        ?.copyWith(color: Theme.of(context).colorScheme.onPrimary);
    final page = ref.watch(adminPageChoice);
    switch (page) {
      case 'PhotoConfig':
        return PhotoConfig(headerTextStyle, subheaderTextStyle, bodyTextStyle);
      case 'ContactConfig':
        return ContactConfig();
      case 'GDriveConfig':
        return GDriveConfig(headerTextStyle, subheaderTextStyle, bodyTextStyle);
      case 'AddPhotos':
        return AddPhotos();
      case 'EditPhoto':
        return EditPhoto();
      default:
        return AdminHomePage(
            headerTextStyle, subheaderTextStyle, bodyTextStyle);
    }
  }
}

class AdminHomePage extends ConsumerWidget {
  final dynamic headerTextStyle;
  final dynamic subheaderTextStyle;
  final dynamic bodyTextStyle;
  const AdminHomePage(
      this.headerTextStyle, this.subheaderTextStyle, this.bodyTextStyle,
      {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return LayoutBuilder(builder: (context, constraints) {
      return SizedBox(
          child: SingleChildScrollView(
              child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            title: Text(
              '  Admin Settings:',
              style: headerTextStyle,
            ),
          ),
          ListTile(
            leading: Icon(Icons.event_note_rounded),
            title: Text(
              'Photos',
              style: subheaderTextStyle,
            ),
            subtitle: Text('Choose Hero Photos for each event'),
            trailing: Icon(Icons.arrow_forward),
            onTap: () =>
                ref.read(adminPageChoice.notifier).state = 'PhotoConfig',
          ),
          ListTile(
            leading: Icon(Icons.contact_phone_rounded),
            title: Text(
              'Contact',
              style: subheaderTextStyle,
            ),
            subtitle: Text('Change Contact and About Us'),
            trailing: Icon(Icons.arrow_forward),
            onTap: () =>
                ref.read(adminPageChoice.notifier).state = 'ContactConfig',
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text(
              'Config',
              style: subheaderTextStyle,
            ),
            subtitle: Text('Change G-Drive links for different events.'),
            trailing: Icon(Icons.arrow_forward),
            onTap: () {
              ref.read(adminPageChoice.notifier).state = 'GDriveConfig';
            },
          ),
        ],
      )));
    });
  }
}

class PhotoConfig extends ConsumerWidget {
  final dynamic headerTextStyle;
  final dynamic subheaderTextStyle;
  final dynamic bodyTextStyle;

  const PhotoConfig(
      this.headerTextStyle, this.subheaderTextStyle, this.bodyTextStyle,
      {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final deleteList = ref.watch(deletePhotoList);
    final dynamic titleStyle = Theme.of(context)
        .textTheme
        .labelMedium
        ?.copyWith(color: Theme.of(context).colorScheme.onSecondary);

    // Requires save button to be pressed to conduct action
    bool enableSaveButton = deleteList.isNotEmpty;

    return DefaultTextStyle(
      style: bodyTextStyle,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Row(
              children: [
                IconButton(
                  onPressed: () =>
                      ref.read(adminPageChoice.notifier).state = '',
                  icon: Icon(Icons.arrow_back),
                ),
                Text('Photos', style: headerTextStyle),
              ],
            ),
            Row(
              children: [
                SizedBox(
                  width: 150, // set width
                  child: ElevatedButton(
                    onPressed: () {
                      ref.read(adminPageChoice.notifier).state = 'AddPhotos';
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.surface,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4)),
                      elevation: 4,
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    ),
                    child: Text(
                      'Add Photos',
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
                SizedBox(
                  width: 150, // set width
                  child: ElevatedButton(
                    onPressed: enableSaveButton
                        ? () => 
                              deletePhoto(deleteList, ref)
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.surface,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                      elevation: 4,
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    ),
                    child: Text(
                      'SAVE',
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                            color: enableSaveButton == false
                                ? Theme.of(context).colorScheme.surface
                                : Theme.of(context).colorScheme.inverseSurface,
                          ),
                    ),
                  ),
                ),
              ],
            )
          ]),
          SizedBox(height: 10),
          DefaultTextStyle(
            style: titleStyle,
            textAlign: TextAlign.center,
            child: LayoutBuilder(builder: (context, constraints) {
              final width = constraints.maxWidth;
              return Column(children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: width * 0.4,
                      child: Text('Image Details'),
                    ),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text('Event'),
                          Text('Gallery#'),
                          Text('Event#'),
                          Text('Storage'),
                          Text('Delete'),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                FileManager(bodyTextStyle),
              ]);
            }),
          ),
        ],
      ),
    );
  }
}

class FileManager extends ConsumerWidget {
  final dynamic bodyTextStyle;
  const FileManager(this.bodyTextStyle, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tempDbList = ref.watch(fileTableProvider);
    final deleteList = ref.watch(deletePhotoList);

    return SizedBox(
        child: DefaultTextStyle(
            style: bodyTextStyle,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: tempDbList.length,
                    itemBuilder: (context, index) {
                      // Data
                      final currentRow = tempDbList[index];
                      final id = currentRow.id;
                      final name = currentRow.name;
                      //The download URL
                      final fileURL = currentRow.fileURL;
                      // Check if current photo [id,name] in delete list
                      bool isIdInDeleteList = deleteList.any(
                        (element) => element[0] == id && element[1] == name,
                      );
                      return LayoutBuilder(builder: (context, constraints) {
                        final width = constraints.maxWidth;
                        return Column(
                          children: [
                            Container(
                                color: Theme.of(context).colorScheme.surface,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    SizedBox(
                                      width: width * 0.4,
                                      child: Row(
                                        children: [
                                          Image.network(fileURL,
                                              height: 80, width: 80),
                                          SizedBox(width: 8),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                    'Name: ${currentRow.name}'), //immutable as referenced by r2
                                                Text(
                                                  'Date: ${currentRow.date}',
                                                  style: bodyTextStyle,
                                                ),

                                                Text(
                                                  'Description: ${currentRow.description}',
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  maxLines: 2,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Text(
                                            currentRow.event,
                                          ),
                                          SizedBox(
                                            width: width * 0.01,
                                          ), // For alignment
                                          Text(currentRow.galleryOrder
                                              .toString()),
                                          SizedBox(
                                            width: width * 0.01,
                                          ),
                                          Text(currentRow.eventsOrder
                                              .toString()),
                                          SizedBox(
                                            width: width * 0.01,
                                          ),
                                          Text(currentRow.filesStorage
                                              .toStringAsPrecision(3)),
                                          Row(
                                            children: [
                                              IconButton(
                                                  onPressed: () {
                                                    ref
                                                        .read(adminPageChoice
                                                            .notifier)
                                                        .state = 'EditPhoto';
                                                    ref.read(editingRowProvider.notifier).state = currentRow;
                                                  },
                                                  icon: Icon(
                                                    Icons.edit,
                                                    color: Colors.amber,
                                                  )),
                                              IconButton(
                                                onPressed: () {
                                                  final currentList = [
                                                    ...ref.read(deletePhotoList)
                                                  ];
                                                  if (isIdInDeleteList) {
                                                    currentList.removeWhere(
                                                        (e) =>
                                                            e[0] == id &&
                                                            e[1] == name);
                                                  } else {
                                                    currentList.add([id, name]);
                                                  }
                                                  ref
                                                      .read(deletePhotoList
                                                          .notifier)
                                                      .state = currentList;
                                                },
                                                icon: isIdInDeleteList == true
                                                    ? Icon(Icons.undo,
                                                        color: const Color
                                                            .fromARGB(
                                                            255, 76, 220, 28))
                                                    : Icon(Icons.delete_forever,
                                                        color: Colors
                                                            .red.shade300),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                )),
                            SizedBox(
                              height: 20,
                            )
                          ],
                        );
                      });
                    },
                  )
                ],
              ),
            )));
  }
}

class ContactConfig extends ConsumerWidget {
  const ContactConfig({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Text('ContactConfig');
  }
}

class GDriveConfig extends HookConsumerWidget {
  final dynamic headerTextStyle;
  final dynamic subheaderTextStyle;
  final dynamic bodyTextStyle;

  const GDriveConfig(
      this.headerTextStyle, this.subheaderTextStyle, this.bodyTextStyle,
      {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Text('data');
  }
}

// Delete Photo
Future<void> deletePhoto(List<List<dynamic>> deleteList, WidgetRef ref) async {
  for (var i in deleteList) {
    bool resR2 = await deleteFileR2(i[1]);
    if (resR2) {
      bool resDB = await deleteFileDB(i[0]);
      if (resDB) {
        final currentPhotoDeleteList = [...ref.read(deletePhotoList)];
        currentPhotoDeleteList.removeWhere(
          (element) => element[0] == i[0] && element[1] == i[1],
        );

        ref.read(deletePhotoList.notifier).state = currentPhotoDeleteList;
        retrieveFiles(ref); // updated files after deletion
      }
    }
  }
}
