import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../models/film_model.dart';
import '../../services/provider/film_provider.dart';

class FilmEditView extends HookConsumerWidget {
  const FilmEditView({
    super.key,
    this.filmId,
  });

  final int? filmId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    late FilmModel? film;
    if (filmId != null) {
      film = ref.read(objectBoxServiceProvider).getFilm(filmId!);
    } else {
      film = FilmModel.empty();
    }

    final titleController = useTextEditingController(text: film?.title ?? '');
    final yearController = useTextEditingController(text: film?.year ?? '');
    final countryController =
        useTextEditingController(text: film?.country ?? '');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit film'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: 'Title'),
            ),
            // YearPicker(firstDate: DateTime(1900), lastDate: DateTime.now(), selectedDate: selectedDate, onChanged: onChanged)
            TextField(
              controller: yearController,
              decoration: const InputDecoration(labelText: 'Year'),
              maxLength: 4,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
              ],
            ),
            TextField(
              controller: countryController,
              decoration: const InputDecoration(labelText: 'Country'),
            ),
            ElevatedButton(
              onPressed: () {
                if (titleController.text.isEmpty ||
                    yearController.text.isEmpty ||
                    countryController.text.isEmpty) return;

                if (titleController.text == film?.title &&
                    yearController.text == film?.year &&
                    countryController.text == film?.country) return;

                final newFilm = FilmModel(
                  id: film?.id ?? 0,
                  title: titleController.text,
                  year: yearController.text,
                  country: countryController.text,
                );

                ref.read(objectBoxServiceProvider).insertFilm(newFilm);

                Navigator.of(context).pop();
              },
              child: const Text('Save film'),
            ),
          ],
        ),
      ),
    );
  }
}
