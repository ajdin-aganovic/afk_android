import 'dart:math';
import 'dart:convert';
import 'package:afk_android/providers/bolest_provider.dart';
import 'package:afk_android/providers/clanarina_provider.dart';
import 'package:afk_android/providers/pozicija_provider.dart';
import 'package:afk_android/providers/stadion_provider.dart';
import 'package:afk_android/providers/statistika_provider.dart';
import 'package:afk_android/providers/termin_provider.dart';
import 'package:afk_android/providers/transakcijski_racun_provider.dart';
import 'package:afk_android/providers/trening_provider.dart';
import 'package:afk_android/screens/bolest_details_screen.dart';
import 'package:afk_android/screens/bolest_list_screen.dart';
import 'package:afk_android/screens/clanarina_details_screen.dart';
import 'package:afk_android/screens/clanarina_list_screen.dart';
import 'package:afk_android/screens/igrac_clanarina_payment.dart';
import 'package:afk_android/screens/korisnici_list_screen.dart';
import 'package:afk_android/screens/korisnik_insert_screen.dart';
import 'package:afk_android/screens/plata_details_screen.dart';
import 'package:afk_android/screens/pozicija_details_screen.dart';
import 'package:afk_android/screens/pozicija_list_screen.dart';
import 'package:afk_android/screens/reset_password_screen.dart';
import 'package:afk_android/screens/stadion_details_screen.dart';
import 'package:afk_android/screens/stadion_screen.dart';
import 'package:afk_android/screens/statistika_details_screen.dart';
import 'package:afk_android/screens/statistika_list_screen.dart';
import 'package:afk_android/screens/termin_details_screen.dart';
import 'package:afk_android/screens/termin_list_screen.dart';
import 'package:afk_android/screens/transakcijski_racun_details.dart';
import 'package:afk_android/screens/transakcijski_racun_list_screen.dart';
import 'package:afk_android/screens/trening_details_screen.dart';
import 'package:afk_android/screens/trening_list_screen.dart';
import 'package:afk_android/screens/uloga_details_screen.dart';
import 'package:afk_android/screens/uloga_list_screen.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart' as dotenv;
import 'package:http/http.dart' as http;
import 'package:afk_android/providers/korisnik_provider.dart';
import 'package:afk_android/providers/platum_provider.dart';
import 'package:afk_android/providers/uloga_provider.dart';
import 'package:afk_android/screens/plata_list_screen.dart';
import 'package:afk_android/screens/korisnik_details_screen.dart';
import 'package:afk_android/utils/util.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:afk_android/widgets/makePayment.dart';
// import 'package:afk_android/api/client.dart';

import '../models/korisnik.dart';
import '../models/korisnik_pozicija.dart';
import '../models/search_result.dart';
import '../providers/korisnik_pozicija_provider.dart';
import 'igrac_vise_detalja_screen.dart';
import 'korisnici_editable_screen.dart';

class IgracScreen extends StatefulWidget {
  Korisnik? korisnik;
  IgracScreen({this.korisnik, super.key});

  @override
  State<IgracScreen> createState() => _IgracScreen();
}

class _IgracScreen extends State<IgracScreen>{
  
  final _formKey=GlobalKey<FormBuilderState>();
   final ScrollController _horizontal = ScrollController(),
      _vertical = ScrollController();
  
Map<String,dynamic>_initialValue={};

  late KorisnikProvider _korisnikProvider;
  SearchResult<Korisnik>? _korisnikResult;
  
late KorisnikPozicijaProvider _korisnikPozicijaProvider;
  SearchResult<KorisnikPozicija>? _korisnikPozicijaResult;
 

  @override
  void initState(){
    super.initState();
    _korisnikProvider=context.read<KorisnikProvider>();
    _korisnikPozicijaProvider=context.read<KorisnikPozicijaProvider>();
    initForm();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();

  }

    Future initForm()async{
      _korisnikResult=await _korisnikProvider.get();
      _korisnikPozicijaResult=await _korisnikPozicijaProvider.get();
      // print(_korisnikResult);
  }

Future<String> getUser() async
{
var data=await _korisnikProvider.get(filter: {
    'KorisnickoIme':Authorization.username,
    });
var korisnickoIme= data.result.first.korisnickoIme;
if(korisnickoIme!=null)
  return korisnickoIme;
else
  return 'Nije pronađen';
}

KorisnikPozicija? getKorisnikPozicija(int id)
  {
    var getKorisnikPozicijaDetails=_korisnikPozicijaResult?.result.firstWhere((element) => element.korisnikId==id);
    return getKorisnikPozicijaDetails;
  }

  @override
  Widget build(BuildContext context) {

    var izabrani=_korisnikResult?.result.first;
    // TODO: implement build
   return 
    SizedBox(
      height: 500,
    width: 600,
      child: 
      Scaffold(
        appBar: AppBar(
          title: const Text("Home"),),
          body: Center(
            child: 
            Container(
              // constraints: const BoxConstraints(maxHeight: 600,maxWidth: 400),
              child: 
              Card(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(children: [
                      Padding(
                        padding: const EdgeInsets.all(9.0),
                        child: 
                          Column(
                            children: [
                            SizedBox(height: 12,),
                            const Text('Aplikacija Fudbalskog Kluba',
                            style: TextStyle(fontSize: 30),), 
                            SizedBox(height: 12,),
                            Text('Dobrodošli ${Authorization.username}',
                            // Text('Dobrodošli ${_korisnikResult?.result.first.korisnickoIme}',

                            style: TextStyle(fontSize: 30),),

                              Row(
                                children: [
                                  Column(
                                    children: [
                                      SizedBox(height: 50, width: 300, child: 
                                                   
                                          ElevatedButton(onPressed: (){
                                          Navigator.of(context).push(
                                          MaterialPageRoute(
                                          builder: (context) => PlatumListScreen()
                                          ),
                                          );
                                          }, child: Text("Go to Platna lista")),),
                                    ],
                                  ),
                                      
                                  Column(
                                    children: [
                                      SizedBox(height: 50, width: 300, child: 
                                                     
                                           ElevatedButton(onPressed: (){
                                           Navigator.of(context).push(
                                           MaterialPageRoute(
                                           builder: (context) => TransakcijskiRacunListScreen()
                                           ),
                                       );
                                       }, child: Text("Go to Transakcijski račun")),),
                                    ],
                                  ),

                                  Column(
                                    children: [
                                      SizedBox(height: 50, width: 300, child: 
                                                     
                                           ElevatedButton(onPressed: (){
                                           Navigator.of(context).push(
                                           MaterialPageRoute(
                                           // builder: (context) => KorisniciListScreen()
                                           builder: (context) => KorisniciEditableScreen()

                                           ),
                                       );
                                       }, child: Text("Go to Korisnici lista")),),
                                    ],
                                  ),
                                ],
                              ),
                              Row(children: [
                                Column(
                                    children: [
                                      SizedBox(height: 50, width: 300, child: 
                                                     
                                           ElevatedButton(onPressed: (){
                                           Navigator.of(context).push(
                                           MaterialPageRoute(
                                           // builder: (context) => KorisniciListScreen()
                                           builder: (context) => IgracClanarinaScreen(korisnik: widget.korisnik,)

                                           ),
                                       );
                                       }, child: Text("Go to Igrač članarina")),),
                                    ],
                                  ),
                              ],)
                            ],
                          ),
                        
                      ),


                    Row(
                      children: [
                        Column(
                          children: [
                            SizedBox(height: 50, width: 300, child: 
                                             
                                   ElevatedButton(onPressed: (){
                                   Navigator.of(context).push(
                                   MaterialPageRoute(
                                   builder: (context) => StadionListScreen()
                                   ),
                               );
                               }, child: Text("Go to Stadion")),),
                          ],
                        ),


                        Column(
                          children: [
                            SizedBox(height: 50, width: 300, child: 
                                          
                                ElevatedButton(onPressed: (){
                                Navigator.of(context).push(
                                MaterialPageRoute(
                                builder: (context) => ClanarinaListScreen()
                                ),
                            );
                            }, child: Text("Go to Članarina")),),
                          ],
                        ),
                      ],
                    ),


                    Row(
                      children: [
                        Column(
                          children: [
                            SizedBox(height: 50, width: 300, child: 
                                          
                                ElevatedButton(onPressed: (){
                                Navigator.of(context).push(
                                MaterialPageRoute(
                                builder: (context) => PozicijaListScreen()
                                ),
                            );
                            }, child: Text("Go to Pozicija")),),
                          ],
                        ),
                        
                        Column(
                          children: [
                            SizedBox(height: 50, width: 300, child: 
                                        
                              ElevatedButton(onPressed: (){
                              Navigator.of(context).push(
                              MaterialPageRoute(
                              builder: (context) => BolestListScreen()
                              ),
                  );
                  }, child: Text("Go to Bolests")),),
                          ],
                        ),
                          
                        Column(
                          children: [
                            SizedBox(height: 50, width: 300, child: 
                                            
                                  ElevatedButton(onPressed: (){
                                  Navigator.of(context).push(
                                  MaterialPageRoute(
                                  builder: (context) => StatistikaListScreen()
                                  ),
                              );
                              }, child: Text("Go to Statistika")),),
                          ],
                        ),
                      ],
                    ),

                          
                       Row(
                         children: [
                          Column(
                            children: [
                              SizedBox(height: 50, width: 300, child: 
                                             
                                   ElevatedButton(onPressed: (){
                                   Navigator.of(context).push(
                                   MaterialPageRoute(
                                   builder: (context) => UlogaListScreen()
                                   ),
                               );
                               }, child: Text("Go to Uloga")),),
                            ],
                          ),

                        Column(
                          children: [
                            SizedBox(height: 50, width: 300, child: 
                                                  
                                        ElevatedButton(onPressed: (){
                                        Navigator.of(context).push(
                                        MaterialPageRoute(
                                        builder: (context) => TerminListScreen()
                                        ),
                                    );
                                    
                                    }, child: Text("Go to Termin")),),
                          ],
                        ),

                        Column(
                          children: [
                            SizedBox(height: 50, width: 300, child: 
                                              
                                    ElevatedButton(onPressed: (){
                                    Navigator.of(context).push(
                                    MaterialPageRoute(
                                    builder: (context) => TreningListScreen()
                                    ),
                                );
                                }, child: Text("Go to Trening")),),
                          ],
                        ),
                      ],
                    ),

                    //Ovo dolje još uvijek neće, treba popraviti
                      
                    Row(children: [
                        SizedBox(height: 50, width: 300, child: 
                          ElevatedButton(onPressed: (){
                          Navigator.of(context).push(
                          MaterialPageRoute(
                          builder: (context) => ViseDetaljaScreen(korisnikPozicija: getKorisnikPozicija(widget.korisnik?.korisnikId??2),)
                          ),
                      );
                      }, child: Text("Go to Više detalja")),),
                    ],
                    )


                    ]
                    
                    ),
                  ],
                ),
              ),
            ),
          ),
      ),
    );
  }

}