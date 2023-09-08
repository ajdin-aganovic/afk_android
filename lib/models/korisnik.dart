import 'package:json_annotation/json_annotation.dart';
part 'korisnik.g.dart';

@JsonSerializable()
class Korisnik{
   int? korisnikId;
  String? ime;
  String? prezime;
  String? korisnickoIme;
  String? email;
  String? lozinkaHash;
  String? lozinkaSalt;
  String? password;
  String? passwordPotvrda;
  String? strucnaSprema;
  DateTime? datumRodjenja;
  bool? podUgovorom;
  DateTime? podUgovoromOd;
  DateTime? podUgovoromDo;
  String? uloga;


  Korisnik(this.korisnikId, this.ime, this.prezime, this.korisnickoIme, this.email, this.lozinkaHash, this.lozinkaSalt,
  this.strucnaSprema, this.datumRodjenja, this.podUgovorom, this.podUgovoromOd, this.podUgovoromDo, this.uloga,
  this.password, this.passwordPotvrda);
  // factory Korisnici.fromJson(Map<String,dynamic>json)=>_$KorisniciFromJson(json);

  factory Korisnik.fromJson(Map<String,dynamic>json)=>_$KorisnikFromJson(json);
  Map<String,dynamic>toJson()=>_$KorisnikToJson(this);
}
