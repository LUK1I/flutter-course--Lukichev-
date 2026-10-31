import 'package:equatable/equatable.dart';

import 'package:hw_1_1/models/game.dart';
import 'package:hw_1_1/models/game_category.dart';

enum CatalogSort {
  newest('Сначала новые'),
  oldest('Сначала старые'),
  titleAsc('По названию (А–Я)'),
  titleDesc('По названию (Я–А)');

  const CatalogSort(this.label);
  final String label;
}

/// Настройки отображения списка: поиск, категория, сортировка и «Только избранные».
/// Все фильтры сочетаются между собой.
class CatalogFilter extends Equatable {
  const CatalogFilter({
    this.query = '',
    this.category,
    this.sort = CatalogSort.newest,
    this.onlyFavorites = false,
  });

  final String query;

  /// null — все категории.
  final GameCategory? category;
  final CatalogSort sort;
  final bool onlyFavorites;

  bool get isActive => query.trim().isNotEmpty || category != null || onlyFavorites;

  CatalogFilter copyWith({
    String? query,
    GameCategory? Function()? category,
    CatalogSort? sort,
    bool? onlyFavorites,
  }) {
    return CatalogFilter(
      query: query ?? this.query,
      category: category != null ? category() : this.category,
      sort: sort ?? this.sort,
      onlyFavorites: onlyFavorites ?? this.onlyFavorites,
    );
  }

  /// Применяет все фильтры и сортировку к полному списку игр.
  List<Game> apply(List<Game> games, Set<String> favoriteIds) {
    final q = query.trim().toLowerCase();
    final result = games.where((game) {
      if (onlyFavorites && !favoriteIds.contains(game.id)) return false;
      if (category != null && game.category != category) return false;
      if (q.isNotEmpty && !game.title.toLowerCase().contains(q)) return false;
      return true;
    }).toList();

    switch (sort) {
      case CatalogSort.newest:
        result.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      case CatalogSort.oldest:
        result.sort((a, b) => a.createdAt.compareTo(b.createdAt));
      case CatalogSort.titleAsc:
        result.sort((a, b) => a.title.toLowerCase().compareTo(b.title.toLowerCase()));
      case CatalogSort.titleDesc:
        result.sort((a, b) => b.title.toLowerCase().compareTo(a.title.toLowerCase()));
    }
    return result;
  }

  @override
  List<Object?> get props => [query, category, sort, onlyFavorites];
}
