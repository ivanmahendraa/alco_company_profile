abstract final class DemoCredentials {
  static const String idCard = '123040014';
  static const String password = 'Password';

  static bool matches({required String idCard, required String password}) {
    return idCard.trim().toUpperCase() == DemoCredentials.idCard &&
        password == DemoCredentials.password;
  }
}
