/// Binds the auth layer's refresh logic to the network layer's
/// [AuthInterceptor], breaking the core → features dependency cycle.
///
/// Currently the [AuthInterceptor] in packages/network handles token
/// refresh internally via [TokenStorage]. This function is the hook
/// point for when external AuthRepository callback is needed.
///
/// Call this after DI is fully initialized.
void bindTokenRefresh() {
  // The AuthInterceptor in packages/network reads tokens from
  // TokenStorage (backed by PreferencesStorage) and refreshes via
  // direct HTTP call. No core→features import needed.
  //
  // If we later need AuthRepository.refreshToken() as the refresh
  // mechanism, inject it here:
  //   final interceptor = sl<AuthInterceptor>();
  //   interceptor.tokenRefresher = () async {
  //     await sl<AuthRepository>().refreshToken();
  //     return sl<TokenStorage>().readAccessToken();
  //   };
  // No-op for now. Token refresh handled by AuthInterceptor + TokenStorage.
}
