import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:hw_1_1/bloc/catalog/catalog_bloc.dart';
import 'package:hw_1_1/bloc/catalog/catalog_event.dart';
import 'package:hw_1_1/bloc/catalog/catalog_state.dart';
import 'package:hw_1_1/models/catalog_filter.dart';
import 'package:hw_1_1/models/game.dart';
import 'package:hw_1_1/repositories/auth_repository.dart';
import 'package:hw_1_1/screens/add/add_game_sheet.dart';
import 'package:hw_1_1/screens/catalog/widgets/catalog_state_views.dart';
import 'package:hw_1_1/screens/catalog/widgets/catalog_toolbar.dart';
import 'package:hw_1_1/screens/catalog/widgets/game_card.dart';
import 'package:hw_1_1/screens/details/game_details_screen.dart';

/// Главный экран: список игр. Строится целиком по состоянию CatalogBloc.
class CatalogScreen extends StatelessWidget {
  const CatalogScreen({super.key});

  Future<void> _openAddSheet(BuildContext context) async {
    final bloc = context.read<CatalogBloc>();
    // Bottom sheet только собирает данные формы и возвращает готовое событие.
    final event = await showModalBottomSheet<CatalogGameAdded>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      useSafeArea: true,
      builder: (_) => const AddGameSheet(),
    );
    if (event != null) bloc.add(event);
  }

  void _openDetails(BuildContext context, Game game) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        // Новый маршрут не лежит под BlocProvider каталога, поэтому передаём
        // тот же Bloc явно — так лайк в деталях и в списке совпадает.
        builder: (_) => BlocProvider.value(
          value: context.read<CatalogBloc>(),
          child: GameDetailsScreen(gameId: game.id),
        ),
      ),
    );
  }

  Future<void> _confirmSignOut(BuildContext context) async {
    final auth = context.read<AuthRepository>();
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Выйти из аккаунта?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Отмена')),
          FilledButton(onPressed: () => Navigator.pop(context, true), child: const Text('Выйти')),
        ],
      ),
    );
    if (confirmed == true) await auth.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Игротека'),
        actions: [
          const _SortButton(),
          IconButton(
            tooltip: 'Выйти',
            icon: const Icon(Icons.logout),
            onPressed: () => _confirmSignOut(context),
          ),
        ],
      ),
      floatingActionButton: BlocBuilder<CatalogBloc, CatalogState>(
        buildWhen: (prev, curr) => prev.runtimeType != curr.runtimeType,
        builder: (context, state) {
          if (state is! CatalogLoaded) return const SizedBox.shrink();
          return FloatingActionButton.extended(
            onPressed: () => _openAddSheet(context),
            icon: const Icon(Icons.add),
            label: const Text('Добавить'),
          );
        },
      ),
      // BlocListener-часть показывает разовые сообщения, BlocBuilder-часть строит экран.
      body: BlocConsumer<CatalogBloc, CatalogState>(
        listenWhen: (prev, curr) => curr is CatalogLoaded && curr.message != null,
        listener: (context, state) {
          final message = (state as CatalogLoaded).message!;
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(SnackBar(content: Text(message)));
        },
        builder: (context, state) {
          return switch (state) {
            CatalogLoading() => const Center(child: CircularProgressIndicator()),
            CatalogFailure(:final message) => CatalogErrorView(
              message: message,
              onRetry: () => context.read<CatalogBloc>().add(const CatalogLoadRequested()),
            ),
            CatalogLoaded() => _CatalogContent(
              state: state,
              onOpenDetails: (game) => _openDetails(context, game),
              onAdd: () => _openAddSheet(context),
            ),
          };
        },
      ),
    );
  }
}

class _CatalogContent extends StatelessWidget {
  const _CatalogContent({required this.state, required this.onOpenDetails, required this.onAdd});

  final CatalogLoaded state;
  final ValueChanged<Game> onOpenDetails;
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<CatalogBloc>();
    final games = state.visibleGames;

    return Column(
      children: [
        if (state.isSaving) const LinearProgressIndicator(),
        CatalogToolbar(filter: state.filter),
        Expanded(
          child: games.isEmpty
              ? _buildEmpty(bloc)
              : ListView.builder(
                  // Нижний отступ, чтобы кнопка «Добавить» не закрывала последнюю карточку.
                  padding: const EdgeInsets.fromLTRB(8, 4, 8, 88),
                  itemCount: games.length,
                  itemBuilder: (context, index) {
                    final game = games[index];
                    return GameCard(
                      key: ValueKey(game.id),
                      game: game,
                      isFavorite: state.isFavorite(game.id),
                      onTap: () => onOpenDetails(game),
                      onFavoriteTap: () => bloc.add(CatalogFavoriteToggled(game.id)),
                    );
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildEmpty(CatalogBloc bloc) {
    final filter = state.filter;

    // В базе вообще нет игр.
    if (state.games.isEmpty) {
      return CatalogEmptyView(
        icon: Icons.videogame_asset_off,
        title: 'Каталог пуст',
        message: 'Добавьте первую игру или заполните каталог стартовым набором.',
        action: Wrap(
          spacing: 12,
          runSpacing: 12,
          alignment: WrapAlignment.center,
          children: [
            FilledButton.icon(
              onPressed: onAdd,
              icon: const Icon(Icons.add),
              label: const Text('Добавить игру'),
            ),
            OutlinedButton.icon(
              onPressed: state.isSaving ? null : () => bloc.add(const CatalogDemoDataRequested()),
              icon: const Icon(Icons.auto_awesome),
              label: const Text('Заполнить демо-данными'),
            ),
          ],
        ),
      );
    }

    final resetButton = OutlinedButton.icon(
      onPressed: () => bloc.add(const CatalogFiltersReset()),
      icon: const Icon(Icons.filter_alt_off),
      label: const Text('Сбросить фильтры'),
    );

    // Включён только фильтр избранного, а лайков нет.
    if (filter.onlyFavorites && filter.query.trim().isEmpty && filter.category == null) {
      return CatalogEmptyView(
        icon: Icons.favorite_border,
        title: 'В избранном пока пусто',
        message: 'Нажмите на сердечко у игры, чтобы добавить её сюда.',
        action: resetButton,
      );
    }

    return CatalogEmptyView(
      icon: Icons.search_off,
      title: 'Ничего не найдено',
      message: 'Попробуйте изменить запрос или фильтры.',
      action: resetButton,
    );
  }
}

/// Меню сортировки в AppBar. Выбранная сортировка хранится в Bloc.
class _SortButton extends StatelessWidget {
  const _SortButton();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CatalogBloc, CatalogState>(
      builder: (context, state) {
        if (state is! CatalogLoaded) return const SizedBox.shrink();
        return PopupMenuButton<CatalogSort>(
          tooltip: 'Сортировка',
          icon: const Icon(Icons.sort),
          initialValue: state.filter.sort,
          onSelected: (sort) => context.read<CatalogBloc>().add(CatalogSortChanged(sort)),
          itemBuilder: (context) => [
            for (final sort in CatalogSort.values)
              CheckedPopupMenuItem(
                value: sort,
                checked: sort == state.filter.sort,
                child: Text(sort.label),
              ),
          ],
        );
      },
    );
  }
}
