import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

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
      case 'HallOfFameConfig':
        return HallOfFameConfig();
      case 'TeamConfig':
        return TeamConfig();
      case 'ContactConfig':
        return ContactConfig();
      case 'HomePageConfig':
        return HomePageConfig();
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
