// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transakcijski_racun.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TransakcijskiRacun _$TransakcijskiRacunFromJson(Map<String, dynamic> json) =>
    TransakcijskiRacun(
      json['transakcijskiRacunId'] as int?,
      json['brojRacuna'] as String?,
      json['adresaPrebivalista'] as String?,
      json['nazivBanke'] as String?,
      json['korisnikId'] as int?,
      json['punoImeKorisnika'] as String?,
    );

Map<String, dynamic> _$TransakcijskiRacunToJson(TransakcijskiRacun instance) =>
    <String, dynamic>{
      'transakcijskiRacunId': instance.transakcijskiRacunId,
      'brojRacuna': instance.brojRacuna,
      'adresaPrebivalista': instance.adresaPrebivalista,
      'nazivBanke': instance.nazivBanke,
      'korisnikId': instance.korisnikId,
      'punoImeKorisnika': instance.punoImeKorisnika,
    };
