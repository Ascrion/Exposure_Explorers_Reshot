import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../services/file_tracker_db.dart';

class TeamPage extends HookConsumerWidget {
  const TeamPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    useEffect(() {
      retrieveFilesTeam(ref);
      return null;
    }, []);
    // Extract stored team request data
    final team = ref.watch(teamProvider);
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
        Container(
          width: width*0.73,
          color: Theme.of(context).colorScheme.surface,
          child: Text(
            'TEAM',
            style: headerTextStyle,
                   textAlign: TextAlign.center,
          ),
        ),
        Expanded(
          child: GridView.builder(
            itemCount: team.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: gridColumns, // Number of columns
              mainAxisSpacing: 20, // Vertical spacing
              crossAxisSpacing: 20, // Horizontal spacing
              childAspectRatio: childAspectRatio, // Width / Height ratio
            ),
            itemBuilder: (context, index) {
              final currentImageData = team[index];
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
                               maxLines: 2,
                              overflow: TextOverflow.ellipsis,
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
