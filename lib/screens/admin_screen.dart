import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_hooks/flutter_hooks.dart';
import '../services/db_generator.dart';

final adminPageChoice = StateProvider<String>((ref) => '');
final gDriveDetails = StateProvider<List<String>>((ref) =>
    ['loading', 'loading']); // Default case to prevent out of index crashes
final eventList = StateProvider<List<Map<String, dynamic>>>((ref) => []);

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
      case 'HallOfFameConfig':
        return HallOfFameConfig();
      case 'TeamConfig':
        return TeamConfig();
      case 'ContactConfig':
        return ContactConfig();
      case 'HomePageConfig':
        return HomePageConfig();
      case 'AdminConfig':
        return AdminConfig(headerTextStyle, subheaderTextStyle, bodyTextStyle);
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
      final width = constraints.maxWidth;
      return SizedBox(
          child: SingleChildScrollView(
              child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '  Admin Settings:',
            style: headerTextStyle,
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
            leading: Image.asset('assets/icons/editors_choice.png'),
            title: Text(
              'Hall Of Fame',
              style: subheaderTextStyle,
            ),
            subtitle: Text('Choose Photos for the Hall Of Fame'),
            trailing: Icon(Icons.arrow_forward),
            onTap: () =>
                ref.read(adminPageChoice.notifier).state = 'HallOfFameConfig',
          ),
          ListTile(
            leading: Icon(Icons.people_alt_rounded),
            title: Text(
              'Team',
              style: subheaderTextStyle,
            ),
            subtitle: Text('Edit Team members and positions'),
            trailing: Icon(Icons.arrow_forward),
            onTap: () =>
                ref.read(adminPageChoice.notifier).state = 'TeamConfig',
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
            leading: Icon(Icons.home),
            title: Text(
              'Homepage',
              style: subheaderTextStyle,
            ),
            subtitle: Text('Change HomePage Video & Description'),
            trailing: Icon(Icons.arrow_forward),
            onTap: () =>
                ref.read(adminPageChoice.notifier).state = 'HomePageConfig',
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text(
              'Config',
              style: subheaderTextStyle,
            ),
            subtitle: Text('Change G-Drive & Drive API Links'),
            trailing: Icon(Icons.arrow_forward),
            onTap: () {
              ref.read(adminPageChoice.notifier).state = 'AdminConfig';
            },
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.04,
          ),
          Text(
            '  Folder Structure:',
            style: headerTextStyle,
          ),
          Container(
            color: Theme.of(context).colorScheme.surface,
            width: width,
            child: GDriveExtractor(bodyTextStyle: bodyTextStyle),
          )
        ],
      )));
    });
  }
}

class PhotoConfig extends ConsumerWidget {
  final dynamic headerTextStyle;
  final dynamic subheaderTextStyle;
  final dynamic bodyTextStyle;

  const PhotoConfig(this.headerTextStyle, this.subheaderTextStyle, this.bodyTextStyle, {super.key});

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
                Expanded(child: Text('Gal_Order')),
                Expanded(child: Text('Eve_Order')),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
  child: Consumer(
    builder: (context, ref, _) {
      final photoAsync = ref.watch(photoMetadataProvider);

      return photoAsync.when(
        data: (photos) => ListView.builder(
          itemCount: photos.length,
          itemBuilder: (context, index) {
            final photo = photos[index];
            final fileID = photo['fileID'] ?? '';
            final imageUrl = "https://lh3.googleusercontent.com/d/1UuqUr4hi5tfSqZOEYtLkySPtedxRqBIe=s220";

            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      imageUrl,
                      height: 80,
                      width: 80,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) =>
                          const Icon(Icons.broken_image, size: 80),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(photo['name'] ?? '', style: TextStyle(fontWeight: FontWeight.bold)),
                        Text("Event: ${photo['event'] ?? ''}"),
                        Text("Date: ${photo['dateOfAddition'] ?? ''}"),
                        Text("Description: ${photo['description'] ?? ''}"),
                        Text("Gallery Order: ${photo['galleryOrder'] ?? ''}"),
                        Text("Events Order: ${photo['eventsOrder'] ?? ''}"),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Text('Error: $err', style: TextStyle(color: Colors.red)),
      );
    },
  ),
),

        ],
      ),
    );
  }
}


class HallOfFameConfig extends ConsumerWidget {
  const HallOfFameConfig({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Text('HallOfFameConfi');
  }
}

class TeamConfig extends ConsumerWidget {
  const TeamConfig({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Text('TeamConfig');
  }
}

class ContactConfig extends ConsumerWidget {
  const ContactConfig({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Text('ContactConfig');
  }
}

class HomePageConfig extends ConsumerWidget {
  const HomePageConfig({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Text('HomePageConfig');
  }
}

class AdminConfig extends HookConsumerWidget {
  final dynamic headerTextStyle;
  final dynamic subheaderTextStyle;
  final dynamic bodyTextStyle;

  const AdminConfig(
      this.headerTextStyle, this.subheaderTextStyle, this.bodyTextStyle,
      {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.watch(gDriveDetails);

    // Only call once on first build
    useEffect(() {
      syncGDriveLink(ref, 'get', '', 'FolderLink');
      syncGDriveLink(ref, 'get', '', 'APILink');
      return null;
    }, []); // Empty dependency list means: run once

    return Column(
      children: [
        ListTile(
          iconColor: Theme.of(context).colorScheme.inversePrimary,
          leading: IconButton(
            onPressed: () => ref.read(adminPageChoice.notifier).state = '',
            icon: Icon(Icons.arrow_back_sharp),
          ),
          title: Text('Config', style: headerTextStyle),
        ),
        ListTile(
          leading: Icon(Icons.add_to_drive),
          title: Text(
            'G-Drive Folder Link',
            style: subheaderTextStyle,
          ),
          subtitle: Text(data[0], style: bodyTextStyle),
          trailing: TextButton(
            onPressed: () {
              final controller = TextEditingController(text: '');
              showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  title: Text('Enter new link:', style: subheaderTextStyle),
                  content: TextField(
                    controller: controller,
                    decoration: InputDecoration(
                        labelText: 'New link..', labelStyle: bodyTextStyle),
                    style: bodyTextStyle,
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text('Cancel',
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.error)),
                    ),
                    TextButton(
                      onPressed: () {
                        final newLink = controller.text.trim();
                        if (newLink.isNotEmpty) {
                          syncGDriveLink(ref, 'set', newLink, 'FolderLink');
                        }
                        Navigator.pop(context);
                      },
                      child: Text('Save',
                          style: TextStyle(
                              color: Theme.of(context)
                                  .colorScheme
                                  .inverseSurface)),
                    ),
                  ],
                ),
              );
            },
            child: Text('Change G-Drive Link?', style: bodyTextStyle),
          ),
        ),
        // API link
        ListTile(
          leading: Icon(Icons.add_to_drive),
          title: Text(
            'Drive API link',
            style: subheaderTextStyle,
          ),
          subtitle: Text(data[1], style: bodyTextStyle),
          trailing: TextButton(
            onPressed: () {
              final controller = TextEditingController(text: '');
              showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  title: Text('Enter new link:', style: subheaderTextStyle),
                  content: TextField(
                    controller: controller,
                    decoration: InputDecoration(
                        labelText: 'New link..', labelStyle: bodyTextStyle),
                    style: bodyTextStyle,
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text('Cancel',
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.error)),
                    ),
                    TextButton(
                      onPressed: () {
                        final newLink = controller.text.trim();
                        if (newLink.isNotEmpty) {
                          syncGDriveLink(ref, 'set', newLink, 'APILink');
                        }
                        Navigator.pop(context);
                      },
                      child: Text('Save',
                          style: TextStyle(
                              color: Theme.of(context)
                                  .colorScheme
                                  .inverseSurface)),
                    ),
                  ],
                ),
              );
            },
            child: Text('Change API Link?', style: bodyTextStyle),
          ),
        ),
      ],
    );
  }
}

// Get or Set G Drive Link & DriveAPI link
void syncGDriveLink(WidgetRef ref, operation, link, mode) async {
  String keyName;
  int modeSelect;

  if (mode == 'FolderLink') {
    keyName = 'gdrivelink';
    modeSelect = 0;
  } else {
    keyName = 'driveApi';
    modeSelect = 1;
  }

  if (operation == 'get') {
    final res = await http.get(
      Uri.parse(
          'https://admin-info-api.navodiths.workers.dev/config/gdrive/get?key=$keyName'), //change key
    );

    if (res.statusCode == 200) {
      //json decode first
      final data = jsonDecode(res.body);
      final val = data['value'];

      final current = ref.read(gDriveDetails.notifier).state;
      final updated = [...current];
      updated[modeSelect] = val;
      ref.read(gDriveDetails.notifier).state = updated;
    } else {
      final current = ref.read(gDriveDetails.notifier).state;
      final updated = [...current];
      updated[modeSelect] = 'No link set';
      ref.read(gDriveDetails.notifier).state = updated;
    }
  } else {
    final response = await http.post(
      Uri.parse(
          'https://admin-info-api.navodiths.workers.dev/config/gdrive/put'),
      headers: {'Content-Type': 'application/json'}, // tell it is json
      body: jsonEncode({'key': keyName, 'value': link}),
    );
    if (response.statusCode == 201) {
      final current = ref.read(gDriveDetails.notifier).state;
      final updated = [...current];
      updated[modeSelect] = link;
      ref.read(gDriveDetails.notifier).state = updated;
    } else {
      final current = ref.read(gDriveDetails.notifier).state;
      final updated = [...current];
      updated[modeSelect] = 'Some error has occured';
      ref.read(gDriveDetails.notifier).state = updated;
    }
  }
}

// Create the API request
class GDriveExtractor extends ConsumerWidget {
  final dynamic bodyTextStyle;
  const GDriveExtractor({this.bodyTextStyle, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filesAsync = ref.watch(driveFilesProvider);
    final details = ref.watch(gDriveDetails);
    final apiKey = details[1];

    return filesAsync.when(
      data: (files) {
        // call the database generator and provide the event folders (Be careful not to use same name on two events)
        final Map<String, String> foldersMap = {
          for (final folder in files)
            folder['name'] as String: folder['id'] as String
        };
        dbCreator(ref, foldersMap, apiKey);

        // return folder structure
        final events = foldersMap.keys.toList();
        return ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: files.length,
          itemBuilder: (context, index) {
            return Text(
              '-  ${events[index]}',
              style: bodyTextStyle,
            );
          },
        );
      },
      loading: () => const CircularProgressIndicator(),
      error: (err, _) => Text(
        'Error: $err',
        style: bodyTextStyle,
      ),
    );
  }
}

final driveFilesProvider =
    FutureProvider<List<Map<String, dynamic>>>((ref) async {
  final details = ref.watch(gDriveDetails);
  final gdriveUrl = details[0];
  final apiKey = details[1];

  // Skip fetching until real data is available
  if (gdriveUrl == 'loading' || apiKey == 'loading') {
    throw Exception('Waiting for data...');
  }

  final folderId = extractFolderId(gdriveUrl);
  if (folderId == null || apiKey.isEmpty) {
    throw Exception(Text("Invalid Drive URL or API Key"));
  }

  final response = await http.get(Uri.parse(
      "https://www.googleapis.com/drive/v3/files?q='$folderId'+in+parents and mimeType='application/vnd.google-apps.folder'&key=$apiKey"));

  if (response.statusCode == 200) {
    final decoded = jsonDecode(response.body);
    final folders = (decoded['files'] as List).cast<
        Map<String, dynamic>>(); // To store event names and eventfolder ids
    ref.read(eventList.notifier).state = folders;
    return folders; // For UI
  } else {
    throw Exception('Failed to fetch files: ${response.body}');
  }
});

String? extractFolderId(String url) {
  final pattern = RegExp(r'/folders/([a-zA-Z0-9_-]+)|id=([a-zA-Z0-9_-]+)');
  final match = pattern.firstMatch(url);
  return match != null ? (match.group(1) ?? match.group(2)) : null;
}
