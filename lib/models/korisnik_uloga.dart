import 'package:json_annotation/json_annotation.dart';
part 'korisnik_uloga.g.dart';

@JsonSerializable()
class KorisnikUloga{
int? korisnikUlogaId;

int? korisnikId;

int? ulogaId;

DateTime? datumIzmjene;


  KorisnikUloga(this.korisnikUlogaId, this.korisnikId, this.ulogaId, this.datumIzmjene);
  // factory Korisnici.fromJson(Map<String,dynamic>json)=>_$KorisniciFromJson(json);

  factory KorisnikUloga.fromJson(Map<String,dynamic>json)=>_$KorisnikUlogaFromJson(json);
  Map<String,dynamic>toJson()=>_$KorisnikUlogaToJson(this);
}