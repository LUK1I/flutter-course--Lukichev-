import 'package:equatable/equatable.dart';

import 'package:hw_1_1/models/catalog_filter.dart';
import 'package:hw_1_1/models/game.dart';

/// Три явных состояния экрана каталога: загрузка, данные, ошибка.
sealed class CatalogState extends Equatable {
  const CatalogState();

  @override
  List<Object?> get props => [];
}

/// Идёт загрузка — показываем индикатор.
final class CatalogLoading extends CatalogState {
  const CatalogLoading();
}

/// Загрузить не удалось — показываем текст ошибки и кнопку «Обновить».
final class CatalogFailure extends CatalogState {
  const CatalogFailure(this.message);
  final String message;

  @override
  List<Object?> get props => [message];
}

/// Данные загружены.
final class CatalogLoaded extends CatalogState {
  const CatalogLoaded({
    required this.games,
    required this.favoriteIds,
    this.filter = const CatalogFilter(),
    this.isSaving = false,
    this.message,
  });

  /// Весь каталог из Firestore (без фильтров).
  final List<Game> games;

  /// id игр, которые лайкнул текущий пользователь.
  final Set<String> favoriteIds;

  final CatalogFilter filter;

  /// Идёт сохранение новой игры.
  final bool isSaving;

  /// Разовое сообщение для SnackBar (например, ошибка лайка). Показывает BlocListener.
  final String? message;

  /// То, что видно на экране: каталог после поиска, фильтров и сортировки.
  List<Game> get visibleGames => filter.apply(games, favoriteIds);

  bool isFavorite(String gameId) => favoriteIds.contains(gameId);

  Game? gameById(String id) {
    for (final game in games) {
      if (game.id == id) return game;
    }
    return null;
  }

  CatalogLoaded copyWith({
    List<Game>? games,
    Set<String>? favoriteIds,
    CatalogFilter? filter,
    bool? isSaving,
    String? message,
  }) {
    return CatalogLoaded(
      games: games ?? this.games,
      favoriteIds: favoriteIds ?? this.favoriteIds,
      filter: filter ?? this.filter,
      isSaving: isSaving ?? this.isSaving,
      // Сообщение не переносится в следующее состояние: оно разовое.
      message: message,
    );
  }

  @override
  List<Object?> get props => [games, favoriteIds, filter, isSaving, message];
}
