import 'package:flutter/material.dart';

import '../../domain/entities/game.dart';
import '../widgets/game_card.dart';

const games = [
  Game(
    id: 1,
    title: 'Minecraft',
    subtitle: 'Mojang Studios',
    category: GameCategory.sandbox,
    description: 'Песочница о блоках: стройте, добывайте ресурсы и выживайте.',
    year: 2011,
  ),
  Game(
    id: 2,
    title: 'Resident Evil 4',
    subtitle: 'Capcom',
    category: GameCategory.horror,
    year: 2023,
  ),
  Game(
    id: 3,
    title: 'Heavy Rain',
    subtitle: 'Quantic Dream',
    category: GameCategory.adventure,
    year: 2010,
  ),
  Game(
    id: 4,
    title: 'The Witcher 3: Wild Hunt',
    subtitle: 'CD Projekt Red',
    category: GameCategory.rpg,
    description: 'Геральт ищет приёмную дочь в огромном открытом мире.',
    year: 2015,
  ),
  Game(
    id: 5,
    title: 'Fortnite',
    subtitle: 'Epic Games',
    category: GameCategory.shooter,
    year: 2017,
  ),
  Game(
    id: 6,
    title: 'Hollow Knight',
    subtitle: 'Team Cherry',
    category: GameCategory.indie,
    year: 2017,
  ),
  Game(
    id: 7,
    title: 'Elden Ring',
    subtitle: 'FromSoftware',
    category: GameCategory.rpg,
    year: 2022,
  ),
  Game(
    id: 8,
    title: 'Counter-Strike 2',
    subtitle: 'Valve',
    category: GameCategory.shooter,
    year: 2023,
  ),
  Game(
    id: 9,
    title: 'Devil May Cry 5',
    subtitle: 'Capcom',
    category: GameCategory.action,
    year: 2019,
  ),
  Game(
    id: 10,
    title: 'The Legend of Zelda: Tears of the Kingdom — Collector\'s Edition',
    subtitle: 'Nintendo Entertainment Planning & Development',
    category: GameCategory.adventure,
    year: 2023,
  ),
];

class CatalogScreen extends StatefulWidget {
  const CatalogScreen({super.key});

  @override
  State<CatalogScreen> createState() => _CatalogScreenState();
}

class _CatalogScreenState extends State<CatalogScreen> {
  /// id лайкнутых игр.
  final Set<int> _likedIds = {};
  bool _onlyFavorites = false;

  void _toggleLike(int id) {
    setState(() {
      if (_likedIds.contains(id)) {
        _likedIds.remove(id);
      } else {
        _likedIds.add(id);
      }
    });
  }

  void _toggleOnlyFavorites() {
    setState(() => _onlyFavorites = !_onlyFavorites);
  }

  @override
  Widget build(BuildContext context) {
    // Отфильтрованный список считаем здесь, отдельно не храним.
    final visibleGames = _onlyFavorites
        ? games.where((game) => _likedIds.contains(game.id)).toList()
        : games;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Игротека'),
        actions: [
          Center(
            child: Padding(
              padding: const EdgeInsets.only(right: 8),
              child: Text('В избранном: ${_likedIds.length}'),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: FilterChip(
                avatar: Icon(
                  _onlyFavorites ? Icons.favorite : Icons.favorite_border,
                  color: Colors.redAccent,
                  size: 18,
                ),
                showCheckmark: false,
                label: const Text('Только избранные'),
                selected: _onlyFavorites,
                onSelected: (_) => _toggleOnlyFavorites(),
              ),
            ),
          ),
          Expanded(
            child: visibleGames.isEmpty
                ? const Center(child: Text('Ничего не нашлось', style: TextStyle(fontSize: 18)))
                : ListView.builder(
                    padding: const EdgeInsets.all(8),
                    itemCount: visibleGames.length,
                    itemBuilder: (context, index) {
                      final game = visibleGames[index];
                      return GameCard(
                        game: game,
                        isLiked: _likedIds.contains(game.id),
                        onLikeTap: () => _toggleLike(game.id),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
