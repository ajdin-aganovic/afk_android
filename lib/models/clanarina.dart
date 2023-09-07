import 'package:json_annotation/json_annotation.dart';
part 'clanarina.g.dart';

@JsonSerializable()
class Clanarina{
  int? clanarinaId ;

int? korisnikId ;

 double? iznosClanarine ;

 double? dug ;


  Clanarina(this.clanarinaId, this.korisnikId, this.iznosClanarine, this.dug);
  // factory Korisnici.fromJson(Map<String,dynamic>json)=>_$KorisniciFromJson(json);

  factory Clanarina.fromJson(Map<String,dynamic>json)=>_$ClanarinaFromJson(json);
  Map<String,dynamic>toJson()=>_$ClanarinaToJson(this);
}