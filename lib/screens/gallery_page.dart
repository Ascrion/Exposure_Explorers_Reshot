import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../services/file_tracker_db.dart';

class GalleryPage extends HookConsumerWidget {
  const GalleryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    useEffect(() {
      retrieveFilesGallery(ref);
      return null;
    }, []);
    // Extract stored gallery request data
    final gallery = ref.watch(galleryProvider);
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.width;
    final gridColumns = 4;
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
            'GALLERY',
            style: headerTextStyle,
                   textAlign: TextAlign.center,
          ),
        ),
        Expanded(
          child: GridView.builder(
            itemCount: gallery.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: gridColumns, // Number of columns
              mainAxisSpacing: 20, // Vertical spacing
              crossAxisSpacing: 20, // Horizontal spacing
              childAspectRatio: 1.0, // Width / Height ratio
            ),
            itemBuilder: (context, index) {
              final currentImageData = gallery[index];
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
                            width: (width * 0.7) / gridColumns,
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
