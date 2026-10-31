import 'package:flutter/material.dart';

/// Состояние «Ошибка»: понятный текст и кнопка «Обновить».
class CatalogErrorView extends StatelessWidget {
  const CatalogErrorView({super.key, required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return _MessageView(
      icon: Icons.wifi_off,
      iconColor: Theme.of(context).colorScheme.error,
      title: 'Не удалось загрузить каталог',
      message: message,
      action: FilledButton.icon(
        onPressed: onRetry,
        icon: const Icon(Icons.refresh),
        label: const Text('Обновить'),
      ),
    );
  }
}

/// Состояние «Пусто»: заглушка с текстом и необязательной кнопкой.
class CatalogEmptyView extends StatelessWidget {
  const CatalogEmptyView({
    super.key,
    required this.icon,
    required this.title,
    required this.message,
    this.action,
  });

  final IconData icon;
  final String title;
  final String message;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    return _MessageView(
      icon: icon,
      iconColor: Theme.of(context).colorScheme.outline,
      title: title,
      message: message,
      action: action,
    );
  }
}

class _MessageView extends StatelessWidget {
  const _MessageView({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.message,
    this.action,
  });

  final IconData icon;
  final Color iconColor;
  final String title;
  final String message;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 72, color: iconColor),
            const SizedBox(height: 16),
            Text(
              title,
              textAlign: TextAlign.center,
              style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(message, textAlign: TextAlign.center, style: theme.textTheme.bodyMedium),
            if (action != null) ...[const SizedBox(height: 24), action!],
          ],
        ),
      ),
    );
  }
}
