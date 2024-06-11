// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'proizvod.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Proizvod _$ProizvodFromJson(Map<String, dynamic> json) => Proizvod(
      json['proizvodId'] as int?,
      json['naziv'] as String?,
      json['sifra'] as String?,
      json['kategorija'] as String?,
      (json['cijena'] as num?)?.toDouble(),
      json['kolicina'] as int?,
      json['stateMachine'] as String?,
    );

Map<String, dynamic> _$ProizvodToJson(Proizvod instance) => <String, dynamic>{
      'proizvodId': instance.proizvodId,
      'naziv': instance.naziv,
      'sifra': instance.sifra,
      'kategorija': instance.kategorija,
      'cijena': instance.cijena,
      'kolicina': instance.kolicina,
      'stateMachine': instance.stateMachine,
    };
