import 'package:path_provider/path_provider.dart';

import '../../objectbox.g.dart';
import '../models/film_model.dart';

class ObjectBoxService {
  late final Store store;
  late final Box<FilmModel> filmBox;

  Future<void> init() async {
    final String path = (await getApplicationDocumentsDirectory()).path;
    store = Store(getObjectBoxModel(), directory: "$path/objectbox");
    filmBox = store.box<FilmModel>();
  }

  FilmModel? getFilm(int id) => filmBox.get(id);

  Stream<List<FilmModel>> getFilms() => filmBox
      .query()
      .watch(triggerImmediately: true)
      .map((query) => query.find());

  Stream<List<FilmModel>> searchFilms(String query) {
    final filmsQuery = filmBox.query(
      FilmModel_.title.contains(
        query.trim(),
        caseSensitive: false,
      ),
    );
    return filmsQuery.watch(triggerImmediately: true).map((q) => q.find());
  }

  int insertFilm(FilmModel film) => filmBox.put(film);

  bool deleteFilm(int id) => filmBox.remove(id);
}
