import 'package:json_annotation/json_annotation.dart';
part 'korisnik_bolest.g.dart';

@JsonSerializable()
class KorisnikBolest{
int? korisnikBolestId;

int? korisnikId;

int? bolestId;


  KorisnikBolest(this.korisnikBolestId, this.korisnikId, this.bolestId);
  // factory Korisnici.fromJson(Map<String,dynamic>json)=>_$KorisniciFromJson(json);

  factory KorisnikBolest.fromJson(Map<String,dynamic>json)=>_$KorisnikBolestFromJson(json);
  Map<String,dynamic>toJson()=>_$KorisnikBolestToJson(this);
}