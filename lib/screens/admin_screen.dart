import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../services/file_tracker_db.dart';
import '../screens/add_photos.dart';

// To choose setting pane
final adminPageChoice = StateProvider<String>((ref) => '');

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
    final dynamic titleStyle = Theme.of(context)
        .textTheme
        .labelMedium
        ?.copyWith(color: Theme.of(context).colorScheme.onSecondary);

    return DefaultTextStyle(
      style: bodyTextStyle,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
            Row(
              children: [
                IconButton(
                  onPressed: () => ref.read(adminPageChoice.notifier).state = '',
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
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      foregroundColor: Colors.white,
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
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
                SizedBox(width: 20,),
               SizedBox(
                  width: 150, // set width
                  child: ElevatedButton(
                    onPressed: () {
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      foregroundColor: Colors.white,
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    ),
                    child: Text(
                      'SAVE',
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                            color: Theme.of(context).colorScheme.inverseSurface,
                          ),
                    ),
                  ),
                ),
              ],
            )
          ]),
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
    final workerUrl = "file-fetcher-api.navodiths.workers.dev";
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
                      final currentRow = tempDbList[index];
                      final id = currentRow.id;
                      final fileURL = currentRow
                          .fileURL; //The key with which the file was uploaded
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
                                                    'Name: ${currentRow.name}'),
                                                Text(
                                                    'Date: ${currentRow.date}'),
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
                                              .toString()),
                                          SizedBox(
                                            width: width * 0.01,
                                          ),
                                          IconButton(
                                            onPressed: () {},
                                            icon: Icon(Icons.delete_forever,
                                                color: Colors.red.shade300),
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
