import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:hw_1_1/bloc/catalog/catalog_bloc.dart';
import 'package:hw_1_1/bloc/catalog/catalog_event.dart';
import 'package:hw_1_1/repositories/auth_repository.dart';
import 'package:hw_1_1/repositories/catalog_repository.dart';
import 'package:hw_1_1/screens/auth/login_screen.dart';
import 'package:hw_1_1/screens/catalog/catalog_screen.dart';

class GameCatalogApp extends StatelessWidget {
  const GameCatalogApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Репозитории создаются один раз и доступны всем экранам через context.read.
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(create: (_) => AuthRepository()),
        RepositoryProvider(create: (_) => CatalogRepository()),
      ],
      child: MaterialApp(
        title: 'Игротека',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const AuthGate(),
      ),
    );
  }
}

/// Решает, что показать: экран входа или каталог.
/// Слушает authStateChanges(), поэтому реагирует на вход, выход и перезапуск.
class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  late final Stream<User?> _authChanges = context.read<AuthRepository>().authStateChanges();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: _authChanges,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }

        final user = snapshot.data;
        if (user == null) return const LoginScreen();

        // Свой Bloc на каждого пользователя: key заставляет пересоздать его
        // при входе под другим аккаунтом.
        return BlocProvider(
          key: ValueKey(user.uid),
          create: (context) =>
              CatalogBloc(repository: context.read<CatalogRepository>(), uid: user.uid)
                ..add(const CatalogLoadRequested()),
          child: const CatalogScreen(),
        );
      },
    );
  }
}
