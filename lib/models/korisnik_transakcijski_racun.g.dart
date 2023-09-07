// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'korisnik_transakcijski_racun.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

KorisnikTransakcijskiRacun _$KorisnikTransakcijskiRacunFromJson(
        Map<String, dynamic> json) =>
    KorisnikTransakcijskiRacun(
      json['korisnikTransakcijskiRacunId'] as int?,
      json['korisnikId'] as int?,
      json['transakcijskiRacunId'] as int?,
      json['datumIzmjene'] == null
          ? null
          : DateTime.parse(json['datumIzmjene'] as String),
    );

Map<String, dynamic> _$KorisnikTransakcijskiRacunToJson(
        KorisnikTransakcijskiRacun instance) =>
    <String, dynamic>{
      'korisnikTransakcijskiRacunId': instance.korisnikTransakcijskiRacunId,
      'korisnikId': instance.korisnikId,
      'transakcijskiRacunId': instance.transakcijskiRacunId,
      'datumIzmjene': instance.datumIzmjene?.toIso8601String(),
    };
