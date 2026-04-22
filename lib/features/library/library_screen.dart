import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_dimensions.dart';
import '../../core/widgets/empty_state_widget.dart';
import '../../core/widgets/filter_chip_row.dart';
import '../../core/widgets/material_card.dart';
import 'library_notifier.dart';
import 'library_state.dart';

class LibraryScreen extends ConsumerStatefulWidget {
  const LibraryScreen({super.key});

  @override
  ConsumerState<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends ConsumerState<LibraryScreen> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(libraryNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Library'),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.go('/library/add'),
        icon: const Icon(Icons.add_rounded),
        label: const Text('Add material'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppDimensions.spacing16),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              onChanged: (value) => ref.read(libraryNotifierProvider.notifier).setSearch(value),
              decoration: const InputDecoration(
                hintText: 'Search title, author, or tag',
                prefixIcon: Icon(Icons.search_rounded),
              ),
            ),
            const SizedBox(height: 12),
            state.when(
              data: (library) => FilterChipRow<LibraryFilter>(
                values: LibraryFilter.values,
                selected: library.filter,
                labelBuilder: (filter) => filter.label,
                onSelected: (filter) {
                  ref.read(libraryNotifierProvider.notifier).setFilter(filter);
                },
              ),
              loading: () => const SizedBox.shrink(),
              error: (_, __) => const SizedBox.shrink(),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: state.when(
                data: (library) {
                  if (library.materials.isEmpty) {
                    return EmptyStateWidget(
                      title: 'Your library is empty',
                      message: 'Bring in a PDF, video playlist, audio course, or study roadmap.',
                      icon: Icons.video_library_rounded,
                      ctaLabel: 'Add material',
                      onPressed: () => context.go('/library/add'),
                    );
                  }
                  return ListView.builder(
                    itemCount: library.materials.length,
                    itemBuilder: (context, index) {
                      final material = library.materials[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: MaterialCard(
                          material: material,
                          onTap: () => context.push('/library/${material.id}'),
                        ),
                      );
                    },
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, _) => EmptyStateWidget(
                  title: 'Library could not load',
                  message: '$error',
                  ctaLabel: 'Retry',
                  onPressed: () => ref.invalidate(libraryNotifierProvider),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
