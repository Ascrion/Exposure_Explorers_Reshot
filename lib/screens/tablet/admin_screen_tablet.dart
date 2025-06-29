import 'package:exposure_explorer_reshot/models/temp_db.dart';
import 'edit_photos_tablet.dart';
import 'package:exposure_explorer_reshot/services/file_photo_bucket_connect.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'file_manager_tablet.dart';
import '../../services/file_tracker_db.dart';
import 'add_photos_tablet.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

// To choose setting pane
final adminPageChoice = StateProvider<String>((ref) => '');

// Tracks files to be deleted (use name to delete from r2 and db )
final deletePhotoList = StateProvider<List<String>>((ref) => []);

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

// Events creator
final eventsProvider = StateProvider<List<String>>((ref) => []);
final eventsDataProvider = StateProvider<List<dynamic>>((ref) => []);

// Track Current files present in storage to avoid duplicated in addition
final fileNames = StateProvider<List<String>>((ref) => []);

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
      case 'AddPhotos':
        return AddPhotos();
      case 'EditPhoto':
        return EditPhoto();
      case 'Help':
        return Help(headerTextStyle!, subheaderTextStyle!, bodyTextStyle!);
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
            leading: Icon(Icons.event_note_rounded),
            title: Text(
              'Admin Help',
              style: subheaderTextStyle,
            ),
            subtitle: Text('Documentation on using the admin page'),
            trailing: Icon(Icons.arrow_forward),
            onTap: () => ref.read(adminPageChoice.notifier).state = 'Help',
          ),
        ],
      ));
    });
  }
}

class Help extends ConsumerWidget {
  final TextStyle headerTextStyle;
  final TextStyle subheaderTextStyle;
  final TextStyle bodyTextStyle;

  const Help(this.headerTextStyle, this.subheaderTextStyle, this.bodyTextStyle,
      {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Row(
              children: [
                IconButton(
                  onPressed: () =>
                      ref.read(adminPageChoice.notifier).state = '',
                  icon: const Icon(Icons.arrow_back),
                ),
                Text('Admin Help', style: headerTextStyle),
              ],
            ),
            Expanded(
              child: Markdown(
                data: _helpMarkdown,
                styleSheet: MarkdownStyleSheet(
                  h1: headerTextStyle,
                  h2: subheaderTextStyle,
                  p: bodyTextStyle,
                  strong: bodyTextStyle.copyWith(fontWeight: FontWeight.bold),
                  listBullet: subheaderTextStyle,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

const String _helpMarkdown = """ ## Basic Image Details:  
Refer to the *Team* and *Hall of Fame* sections below for specific instructions.

Each image has the following fields:

- **Name**: Derived from the file name. Cannot be changed. *(Required)*  
- **Date**: The date the image was captured.  
- **Description**: A brief description of the image.  
- **Event**: The event the photo belongs to. *(Required)*  
- **Gallery #**: Determines the position of the photo in the main gallery. Must be > 0 for the photo to appear.  
- **Event #**: Determines the photo’s position within its specific event. Must be > 0 for visibility.  
- **Storage**: File size, automatically extracted.

## Adding Photos to Gallery / Event Section:

- Click the **Add Photos** button on the File Manager page.  
- Supported formats: **.jpg**, **.png**  
- Maximum size: **20MB per photo**
- total size must not exceed **500MB**  
- total number of files cannot exceed **50**
- **Event** is mandatory.  
- **Gallery #** and **Event #** default to -1 (Not shown) if not changed when adding photo.
- Press **Submit** after uploading.

## Adding Photos to Team:

- Follow the same steps as adding a gallery photo.  
- In the **Event** field, enter: **TEAM** (in **all caps**).  
- In the **Date** field, specify the **position** (e.g., President, Coordinator).  
- Use the **Description** to mention team member names and details. 
- Keep **Gallery #** empty to stop image from appearing in gallery.
- Use **Event #** to change position of current image in TEAM. 
- Press **Submit** once done.

## Adding Photos to Hall of Fame:

- Same as above.  
- In the **Event** field, enter: **HOF** (in **all caps**).  
- In the **Date** field, mention the date the photo was captured.  
- Use the **Description** to include the **Photographer’s name and details**.  
- Keep **Gallery #** empty to stop image from appearing in gallery.
- Use **Event #** to change position of current image in HOF.
- Press **Submit** once done.

## Editing Photos:

- Click the  **Edit** button next to the photo.  
- Existing values will be pre-filled.  
- Modify required fields.  
- Press **Submit** to save changes.

## Deleting Photos:

- Click the  **Delete** button beside the photo.  
- To undo a selection before deletion, click the **Undo** button.  
- Press **Save** to confirm deletion.  
- Once deleted, images **cannot be restored**.
""";

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
      child: SingleChildScrollView(
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
                  Text('File Manager', style: headerTextStyle),
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
                        style: Theme.of(context)
                            .textTheme
                            .labelMedium
                            ?.copyWith(
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
                          ? () => deletePhoto(deleteList, ref)
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
                        style:
                            Theme.of(context).textTheme.labelMedium?.copyWith(
                                  color: enableSaveButton == false
                                      ? Theme.of(context).colorScheme.surface
                                      : Theme.of(context)
                                          .colorScheme
                                          .inverseSurface,
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
      ),
    );
  }
}

// Delete Photo
Future<void> deletePhoto(List<String> deleteList, WidgetRef ref) async {
  for (var i in deleteList) {
    bool resR2 = await deleteFileR2(i);
    if (resR2) {
      bool resDB = await deleteFileDB(i);
      if (resDB) {
        final currentPhotoDeleteList = [...ref.read(deletePhotoList)];
        currentPhotoDeleteList.removeWhere(
          (element) => element == i,
        );

        ref.read(deletePhotoList.notifier).state = currentPhotoDeleteList;
        retrieveFiles(ref); // updated files after deletion
      }
    }
  }
}
