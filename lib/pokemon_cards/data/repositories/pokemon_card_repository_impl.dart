import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:pokecard_dex/pokemon_cards/data/models/pokemon_card_model.dart';
import 'package:pokecard_dex/pokemon_cards/domain/entities/pokemon_card.dart';
import 'package:pokecard_dex/pokemon_cards/domain/repositories/pokemon_card_repository.dart';

// Replace 'YOUR_API_KEY_HERE' with your actual API key from https://pokemontcg.io/
const String apiKey = '4639a28c-ca79-40d4-96b5-ccd487ea2a05';

class PokemonCardRepositoryImpl implements PokemonCardRepository {
  PokemonCardRepositoryImpl({Dio? dio})
      : _dio = dio ??
            Dio(
              BaseOptions(
                headers: {'X-Api-Key': apiKey},
                connectTimeout: const Duration(seconds: 60),
                receiveTimeout: const Duration(seconds: 60),
                sendTimeout: const Duration(seconds: 60),
              ),
            )..interceptors.add(
                DioCacheInterceptor(
                  options: CacheOptions(
                    store: MemCacheStore(),
                    policy: CachePolicy.refreshForceCache,
                    hitCacheOnErrorExcept: [401, 403],
                    maxStale: const Duration(days: 7),
                    priority: CachePriority.high,
                  ),
                ),
              );

  final Dio _dio;
  final String _baseUrl = 'https://api.pokemontcg.io/v2';

  @override
  Future<List<PokemonCard>> getCards({
    required int page,
    int pageSize = 15,
  }) async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        '$_baseUrl/cards',
        queryParameters: {
          'page': page,
          'pageSize': pageSize,
          'orderBy': 'name',
        },
      );

      if (response.statusCode == 200 && response.data != null) {
        final data = response.data!;
        final results = data['data'] as List<dynamic>?;
        
        if (results == null || results.isEmpty) {
          return [];
        }
        
        return results
            .map((json) => PokemonCardModel.fromJson(
                  json as Map<String, dynamic>,
                ).toEntity())
            .toList();
      } else {
        throw Exception('Failed to load Pokémon cards: ${response.statusCode}');
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        throw Exception('Connection timeout. Please check your internet connection.');
      } else if (e.type == DioExceptionType.connectionError) {
        throw Exception('No internet connection. Please check your network.');
      }
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      throw Exception('Error loading cards: $e');
    }
  }
}