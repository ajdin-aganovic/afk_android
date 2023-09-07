import 'package:json_annotation/json_annotation.dart';
part 'transakcijski_racun.g.dart';

@JsonSerializable()
class TransakcijskiRacun{
   int? transakcijskiRacunId;
  String? brojRacuna;
  String? adresaPrebivalista;
  String? nazivBanke;
  int? korisnikId;
  String? punoImeKorisnika;


  TransakcijskiRacun(this.transakcijskiRacunId, this.brojRacuna, this.adresaPrebivalista, this.nazivBanke, this.korisnikId, this.punoImeKorisnika);
  // factory Korisnici.fromJson(Map<String,dynamic>json)=>_$KorisniciFromJson(json);

  factory TransakcijskiRacun.fromJson(Map<String,dynamic>json)=>_$TransakcijskiRacunFromJson(json);
  Map<String,dynamic>toJson()=>_$TransakcijskiRacunToJson(this);
}


//samo izbrisati punoImeKorisnika

// public int TransakcijskiRacunId { get; set; }

// public string? BrojRacuna { get; set; }

// public string? AdresaPrebivalista { get; set; }

// public string? NazivBanke { get; set; }