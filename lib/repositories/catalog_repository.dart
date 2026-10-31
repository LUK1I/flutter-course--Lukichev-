import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:hw_1_1/data/demo_games.dart';
import 'package:hw_1_1/models/game.dart';
import 'package:hw_1_1/models/game_category.dart';

/// Ошибка при работе с каталогом с понятным пользователю текстом.
class CatalogException implements Exception {
  const CatalogException(this.message);
  final String message;

  @override
  String toString() => message;
}

/// Вся работа с Cloud Firestore.
///
/// Структура базы:
///   games/{gameId}  — элементы каталога (общие для всех);
///   users/{uid}     — поле `favorites`: список id избранных игр пользователя.
class CatalogRepository {
  CatalogRepository({FirebaseFirestore? firestore}) : _db = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _db;

  static const _timeout = Duration(seconds: 10);

  CollectionReference<Map<String, dynamic>> get _games => _db.collection('games');

  DocumentReference<Map<String, dynamic>> _user(String uid) => _db.collection('users').doc(uid);

  /// Загружает весь каталог. Читаем именно с сервера, а не из локального кэша:
  /// без интернета пользователь увидит ошибку и кнопку «Обновить».
  Future<List<Game>> fetchGames() {
    return _guard(() async {
      final snapshot = await _games.get(const GetOptions(source: Source.server));
      return snapshot.docs.map((doc) => Game.fromJson(doc.id, doc.data())).toList();
    });
  }

  Future<Set<String>> fetchFavoriteIds(String uid) {
    return _guard(() async {
      final doc = await _user(uid).get(const GetOptions(source: Source.server));
      final favorites = doc.data()?['favorites'] as List<dynamic>? ?? const [];
      return favorites.whereType<String>().toSet();
    });
  }

  Future<void> setFavorite({
    required String uid,
    required String gameId,
    required bool isFavorite,
  }) {
    return _guard(
      () => _user(uid).set({
        'favorites': isFavorite
            ? FieldValue.arrayUnion([gameId])
            : FieldValue.arrayRemove([gameId]),
      }, SetOptions(merge: true)),
    );
  }

  /// Создаёт новый документ в коллекции `games` и возвращает созданную игру.
  Future<Game> addGame({
    required String title,
    required String subtitle,
    required GameCategory category,
    required String description,
    required int? year,
    required String platforms,
    required String imageUrl,
  }) {
    return _guard(() async {
      final doc = _games.doc();
      final game = Game(
        id: doc.id,
        title: title,
        subtitle: subtitle,
        category: category,
        description: description,
        year: year,
        platforms: platforms,
        rating: null,
        imageUrl: imageUrl,
        createdAt: DateTime.now(),
      );
      await doc.set(game.toJson());
      return game;
    });
  }

  /// Одноразовое наполнение пустой базы стартовыми играми (одной пачкой).
  /// После этого данные живут только в Firestore.
  Future<void> addDemoGames() {
    return _guard(() async {
      final batch = _db.batch();
      final now = DateTime.now();
      for (var i = 0; i < demoGames.length; i++) {
        // Немного разносим даты, чтобы сортировка по дате была наглядной.
        final data = Map<String, dynamic>.from(demoGames[i])
          ..['createdAt'] = Timestamp.fromDate(now.subtract(Duration(minutes: i)));
        batch.set(_games.doc(), data);
      }
      await batch.commit();
    });
  }

  Future<T> _guard<T>(Future<T> Function() action) async {
    try {
      return await action().timeout(_timeout);
    } on TimeoutException {
      throw const CatalogException('Сервер не отвечает. Проверьте подключение к интернету.');
    } on FirebaseException catch (e) {
      switch (e.code) {
        case 'unavailable':
          throw const CatalogException('Нет соединения с сервером. Проверьте интернет.');
        case 'permission-denied':
          throw const CatalogException('Нет доступа к данным. Проверьте правила Firestore.');
        default:
          throw CatalogException('Ошибка базы данных (${e.code}).');
      }
    } catch (_) {
      throw const CatalogException('Не удалось загрузить данные.');
    }
  }
}
