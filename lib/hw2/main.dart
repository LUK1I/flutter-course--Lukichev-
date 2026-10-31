// ДЗ 2 — экран списка каталога. Тема: видеоигры.
// Запуск: flutter run -t lib/hw2/main.dart

import 'package:flutter/material.dart';

void main() {
  runApp(const CatalogApp());
}

/// Одна игра в каталоге.
class Game {
  const Game({
    required this.title,
    required this.studio,
    required this.genre,
    required this.genreIcon,
    required this.color,
    this.isFavorite = false,
  });

  final String title;
  final String studio;
  final String genre;
  final IconData genreIcon;
  final Color color;
  final bool isFavorite;
}

const games = [
  Game(
    title: 'Minecraft',
    studio: 'Mojang Studios',
    genre: 'Песочница',
    genreIcon: Icons.view_in_ar,
    color: Color(0xFF43A047),
    isFavorite: true,
  ),
  Game(
    title: 'Resident Evil 4',
    studio: 'Capcom',
    genre: 'Хоррор',
    genreIcon: Icons.dark_mode,
    color: Color(0xFF424242),
  ),
  Game(
    title: 'Heavy Rain',
    studio: 'Quantic Dream',
    genre: 'Приключения',
    genreIcon: Icons.explore,
    color: Color(0xFF1E88E5),
    isFavorite: true,
  ),
  Game(
    title: 'The Witcher 3: Wild Hunt',
    studio: 'CD Projekt Red',
    genre: 'RPG',
    genreIcon: Icons.shield,
    color: Color(0xFF8E24AA),
  ),
  Game(
    title: 'Fortnite',
    studio: 'Epic Games',
    genre: 'Шутер',
    genreIcon: Icons.gps_fixed,
    color: Color(0xFFF4511E),
  ),
  Game(
    title: 'Hollow Knight',
    studio: 'Team Cherry',
    genre: 'Инди',
    genreIcon: Icons.auto_awesome,
    color: Color(0xFFFFB300),
    isFavorite: true,
  ),
  Game(
    title: 'Elden Ring',
    studio: 'FromSoftware',
    genre: 'RPG',
    genreIcon: Icons.shield,
    color: Color(0xFF6D4C41),
  ),
  Game(
    title: 'Counter-Strike 2',
    studio: 'Valve',
    genre: 'Шутер',
    genreIcon: Icons.gps_fixed,
    color: Color(0xFF00897B),
  ),
  Game(
    title: 'Devil May Cry 5',
    studio: 'Capcom',
    genre: 'Экшен',
    genreIcon: Icons.sports_martial_arts,
    color: Color(0xFFE53935),
  ),
  Game(
    title: 'The Legend of Zelda: Tears of the Kingdom — Collector\'s Edition',
    studio: 'Nintendo Entertainment Planning & Development',
    genre: 'Приключения',
    genreIcon: Icons.explore,
    color: Color(0xFF3949AB),
  ),
];

class CatalogApp extends StatelessWidget {
  const CatalogApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Игротека',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorSchemeSeed: Colors.deepPurple),
      home: const CatalogScreen(),
    );
  }
}

class CatalogScreen extends StatelessWidget {
  const CatalogScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Игротека')),
      body: ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: games.length,
        itemBuilder: (context, index) => GameCard(game: games[index]),
      ),
    );
  }
}

/// Карточка: обложка слева, справа текст. Expanded отдаёт тексту всё
/// оставшееся место, поэтому длинное название не вылезает за край.
class GameCard extends StatelessWidget {
  const GameCard({super.key, required this.game});

  final Game game;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            GameCover(game: game),
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
                    game.studio,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: Colors.grey.shade700),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(game.genreIcon, size: 18, color: game.color),
                      const SizedBox(width: 4),
                      Text(game.genre),
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
}

/// Обложка — Stack из трёх слоёв:
/// 1) цветной фон, 2) первая буква названия по центру, 3) лайк в правом верхнем углу.
class GameCover extends StatelessWidget {
  const GameCover({super.key, required this.game});

  final Game game;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 90,
      height: 90,
      child: Stack(
        // Без expand фон-Container без размеров сожмётся до нуля.
        fit: StackFit.expand,
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [game.color, Color.lerp(game.color, Colors.black, 0.4)!],
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
            top: 4,
            right: 4,
            child: Icon(
              game.isFavorite ? Icons.favorite : Icons.favorite_border,
              color: game.isFavorite ? Colors.redAccent : Colors.white,
              size: 22,
            ),
          ),
        ],
      ),
    );
  }
}
