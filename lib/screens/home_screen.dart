import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';

final currentPage = StateProvider<String>((ref) => 'HOME');
final exposureSlider = StateProvider<double>((ref) => 0.0);

// Pass current time for the clock and rebuild the widget
final currentTime = StreamProvider<String>((ref) async* {
  yield DateTime.now().toString(); // at start
  while (true) {
    await Future.delayed(Duration(minutes: 1));
    yield DateTime.now().toString();
  }
});

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          final width = MediaQuery.of(context).size.width;
          final height = MediaQuery.of(context).size.height;
          return Row(
            children: [
              Container(
                color: Theme.of(context).colorScheme.primary,
                width: width * 0.09,
                height: height,
                child: LeftSidebar(),
              ),
              Container(
                color: Theme.of(context).colorScheme.tertiary,
                width: width * 0.71,
                height: height,
                child: CentralBar(),
              ),
              Container(
                color: Theme.of(context).colorScheme.primary,
                width: width * 0.2,
                height: height,
                child: RightSidebar(),
              )
            ],
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
    final Uri url = Uri.parse('https://www.nitgoa.ac.in/');

    return Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
      IconButton(
        onPressed: () {
          ref.read(currentPage.notifier).state = 'HOME';
        },
        icon: Icon(
          Icons.home,
          size: 50,
        ),
      ),
      Text(page,
          textAlign: TextAlign.center,
          style: Theme.of(context)
              .textTheme
              .labelLarge
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
                    if (await canLaunchUrl(url)) {
                      await launchUrl(url,
                          mode: LaunchMode.externalApplication);
                    } else {
                      throw 'Could not launch $url';
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
          '../../assets/images/NITG_White.png',
          width: 45,
          height: 45,
        ),
      ),
      SizedBox(
        height: height * 0.6,
      ),
      IconButton(
          onPressed: () {},
          icon: Icon(
            Icons.account_circle_outlined,
            size: 45,
          ))
    ]);
  }
}

class CentralBar extends ConsumerWidget {
  const CentralBar({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final height = constraints.maxHeight;

        return Column(
          children: [
            SizedBox(
              width: width,
              height: height * 0.96,
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
          width: 28,
          height: 28,
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
        return Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SizedBox(
              width: width,
              height: height * 0.2,
              child: Image.asset('../../assets/images/logo.png', width: width),
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
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    exposure.round().toString(),
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: Theme.of(context).colorScheme.secondary),
                  ),
                  Slider(
                    min: -10,
                    max: 10,
                    value: exposure,
                    divisions: 20,
                    thumbColor: Theme.of(context).colorScheme.outline,
                    activeColor: Theme.of(context).colorScheme.tertiary,
                    inactiveColor: Theme.of(context).colorScheme.surface,
                    // for tooltip on thumb
                    onChanged: (val) {
                      ref.read(exposureSlider.notifier).state = val;
                    },
                  ),
                ],
              ),
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
   final hoverColor =  Theme.of(context).colorScheme.outline;

return Column(
  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  children: [
    for (final label in ['HOME', 'GALLERY', 'EVENTS', 'HALL OF FAME', 'TEAM', 'CONTACT'])
      _NavItem(
        label: label,
        isActive: current == label,
        onTap: () => ref.read(currentPage.notifier).state = label,
        activeColor: activeColor,
        defaultColor: defaultColor,
        defaultBG: defaultBG,
        hoverColor:hoverColor,
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
    if (widget.isActive){
       color = widget.activeColor;
    }
    else if (_isHovered){
      color = widget.hoverColor;
    }
    else{
      color = widget.defaultColor;
    }

    return Material(
      color: widget.defaultBG,
      child: InkWell(
        onTap: widget.onTap,
        onHover: (hovering) => setState(() => _isHovered = hovering),
         hoverColor: Colors.transparent,
  splashColor: Colors.transparent,   // 👈 disables ripple
  highlightColor: Colors.transparent,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            widget.label,
            style: Theme.of(widget.context)
                .textTheme
                .labelLarge
                ?.copyWith(color: color),
          ),
        ),
      ),
    );
  }
}
