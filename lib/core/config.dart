/// Supabase connection. The publishable key is safe to ship in the app:
/// every table is protected by row-level security on the server.
/// Override at build time with --dart-define=SUPABASE_URL=... etc.
class AppConfig {
  static const supabaseUrl = String.fromEnvironment(
    'SUPABASE_URL',
    defaultValue: 'https://axncazensmjdqpczvzwf.supabase.co',
  );
  static const supabaseKey = String.fromEnvironment(
    'SUPABASE_KEY',
    defaultValue: 'sb_publishable_7hGIGHFa1mcWPMI8mEZKGw_-wgkkSYT',
  );

  static const appName = 'دردشة';

  /// Where Google sign-in returns to the app (must be in Supabase Auth → URL
  /// Configuration → Redirect URLs).
  static const authRedirect = 'com.thanoon12k.chatapp://login-callback';
  static const mediaBucket = 'chat-media';
}
