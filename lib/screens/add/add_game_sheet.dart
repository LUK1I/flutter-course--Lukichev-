import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:hw_1_1/bloc/catalog/catalog_event.dart';
import 'package:hw_1_1/models/game_category.dart';

/// Форма добавления игры в bottom sheet. Обязательное поле одно — «Название».
/// Возвращает через Navigator.pop готовое событие CatalogGameAdded,
/// а отправляет его в Bloc экран каталога.
class AddGameSheet extends StatefulWidget {
  const AddGameSheet({super.key});

  @override
  State<AddGameSheet> createState() => _AddGameSheetState();
}

class _AddGameSheetState extends State<AddGameSheet> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _subtitleController = TextEditingController();
  final _yearController = TextEditingController();
  final _platformsController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _imageUrlController = TextEditingController();
  GameCategory _category = GameCategory.action;

  @override
  void dispose() {
    _titleController.dispose();
    _subtitleController.dispose();
    _yearController.dispose();
    _platformsController.dispose();
    _descriptionController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    Navigator.of(context).pop(
      CatalogGameAdded(
        title: _titleController.text.trim(),
        subtitle: _subtitleController.text.trim(),
        category: _category,
        description: _descriptionController.text.trim(),
        year: int.tryParse(_yearController.text.trim()),
        platforms: _platformsController.text.trim(),
        imageUrl: _imageUrlController.text.trim(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Отступ снизу на высоту клавиатуры, чтобы она не закрывала поля.
    final keyboardInset = MediaQuery.viewInsetsOf(context).bottom;

    return Padding(
      padding: EdgeInsets.only(bottom: keyboardInset),
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('Новая игра', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 16),
              TextFormField(
                controller: _titleController,
                autofocus: true,
                textCapitalization: TextCapitalization.sentences,
                decoration: const InputDecoration(
                  labelText: 'Название *',
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    (value == null || value.trim().isEmpty) ? 'Введите название' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _subtitleController,
                decoration: const InputDecoration(
                  labelText: 'Студия-разработчик',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<GameCategory>(
                initialValue: _category,
                decoration: const InputDecoration(labelText: 'Жанр', border: OutlineInputBorder()),
                items: [
                  for (final category in GameCategory.values)
                    DropdownMenuItem(
                      value: category,
                      child: Row(
                        children: [
                          Icon(category.icon, color: category.color, size: 20),
                          const SizedBox(width: 8),
                          Text(category.label),
                        ],
                      ),
                    ),
                ],
                // setState здесь — локальное состояние поля ввода, не данные каталога.
                onChanged: (value) => setState(() => _category = value ?? _category),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: TextFormField(
                      controller: _yearController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(4),
                      ],
                      decoration: const InputDecoration(
                        labelText: 'Год',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) return null;
                        final year = int.tryParse(value);
                        if (year == null || year < 1950 || year > 2100) {
                          return '1950–2100';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 3,
                    child: TextFormField(
                      controller: _platformsController,
                      decoration: const InputDecoration(
                        labelText: 'Платформы',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _descriptionController,
                minLines: 2,
                maxLines: 5,
                textCapitalization: TextCapitalization.sentences,
                decoration: const InputDecoration(
                  labelText: 'Описание',
                  border: OutlineInputBorder(),
                  alignLabelWithHint: true,
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _imageUrlController,
                keyboardType: TextInputType.url,
                decoration: const InputDecoration(
                  labelText: 'Ссылка на обложку (необязательно)',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              FilledButton.icon(
                onPressed: _submit,
                style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(48)),
                icon: const Icon(Icons.check),
                label: const Text('Добавить'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
