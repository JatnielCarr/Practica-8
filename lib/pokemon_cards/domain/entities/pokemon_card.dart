import 'package:equatable/equatable.dart';

class PokemonCard extends Equatable {
  const PokemonCard({
    required this.id,
    required this.name,
    required this.imageUrl,
    this.hp,
    this.supertype,
    this.rarity,
    this.artist,
    this.set,
    this.number,
    this.attacks,
    this.types,
    this.largeImageUrl,
  });

  final String id;
  final String name;
  final String imageUrl;
  final String? hp;
  final String? supertype;
  final String? rarity;
  final String? artist;
  final String? set;
  final String? number;
  final List<Attack>? attacks;
  final List<String>? types;
  final String? largeImageUrl;

  @override
  List<Object?> get props => [
        id,
        name,
        imageUrl,
        hp,
        supertype,
        rarity,
        artist,
        set,
        number,
        attacks,
        types,
        largeImageUrl,
      ];
}

class Attack extends Equatable {
  const Attack({
    required this.name,
    required this.damage,
    this.cost,
    this.text,
  });

  final String name;
  final String damage;
  final List<String>? cost;
  final String? text;

  @override
  List<Object?> get props => [name, damage, cost, text];
}