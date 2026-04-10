/// Interface for reading/writing auth tokens.
/// Decouples the network layer from any specific storage implementation.
abstract interface class TokenStorage {
  Future<String?> readAccessToken();
  Future<String?> readRefreshToken();
  Future<void> saveTokens(String accessToken, String refreshToken);
  Future<void> clearTokens();
}

/// Callback that performs the actual token refresh via the auth layer.
/// Returns the new access token, or null if refresh failed.
typedef TokenRefreshCallback = Future<String?> Function();
