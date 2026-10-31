import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:hw_1_1/bloc/catalog/catalog_bloc.dart';
import 'package:hw_1_1/bloc/catalog/catalog_event.dart';
import 'package:hw_1_1/models/catalog_filter.dart';
import 'package:hw_1_1/models/game_category.dart';

/// Поле поиска + чипсы «Только избранные» и категорий.
/// Текущие значения приходят из состояния Bloc, изменения уходят в Bloc событиями.
class CatalogToolbar extends StatefulWidget {
  const CatalogToolbar({super.key, required this.filter});

  final CatalogFilter filter;

  @override
  State<CatalogToolbar> createState() => _CatalogToolbarState();
}

class _CatalogToolbarState extends State<CatalogToolbar> {
  late final _searchController = TextEditingController(text: widget.filter.query);

  @override
  void didUpdateWidget(covariant CatalogToolbar oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Если поиск сбросили кнопкой «Сбросить фильтры» — очищаем и поле.
    if (widget.filter.query != _searchController.text) {
      _searchController.text = widget.filter.query;
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<CatalogBloc>();
    final filter = widget.filter;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 8, 12, 4),
          child: TextField(
            controller: _searchController,
            onChanged: (text) => bloc.add(CatalogSearchChanged(text)),
            textInputAction: TextInputAction.search,
            decoration: InputDecoration(
              hintText: 'Поиск по названию',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: filter.query.isEmpty
                  ? null
                  : IconButton(
                      tooltip: 'Очистить',
                      icon: const Icon(Icons.close),
                      onPressed: () => bloc.add(const CatalogSearchChanged('')),
                    ),
              filled: true,
              isDense: true,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(28),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),
        SizedBox(
          height: 48,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            children: [
              FilterChip(
                avatar: Icon(
                  filter.onlyFavorites ? Icons.favorite : Icons.favorite_border,
                  color: Colors.red,
                  size: 18,
                ),
                showCheckmark: false,
                label: const Text('Только избранные'),
                selected: filter.onlyFavorites,
                onSelected: (_) => bloc.add(const CatalogOnlyFavoritesToggled()),
              ),
              const VerticalDivider(width: 20, indent: 8, endIndent: 8),
              _CategoryChip(
                label: 'Все',
                icon: Icons.apps,
                selected: filter.category == null,
                onSelected: () => bloc.add(const CatalogCategorySelected(null)),
              ),
              for (final category in GameCategory.values)
                _CategoryChip(
                  label: category.label,
                  icon: category.icon,
                  selected: filter.category == category,
                  // Повторное нажатие на выбранную категорию снимает фильтр.
                  onSelected: () => bloc.add(
                    CatalogCategorySelected(filter.category == category ? null : category),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class _CategoryChip extends StatelessWidget {
  const _CategoryChip({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onSelected,
  });

  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onSelected;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        avatar: Icon(icon, size: 18),
        showCheckmark: false,
        label: Text(label),
        selected: selected,
        onSelected: (_) => onSelected(),
      ),
    );
  }
}
