// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'narudzba.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Narudzba _$NarudzbaFromJson(Map<String, dynamic> json) => Narudzba(
      json['narudzbaId'] as int?,
      json['brojNarudzba'] as String?,
      json['datum'] as DateTime?,
      json['status'] as String?,
    );

Map<String, dynamic> _$NarudzbaToJson(Narudzba instance) => <String, dynamic>{
      'narudzbaId': instance.narudzbaId,
      'brojNarudzba': instance.brojNarudzba,
      'datum': instance.datum,
      'status': instance.status,
    };
