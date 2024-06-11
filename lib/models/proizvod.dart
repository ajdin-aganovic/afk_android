import 'package:json_annotation/json_annotation.dart';
part 'proizvod.g.dart';

@JsonSerializable()
class Proizvod{
  int? proizvodId ;

String? naziv;

String? sifra;
String? kategorija;
double? cijena;
int? kolicina;
String? stateMachine;


  Proizvod(this.proizvodId, this.naziv, this.sifra, this.kategorija, this.cijena, this.kolicina, this.stateMachine);
  // factory Korisnici.fromJson(Map<String,dynamic>json)=>_$KorisniciFromJson(json);

  factory Proizvod.fromJson(Map<String,dynamic>json)=>_$ProizvodFromJson(json);
  Map<String,dynamic>toJson()=>_$ProizvodToJson(this);
}