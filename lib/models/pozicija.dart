import 'package:json_annotation/json_annotation.dart';
part 'pozicija.g.dart';

@JsonSerializable()
class Pozicija{
  int? pozicijaId ;

String? nazivPozicije;

String? kategorijaPozicije ;


  Pozicija(this.pozicijaId, this.nazivPozicije, this.kategorijaPozicije);
  // factory Korisnici.fromJson(Map<String,dynamic>json)=>_$KorisniciFromJson(json);

  factory Pozicija.fromJson(Map<String,dynamic>json)=>_$PozicijaFromJson(json);
  Map<String,dynamic>toJson()=>_$PozicijaToJson(this);
}