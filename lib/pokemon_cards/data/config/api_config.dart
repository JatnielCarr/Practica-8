/// Configuración de la API
class ApiConfig {
  /// URL base de la API
  /// 
  /// Usando API pública de Pokémon TCG: https://api.pokemontcg.io/v2
  /// Esta API funciona sin necesidad de tener tu laptop encendida
  static const String baseUrl = 'https://api.pokemontcg.io/v2';
  
  /// API Key para pokemontcg.io
  static const String? apiKey = 'f5f9f822-fcfd-47ad-9088-b24a4860c95f';
  
  /// Timeout para requests
  static const Duration timeout = Duration(seconds: 30);
  
  /// ID del usuario para favoritos (en producción usar auth real)
  static const String defaultUserId = 'default-user';
}
