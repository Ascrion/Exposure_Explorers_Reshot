import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../services/file_tracker_db.dart';

class HofPage extends HookConsumerWidget {
  const HofPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    useEffect(() {
      retrieveFilesHOF(ref);
      return null;
    }, []);
    // Extract stored hof request data
    final hof = ref.watch(hofProvider);
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.width;
    final gridColumns = 4;
    final childAspectRatio = 0.75;
    final bodyTextStyle = Theme.of(context)
        .textTheme
        .bodyMedium
        ?.copyWith(color: Theme.of(context).colorScheme.onSecondary);
    final headerTextStyle = Theme.of(context)
        .textTheme
        .labelLarge
        ?.copyWith(color: Theme.of(context).colorScheme.secondary);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          'HALL OF FAME',
          style: headerTextStyle,
        ),
        Expanded(
          child: GridView.builder(
            itemCount: hof.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: gridColumns, // Number of columns
              mainAxisSpacing: 20, // Vertical spacing
              crossAxisSpacing: 20, // Horizontal spacing
              childAspectRatio: childAspectRatio, // Width / Height ratio
            ),
            itemBuilder: (context, index) {
              final currentImageData = hof[index];
              final currentImage = NetworkImage(currentImageData.fileURL);
              return GridTile(
                child: Card(
                  child: Container(
                    padding: EdgeInsetsGeometry.all(2),
                    width: (width * 0.5 )/ gridColumns,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          color: Theme.of(context).colorScheme.primary,
                          height: (height) / (10*childAspectRatio),
                          width: (width * 0.75)/ gridColumns,
                          child: Image(image: currentImage),
                        ),
                       Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              currentImageData.date,
                              style: headerTextStyle,
                              textAlign: TextAlign.center,
                            ),
                            Text(
                              currentImageData.description,
                              style: bodyTextStyle,
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ],
                    ),
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
