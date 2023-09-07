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

//  public int KorisnikId { get; set; }

//         public string? Ime { get; set; }

//         public string? Prezime { get; set; }

//         public string? Email { get; set; }

//         public string? Lozinka { get; set; }

//         public int UlogaId { get; set; }

//         public string? StrucnaSprema { get; set; }

//         public DateTime? DatumRodjenja { get; set; }

//         public int? BolestId { get; set; }
//         public int TipKorisnikaId { get; set; }
//         public int? TransakcijskiRacunId { get; set; }
//         public bool? PodUgovorom { get; set; }
//         public DateTime? PodUgovoromOd { get; set; }
//         public DateTime? PodUgovoromDo { get; set; }
//         public string? KorisnickoIme { get; set; }