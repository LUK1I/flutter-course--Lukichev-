import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

import 'package:hw_1_1/models/game_category.dart';

/// Элемент каталога — одна видеоигра.
/// Хранится документом в коллекции `games` в Firestore.
class Game extends Equatable {
  const Game({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.category,
    required this.description,
    required this.year,
    required this.platforms,
    required this.rating,
    required this.imageUrl,
    required this.createdAt,
  });

  /// id документа в Firestore.
  final String id;
  final String title;

  /// Подпись в карточке — студия-разработчик.
  final String subtitle;
  final GameCategory category;
  final String description;
  final int? year;
  final String platforms;

  /// Оценка от 0 до 10, может отсутствовать.
  final double? rating;

  /// Ссылка на обложку в интернете. Если пустая — рисуем цветную обложку с буквой.
  final String imageUrl;
  final DateTime createdAt;

  /// Документ Firestore -> объект. Отсутствующие поля заменяются значениями
  /// по умолчанию, чтобы документ, добавленный руками в консоли, не ломал экран.
  factory Game.fromJson(String id, Map<String, dynamic> json) {
    final createdAt = json['createdAt'];
    return Game(
      id: id,
      title: (json['title'] as String?)?.trim().isNotEmpty == true
          ? (json['title'] as String).trim()
          : 'Без названия',
      subtitle: json['subtitle'] as String? ?? '',
      category: GameCategory.fromKey(json['category'] as String?),
      description: json['description'] as String? ?? '',
      year: (json['year'] as num?)?.toInt(),
      platforms: json['platforms'] as String? ?? '',
      rating: (json['rating'] as num?)?.toDouble(),
      imageUrl: json['imageUrl'] as String? ?? '',
      createdAt: createdAt is Timestamp
          ? createdAt.toDate()
          : DateTime.fromMillisecondsSinceEpoch(0),
    );
  }

  /// Объект -> данные для документа Firestore (id хранится как имя документа).
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'subtitle': subtitle,
      'category': category.key,
      'description': description,
      'year': year,
      'platforms': platforms,
      'rating': rating,
      'imageUrl': imageUrl,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  @override
  List<Object?> get props => [
    id,
    title,
    subtitle,
    category,
    description,
    year,
    platforms,
    rating,
    imageUrl,
    createdAt,
  ];
}
