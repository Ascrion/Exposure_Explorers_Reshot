import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_hooks/flutter_hooks.dart';

final adminPageChoice = StateProvider<String>((ref) => '');
final gDriveLink = StateProvider<String>((ref) => '');

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
        ?.copyWith(color: Theme.of(context).colorScheme.onSecondary);
    final page = ref.watch(adminPageChoice);
    switch (page) {
      case 'GalleryConfig':
        return GalleryConfig();
      case 'EventsConfig':
        return EventsConfig();
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
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '  Please Choose an option:',
          style: headerTextStyle,
        ),
        ListTile(
          leading: Icon(Icons.photo_library_sharp),
          title: Text(
            'Gallery',
            style: subheaderTextStyle,
          ),
          subtitle: Text('Choose Hero Photos for the gallery page'),
          trailing: Icon(Icons.arrow_forward),
          onTap: () =>
              ref.read(adminPageChoice.notifier).state = 'GalleryConfig',
        ),
        ListTile(
          leading: Icon(Icons.event_note_rounded),
          title: Text(
            'Events',
            style: subheaderTextStyle,
          ),
          subtitle: Text('Choose Hero Photos for each event'),
          trailing: Icon(Icons.arrow_forward),
          onTap: () =>
              ref.read(adminPageChoice.notifier).state = 'EventsConfig',
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
          onTap: () => ref.read(adminPageChoice.notifier).state = 'TeamConfig',
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
          subtitle: Text('Change G-Drive Link'),
          trailing: Icon(Icons.arrow_forward),
          onTap: () {
            ref.read(adminPageChoice.notifier).state = 'AdminConfig';
          },
        )
      ],
    );
  }
}

class GalleryConfig extends ConsumerWidget {
  const GalleryConfig({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Text('Gallery');
  }
}

class EventsConfig extends ConsumerWidget {
  const EventsConfig({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Text('Events');
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
    final String link = ref.watch(gDriveLink);

    // Only call once on first build
    useEffect(() {
      syncGDriveLink(ref, 'get', '');
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
            'G-Drive Link',
            style: subheaderTextStyle,
          ),
          subtitle: Text(link, style: bodyTextStyle),
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
                          syncGDriveLink(ref, 'set', newLink);
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
        )
      ],
    );
  }
}

// Get or Set G Drive Link
void syncGDriveLink(WidgetRef ref, operation, link) async {
  if (operation == 'get') {
    final res = await http.get(
      Uri.parse(
          'https://admin-info-api.navodiths.workers.dev/config/gdrive/get?key=gdrivelink'), //change key
    );

    if (res.statusCode == 200) {
      //json decode first
      final data = jsonDecode(res.body);
      final val = data['value'];
      ref.read(gDriveLink.notifier).state = val;
    } else {
      ref.read(gDriveLink.notifier).state = 'No link Set';
    }
  } else {
    final response = await http.post(
      Uri.parse(
          'https://admin-info-api.navodiths.workers.dev/config/gdrive/put'),
      headers: {'Content-Type': 'application/json'}, // tell it is json
      body: jsonEncode({'key': 'gdrivelink', 'value': link}),
    );
    if (response.statusCode == 201) {
      ref.read(gDriveLink.notifier).state =
          link; // To let user know that link successfully changed
    } else {
      ref.read(gDriveLink.notifier).state = 'Some Error has occured';
    }
  }
}
//curl "https://admin-info-api.navodiths.workers.dev/config/gdrive/get?key=gdrivelink"

// curl -X POST https://admin-info-api.navodiths.workers.dev/config/gdrive/put \
//   -H "Content-Type: application/json" \
//   -d '{"key": "gdrivelink", "value": "trial"}'
