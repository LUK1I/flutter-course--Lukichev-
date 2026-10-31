import 'package:flutter/material.dart';

/// Жанр игры. В Firestore хранится строкой [key].
enum GameCategory {
  action('action', 'Экшен', Icons.sports_martial_arts, Color(0xFFE53935)),
  horror('horror', 'Хоррор', Icons.dark_mode, Color(0xFF424242)),
  rpg('rpg', 'RPG', Icons.shield, Color(0xFF8E24AA)),
  sandbox('sandbox', 'Песочница', Icons.view_in_ar, Color(0xFF43A047)),
  shooter('shooter', 'Шутер', Icons.gps_fixed, Color(0xFFF4511E)),
  adventure('adventure', 'Приключения', Icons.explore, Color(0xFF1E88E5)),
  strategy('strategy', 'Стратегия', Icons.psychology, Color(0xFF00897B)),
  indie('indie', 'Инди', Icons.auto_awesome, Color(0xFFFFB300));

  const GameCategory(this.key, this.label, this.icon, this.color);

  final String key;
  final String label;
  final IconData icon;
  final Color color;

  /// Неизвестный ключ (например, опечатка в Firebase Console) не роняет
  /// приложение, а превращается в «Инди».
  static GameCategory fromKey(String? key) {
    return GameCategory.values.firstWhere((c) => c.key == key, orElse: () => GameCategory.indie);
  }
}
