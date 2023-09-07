import 'package:json_annotation/json_annotation.dart';
part 'trening.g.dart';

@JsonSerializable()
class Trening{
int? treningId ;

String? nazivTreninga ;

String? tipTreninga ;
String? datumTreninga;


  Trening(this.treningId, this.nazivTreninga, this.tipTreninga, this.datumTreninga);
  // factory Korisnici.fromJson(Map<String,dynamic>json)=>_$KorisniciFromJson(json);

  factory Trening.fromJson(Map<String,dynamic>json)=>_$TreningFromJson(json);
  Map<String,dynamic>toJson()=>_$TreningToJson(this);
}
