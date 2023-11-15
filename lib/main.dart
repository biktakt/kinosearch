import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'services/provider/film_provider.dart';
import 'services/sync_service.dart';
import 'src/app.dart';

void main() async {
  runApp(const Center(child: CircularProgressIndicator()));

  WidgetsFlutterBinding.ensureInitialized();

  final container = ProviderContainer();
  await container.read(objectBoxServiceProvider).init();

  final reference = container.read(objectBoxServiceProvider).store.reference;
  await MySyncService.instance.initIsolate();
  MySyncService.instance.sendPort.send(reference);

  runApp(
    UncontrolledProviderScope(
      container: container,
      child: const KinoSearchApp(),
    ),
  );
}
