// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pozicija.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Pozicija _$PozicijaFromJson(Map<String, dynamic> json) => Pozicija(
      json['pozicijaId'] as int?,
      json['nazivPozicije'] as String?,
      json['kategorijaPozicije'] as String?,
    );

Map<String, dynamic> _$PozicijaToJson(Pozicija instance) => <String, dynamic>{
      'pozicijaId': instance.pozicijaId,
      'nazivPozicije': instance.nazivPozicije,
      'kategorijaPozicije': instance.kategorijaPozicije,
    };
