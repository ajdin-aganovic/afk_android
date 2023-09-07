import 'package:json_annotation/json_annotation.dart';
part 'korisnik_pozicija.g.dart';

@JsonSerializable()
class KorisnikPozicija{
int? korisnikPozicijaId;

int? korisnikId;

int? pozicijaId;


  KorisnikPozicija(this.korisnikPozicijaId, this.korisnikId, this.pozicijaId);
  // factory Korisnici.fromJson(Map<String,dynamic>json)=>_$KorisniciFromJson(json);

  factory KorisnikPozicija.fromJson(Map<String,dynamic>json)=>_$KorisnikPozicijaFromJson(json);
  Map<String,dynamic>toJson()=>_$KorisnikPozicijaToJson(this);
}