// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'platum.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Platum _$PlatumFromJson(Map<String, dynamic> json) => Platum(
      json['plataId'] as int?,
      json['transakcijskiRacunId'] as int?,
      json['stateMachine'] as String?,
      json['iznos'] as num?,
      json['datumSlanja'] == null
          ? null
          : DateTime.parse(json['datumSlanja'] as String),
    );

Map<String, dynamic> _$PlatumToJson(Platum instance) => <String, dynamic>{
      'plataId': instance.plataId,
      'transakcijskiRacunId': instance.transakcijskiRacunId,
      'stateMachine': instance.stateMachine,
      'iznos': instance.iznos,
      'datumSlanja': instance.datumSlanja?.toIso8601String(),
    };
