/// Стартовый набор игр. Используется ОДИН раз — по кнопке
/// «Заполнить демо-данными» на пустом каталоге: записывается в Firestore,
/// а дальше приложение работает только с данными из базы.
const List<Map<String, dynamic>> demoGames = [
  {
    'title': 'Minecraft',
    'subtitle': 'Mojang Studios',
    'category': 'sandbox',
    'description':
        'Песочница о блоках: добывайте ресурсы, стройте что угодно и выживайте '
        'по ночам, когда из темноты выходят монстры.',
    'year': 2011,
    'platforms': 'PC, консоли, мобильные',
    'rating': 9.0,
    'imageUrl': '',
  },
  {
    'title': 'Resident Evil 4',
    'subtitle': 'Capcom',
    'category': 'horror',
    'description':
        'Леон Кеннеди отправляется в испанскую деревню, чтобы спасти дочь '
        'президента. Ремейк классики survival horror.',
    'year': 2023,
    'platforms': 'PC, PS5, Xbox Series',
    'rating': 9.3,
    'imageUrl': '',
  },
  {
    'title': 'Heavy Rain',
    'subtitle': 'Quantic Dream',
    'category': 'adventure',
    'description':
        'Интерактивная драма о поисках «Мастера оригами». Четыре героя, '
        'а каждое решение меняет ход истории.',
    'year': 2010,
    'platforms': 'PC, PS4',
    'rating': 8.7,
    'imageUrl': '',
  },
  {
    'title': 'The Witcher 3: Wild Hunt',
    'subtitle': 'CD Projekt Red',
    'category': 'rpg',
    'description':
        'Геральт из Ривии ищет приёмную дочь в огромном открытом мире, '
        'полном чудовищ, политики и сложных моральных выборов.',
    'year': 2015,
    'platforms': 'PC, консоли',
    'rating': 9.8,
    'imageUrl': '',
  },
  {
    'title': 'Fortnite',
    'subtitle': 'Epic Games',
    'category': 'shooter',
    'description':
        'Королевская битва на сто игроков со строительством укрытий '
        'прямо во время перестрелки.',
    'year': 2017,
    'platforms': 'PC, консоли, мобильные',
    'rating': 8.0,
    'imageUrl': '',
  },
  {
    'title': 'Hollow Knight',
    'subtitle': 'Team Cherry',
    'category': 'indie',
    'description':
        'Метроидвания о маленьком рыцаре в подземном королевстве насекомых. '
        'Сложные боссы и потрясающий рисованный мир.',
    'year': 2017,
    'platforms': 'PC, Switch, PS4, Xbox One',
    'rating': 9.4,
    'imageUrl': '',
  },
  {
    'title': 'Elden Ring',
    'subtitle': 'FromSoftware',
    'category': 'rpg',
    'description':
        'Экшен-RPG в открытом мире от создателей Dark Souls '
        'по миру, придуманному вместе с Джорджем Мартином.',
    'year': 2022,
    'platforms': 'PC, PS5, Xbox Series',
    'rating': 9.6,
    'imageUrl': '',
  },
  {
    'title': 'Counter-Strike 2',
    'subtitle': 'Valve',
    'category': 'shooter',
    'description':
        'Командный тактический шутер: террористы против спецназа, '
        'закладка бомбы и точная стрельба.',
    'year': 2023,
    'platforms': 'PC',
    'rating': 8.2,
    'imageUrl': '',
  },
  {
    'title': 'Devil May Cry 5',
    'subtitle': 'Capcom',
    'category': 'action',
    'description':
        'Стильный слэшер о охотниках на демонов: Неро, Данте и загадочный V '
        'сражаются с армией ада.',
    'year': 2019,
    'platforms': 'PC, консоли',
    'rating': 8.9,
    'imageUrl': '',
  },
  {
    'title': 'Sid Meier\'s Civilization VI',
    'subtitle': 'Firaxis Games',
    'category': 'strategy',
    'description':
        'Пошаговая стратегия: проведите свою цивилизацию от каменного века '
        'до космической эры. «Ещё один ход» — и уже утро.',
    'year': 2016,
    'platforms': 'PC, консоли, мобильные',
    'rating': 8.8,
    'imageUrl': '',
  },
];
