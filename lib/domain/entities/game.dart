/// Жанр игры.
enum GameCategory {
  action('Экшен'),
  horror('Хоррор'),
  rpg('RPG'),
  sandbox('Песочница'),
  shooter('Шутер'),
  adventure('Приключения'),
  indie('Инди');

  const GameCategory(this.label);

  /// Название жанра для экрана.
  final String label;
}

/// Один элемент каталога — видеоигра.
class Game {
  const Game({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.category,
    this.description,
    this.year,
  });

  final int id;
  final String title;

  /// Подпись — студия-разработчик.
  final String subtitle;
  final GameCategory category;
  final String? description;
  final int? year;
}
