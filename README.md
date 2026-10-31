# Игротека — каталог видеоигр

Финальный проект раздела 1 курса «Принципы управления РПП» (Flutter, Университет Иннополис).
Автор: Лукичев.

Приложение-каталог видеоигр: вход по email и паролю (Firebase Authentication),
каталог в Cloud Firestore, экран деталей, добавление игр, избранное у каждого
пользователя своё, управление состоянием через BLoC.

**Дополнительные опции:** поиск по названию; фильтр по жанру и сортировка (по названию, по дате добавления).

## Структура `lib/`

```
lib/
├── main.dart                  — инициализация Firebase и запуск
├── app.dart                   — MaterialApp, репозитории, AuthGate (вход ↔ каталог)
├── firebase_options.dart      — генерируется `flutterfire configure`
├── models/
│   ├── game.dart              — модель игры, fromJson / toJson
│   ├── game_category.dart     — жанры: название, иконка, цвет
│   └── catalog_filter.dart    — поиск + жанр + сортировка + «Только избранные»
├── repositories/
│   ├── auth_repository.dart   — Firebase Auth, понятные тексты ошибок
│   └── catalog_repository.dart — Firestore: игры, избранное, добавление
├── bloc/catalog/
│   ├── catalog_bloc.dart      — логика каталога
│   ├── catalog_event.dart     — события (загрузить, лайк, фильтр, добавить…)
│   └── catalog_state.dart     — состояния: загрузка / данные / ошибка
├── screens/
│   ├── auth/login_screen.dart
│   ├── catalog/catalog_screen.dart (+ widgets/)
│   ├── details/game_details_screen.dart
│   └── add/add_game_sheet.dart — добавление в bottom sheet
├── data/demo_games.dart       — стартовый набор для кнопки «Заполнить демо-данными»
└── lab1/main.dart             — ЛР 1
```

Поток данных: **виджет → событие → CatalogBloc → CatalogRepository → Firestore**,
обратно: **Firestore → репозиторий → Bloc выдаёт новое состояние → BlocBuilder перестраивает экран.**

## Firestore

```
games/{gameId}   title, subtitle, category, description, year, platforms, rating, imageUrl, createdAt
users/{uid}      favorites: [gameId, …]
```

Правила (Rules):

```
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /{document=**} {
      allow read, write: if request.auth != null;
    }
  }
}
```

## Запуск

```bash
flutter pub get
flutterfire configure   # один раз, создаёт lib/firebase_options.dart
flutter run
```
