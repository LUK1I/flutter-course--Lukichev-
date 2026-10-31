import 'package:flutter/material.dart';

import 'package:hw_1_1/models/game.dart';

/// Обложка игры — Stack из слоёв:
/// 1) цветной градиент по цвету жанра; 2) первая буква названия;
/// 3) картинка по ссылке, если она есть (при ошибке загрузки остаётся буква);
/// 4) иконка жанра в углу.
class GameCover extends StatelessWidget {
  const GameCover({
    super.key,
    required this.game,
    this.width = 88,
    this.height = 88,
    this.borderRadius = 12,
    this.letterSize = 40,
  });

  final Game game;
  final double width;
  final double height;
  final double borderRadius;
  final double letterSize;

  @override
  Widget build(BuildContext context) {
    final color = game.category.color;
    final letter = game.title.isEmpty ? '?' : game.title.characters.first.toUpperCase();

    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: SizedBox(
        width: width,
        height: height,
        child: Stack(
          fit: StackFit.expand,
          children: [
            DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [color, Color.lerp(color, Colors.black, 0.45)!],
                ),
              ),
            ),
            Center(
              child: Text(
                letter,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: letterSize,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
            if (game.imageUrl.isNotEmpty)
              Image.network(
                game.imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => const SizedBox.shrink(),
              ),
            Positioned(
              right: 6,
              bottom: 6,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.35),
                  shape: BoxShape.circle,
                ),
                child: Icon(game.category.icon, color: Colors.white, size: letterSize * 0.4),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
