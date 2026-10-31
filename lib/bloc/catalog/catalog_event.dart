import 'package:equatable/equatable.dart';

import 'package:hw_1_1/models/catalog_filter.dart';
import 'package:hw_1_1/models/game_category.dart';

/// Всё, что может произойти с каталогом: виджеты только отправляют эти события в Bloc.
sealed class CatalogEvent extends Equatable {
  const CatalogEvent();

  @override
  List<Object?> get props => [];
}

/// Загрузить (или перезагрузить по кнопке «Обновить») каталог и избранное.
final class CatalogLoadRequested extends CatalogEvent {
  const CatalogLoadRequested();
}

/// Нажатие на лайк.
final class CatalogFavoriteToggled extends CatalogEvent {
  const CatalogFavoriteToggled(this.gameId);
  final String gameId;

  @override
  List<Object?> get props => [gameId];
}

/// Переключатель «Только избранные».
final class CatalogOnlyFavoritesToggled extends CatalogEvent {
  const CatalogOnlyFavoritesToggled();
}

/// Ввод текста в поле поиска.
final class CatalogSearchChanged extends CatalogEvent {
  const CatalogSearchChanged(this.query);
  final String query;

  @override
  List<Object?> get props => [query];
}

/// Выбор категории в чипсах (null — «Все»).
final class CatalogCategorySelected extends CatalogEvent {
  const CatalogCategorySelected(this.category);
  final GameCategory? category;

  @override
  List<Object?> get props => [category];
}

final class CatalogSortChanged extends CatalogEvent {
  const CatalogSortChanged(this.sort);
  final CatalogSort sort;

  @override
  List<Object?> get props => [sort];
}

/// Сброс поиска, категории и «Только избранных».
final class CatalogFiltersReset extends CatalogEvent {
  const CatalogFiltersReset();
}

/// Добавить новую игру.
final class CatalogGameAdded extends CatalogEvent {
  const CatalogGameAdded({
    required this.title,
    this.subtitle = '',
    this.category = GameCategory.indie,
    this.description = '',
    this.year,
    this.platforms = '',
    this.imageUrl = '',
  });

  final String title;
  final String subtitle;
  final GameCategory category;
  final String description;
  final int? year;
  final String platforms;
  final String imageUrl;

  @override
  List<Object?> get props => [title, subtitle, category, description, year, platforms, imageUrl];
}

/// Заполнить пустую базу стартовыми играми.
final class CatalogDemoDataRequested extends CatalogEvent {
  const CatalogDemoDataRequested();
}
