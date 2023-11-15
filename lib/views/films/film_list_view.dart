import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../services/provider/film_provider.dart';
import '../../services/sync_service.dart';
import 'film_details_view.dart';

class FilmListView extends HookConsumerWidget {
  const FilmListView({
    super.key,
    required this.searchTerm,
  });

  final String searchTerm;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filmsStream = ref.watch(filtredFilmsProvider(searchTerm));

    return RefreshIndicator(
      onRefresh: () {
        // ignore: unused_result
        ref.refresh(filtredFilmsProvider(searchTerm));
        return Future.delayed(const Duration(seconds: 1));
      },
      child: filmsStream.when(
        data: (films) {
          return ListView.builder(
            restorationId: 'filmsListView',
            itemCount: films.length,
            itemBuilder: (BuildContext context, int index) {
              final film = films[index];

              return ListTile(
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: RichText(
                        text: TextSpan(
                          text: film.title,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            overflow: TextOverflow.ellipsis,
                          ),
                          children: [
                            TextSpan(
                              text: ' (${film.year})',
                              style: const TextStyle(
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Text(
                        film.country,
                        textAlign: TextAlign.end,
                      ),
                    ),
                  ],
                ),
                leading: CircleAvatar(
                  child: Text(film.id.toString()),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FilmDetailsView(filmId: film.id),
                    ),
                  );
                },
                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () =>
                      // ref.read(objectBoxServiceProvider).deleteFilm(film.id),
                      MySyncService.instance.sendPort.send(film.id),
                ),
              );
            },
          );
        },
        error: (error, stackTrace) {
          return const Center(
            child: Text('Error'),
          );
        },
        loading: () {
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
