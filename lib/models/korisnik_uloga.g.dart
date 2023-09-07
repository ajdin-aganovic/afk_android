// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'korisnik_uloga.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

KorisnikUloga _$KorisnikUlogaFromJson(Map<String, dynamic> json) =>
    KorisnikUloga(
      json['korisnikUlogaId'] as int?,
      json['korisnikId'] as int?,
      json['ulogaId'] as int?,
      json['datumIzmjene'] == null
          ? null
          : DateTime.parse(json['datumIzmjene'] as String),
    );

Map<String, dynamic> _$KorisnikUlogaToJson(KorisnikUloga instance) =>
    <String, dynamic>{
      'korisnikUlogaId': instance.korisnikUlogaId,
      'korisnikId': instance.korisnikId,
      'ulogaId': instance.ulogaId,
      'datumIzmjene': instance.datumIzmjene?.toIso8601String(),
    };
