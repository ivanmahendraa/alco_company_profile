abstract final class DemoCredentials {
  static const String email = 'demo@alco.local';
  static const String password = 'AlcoDemo2026!';

  static bool matches({required String email, required String password}) {
    return email.trim().toLowerCase() == DemoCredentials.email &&
        password == DemoCredentials.password;
  }
}
