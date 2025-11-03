part of 'pokemon_card_bloc.dart';

abstract class PokemonCardEvent extends Equatable {
  const PokemonCardEvent();

  @override
  List<Object> get props => [];
}

final class CardsFetched extends PokemonCardEvent {}

final class CardsSearched extends PokemonCardEvent {
  const CardsSearched(this.query);
  
  final String query;
  
  @override
  List<Object> get props => [query];
}

final class CardsRefreshed extends PokemonCardEvent {}