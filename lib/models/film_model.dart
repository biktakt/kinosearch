import 'package:objectbox/objectbox.dart';

typedef Country = String;

@Entity()
class FilmModel {
  //название, год, страна
  int id;
  String title;
  String year;
  Country country;

  FilmModel({
    this.id = 0,
    required this.title,
    required this.year,
    required this.country,
  });

  factory FilmModel.empty() {
    return FilmModel(title: '', year: '', country: '');
  }

  @override
  String toString() => 'Film(id: $id, '
      'title: $title, '
      'year: $year, '
      'country: $country)';

  @override
  bool operator ==(covariant FilmModel other) => id == other.id;

  @override
  int get hashCode => Object.hashAll([id]);
}
