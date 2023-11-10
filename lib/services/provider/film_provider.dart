import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../models/film_model.dart';
import '../objectbox.dart';

final objectBoxServiceProvider =
    Provider<ObjectBoxService>((ref) => ObjectBoxService());

// final filmsProvider = Provider<Stream<List<FilmModel>>>((ref) {
//   final service = ref.watch(objectBoxServiceProvider);
//   return service.getFilms();
// });

// final filmsProvider =
//     Provider.family<Stream<List<FilmModel>>, String>((ref, String query) {
//   final service = ref.watch(objectBoxServiceProvider);
//   return service.getFilms();
// });

final filtredFilmsProvider =
    StreamProvider.family<List<FilmModel>, String>((ref, String query) {
  final service = ref.watch(objectBoxServiceProvider);
  if (query.isEmpty) {
    return service.getFilms();
  }
  return service.searchFilms(query);
});
