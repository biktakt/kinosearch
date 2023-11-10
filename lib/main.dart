import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'services/provider/film_provider.dart';
import 'src/app.dart';

// late ObjectBox objectbox;

void main() async {
  runApp(const Center(child: CircularProgressIndicator()));

  WidgetsFlutterBinding.ensureInitialized();

  final container = ProviderContainer();
  await container.read(objectBoxServiceProvider).init();

  runApp(
    UncontrolledProviderScope(
      container: container,
      child: const KinoSearchApp(),
    ),
  );
}
