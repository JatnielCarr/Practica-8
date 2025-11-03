import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:pokecard_dex/pokemon_cards/domain/entities/pokemon_card.dart';
import 'package:pokecard_dex/pokemon_cards/domain/repositories/pokemon_card_repository.dart';
import 'package:stream_transform/stream_transform.dart';

part 'pokemon_card_event.dart';
part 'pokemon_card_state.dart';

const _throttleDuration = Duration(milliseconds: 100);

EventTransformer<E> throttleDroppable<E>(Duration duration) {
  return (events, mapper) {
    return droppable<E>().call(events.throttle(duration), mapper);
  };
}

class PokemonCardBloc extends Bloc<PokemonCardEvent, PokemonCardState> {
  PokemonCardBloc({required PokemonCardRepository pokemonCardRepository})
      : _pokemonCardRepository = pokemonCardRepository,
        super(const PokemonCardState()) {
    on<CardsFetched>(
      _onCardsFetched,
      transformer: throttleDroppable(_throttleDuration),
    );
    on<CardsSearched>(_onCardsSearched);
    on<CardsRefreshed>(_onCardsRefreshed);
  }

  final PokemonCardRepository _pokemonCardRepository;
  int _currentPage = 1;

  Future<void> _onCardsFetched(
    CardsFetched event,
    Emitter<PokemonCardState> emit,
  ) async {
    if (state.hasReachedMax) return;
    
    try {
      if (state.status == PokemonCardStatus.initial) {
        final cards = await _pokemonCardRepository.getCards(page: _currentPage);
        _currentPage++;
        
        if (cards.isEmpty) {
          return emit(
            state.copyWith(
              status: PokemonCardStatus.success,
              cards: [],
              filteredCards: [],
              hasReachedMax: true,
            ),
          );
        }
        
        return emit(
          state.copyWith(
            status: PokemonCardStatus.success,
            cards: cards,
            filteredCards: cards,
            hasReachedMax: false,
          ),
        );
      }

      final cards = await _pokemonCardRepository.getCards(page: _currentPage);
      _currentPage++;
      
      if (cards.isEmpty) {
        emit(state.copyWith(hasReachedMax: true));
      } else {
        final allCards = List.of(state.cards)..addAll(cards);
        final filtered = _filterCards(allCards, state.searchQuery);
        emit(
          state.copyWith(
            status: PokemonCardStatus.success,
            cards: allCards,
            filteredCards: filtered,
            hasReachedMax: false,
          ),
        );
      }
    } catch (e) {
      emit(state.copyWith(
        status: PokemonCardStatus.failure,
        errorMessage: e.toString().replaceFirst('Exception: ', ''),
      ));
    }
  }

  void _onCardsSearched(
    CardsSearched event,
    Emitter<PokemonCardState> emit,
  ) {
    final filtered = _filterCards(state.cards, event.query);
    emit(state.copyWith(
      filteredCards: filtered,
      searchQuery: event.query,
    ));
  }

  Future<void> _onCardsRefreshed(
    CardsRefreshed event,
    Emitter<PokemonCardState> emit,
  ) async {
    _currentPage = 1;
    emit(const PokemonCardState());
    add(CardsFetched());
  }

  List<PokemonCard> _filterCards(List<PokemonCard> cards, String query) {
    if (query.isEmpty) return cards;
    final lowercaseQuery = query.toLowerCase();
    return cards.where((card) {
      return card.name.toLowerCase().contains(lowercaseQuery) ||
          (card.supertype?.toLowerCase().contains(lowercaseQuery) ?? false) ||
          (card.hp?.toLowerCase().contains(lowercaseQuery) ?? false);
    }).toList();
  }
}