import 'package:json_annotation/json_annotation.dart';
part 'bolest.g.dart';

@JsonSerializable()
class Bolest{
int? bolestId;

String? sifraPovrede;

String? tipPovrede;

int? trajanjePovredeDani;


  Bolest(this.bolestId, this.sifraPovrede, this.tipPovrede, this.trajanjePovredeDani);
  // factory Korisnici.fromJson(Map<String,dynamic>json)=>_$KorisniciFromJson(json);

  factory Bolest.fromJson(Map<String,dynamic>json)=>_$BolestFromJson(json);
  Map<String,dynamic>toJson()=>_$BolestToJson(this);
}