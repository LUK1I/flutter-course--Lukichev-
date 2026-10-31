import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:hw_1_1/bloc/catalog/catalog_event.dart';
import 'package:hw_1_1/bloc/catalog/catalog_state.dart';
import 'package:hw_1_1/models/catalog_filter.dart';
import 'package:hw_1_1/repositories/catalog_repository.dart';

/// Управляет данными каталога: получает события от виджетов, обращается
/// к репозиторию и выдаёт новое состояние, по которому перестраивается экран.
///
/// Создаётся отдельно для каждого вошедшего пользователя ([uid]),
/// поэтому у каждого аккаунта своё избранное.
class CatalogBloc extends Bloc<CatalogEvent, CatalogState> {
  CatalogBloc({required this._repository, required this._uid}) : super(const CatalogLoading()) {
    on<CatalogLoadRequested>(_onLoadRequested);
    on<CatalogFavoriteToggled>(_onFavoriteToggled);
    on<CatalogOnlyFavoritesToggled>(_onOnlyFavoritesToggled);
    on<CatalogSearchChanged>(_onSearchChanged);
    on<CatalogCategorySelected>(_onCategorySelected);
    on<CatalogSortChanged>(_onSortChanged);
    on<CatalogFiltersReset>(_onFiltersReset);
    on<CatalogGameAdded>(_onGameAdded);
    on<CatalogDemoDataRequested>(_onDemoDataRequested);
  }

  final CatalogRepository _repository;
  final String _uid;

  /// Фильтры переживают перезагрузку по кнопке «Обновить».
  CatalogFilter _filter = const CatalogFilter();

  Future<void> _onLoadRequested(CatalogLoadRequested event, Emitter<CatalogState> emit) async {
    emit(const CatalogLoading());
    try {
      final games = await _repository.fetchGames();
      final favoriteIds = await _repository.fetchFavoriteIds(_uid);
      emit(CatalogLoaded(games: games, favoriteIds: favoriteIds, filter: _filter));
    } on CatalogException catch (e) {
      emit(CatalogFailure(e.message));
    }
  }

  Future<void> _onFavoriteToggled(CatalogFavoriteToggled event, Emitter<CatalogState> emit) async {
    final current = state;
    if (current is! CatalogLoaded) return;

    final wasFavorite = current.isFavorite(event.gameId);
    final updated = Set<String>.of(current.favoriteIds);
    wasFavorite ? updated.remove(event.gameId) : updated.add(event.gameId);

    // Сразу показываем новый лайк, не дожидаясь ответа сервера.
    emit(current.copyWith(favoriteIds: updated));

    try {
      await _repository.setFavorite(uid: _uid, gameId: event.gameId, isFavorite: !wasFavorite);
    } on CatalogException catch (e) {
      // Сервер не сохранил — возвращаем лайк как был.
      final latest = state;
      if (latest is! CatalogLoaded) return;
      final reverted = Set<String>.of(latest.favoriteIds);
      wasFavorite ? reverted.add(event.gameId) : reverted.remove(event.gameId);
      emit(latest.copyWith(favoriteIds: reverted, message: 'Лайк не сохранён. ${e.message}'));
    }
  }

  void _onOnlyFavoritesToggled(CatalogOnlyFavoritesToggled event, Emitter<CatalogState> emit) {
    _updateFilter(emit, (f) => f.copyWith(onlyFavorites: !f.onlyFavorites));
  }

  void _onSearchChanged(CatalogSearchChanged event, Emitter<CatalogState> emit) {
    _updateFilter(emit, (f) => f.copyWith(query: event.query));
  }

  void _onCategorySelected(CatalogCategorySelected event, Emitter<CatalogState> emit) {
    _updateFilter(emit, (f) => f.copyWith(category: () => event.category));
  }

  void _onSortChanged(CatalogSortChanged event, Emitter<CatalogState> emit) {
    _updateFilter(emit, (f) => f.copyWith(sort: event.sort));
  }

  void _onFiltersReset(CatalogFiltersReset event, Emitter<CatalogState> emit) {
    // Сортировку оставляем, сбрасываем только то, что скрывает элементы.
    _updateFilter(emit, (f) => CatalogFilter(sort: f.sort));
  }

  void _updateFilter(Emitter<CatalogState> emit, CatalogFilter Function(CatalogFilter) change) {
    _filter = change(_filter);
    final current = state;
    if (current is CatalogLoaded) {
      emit(current.copyWith(filter: _filter));
    }
  }

  Future<void> _onGameAdded(CatalogGameAdded event, Emitter<CatalogState> emit) async {
    final current = state;
    if (current is! CatalogLoaded) return;

    emit(current.copyWith(isSaving: true));
    try {
      final game = await _repository.addGame(
        title: event.title,
        subtitle: event.subtitle,
        category: event.category,
        description: event.description,
        year: event.year,
        platforms: event.platforms,
        imageUrl: event.imageUrl,
      );
      // Пока шло сохранение, каталог могли перезагрузить — тогда игра и так придёт из базы.
      final latest = state;
      if (latest is! CatalogLoaded) return;
      emit(
        latest.copyWith(
          games: [...latest.games, game],
          isSaving: false,
          message: 'Игра «${game.title}» добавлена',
        ),
      );
    } on CatalogException catch (e) {
      final latest = state;
      if (latest is! CatalogLoaded) return;
      emit(latest.copyWith(isSaving: false, message: 'Не удалось добавить игру. ${e.message}'));
    }
  }

  Future<void> _onDemoDataRequested(
    CatalogDemoDataRequested event,
    Emitter<CatalogState> emit,
  ) async {
    final current = state;
    if (current is! CatalogLoaded) return;

    emit(current.copyWith(isSaving: true));
    try {
      await _repository.addDemoGames();
    } on CatalogException catch (e) {
      emit(current.copyWith(isSaving: false, message: e.message));
      return;
    }
    // Перечитываем каталог из Firestore, чтобы показать то, что реально в базе.
    add(const CatalogLoadRequested());
  }
}
