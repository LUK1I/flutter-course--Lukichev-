import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:hw_1_1/bloc/catalog/catalog_bloc.dart';
import 'package:hw_1_1/bloc/catalog/catalog_event.dart';
import 'package:hw_1_1/bloc/catalog/catalog_state.dart';
import 'package:hw_1_1/models/game.dart';
import 'package:hw_1_1/screens/catalog/widgets/game_cover.dart';

/// Экран деталей. Получает только id игры, а саму игру и лайк берёт
/// из того же CatalogBloc, что и список, поэтому они всегда совпадают.
class GameDetailsScreen extends StatelessWidget {
  const GameDetailsScreen({super.key, required this.gameId});

  final String gameId;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CatalogBloc, CatalogState>(
      builder: (context, state) {
        final game = state is CatalogLoaded ? state.gameById(gameId) : null;
        if (state is! CatalogLoaded || game == null) {
          return Scaffold(
            appBar: AppBar(),
            body: const Center(child: Text('Игра не найдена')),
          );
        }

        final isFavorite = state.isFavorite(game.id);
        void toggleFavorite() => context.read<CatalogBloc>().add(CatalogFavoriteToggled(game.id));

        return Scaffold(
          appBar: AppBar(
            title: Text(game.title, maxLines: 1, overflow: TextOverflow.ellipsis),
            actions: [
              IconButton(
                tooltip: isFavorite ? 'Убрать из избранного' : 'В избранное',
                onPressed: toggleFavorite,
                icon: Icon(
                  isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: isFavorite ? Colors.red : null,
                ),
              ),
            ],
          ),
          body: _DetailsBody(game: game, isFavorite: isFavorite, onFavoriteTap: toggleFavorite),
        );
      },
    );
  }
}

class _DetailsBody extends StatelessWidget {
  const _DetailsBody({required this.game, required this.isFavorite, required this.onFavoriteTap});

  final Game game;
  final bool isFavorite;
  final VoidCallback onFavoriteTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return LayoutBuilder(
      builder: (context, constraints) {
        final coverWidth = constraints.maxWidth > 600 ? 600.0 : constraints.maxWidth - 32;

        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Center(
              child: Hero(
                tag: 'cover-${game.id}',
                child: GameCover(
                  game: game,
                  width: coverWidth,
                  height: 220,
                  borderRadius: 20,
                  letterSize: 96,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              game.title,
              style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            if (game.subtitle.isNotEmpty) ...[
              const SizedBox(height: 4),
              Text(
                game.subtitle,
                style: theme.textTheme.titleMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                Chip(
                  avatar: Icon(game.category.icon, color: game.category.color, size: 18),
                  label: Text(game.category.label),
                ),
                if (game.year != null)
                  Chip(
                    avatar: const Icon(Icons.calendar_today, size: 18),
                    label: Text('${game.year}'),
                  ),
                if (game.rating != null)
                  Chip(
                    avatar: const Icon(Icons.star, color: Colors.amber, size: 18),
                    label: Text(game.rating!.toStringAsFixed(1)),
                  ),
                if (game.platforms.isNotEmpty)
                  Chip(avatar: const Icon(Icons.devices, size: 18), label: Text(game.platforms)),
              ],
            ),
            const SizedBox(height: 24),
            Text('Описание', style: theme.textTheme.titleMedium),
            const SizedBox(height: 8),
            Text(
              game.description.isEmpty ? 'Описания пока нет.' : game.description,
              style: theme.textTheme.bodyLarge,
            ),
            const SizedBox(height: 24),
            Text('Добавлено: ${_formatDate(game.createdAt)}', style: theme.textTheme.bodySmall),
            const SizedBox(height: 24),
            isFavorite
                ? OutlinedButton.icon(
                    onPressed: onFavoriteTap,
                    icon: const Icon(Icons.favorite, color: Colors.red),
                    label: const Text('В избранном'),
                  )
                : FilledButton.icon(
                    onPressed: onFavoriteTap,
                    icon: const Icon(Icons.favorite_border),
                    label: const Text('Добавить в избранное'),
                  ),
          ],
        );
      },
    );
  }

  static String _formatDate(DateTime date) {
    String two(int n) => n.toString().padLeft(2, '0');
    return '${two(date.day)}.${two(date.month)}.${date.year}';
  }
}
