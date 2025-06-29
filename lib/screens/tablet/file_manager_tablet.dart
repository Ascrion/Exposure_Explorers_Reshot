import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import '../../services/file_tracker_db.dart';

import 'admin_screen_tablet.dart';

class FileManager extends HookConsumerWidget {
  final dynamic bodyTextStyle;
  const FileManager(this.bodyTextStyle, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    
    // Retrieve files only once to avoid multiple read calls
    useEffect(() {
  retrieveFiles(ref).then((_) {
    // after files are loaded, get a list of current file names to avoid duplicates
    final tempDbList = ref.read(fileTableProvider);
    final currentNames = <String>[];
    for (var currentPhoto in tempDbList) {
      currentNames.add(currentPhoto.name);
    }
    ref.read(fileNames.notifier).state = currentNames;
  });
  return null;
}, []);

    final tempDbList = ref.watch(fileTableProvider); // repeated again to track file changes 
    final deleteList = ref.watch(deletePhotoList);

    return SizedBox(
        child: DefaultTextStyle(
            style: bodyTextStyle,
            child: Column(
              children: [
                ListView.builder(
                  shrinkWrap: true,
                  //physics: NeverScrollableScrollPhysics(),
                  itemCount: tempDbList.length,
                  itemBuilder: (context, index) {
                    // Data
                    final currentRow = tempDbList[index];
                    final name = currentRow.name;

                    //The download URL
                    final fileURL = currentRow.fileURL;
                    // Check if current photo [id,name] in delete list
                    bool isIdInDeleteList = deleteList.any(
                      (element) => element==name,
                    );
                    return LayoutBuilder(builder: (context, constraints) {
                      final width = constraints.maxWidth;
                      return Column(
                        children: [
                          Container(
                              color: Theme.of(context).colorScheme.surface,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  SizedBox(
                                    width: width * 0.4,
                                    child: Row(
                                      children: [
                                        Image.network(fileURL,
                                            height: 80, width: 80),
                                        SizedBox(width: 8),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                  'Name: ${currentRow.name}'), //immutable as referenced by r2
                                              Text(
                                                'Date: ${currentRow.date}',
                                                style: bodyTextStyle,
                                              ),

                                              Text(
                                                'Description: ${currentRow.description}',
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 2,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Text(
                                          currentRow.event,
                                        ),
                                        SizedBox(
                                          width: width * 0.01,
                                        ), // For alignment
                                        Text(
                                            currentRow.galleryOrder.toString()),
                                        SizedBox(
                                          width: width * 0.01,
                                        ),
                                        Text(currentRow.eventsOrder.toString()),
                                        SizedBox(
                                          width: width * 0.01,
                                        ),
                                        Text(currentRow.filesStorage
                                            .toStringAsPrecision(3)),
                                        Row(
                                          children: [
                                            IconButton(
                                                onPressed: () {
                                                  ref
                                                      .read(adminPageChoice
                                                          .notifier)
                                                      .state = 'EditPhoto';
                                                  ref
                                                      .read(editingRowProvider
                                                          .notifier)
                                                      .state = currentRow;
                                                },
                                                icon: Icon(
                                                  Icons.edit,
                                                  color: Colors.amber,
                                                )),
                                            IconButton(
                                              onPressed: () {
                                                final currentList = [
                                                  ...ref.read(deletePhotoList)
                                                ];
                                                if (isIdInDeleteList) {
                                                  currentList.removeWhere((e) =>
                                                      e == name);
                                                } else {
                                                  currentList.add(name);
                                                }
                                                ref
                                                    .read(deletePhotoList
                                                        .notifier)
                                                    .state = currentList;
                                              },
                                              icon: isIdInDeleteList == true
                                                  ? Icon(Icons.undo,
                                                      color:
                                                          const Color.fromARGB(
                                                              255, 76, 220, 28))
                                                  : Icon(Icons.delete_forever,
                                                      color:
                                                          Colors.red.shade300),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              )),
                          SizedBox(
                            height: 20,
                          )
                        ],
                      );
                    });
                  },
                )
              ],
            )));
  }
}