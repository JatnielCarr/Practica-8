part of 'pokemon_card_bloc.dart';

enum PokemonCardStatus { initial, success, failure }

final class PokemonCardState extends Equatable {
  const PokemonCardState({
    this.status = PokemonCardStatus.initial,
    this.cards = const <PokemonCard>[],
    this.filteredCards = const <PokemonCard>[],
    this.hasReachedMax = false,
    this.errorMessage,
    this.searchQuery = '',
  });

  final PokemonCardStatus status;
  final List<PokemonCard> cards;
  final List<PokemonCard> filteredCards;
  final bool hasReachedMax;
  final String? errorMessage;
  final String searchQuery;

  PokemonCardState copyWith({
    PokemonCardStatus? status,
    List<PokemonCard>? cards,
    List<PokemonCard>? filteredCards,
    bool? hasReachedMax,
    String? errorMessage,
    String? searchQuery,
  }) {
    return PokemonCardState(
      status: status ?? this.status,
      cards: cards ?? this.cards,
      filteredCards: filteredCards ?? this.filteredCards,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      errorMessage: errorMessage ?? this.errorMessage,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }

  @override
  List<Object?> get props => [status, cards, filteredCards, hasReachedMax, errorMessage, searchQuery];
}