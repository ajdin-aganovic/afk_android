import 'package:json_annotation/json_annotation.dart';
part 'korisnik_transakcijski_racun.g.dart';

@JsonSerializable()
class KorisnikTransakcijskiRacun{
int? korisnikTransakcijskiRacunId;

int? korisnikId;

int? transakcijskiRacunId;

DateTime? datumIzmjene;


  KorisnikTransakcijskiRacun(this.korisnikTransakcijskiRacunId, this.korisnikId, this.transakcijskiRacunId, this.datumIzmjene);
  // factory Korisnici.fromJson(Map<String,dynamic>json)=>_$KorisniciFromJson(json);

  factory KorisnikTransakcijskiRacun.fromJson(Map<String,dynamic>json)=>_$KorisnikTransakcijskiRacunFromJson(json);
  Map<String,dynamic>toJson()=>_$KorisnikTransakcijskiRacunToJson(this);
}