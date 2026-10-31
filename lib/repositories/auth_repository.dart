import 'package:firebase_auth/firebase_auth.dart';

/// Ошибка входа/регистрации с понятным пользователю текстом.
class AuthException implements Exception {
  const AuthException(this.message);
  final String message;

  @override
  String toString() => message;
}

/// Вся работа с Firebase Authentication.
class AuthRepository {
  AuthRepository({FirebaseAuth? auth}) : _auth = auth ?? FirebaseAuth.instance;

  final FirebaseAuth _auth;

  /// Поток сообщает о каждом входе и выходе. Firebase сам хранит сессию,
  /// поэтому после перезапуска сюда сразу приходит вошедший пользователь.
  Stream<User?> authStateChanges() => _auth.authStateChanges();

  User? get currentUser => _auth.currentUser;

  Future<void> signIn({required String email, required String password}) {
    return _guard(() => _auth.signInWithEmailAndPassword(email: email.trim(), password: password));
  }

  Future<void> signUp({required String email, required String password}) {
    return _guard(
      () => _auth.createUserWithEmailAndPassword(email: email.trim(), password: password),
    );
  }

  Future<void> signOut() => _auth.signOut();

  Future<void> _guard(Future<Object?> Function() action) async {
    try {
      await action();
    } on FirebaseAuthException catch (e) {
      throw AuthException(_messageFor(e.code));
    } catch (_) {
      throw const AuthException('Что-то пошло не так. Попробуйте ещё раз.');
    }
  }

  static String _messageFor(String code) {
    switch (code) {
      case 'invalid-email':
        return 'Некорректный email.';
      case 'user-disabled':
        return 'Этот аккаунт заблокирован.';
      case 'user-not-found':
      case 'wrong-password':
      case 'invalid-credential':
      case 'INVALID_LOGIN_CREDENTIALS':
        return 'Неверный email или пароль.';
      case 'email-already-in-use':
        return 'Этот email уже занят. Попробуйте войти.';
      case 'weak-password':
        return 'Слишком короткий пароль: нужно минимум 6 символов.';
      case 'missing-password':
        return 'Введите пароль.';
      case 'too-many-requests':
        return 'Слишком много попыток. Подождите немного и попробуйте снова.';
      case 'network-request-failed':
        return 'Нет соединения с интернетом.';
      case 'operation-not-allowed':
      case 'configuration-not-found':
        return 'Вход по email не включён в Firebase Console (Authentication → Sign-in method).';
      default:
        return 'Ошибка входа ($code).';
    }
  }
}
