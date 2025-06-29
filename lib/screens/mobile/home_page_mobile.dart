import './user_login_screen_mobile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'admin_screen_mobile.dart';
import 'gallery_page_mobile.dart';
import 'events_page_mobile.dart';
import 'team_page_mobile.dart';
import 'hof_page_mobile.dart';
import '../../services/video_player.dart';

final currentPage = StateProvider<String>((ref) => 'HOME');
final exposureSlider = StateProvider<double>((ref) => 0.0);
final userVideoChoice = StateProvider<bool>((ref) => true);

// Pass current time for the clock and rebuild the widget
final currentTime = StreamProvider<String>((ref) async* {
  yield DateTime.now().toString(); // at start
  while (true) {
    await Future.delayed(Duration(minutes: 1));
    yield DateTime.now().toString();
  }
});

// iconScale -> For larger tablets in potrait mode, it will scale up somethings accordinly
double iconScale = 1;

class HomePageMobile extends HookConsumerWidget {
  const HomePageMobile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    iconScale = (width / 900).clamp(0.7, 1);

    return Column(
      children: [
        Container(
          color: Theme.of(context).colorScheme.primary,
          width: width,
          height: height * 0.05,
          child: TopBar(),
        ),
        SizedBox(
          width: width,
          height: height * 0.85,
          child: CentralContentController(height * 0.85),
        ),
        Container(
          width: width,
          height: height * 0.05,
          color: Theme.of(context).colorScheme.surface,
          child: ActionPanel(),
        ),
        Container(
          width: width,
          height: height * 0.05,
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
          child: CenterBottomBar(),
        ),
      ],
    );
  }
}


// ignore: must_be_immutable
class CentralContentController extends ConsumerWidget {
  double parentHeight;
  CentralContentController(this.parentHeight, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        Stack(
          children: [
            Container(
                height: parentHeight,
                color: Theme.of(context).colorScheme.primary,
                child: CenterMain()),
            Column(
              children: [
                SizedBox(
                  height: parentHeight * 0.93,
                ),
                SizedBox(
                  height: parentHeight * 0.07,
                  child: MenuBar(),
                )
              ],
            )
          ],
        ),
      ],
    );
  }
}

// Controls which 'page' content is displayed in the center
class CenterMain extends ConsumerWidget {
  const CenterMain({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final page = ref.watch(currentPage);

    // based on the page, change central content
    if (page == 'HOME') {
      return HomePageContent();
    } else if (page == 'USER') {
      return UserPageContent();
    } else if (page == 'ADMIN') {
      return AdminPage();
    } else if (page == 'GALLERY') {
      return GalleryPageContent();
    } else if (page == 'EVENTS') {
      return EventsPageContent();
    } else if (page == 'EVENT PAGE') {
      final currentEventPageData = ref.watch(currentEventPageDataProvider);
      return CurrentEventPage(
          currentEventPageData[0],
          currentEventPageData[1],
          currentEventPageData[2],
          currentEventPageData[3],
          currentEventPageData[4]);
    } else if (page == 'TEAM') {
      return TeamPageContent();
    } else if (page == 'HALL OF FAME') {
      return HOFPageContent();
    } else {
      return HomePageContent(); //default fallback
    }
  }
}

// To select page
class MenuBar extends ConsumerWidget {
  const MenuBar({super.key});

  final List<String> pages = const [
    'EVENTS',
    'GALLERY',
    'HOME',
    'HALL OF FAME',
    'TEAM',
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final page = ref.watch(currentPage);
    final nonActiveBg = Theme.of(context).colorScheme.tertiary;
    final activeBg = Theme.of(context).colorScheme.secondary;

    final baseStyle = ElevatedButton.styleFrom(
      foregroundColor: Theme.of(context).colorScheme.onPrimary,
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      textStyle: Theme.of(context).textTheme.bodyMedium,
      fixedSize: Size(200 * iconScale, 30 * iconScale),
    );

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: pages.map((label) {
          final isActive = page == label;
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () => ref.read(currentPage.notifier).state = label,
              style: baseStyle.copyWith(
                backgroundColor:
                    WidgetStateProperty.all(isActive ? activeBg : nonActiveBg),
              ),
              child: Text(label,textAlign: TextAlign.center,),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class TopBar extends ConsumerWidget {
  const TopBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Uri nitgUrl = Uri.parse('https://www.nitgoa.ac.in/');
    final Uri instaUrl =
        Uri.parse('https://www.instagram.com/exposure.explorers_nitg/');
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () async {
              showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  title: Text('Do you want to be redirected to NITGoa Site?',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onSecondary)),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text('No',
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(
                                  color:
                                      Theme.of(context).colorScheme.secondary)),
                    ),
                    TextButton(
                      onPressed: () async {
                        if (await canLaunchUrl(nitgUrl)) {
                          await launchUrl(nitgUrl,
                              mode: LaunchMode.externalApplication);
                        } else {
                          throw 'Could not launch $nitgUrl';
                        }
                        // ignore: use_build_context_synchronously
                        Navigator.pop(context);
                      },
                      child: Text('Yes',
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSecondary)),
                    ),
                  ],
                ),
              );
            },
            child: Image.asset(
              'assets/images/NITG_White.png',
              width: 45 * iconScale,
              height: 45 * iconScale,
            ),
          ),
        ),
        Text(
          'Exposure Explorers',
          textAlign: TextAlign.center,
          style: Theme.of(context)
              .textTheme
              .headlineLarge
              ?.copyWith(color: Theme.of(context).colorScheme.secondary),
        ),
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () async {
              showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  title: Text(
                      'Do you want to be redirected to Exposure Explorer'
                      's Instagram Page?',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onSecondary)),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text('No',
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(
                                  color:
                                      Theme.of(context).colorScheme.secondary)),
                    ),
                    TextButton(
                      onPressed: () async {
                        if (await canLaunchUrl(instaUrl)) {
                          await launchUrl(instaUrl,
                              mode: LaunchMode.externalApplication);
                        } else {
                          throw 'Could not launch $instaUrl';
                        }
                        // ignore: use_build_context_synchronously
                        Navigator.pop(context);
                      },
                      child: Text('Yes',
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSecondary)),
                    ),
                  ],
                ),
              );
            },
            child: Image.asset(
              'assets/icons/instagram_icon.png',
              width: 45 * iconScale,
              height: 45 * iconScale,
            ),
          ),
        ),
      ],
    );
  }
}

class ActionPanel extends ConsumerWidget {
  const ActionPanel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final page = ref.watch(currentPage);
    // to control the home video
    final isPlaying = ref.watch(isVideoPlayingProvider);
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          IconButton(
            padding: EdgeInsets.zero,
            constraints: BoxConstraints(),
            onPressed: () async {
              ref.read(currentPage.notifier).state = 'HOME';
              await Future.delayed(Duration(seconds: 5));
            },
            icon: Icon(
              Icons.home,
              size: 50 * iconScale,
            ),
          ),
          Text(page,
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .labelLarge
                  ?.copyWith(color: Theme.of(context).colorScheme.secondary)),
          SizedBox(
            child: page == 'HOME'
                ? IconButton(
                    padding: EdgeInsets.zero,
                    constraints: BoxConstraints(),
                    onPressed: () {
                      if (isPlaying) {
                        ref.read(videoControllerProvider.notifier).pause();
                        ref.read(userVideoChoice.notifier).state = false;
                      } else {
                        ref.read(videoControllerProvider.notifier).play();
                        ref.read(userVideoChoice.notifier).state = true;
                      }
                    },
                    icon: isPlaying
                        ? Icon(
                            Icons.videocam_off,
                            size: 45 * iconScale,
                            color: Colors.red,
                          )
                        : Icon(
                            Icons.videocam,
                            size: 45 * iconScale,
                            color: Colors.green,
                          ))
                : SizedBox(),
          ),
          IconButton(
            padding: EdgeInsets.zero,
            constraints: BoxConstraints(),
            onPressed: () {
              ref.read(currentPage.notifier).state = 'USER';
            },
            icon: page == 'USER'
                ? Icon(
                    Icons.account_circle_outlined,
                    color: Theme.of(context).colorScheme.secondary,
                    size: 45 * iconScale,
                  )
                : Icon(
                    Icons.account_circle_outlined,
                    size: 45 * iconScale,
                  ),
          )
        ]);
  }
}

class HomePageContent extends HookConsumerWidget {
  const HomePageContent({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final videoChoice = ref.watch(userVideoChoice);
    final controller = ref.read(videoControllerProvider.notifier);

    useEffect(() {
      Future.delayed(const Duration(milliseconds: 100), () {
        if (videoChoice) {
          controller.play();
        } else {
          controller.pause();
        }
      });
      return null;
    }, [videoChoice]);

    return Stack(
      children: [
        const HeroVideo(),
        Center(
          child: Text(
            'Exposure Explorers \n is the official \n Photography & Videography \n Club of NIT Goa',
            textAlign: TextAlign.center,
            style: Theme.of(context)
                .textTheme
                .headlineLarge
                ?.copyWith(color: Theme.of(context).colorScheme.onSecondary),
          ),
        ),
      ],
    );
  }
}

class CenterBottomBar extends ConsumerWidget {
  const CenterBottomBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final datetime = ref.watch(currentTime).value;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        SvgPicture.asset(
          'assets/icons/connection.svg',
          width: 28 * iconScale,
          height: 28 * iconScale,
        ),
        Text(
          'F2.1',
          style: Theme.of(context)
              .textTheme
              .labelMedium
              ?.copyWith(color: Theme.of(context).colorScheme.secondary),
        ),
        Text(
          '© 2025 Navodith Sheth',
          style: Theme.of(context)
              .textTheme
              .labelMedium
              ?.copyWith(color: Theme.of(context).colorScheme.onPrimary),
        ),
        Text(
          '$datetime',
          style: Theme.of(context)
              .textTheme
              .labelMedium
              ?.copyWith(color: Theme.of(context).colorScheme.onPrimary),
        ),
      ],
    );
  }
}

class UserPageContent extends ConsumerWidget {
  const UserPageContent({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return LoginPage();
  }
}

class GalleryPageContent extends ConsumerWidget {
  const GalleryPageContent({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GalleryPage();
  }
}

class EventsPageContent extends ConsumerWidget {
  const EventsPageContent({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return EventsPage();
  }
}

class TeamPageContent extends ConsumerWidget {
  const TeamPageContent({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return TeamPage();
  }
}

class HOFPageContent extends ConsumerWidget {
  const HOFPageContent({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return HofPage();
  }
}
