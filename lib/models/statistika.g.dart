// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'statistika.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Statistika _$StatistikaFromJson(Map<String, dynamic> json) => Statistika(
      json['statistikaId'] as int?,
      json['korisnikId'] as int?,
      json['golovi'] as int?,
      json['asistencije'] as int?,
      json['igracMjeseca'] as bool?,
      json['bezPrimGola'] as int?,
      json['zutiKartoni'] as int?,
      json['crveniKartoni'] as int?,
      (json['prosjecnaOcjena'] as num?)?.toDouble(),
      (json['ocjenaZadUtak'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$StatistikaToJson(Statistika instance) =>
    <String, dynamic>{
      'statistikaId': instance.statistikaId,
      'korisnikId': instance.korisnikId,
      'golovi': instance.golovi,
      'asistencije': instance.asistencije,
      'igracMjeseca': instance.igracMjeseca,
      'bezPrimGola': instance.bezPrimGola,
      'zutiKartoni': instance.zutiKartoni,
      'crveniKartoni': instance.crveniKartoni,
      'prosjecnaOcjena': instance.prosjecnaOcjena,
      'ocjenaZadUtak': instance.ocjenaZadUtak,
    };
