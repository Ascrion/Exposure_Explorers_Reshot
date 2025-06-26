import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../services/file_tracker_db.dart';
import '../models/temp_db.dart';
import '../screens/admin_screen.dart';

// User file errot tracker
final userErrorProvider = StateProvider<String>((ref) => '');

class EditPhoto extends ConsumerStatefulWidget {
  const EditPhoto({super.key});

  @override
  ConsumerState<EditPhoto> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<EditPhoto> {
  final _focusNode1 = FocusNode();
  final _focusNode2 = FocusNode();
  final _focusNode3 = FocusNode();
  final _focusNode4 = FocusNode();
  final _focusNode5 = FocusNode();

  @override
  void dispose() {
    _focusNode1.dispose();
    _focusNode2.dispose();
    _focusNode3.dispose();
    _focusNode4.dispose();
    _focusNode5.dispose();

    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    // Clear state providers
    Future.microtask(() {
      ref.read(userErrorProvider.notifier).state = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    FileRow currentRow = ref.watch(editingRowProvider);
    String userError = ref.watch(userErrorProvider);
    String description = '';
    String event = '';
    String date = '';
    int galleryOrder = 0;
    int eventsOrder = 0;

    final labelTextStyle = Theme.of(context).textTheme.titleMedium?.copyWith(
        color: Theme.of(context).colorScheme.onPrimary, fontSize: 20);

    return LayoutBuilder(builder: (context, constraints) {
      final width = MediaQuery.of(context).size.width;
      final height = constraints.maxHeight;
      return Align(
          child: SizedBox(
              height: height * 0.8,
              width: width / 2,
              child: Card(
                child: Padding(
                  padding:
                      const EdgeInsetsDirectional.symmetric(horizontal: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ListTile(
                          leading: IconButton(
                              onPressed: () {
                                ref.read(adminPageChoice.notifier).state =
                                    'PhotoConfig'; // Return Back
                              },
                              icon: Icon(Icons.arrow_back))),
                      Container(
                          width: width / 3,
                          height: height / 10,
                          color: Theme.of(context).colorScheme.onSurface,
                          child: Image.network(currentRow.fileURL)),
                      SizedBox(
                        height: height / 20,
                        child: Text(
                          userError,
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.error),
                        ),
                      ),
                      TextField(
                        decoration: InputDecoration(
                            labelText: 'Event',
                            floatingLabelStyle: labelTextStyle,
                            labelStyle: labelTextStyle,
                            hintText: currentRow.event),
                        onChanged: (val) => event = val,
                        focusNode: _focusNode1,
                        onSubmitted: (_) =>
                            FocusScope.of(context).requestFocus(_focusNode2),
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context).colorScheme.onPrimary),
                        cursorColor: Theme.of(context).colorScheme.secondary,
                      ),
                      TextField(
                        decoration: InputDecoration(
                            labelText: 'Date / Position(TEAM)',
                            floatingLabelStyle: labelTextStyle,
                            labelStyle: labelTextStyle,
                             hintText: currentRow.date),
                        onChanged: (val) => date = val,
                        focusNode: _focusNode2,
                        onSubmitted: (_) =>
                            FocusScope.of(context).requestFocus(_focusNode3),
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context).colorScheme.onPrimary),
                        cursorColor: Theme.of(context).colorScheme.secondary,
                      ),
                      TextField(
                        decoration: InputDecoration(
                            labelText: 'Description',
                            floatingLabelStyle: labelTextStyle,
                            labelStyle: labelTextStyle,
                             hintText: currentRow.description),
                        onChanged: (val) => description = val,
                        focusNode: _focusNode3,
                        onSubmitted: (_) =>
                            FocusScope.of(context).requestFocus(_focusNode4),
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context).colorScheme.onPrimary),
                        cursorColor: Theme.of(context).colorScheme.secondary,
                      ),
                      TextField(
                        decoration: InputDecoration(
                            labelText: 'Gallery Order',
                            floatingLabelStyle: labelTextStyle,
                            labelStyle: labelTextStyle,
                             hintText: currentRow.galleryOrder.toString()),
                        onChanged: (val) => int.tryParse(val)!,
                        focusNode: _focusNode4,
                        onSubmitted: (_) =>
                            FocusScope.of(context).requestFocus(_focusNode5),
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context).colorScheme.onPrimary),
                        cursorColor: Theme.of(context).colorScheme.secondary,
                      ),
                      TextField(
                        decoration: InputDecoration(
                            labelText: 'Events Order',
                            floatingLabelStyle: labelTextStyle,
                            labelStyle: labelTextStyle,
                             hintText: currentRow.eventsOrder.toString()),
                        onChanged: (val) => eventsOrder = int.tryParse(val)!,
                        focusNode: _focusNode5,
                        onSubmitted: (_) => FocusScope.of(context).unfocus(),
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context).colorScheme.onPrimary),
                        cursorColor: Theme.of(context).colorScheme.secondary,
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue, // 🔵 Background color
                          foregroundColor: Colors.white, // ⚪ Text color
                          elevation: 4, // ✨ Shadow
                          shape: RoundedRectangleBorder(
                            // 🔲 Border radius
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: EdgeInsets.symmetric(
                              horizontal: 50, vertical: 20),
                          textStyle: labelTextStyle,
                        ),
                        onPressed: () {
                          if (event.isEmpty) {
                            ref.read(userErrorProvider.notifier).state =
                                'Fill event field';
                          } else {
                            final newRow = FileRow(
                              id: currentRow.id,
                              name: currentRow.name,
                              event:
                                  event.isNotEmpty ? event : currentRow.event,
                              fileURL: currentRow.fileURL,
                              date: date.isNotEmpty ? date : currentRow.date,
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
              )));
    });
  }
}

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