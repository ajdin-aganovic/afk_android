// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'korisnik.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Korisnik _$KorisnikFromJson(Map<String, dynamic> json) => Korisnik(
      json['korisnikId'] as int?,
      json['ime'] as String?,
      json['prezime'] as String?,
      json['korisnickoIme'] as String?,
      json['email'] as String?,
      json['lozinkaHash'] as String?,
      json['lozinkaSalt'] as String?,
      json['strucnaSprema'] as String?,
      json['datumRodjenja'] == null
          ? null
          : DateTime.parse(json['datumRodjenja'] as String),
      json['podUgovorom'] as bool?,
      json['podUgovoromOd'] == null
          ? null
          : DateTime.parse(json['podUgovoromOd'] as String),
      json['podUgovoromDo'] == null
          ? null
          : DateTime.parse(json['podUgovoromDo'] as String),
      json['uloga'] as String?,
      json['password'] as String?,
      json['passwordPotvrda'] as String?,
    );

Map<String, dynamic> _$KorisnikToJson(Korisnik instance) => <String, dynamic>{
      'korisnikId': instance.korisnikId,
      'ime': instance.ime,
      'prezime': instance.prezime,
      'korisnickoIme': instance.korisnickoIme,
      'email': instance.email,
      'lozinkaHash': instance.lozinkaHash,
      'lozinkaSalt': instance.lozinkaSalt,
      'password': instance.password,
      'passwordPotvrda': instance.passwordPotvrda,
      'strucnaSprema': instance.strucnaSprema,
      'datumRodjenja': instance.datumRodjenja?.toIso8601String(),
      'podUgovorom': instance.podUgovorom,
      'podUgovoromOd': instance.podUgovoromOd?.toIso8601String(),
      'podUgovoromDo': instance.podUgovoromDo?.toIso8601String(),
      'uloga': instance.uloga,
    };
