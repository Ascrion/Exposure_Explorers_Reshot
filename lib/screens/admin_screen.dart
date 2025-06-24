import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../services/file_tracker_db.dart';

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
            trailing: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.inversePrimary,
                foregroundColor: Colors.white,
                elevation: 4,
                shape: RoundedRectangleBorder(
                  // 🔲 Border radius
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                textStyle: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSecondary),
              ),
              child: Text('Save'),
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
      textAlign: TextAlign.center,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            iconColor: Theme.of(context).colorScheme.inversePrimary,
            leading: IconButton(
              onPressed: () => ref.read(adminPageChoice.notifier).state = '',
              icon: Icon(Icons.arrow_back_sharp),
            ),
            title: Text('Photos', style: headerTextStyle),
          ),
          DefaultTextStyle(
            style: titleStyle,
            textAlign: TextAlign.center,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Expanded(child: Text('Image')),
                Expanded(child: Text('Name')),
                Expanded(child: Text('Event')),
                Expanded(child: Text('Date')),
                Expanded(child: Text('Description')),
                Expanded(child: Text('Gallery#')),
                Expanded(child: Text('Event#')),
                Expanded(child: Text('Storage')),
              ],
            ),
          ),
          FileManager(bodyTextStyle),
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
            textAlign: TextAlign.center,
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
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Image.network(
                            fileURL,
                            height: 80,
                            width: 80,
                          ),
                          Text(currentRow.name),
                          Text(currentRow.event),
                          Text(currentRow.date),
                          Text(currentRow.description),
                          Text(currentRow.galleryOrder.toString()),
                          Text(currentRow.eventsOrder.toString()),
                          Text(currentRow.filesStorage.toString()),
                        ],
                      );
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
