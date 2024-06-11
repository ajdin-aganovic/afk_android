import 'package:json_annotation/json_annotation.dart';
part 'narudzba.g.dart';

@JsonSerializable()
class Narudzba{
   int? narudzbaId;
  String? brojNarudzba;
  DateTime? datum;
  String? status;


  Narudzba(this.narudzbaId, this.brojNarudzba, this.datum, this.status);
  // factory Korisnici.fromJson(Map<String,dynamic>json)=>_$KorisniciFromJson(json);

  factory Narudzba.fromJson(Map<String,dynamic>json)=>_$NarudzbaFromJson(json);
  Map<String,dynamic>toJson()=>_$NarudzbaToJson(this);
}
