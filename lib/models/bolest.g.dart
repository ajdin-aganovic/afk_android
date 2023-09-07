// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bolest.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Bolest _$BolestFromJson(Map<String, dynamic> json) => Bolest(
      json['bolestId'] as int?,
      json['sifraPovrede'] as String?,
      json['tipPovrede'] as String?,
      json['trajanjePovredeDani'] as int?,
    );

Map<String, dynamic> _$BolestToJson(Bolest instance) => <String, dynamic>{
      'bolestId': instance.bolestId,
      'sifraPovrede': instance.sifraPovrede,
      'tipPovrede': instance.tipPovrede,
      'trajanjePovredeDani': instance.trajanjePovredeDani,
    };
