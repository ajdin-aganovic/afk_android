// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'trening.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Trening _$TreningFromJson(Map<String, dynamic> json) => Trening(
      json['treningId'] as int?,
      json['nazivTreninga'] as String?,
      json['tipTreninga'] as String?,
      json['datumTreninga'] as String?,
    );

Map<String, dynamic> _$TreningToJson(Trening instance) => <String, dynamic>{
      'treningId': instance.treningId,
      'nazivTreninga': instance.nazivTreninga,
      'tipTreninga': instance.tipTreninga,
      'datumTreninga': instance.datumTreninga,
    };
