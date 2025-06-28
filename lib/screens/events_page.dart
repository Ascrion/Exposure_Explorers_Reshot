import 'package:exposure_explorer_reshot/models/temp_db.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../services/file_tracker_db.dart';
import 'home_screen.dart';

final currentEventPageDataProvider = StateProvider<List<dynamic>>((ref) => []);

// List of Events on the event page
class EventsPage extends HookConsumerWidget {
  const EventsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    useEffect(() {
      retrieveFilesEvents(ref);
      return null;
    }, []);
    // Extract stored events request data
    final events = ref.watch(eventsProvider);
    List eventList = [];
    for (var row in events) {
      if (eventList.contains(row.event)) {
        continue;
      } else {
        eventList.add(row.event);
      }
    }
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.width;
    final bodyTextStyle = Theme.of(context)
        .textTheme
        .bodyMedium
        ?.copyWith(color: Theme.of(context).colorScheme.onSecondary);
    final headerTextStyle = Theme.of(context)
        .textTheme
        .labelLarge
        ?.copyWith(color: Theme.of(context).colorScheme.secondary);
    final subheaderTextStyle = Theme.of(context)
        .textTheme
        .labelMedium
        ?.copyWith(color: Theme.of(context).colorScheme.secondary);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: width*0.73,
                color: Theme.of(context).colorScheme.surface,
          child: Text(
            'EVENTS',
            style: headerTextStyle,
            textAlign: TextAlign.center,
          ),
        ),
        Expanded(
          child: ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: eventList.length,
              itemBuilder: (context, index) {
                final currentEvent = eventList[index];
                // Get current Image Data
                List<FileRow> currentEventData = [];
                for (var i in events) {
                  if (i.event == currentEvent) {
                    currentEventData.add(i);
                  }
                }
                // Hero images
                const int maxImages = 4;

                return Padding(
                  padding: EdgeInsetsGeometry.symmetric(vertical: 10),
                  child: Material(
                      color: Theme.of(context).colorScheme.surface,
                      child: InkWell(
                          onTap: () {
                            ref.read(currentPage.notifier).state =
                                'EVENT PAGE';
                            ref
                                .read(currentEventPageDataProvider.notifier)
                                .state = [
                              currentEventData,
                              bodyTextStyle,
                              headerTextStyle,
                              height,
                              width
                            ];
                          },
                          child: Column(
                            children: [
                              Text(
                                currentEvent,
                                style: subheaderTextStyle,
                              ),
                              Padding(
                                padding: const EdgeInsets.all(2),
                                child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: currentEventData
                                      .take(maxImages)
                                      .map((file) => Image.network(file.fileURL,
                                          height:
                                              (height * 0.3) / eventList.length,
                                          width: (width * 0.6) / maxImages))
                                      .toList(),
                                ),
                              )
                            ],
                          ))),
                );
              }),
        ),
      ],
    );
  }
}

// Create a gallery view for each event
class CurrentEventPage extends ConsumerWidget {
  final List<FileRow> currentEventData;
  final TextStyle? bodyTextStyle;
  final TextStyle? headerTextStyle;
  final double height;
  final double width;
  const CurrentEventPage(this.currentEventData, this.bodyTextStyle,
      this.headerTextStyle, this.height, this.width,
      {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gridCols = 4;
    return Column(
      children: [Row(
              children: [
                IconButton(
                    onPressed: () =>
                        ref.read(currentPage.notifier).state = 'EVENTS',
                    icon: Icon(Icons.arrow_back)),
                Text(
                  currentEventData[0].event,
                  style: headerTextStyle,
                ),
              ],
            ),
        Expanded(
          child: GridView.builder(
            itemCount: currentEventData.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: gridCols, // Number of columns
              mainAxisSpacing: 20, // Vertical spacing
              crossAxisSpacing: 20, // Horizontal spacing
              childAspectRatio: 1.0, // Width / Height ratio
            ),
            itemBuilder: (context, index) {
              final currentImageData = currentEventData[index];
              final currentImage = NetworkImage(currentImageData.fileURL);
              return GridTile(
                child: Card(
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                        hoverColor: Theme.of(context)
                            .hoverColor, // fills full tile on hover
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (_) => AlertDialog(
                              title: Text(
                                currentImageData.name,
                                style: bodyTextStyle,
                                textAlign: TextAlign.center,
                              ),
                              content: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  Container(
                                    color: Theme.of(context).colorScheme.primary,
                                    height: height / 3,
                                    width: width * 0.5,
                                    child: Image(image: currentImage),
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Date: ${currentImageData.date}',
                                        style: bodyTextStyle,
                                        textAlign: TextAlign.left,
                                      ),
                                      Text(
                                        'Description: ${currentImageData.description}',
                                        style: bodyTextStyle,
                                        textAlign: TextAlign.left,
                                      ),
                                      Text(
                                        'Event: ${currentImageData.event}',
                                        style: bodyTextStyle,
                                        textAlign: TextAlign.left,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                        child: Padding(
                          padding: EdgeInsetsGeometry.all(8),
                          child: Image(
                            image: currentImage,
                            width: (width * 0.7) / gridCols,
                            fit: BoxFit.cover,
                          ),
                        )),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
