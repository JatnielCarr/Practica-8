/// Configuración de la API
class ApiConfig {
  /// URL base de la API
  /// 
  /// En desarrollo local: http://localhost:3000
  /// En producción: reemplazar con la URL deployed (ej: https://tu-api.railway.app)
  static const String baseUrl = 'http://localhost:3000/api/v1';
  
  /// API Key (opcional para tu propia API)
  static const String? apiKey = null;
  
  /// Timeout para requests
  static const Duration timeout = Duration(seconds: 30);
  
  /// ID del usuario para favoritos (en producción usar auth real)
  static const String defaultUserId = 'default-user';
}
