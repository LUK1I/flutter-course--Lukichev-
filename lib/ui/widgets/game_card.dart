import 'package:flutter/material.dart';

import '../../domain/entities/game.dart';

/// Карточка игры. Сама ничего не хранит: получает игру и isLiked,
/// а о нажатии на сердечко сообщает наверх через onLikeTap.
class GameCard extends StatelessWidget {
  const GameCard({super.key, required this.game, required this.isLiked, required this.onLikeTap});

  final Game game;
  final bool isLiked;
  final VoidCallback onLikeTap;

  @override
  Widget build(BuildContext context) {
    final color = _colorFor(game.category);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            _buildCover(color),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    game.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    game.subtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: Colors.grey.shade700),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(_iconFor(game.category), size: 18, color: color),
                      const SizedBox(width: 4),
                      Text(
                        game.year == null
                            ? game.category.label
                            : '${game.category.label} · ${game.year}',
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Обложка — Stack из трёх слоёв: фон, буква, сердечко в правом верхнем углу.
  Widget _buildCover(Color color) {
    return SizedBox(
      width: 90,
      height: 90,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [color, Color.lerp(color, Colors.black, 0.4)!],
              ),
            ),
          ),
          Center(
            child: Text(
              game.title[0],
              style: const TextStyle(
                color: Colors.white,
                fontSize: 40,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          Positioned(
            top: 0,
            right: 0,
            child: IconButton(
              onPressed: onLikeTap,
              tooltip: isLiked ? 'Убрать из избранного' : 'В избранное',
              icon: Icon(
                isLiked ? Icons.favorite : Icons.favorite_border,
                color: isLiked ? Colors.redAccent : Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  static Color _colorFor(GameCategory category) {
    switch (category) {
      case GameCategory.action:
        return const Color(0xFFE53935);
      case GameCategory.horror:
        return const Color(0xFF424242);
      case GameCategory.rpg:
        return const Color(0xFF8E24AA);
      case GameCategory.sandbox:
        return const Color(0xFF43A047);
      case GameCategory.shooter:
        return const Color(0xFFF4511E);
      case GameCategory.adventure:
        return const Color(0xFF1E88E5);
      case GameCategory.indie:
        return const Color(0xFFFFB300);
    }
  }

  static IconData _iconFor(GameCategory category) {
    switch (category) {
      case GameCategory.action:
        return Icons.sports_martial_arts;
      case GameCategory.horror:
        return Icons.dark_mode;
      case GameCategory.rpg:
        return Icons.shield;
      case GameCategory.sandbox:
        return Icons.view_in_ar;
      case GameCategory.shooter:
        return Icons.gps_fixed;
      case GameCategory.adventure:
        return Icons.explore;
      case GameCategory.indie:
        return Icons.auto_awesome;
    }
  }
}
