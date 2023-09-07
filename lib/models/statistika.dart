import 'package:json_annotation/json_annotation.dart';
part 'statistika.g.dart';

@JsonSerializable()
class Statistika{
int? statistikaId;
int? korisnikId;

int? golovi;

int? asistencije;

bool? igracMjeseca;

int? bezPrimGola;

int? zutiKartoni;

int? crveniKartoni;

double? prosjecnaOcjena;

double? ocjenaZadUtak;


  Statistika(this.statistikaId,this.korisnikId, this.golovi, this.asistencije,
  this.igracMjeseca, this.bezPrimGola, this.zutiKartoni, this.crveniKartoni, 
  this.prosjecnaOcjena, this.ocjenaZadUtak);
  // factory Korisnici.fromJson(Map<String,dynamic>json)=>_$KorisniciFromJson(json);

  factory Statistika.fromJson(Map<String,dynamic>json)=>_$StatistikaFromJson(json);
  Map<String,dynamic>toJson()=>_$StatistikaToJson(this);
}