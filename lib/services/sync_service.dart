import 'dart:async';
import 'dart:isolate';

import 'package:flutter/services.dart';

import '../models/film_model.dart';
import '../objectbox.g.dart';

class MySyncService {
  static final MySyncService instance = MySyncService._();
  MySyncService._();

  late final Isolate isolate;
  late final SendPort sendPort;

  Future<void> initIsolate() async {
    final completer = Completer<SendPort>();
    final isolateToMainStream = ReceivePort();

    // late StreamSubscription sub;
    // sub =
    isolateToMainStream.listen((Object? data) {
      if (!completer.isCompleted && data is SendPort) {
        final mainToIsolateStream = data;
        completer.complete(mainToIsolateStream);
      } else {
        print('Main isolate $data');
        // sub.cancel();
        // isolateToMainStream.close();
      }
    });

    isolate = await Isolate.spawn(
      _createdIsolate,
      isolateToMainStream.sendPort,
    );
    sendPort = await completer.future;
  }

  static void _createdIsolate(SendPort isolateToMainStream) async {
    final mainToIsolateStream = ReceivePort();
    isolateToMainStream.send(mainToIsolateStream.sendPort);

    late final Store localStore;
    late final Box<FilmModel> filmBox;

    mainToIsolateStream.listen((data) {
      print('[Created isolate] $data');
      if (data is ByteData) {
        localStore = Store.fromReference(getObjectBoxModel(), data);
        filmBox = localStore.box<FilmModel>();
      } else if (data is FilmModel) {
        filmBox.put(data);
      } else if (data is int) {
        filmBox.remove(data);
      }
      // isolateToMainStream.send(data);
    });
  }
}
