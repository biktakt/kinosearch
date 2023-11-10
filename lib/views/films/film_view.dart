import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'film_edit_view.dart';
import 'film_list_view.dart';

class FilmsView extends HookConsumerWidget {
  const FilmsView({super.key});

  static const routeName = '/';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = useTextEditingController();
    final searchTerm = useState('');

    useEffect(
      () {
        controller.addListener(() {
          searchTerm.value = controller.text;
        });
        return () {};
      },
      [controller],
    );

    return Scaffold(
      appBar: AppBar(
        title: SizedBox(
          height: 40,
          width: double.infinity,
          child: TextField(
            controller: controller,
            decoration: InputDecoration(
              suffixIcon: IconButton(
                icon: const Icon(Icons.clear),
                onPressed: () {
                  controller.clear();
                  FocusManager.instance.primaryFocus?.unfocus();
                },
              ),
            ),
          ),
        ),
      ),
      body: FilmListView(
        searchTerm: searchTerm.value,
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const FilmEditView(),
            ),
          );
        },
      ),
    );
  }
}
