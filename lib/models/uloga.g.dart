// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'uloga.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Uloga _$UlogaFromJson(Map<String, dynamic> json) => Uloga(
      json['ulogaId'] as int?,
      json['nazivUloge'] as String?,
      json['podtipUloge'] as String?,
    );

Map<String, dynamic> _$UlogaToJson(Uloga instance) => <String, dynamic>{
      'ulogaId': instance.ulogaId,
      'nazivUloge': instance.nazivUloge,
      'podtipUloge': instance.podtipUloge,
    };
