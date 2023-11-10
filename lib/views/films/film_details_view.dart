import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../services/provider/film_provider.dart';
import 'film_edit_view.dart';

class FilmDetailsView extends ConsumerWidget {
  const FilmDetailsView({
    super.key,
    required this.filmId,
  });

  final int filmId;
  // static const routeName = '/film_details';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final film = ref.read(objectBoxServiceProvider).getFilm(filmId);

    return Scaffold(
      appBar: AppBar(
        title: Text(film!.title),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FilmEditView(filmId: filmId),
                ),
              );
            },
            icon: const Icon(Icons.edit),
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                child: Text(
                  film.title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 64),
                ),
              ),
            ],
          ),
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.circle),
                  Text('Year: ${film.year}'),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.flag),
                  Text('Country: ${film.country}'),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
