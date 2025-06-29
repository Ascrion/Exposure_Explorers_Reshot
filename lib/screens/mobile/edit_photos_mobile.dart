import 'package:exposure_explorer_reshot/screens/tablet/home_page_tablet.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../services/file_tracker_db.dart';
import '../../models/temp_db.dart';
import 'admin_screen_mobile.dart';

// Edit Photo
Future<void> editPhoto(FileRow newRow, WidgetRef ref) async {
  bool resDB = await updateFileDB(newRow);
  if (resDB) {
    ref.read(userErrorProvider.notifier).state = 'File Updated Successfully';
    retrieveFiles(ref); // updated files after edit
  }else{
    ref.read(userErrorProvider.notifier).state = 'Error during File Edit';
  }
} 

// User file errot tracker
final userErrorProvider = StateProvider<String>((ref) => '');

class EditPhoto extends ConsumerStatefulWidget {
  const EditPhoto({super.key});

  @override
  ConsumerState<EditPhoto> createState() => _EditPageState();
}
class _EditPageState extends ConsumerState<EditPhoto> {
  final _focusNode1 = FocusNode();
  final _focusNode2 = FocusNode();
  final _focusNode3 = FocusNode();
  final _focusNode4 = FocusNode();
  final _focusNode5 = FocusNode();

  late final TextEditingController eventController;
  late final TextEditingController dateController;
  late final TextEditingController descController;
  late final TextEditingController galleryOrderController;
  late final TextEditingController eventsOrderController;

  @override
  void initState() {
    super.initState();

    final currentRow = ref.read(editingRowProvider);
    eventController = TextEditingController(text: currentRow.event);
    dateController = TextEditingController(text: currentRow.date);
    descController = TextEditingController(text: currentRow.description);
    galleryOrderController =
        TextEditingController(text: currentRow.galleryOrder.toString());
    eventsOrderController =
        TextEditingController(text: currentRow.eventsOrder.toString());

    Future.microtask(() {
      ref.read(userErrorProvider.notifier).state = '';
    });
  }

  @override
  void dispose() {
    _focusNode1.dispose();
    _focusNode2.dispose();
    _focusNode3.dispose();
    _focusNode4.dispose();
    _focusNode5.dispose();

    eventController.dispose();
    dateController.dispose();
    descController.dispose();
    galleryOrderController.dispose();
    eventsOrderController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    FileRow currentRow = ref.watch(editingRowProvider);
    String userError = ref.watch(userErrorProvider);

    final labelTextStyle = Theme.of(context).textTheme.titleMedium?.copyWith(
          color: Theme.of(context).colorScheme.onPrimary,
          fontSize: 20,
        );

    return LayoutBuilder(builder: (context, constraints) {
      final width = MediaQuery.of(context).size.width;
      final height = constraints.maxHeight;

      return Align(
        child: Container(
          alignment: Alignment.center,
          height: height/1.2,
          width: width / 1.2,
          child: Card(
            child: Padding(
              padding: const EdgeInsetsDirectional.symmetric(horizontal: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ListTile(
                    leading: IconButton(
                      onPressed: () {
                        ref.read(adminPageChoice.notifier).state = 'PhotoConfig';
                      },
                      icon: Icon(Icons.arrow_back),
                    ),
                  ),
                  Container(
                    width: width / 3,
                    height: height / 10,
                    color: Theme.of(context).colorScheme.onSurface,
                    child: Image.network(currentRow.fileURL),
                  ),
                  SizedBox(
                    height: height / 20,
                    child: Text(
                      userError,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.error,
                      ),
                    ),
                  ),
                  TextField(
                    controller: eventController,
                    decoration: InputDecoration(
                      labelText: 'Event/TEAM/HOF',
                      floatingLabelStyle: labelTextStyle,
                      labelStyle: labelTextStyle,
                    ),
                    focusNode: _focusNode1,
                    onSubmitted: (_) =>
                        FocusScope.of(context).requestFocus(_focusNode2),
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onPrimary),
                    cursorColor: Theme.of(context).colorScheme.secondary,
                  ),
                  TextField(
                    controller: dateController,
                    decoration: InputDecoration(
                      labelText: 'Date / Position(TEAM)',
                      floatingLabelStyle: labelTextStyle,
                      labelStyle: labelTextStyle,
                    ),
                    focusNode: _focusNode2,
                    onSubmitted: (_) =>
                        FocusScope.of(context).requestFocus(_focusNode3),
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onPrimary),
                    cursorColor: Theme.of(context).colorScheme.secondary,
                  ),
                  TextField(
                    controller: descController,
                    decoration: InputDecoration(
                      labelText: 'Description',
                      floatingLabelStyle: labelTextStyle,
                      labelStyle: labelTextStyle,
                    ),
                    focusNode: _focusNode3,
                    onSubmitted: (_) =>
                        FocusScope.of(context).requestFocus(_focusNode4),
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onPrimary),
                    cursorColor: Theme.of(context).colorScheme.secondary,
                  ),
                  TextField(
                    controller: galleryOrderController,
                    decoration: InputDecoration(
                      labelText: 'Gallery Order',
                      floatingLabelStyle: labelTextStyle,
                      labelStyle: labelTextStyle,
                    ),
                    keyboardType: TextInputType.number,
                    focusNode: _focusNode4,
                    onSubmitted: (_) =>
                        FocusScope.of(context).requestFocus(_focusNode5),
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onPrimary),
                    cursorColor: Theme.of(context).colorScheme.secondary,
                  ),
                  TextField(
                    controller: eventsOrderController,
                    decoration: InputDecoration(
                      labelText: 'Events Order',
                      floatingLabelStyle: labelTextStyle,
                      labelStyle: labelTextStyle,
                    ),
                    keyboardType: TextInputType.number,
                    focusNode: _focusNode5,
                    onSubmitted: (_) => FocusScope.of(context).unfocus(),
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onPrimary),
                    cursorColor: Theme.of(context).colorScheme.secondary,
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      fixedSize: Size(width*0.3*iconScale, height*0.05*iconScale),
                      textStyle: labelTextStyle,
                    ),
                    onPressed: () {
                      final event = eventController.text.trim();
                      final date = dateController.text.trim();
                      final description = descController.text.trim();
                      final galleryOrder =
                          int.tryParse(galleryOrderController.text) ?? 0;
                      final eventsOrder =
                          int.tryParse(eventsOrderController.text) ?? 0;

                      if (event.isEmpty) {
                        ref.read(userErrorProvider.notifier).state =
                            'Fill event field';
                      } else {
                        final newRow = FileRow(
                          id: currentRow.id,
                          name: currentRow.name,
                          event: event,
                          fileURL: currentRow.fileURL,
                          date: date,
                          description: description,
                          galleryOrder: galleryOrder,
                          eventsOrder: eventsOrder,
                          filesStorage: currentRow.filesStorage,
                        );
                        editPhoto(newRow, ref);
                      }
                    },
                    child: Text('Submit'),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}
