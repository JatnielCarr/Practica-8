import 'package:pokecard_dex/pokemon_cards/domain/entities/pokemon_card.dart';

class PokemonCardModel {
  const PokemonCardModel({
    required this.id,
    required this.name,
    required this.images,
    this.hp,
    this.supertype,
    this.rarity,
    this.artist,
    this.set,
    this.number,
    this.attacks,
    this.types,
  });

  factory PokemonCardModel.fromJson(Map<String, dynamic> json) {
    final attacksList = json['attacks'] as List<dynamic>?;
    final typesList = json['types'] as List<dynamic>?;
    
    return PokemonCardModel(
      id: json['id'] as String,
      name: json['name'] as String,
      images: CardImagesModel.fromJson(json['images'] as Map<String, dynamic>),
      hp: json['hp'] as String?,
      supertype: json['supertype'] as String?,
      rarity: json['rarity'] as String?,
      artist: json['artist'] as String?,
      set: json['set']?['name'] as String?,
      number: json['number'] as String?,
      attacks: attacksList?.map((a) => AttackModel.fromJson(a as Map<String, dynamic>)).toList(),
      types: typesList?.map((t) => t as String).toList(),
    );
  }

  final String id;
  final String name;
  final CardImagesModel images;
  final String? hp;
  final String? supertype;
  final String? rarity;
  final String? artist;
  final String? set;
  final String? number;
  final List<AttackModel>? attacks;
  final List<String>? types;

  // PUENTE: Modelo → Entidad
  PokemonCard toEntity() {
    return PokemonCard(
      id: id,
      name: name,
      imageUrl: images.small,
      hp: hp,
      supertype: supertype,
      rarity: rarity,
      artist: artist,
      set: set,
      number: number,
      attacks: attacks?.map((a) => a.toEntity()).toList(),
      types: types,
      largeImageUrl: images.large,
    );
  }
}

class CardImagesModel {
  const CardImagesModel({required this.small, required this.large});

  factory CardImagesModel.fromJson(Map<String, dynamic> json) {
    return CardImagesModel(
      small: json['small'] as String,
      large: json['large'] as String,
    );
  }

  final String small;
  final String large;
}

class AttackModel {
  const AttackModel({
    required this.name,
    required this.damage,
    this.cost,
    this.text,
  });

  factory AttackModel.fromJson(Map<String, dynamic> json) {
    final costList = json['cost'] as List<dynamic>?;
    
    return AttackModel(
      name: json['name'] as String? ?? '',
      damage: json['damage'] as String? ?? '',
      cost: costList?.map((c) => c as String).toList(),
      text: json['text'] as String?,
    );
  }

  final String name;
  final String damage;
  final List<String>? cost;
  final String? text;

  Attack toEntity() {
    return Attack(
      name: name,
      damage: damage,
      cost: cost,
      text: text,
    );
  }
}