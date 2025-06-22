import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AdminPage extends ConsumerWidget {
  const AdminPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final headerTextStyle = Theme.of(context).textTheme.labelLarge?.copyWith(color: Theme.of(context).colorScheme.onPrimary);
    return Scaffold(
      appBar: AppBar(title: Text('Welcome Dear Admin',style: headerTextStyle)),
      body: Center(
          child: Text('data'),));
  }
}