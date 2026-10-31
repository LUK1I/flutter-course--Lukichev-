import 'package:flutter/material.dart';

import 'package:hw_1_1/models/game.dart';
import 'package:hw_1_1/screens/catalog/widgets/game_cover.dart';

/// Карточка игры в списке: обложка, название, подпись, иконка жанра и лайк.
/// Сама ничего не меняет — только сообщает о нажатиях наверх.
class GameCard extends StatelessWidget {
  const GameCard({
    super.key,
    required this.game,
    required this.isFavorite,
    required this.onTap,
    required this.onFavoriteTap,
  });

  final Game game;
  final bool isFavorite;
  final VoidCallback onTap;
  final VoidCallback onFavoriteTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Hero(
                tag: 'cover-${game.id}',
                child: GameCover(game: game),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      game.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    if (game.subtitle.isNotEmpty) ...[
                      const SizedBox(height: 2),
                      Text(
                        game.subtitle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Icon(game.category.icon, size: 16, color: game.category.color),
                        const SizedBox(width: 4),
                        Flexible(
                          child: Text(
                            game.year == null
                                ? game.category.label
                                : '${game.category.label} · ${game.year}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.bodySmall,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              IconButton(
                tooltip: isFavorite ? 'Убрать из избранного' : 'В избранное',
                onPressed: onFavoriteTap,
                icon: Icon(
                  isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: isFavorite ? Colors.red : null,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
