import 'user_login_screen_tablet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'admin_screen_tablet.dart';
import 'gallery_page_tablet.dart';
import 'events_page_tablet.dart';
import 'team_page_tablet.dart';
import 'hof_page_tablet.dart';
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


// Initialize widths to allow other pages to use it.
double iconScale = 1;
double leftWidth = 10;
double centerWidth =730;
double rightWidth = 170;

class HomePageTablet extends HookConsumerWidget {
  const HomePageTablet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          return LayoutBuilder(
            builder: (context, constraints) {
              final width = constraints.maxWidth;
              final height = constraints.maxHeight;
              iconScale = (width / 1024).clamp(0.4, 1.0);
              // larger width
              leftWidth = width*0.1;
              centerWidth = width*0.73;
              rightWidth = width*0.17;

              // smaller tablets
              if (width < 850) {
                leftWidth = width * 0.05;
                centerWidth = width * 0.85;
                rightWidth = width * 0.1;
                
              }

              return Row(
                children: [
                  Container(
                    width: leftWidth,
                    height: height,
                    color: Theme.of(context).colorScheme.primary,
                    child: LeftSidebar(),
                  ),
                  Container(
                    width: centerWidth,
                    height: height,
                    color: Theme.of(context).colorScheme.tertiary,
                    child: CentralBar(),
                  ),
                  Container(
                    width: rightWidth,
                    height: height,
                    color: Theme.of(context).colorScheme.primary,
                    child: RightSidebar(),
                  ),
                ],
              );
            },
          );
        },
      ),
      backgroundColor: Theme.of(context).colorScheme.primary,
    );
  }
}

class LeftSidebar extends ConsumerWidget {
  const LeftSidebar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final page = ref.watch(currentPage);
    final height = MediaQuery.of(context).size.height;
    final Uri nitgUrl = Uri.parse('https://www.nitgoa.ac.in/');
    final Uri instaUrl =
        Uri.parse('https://www.instagram.com/exposure.explorers_nitg/');
    // to control the home video
    final isPlaying = ref.watch(isVideoPlayingProvider);

    return Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, crossAxisAlignment: CrossAxisAlignment.center, children: [
      IconButton(
        padding: EdgeInsets.zero,
constraints: BoxConstraints(),
        onPressed: () async {
          ref.read(currentPage.notifier).state = 'HOME';
          await Future.delayed(Duration(seconds: 5));
        },
        icon: Icon(
          Icons.home,
          size: 50*iconScale,
        ),
      ),
      Text(page,
          textAlign: TextAlign.center,
          style: Theme.of(context)
              .textTheme
              .labelMedium
              ?.copyWith(color: Theme.of(context).colorScheme.secondary)),
      InkWell(
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
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.secondary)),
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
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onSecondary)),
                ),
              ],
            ),
          );
        },
        child: Image.asset(
          'assets/images/NITG_White.png',
          width: 45*iconScale,
          height: 45*iconScale,
        ),
      ),
      InkWell(
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
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.secondary)),
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
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onSecondary)),
                ),
              ],
            ),
          );
        },
        child: Image.asset(
          'assets/icons/instagram_icon.png',
          width: 45*iconScale,
          height: 45*iconScale,
        ),
      ),
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
                        size: 45*iconScale,
                        color: Colors.red,
                      )
                    : Icon(
                        Icons.videocam,
                        size: 45*iconScale,
                        color: Colors.green,
                      ))
            : SizedBox(),
      ),
      SizedBox(
        height: height * 0.4*iconScale,
      ),
      Center(
        child: IconButton(
            padding: EdgeInsets.zero,
  constraints: BoxConstraints(),
          onPressed: () {
            ref.read(currentPage.notifier).state = 'USER';
          },
          icon: page == 'USER'
              ? Icon(
                  Icons.account_circle_outlined,
                  color: Theme.of(context).colorScheme.secondary,
                  size: 45*iconScale,
                )
              : Icon(
                  Icons.account_circle_outlined,
                  size: 45*iconScale,
                ),
        ),
      )
    ]);
  }
}

class CentralBar extends ConsumerWidget {
  const CentralBar({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final page = ref.watch(currentPage);
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final height = constraints.maxHeight;
        return Column(
          children: [
            Container(
              color: page == "HOME"?Theme.of(context).colorScheme.primary:Colors.transparent,
              width: width,
              height: height * 0.96,
              child: CenterMain(),
            ),
            Container(
              width: width,
              height: height * 0.04,
              color: Theme.of(context).colorScheme.surface,
              child: CenterBottomBar(),
            ),
          ],
        );
      },
    );
  }
}

// Controls which 'page' content is displayed in the center
class CenterMain extends ConsumerWidget {
  const CenterMain({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final page = ref.watch(currentPage);
    final exposure = ref.watch(exposureSlider);

    //changes exposure of content (only for homepage as it block inputs in other pages)
    Color overlayColor;
    if (exposure < 0) {
      final opacity = (-exposure / 10).clamp(0.0, 1.0);
      overlayColor = Colors.black.withAlpha((opacity * 255).round());
    } else if (exposure > 0) {
      final opacity = (exposure / 10).clamp(0.0, 1.0);
      overlayColor = Colors.white.withAlpha((opacity * 255).round());
    } else {
      overlayColor = Colors.transparent;
    }

    // based on the page, change central content
    if (page == 'HOME') {
      return Stack(
        children: [
          HomePageContent(),
          Container(color: overlayColor)
        ], //Exposure Control
      );
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
      return Stack(
        children: [HomePageContent(), Container(color: overlayColor)],
      ); //default fallback
    }

    // page bypass for debugging purposes
    // return AdminPage();
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
    
        Center(
          child: AspectRatio(
            aspectRatio: 16 / 9,
            child: HeroVideo(),
          ),
        ),
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
          width: 28*iconScale,
          height: 28*iconScale,
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

class RightSidebar extends ConsumerWidget {
  const RightSidebar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final height = MediaQuery.of(context).size.height;
        final width = constraints.maxWidth;
        final exposure = ref.watch(exposureSlider);
        final page = ref.watch(currentPage);
        return Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SizedBox(
              width: width,
              height: height * 0.2,
              child: Image.asset('assets/images/logo.png', width: width),
            ),
            Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      Theme.of(context)
                          .colorScheme
                          .secondaryFixed, // strong glow at base
                      Theme.of(context).colorScheme.secondaryFixedDim,
                      Theme.of(context).colorScheme.primary // fade to black
                    ],
                    stops: [0.0, 0.1, 1.0],
                  ),
                ),
                child: SizedBox(
                    child: page == 'HOME'
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                exposure.round().toString(),
                                style: Theme.of(context)
                                    .textTheme
                                    .labelMedium
                                    ?.copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary),
                              ),
                              Slider(
                                min: -10,
                                max: 10,
                                value: exposure,
                                divisions: 20,
                                thumbColor:
                                    Theme.of(context).colorScheme.outline,
                                activeColor:
                                    Theme.of(context).colorScheme.tertiary,
                                inactiveColor:
                                    Theme.of(context).colorScheme.surface,
                                // for tooltip on thumb
                                onChanged: (val) {
                                  ref.read(exposureSlider.notifier).state = val;
                                },
                              ),
                            ],
                          )
                        : SizedBox(
                            height: height * 0.09*iconScale,
                          )) //Disable slider on other pages to avoid blocking inputs

                ),
            SizedBox(
              height: height * 0.6,
              child: Menu(),
            ),
          ],
        );
      },
    );
  }
}

class Menu extends ConsumerWidget {
  const Menu(
      //mention this.parameter being passed
      {super.key}); // Use positional + key

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final current = ref.watch(currentPage);
    final activeColor = Theme.of(context).colorScheme.secondary;
    final defaultColor = Theme.of(context).colorScheme.onPrimary;
    final defaultBG = Theme.of(context).colorScheme.primary;
    final hoverColor = Theme.of(context).colorScheme.outline;

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        for (final label in [
          'HOME',
          'GALLERY',
          'EVENTS',
          'HALL OF FAME',
          'TEAM',
        ])
          _NavItem(
            label: label,
            isActive: current == label,
            onTap: () => ref.read(currentPage.notifier).state = label,
            activeColor: activeColor,
            defaultColor: defaultColor,
            defaultBG: defaultBG,
            hoverColor: hoverColor,
            context: context,
          ),
      ],
    );
  }
}

class _NavItem extends StatefulWidget {
  final String label;
  final bool isActive;
  final VoidCallback onTap;
  final Color activeColor;
  final Color defaultColor;
  final Color defaultBG;
  final BuildContext context;
  final Color hoverColor;

  const _NavItem({
    required this.label,
    required this.isActive,
    required this.onTap,
    required this.activeColor,
    required this.defaultColor,
    required this.defaultBG,
    required this.context,
    required this.hoverColor,
  });

  @override
  State<_NavItem> createState() => _NavItemState();
}

class _NavItemState extends State<_NavItem> {
  bool _isHovered = false;
  @override
  Widget build(BuildContext context) {
    var color = widget.defaultColor;
    if (widget.isActive) {
      color = widget.activeColor;
    } else if (_isHovered) {
      color = widget.hoverColor;
    } else {
      color = widget.defaultColor;
    }

    return Material(
      color: widget.defaultBG,
      child: InkWell(
        onTap: widget.onTap,
        onHover: (hovering) => setState(() => _isHovered = hovering),
        hoverColor: Colors.transparent,
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 8.0*iconScale),
          child: Text(
            widget.label,
            style: Theme.of(widget.context)
                .textTheme
                .labelLarge
                ?.copyWith(color: color),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
