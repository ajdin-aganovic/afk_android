import 'dart:math';
import 'dart:convert';
import 'package:afk_admin/providers/bolest_provider.dart';
import 'package:afk_admin/providers/clanarina_provider.dart';
import 'package:afk_admin/providers/pozicija_provider.dart';
import 'package:afk_admin/providers/stadion_provider.dart';
import 'package:afk_admin/providers/statistika_provider.dart';
import 'package:afk_admin/providers/termin_provider.dart';
import 'package:afk_admin/providers/transakcijski_racun_provider.dart';
import 'package:afk_admin/providers/trening_provider.dart';
import 'package:afk_admin/screens/bolest_details_screen.dart';
import 'package:afk_admin/screens/bolest_list_screen.dart';
import 'package:afk_admin/screens/clanarina_details_screen.dart';
import 'package:afk_admin/screens/clanarina_list_screen.dart';
import 'package:afk_admin/screens/korisnici_editable_screen.dart';
import 'package:afk_admin/screens/korisnici_list_screen.dart';
import 'package:afk_admin/screens/korisnik_insert_screen.dart';
import 'package:afk_admin/screens/plata_details_screen.dart';
import 'package:afk_admin/screens/pozicija_details_screen.dart';
import 'package:afk_admin/screens/pozicija_list_screen.dart';
import 'package:afk_admin/screens/proizvod_details_screen.dart';
import 'package:afk_admin/screens/proizvod_list_screen.dart';
import 'package:afk_admin/screens/reset_password_screen.dart';
import 'package:afk_admin/screens/stadion_details_screen.dart';
import 'package:afk_admin/screens/stadion_screen.dart';
import 'package:afk_admin/screens/statistika_details_screen.dart';
import 'package:afk_admin/screens/statistika_list_screen.dart';
import 'package:afk_admin/screens/termin_details_screen.dart';
import 'package:afk_admin/screens/termin_list_screen.dart';
import 'package:afk_admin/screens/transakcijski_racun_details.dart';
import 'package:afk_admin/screens/transakcijski_racun_list_screen.dart';
import 'package:afk_admin/screens/trening_details_screen.dart';
import 'package:afk_admin/screens/trening_list_screen.dart';
import 'package:afk_admin/screens/uloga_details_screen.dart';
import 'package:afk_admin/screens/uloga_list_screen.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart' as dotenv;
import 'package:http/http.dart' as http;
import 'package:afk_admin/providers/korisnik_provider.dart';
import 'package:afk_admin/providers/platum_provider.dart';
import 'package:afk_admin/providers/uloga_provider.dart';
import 'package:afk_admin/screens/plata_list_screen.dart';
import 'package:afk_admin/screens/korisnik_details_screen.dart';
import 'package:afk_admin/utils/util.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:afk_admin/widgets/makePayment.dart';
// import 'package:afk_admin/api/client.dart';

import '../main.dart';
import '../models/korisnik.dart';
import '../models/search_result.dart';
import 'korisnik_dodaj_screen.dart';
import 'lista_igraca_screen.dart';

class AdminScreen extends StatefulWidget {
  Korisnik? korisnik;
  AdminScreen({this.korisnik, super.key});

  @override
  State<AdminScreen> createState() => _AdminScreen();
}

class _AdminScreen extends State<AdminScreen>{
  
  final _formKey=GlobalKey<FormBuilderState>();
   final ScrollController _horizontal = ScrollController(),
      _vertical = ScrollController();
  
Map<String,dynamic>_initialValue={};

  late KorisnikProvider _korisnikProvider;
  

  SearchResult<Korisnik>? _korisnikResult;

  @override
  void initState(){
    super.initState();
    _korisnikProvider=context.read<KorisnikProvider>();
    initForm();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();

  }

    Future initForm()async{
      _korisnikResult=await _korisnikProvider.get();
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

  @override
  Widget build(BuildContext context) {
    // // var izabrani=_korisnikResult?.result.where((element) => widget.korisnik!.korisnikId==element.korisnikId);
    // var izabrani=_korisnikResult?.result.where((element) => _korisnikResult!.result.first.korisnickoIme==element.korisnickoIme)??_korisnikResult?.result.first;
   
    // if(izabrani==null)
    //  { izabrani=_korisnikResult?.result.first;}
    // var izabrani=getUser();
    
    // if(izabrani?.korisnickoIme!=Authorization.username)
    //   {
    //     izabrani;
    //   }

    // var izabrani=_korisnikProvider.get();
    // _korisnikResult=_korisnikProvider.get() as SearchResult<Korisnik>?;

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

                                    SizedBox(height: 50, width: 300, child:
                                    
                                  ElevatedButton(onPressed: (){
                                  Navigator.of(context).push(
                                  MaterialPageRoute(
                                  builder: (context) => PlatumListScreen()
                                  ),
                                  );
                                  }, child: Text("Go to Platna lista")),
                                    ),
                                                


                                 SizedBox(height: 50, width: 300, child:
                                 
                                      ElevatedButton(onPressed: (){
                                      Navigator.of(context).push(
                                      MaterialPageRoute(
                                      builder: (context) => PlatumDetailsScreen()
                                      ),
                                  );
                                  }, child: Text("Add new Platna lista")),
                                 ),
                                                
                                ]
                              ),
                              Row(children: [
                                 SizedBox(height: 50, width: 300, child:
                                 
                                      ElevatedButton(onPressed: (){
                                      Navigator.of(context).push(
                                      MaterialPageRoute(
                                      builder: (context) => TransakcijskiRacunListScreen()
                                      ),
                                  );
                                  }, child: Text("Go to Transakcijski račun")),
                                 ),
                                                

                                SizedBox(height: 50, width: 300, child: 
                                      ElevatedButton(onPressed: (){
                                      Navigator.of(context).push(
                                      MaterialPageRoute(
                                      builder: (context) => TransakcijskiRacunDetailsScreen()
                                      ),
                                  );
                                  }, child: Text("Add new Transakcijski račun")),
                                
                                ),
                                                
                              ]
                              ),
                              Row(
                                children:[
                                  SizedBox(height: 50, width: 300, child: 
                                  
                                      ElevatedButton(onPressed: (){
                                      Navigator.of(context).push(
                                      MaterialPageRoute(
                                      builder: (context) => KorisniciEditableScreen()
                                      ),
                                  );
                                  }, child: Text("Go to Korisnici lista")),
                                  ),
                                                

                                  SizedBox(height: 50, width: 300, child: 
                                  
                                      ElevatedButton(onPressed: (){
                                      Navigator.of(context).push(
                                      MaterialPageRoute(
                                      builder: (context) => DodajScreen()
                                      ),
                                  );
                                  }, child: Text("Add new Korisnik")),
                                  ),
                                                
                                  
                                ],
                              ),
                            ],
                          ),
                        
                      ),
                    Row(
                      children: [
                        SizedBox(height: 50, width: 300, child: 
                        
                              ElevatedButton(onPressed: (){
                              Navigator.of(context).push(
                              MaterialPageRoute(
                              builder: (context) => StadionListScreen()
                              ),
                          );
                          }, child: Text("Go to Stadion")),
                        ),
                                        
                          
                          SizedBox(height: 50, width: 300, child: 
                              ElevatedButton(onPressed: (){
                              Navigator.of(context).push(
                              MaterialPageRoute(
                              builder: (context) => StadionDetailsScreen()
                              ),
                          );
                          }, child: Text("Add new Stadion")),
                          ),
                                        

                      ]
                    ),
                    Row(children: [
                            SizedBox(height: 50, width: 300, child:
                            
                              ElevatedButton(onPressed: (){
                              Navigator.of(context).push(
                              MaterialPageRoute(
                              builder: (context) => ClanarinaListScreen()
                              ),
                          );
                          }, child: Text("Go to Članarina")),
                            ),
                                        
                          
                         SizedBox(height: 50, width: 300,child: 
                              ElevatedButton(onPressed: (){
                              Navigator.of(context).push(
                              MaterialPageRoute(
                              builder: (context) => ClanarinaDetailsScreen()
                              ),
                          );
                          }, child: Text("Add new Članarina")),  
                         
                         ),
                                        
        
                    ]
                    ),
                    Row(children: [
                           SizedBox(height: 50, width: 300,child: 
                           
                              ElevatedButton(onPressed: (){
                              Navigator.of(context).push(
                              MaterialPageRoute(
                              builder: (context) => PozicijaListScreen()
                              ),
                          );
                          }, child: Text("Go to Pozicija")),
                           ),
                                        
                          
                          SizedBox(height: 50, width: 300,child: 
                          
                              ElevatedButton(onPressed: (){
                              Navigator.of(context).push(
                              MaterialPageRoute(
                              builder: (context) => PozicijaDetailsScreen()
                              ),
                          );
                          }, child: Text("Add new Pozicija")),  
                          
                          ),
                                        
                      ],
                    ),
                      
                    Row(
                      children: [
                         SizedBox(height: 50, width: 300,child: 
                         
                              ElevatedButton(onPressed: (){
                              Navigator.of(context).push(
                              MaterialPageRoute(
                              builder: (context) => StatistikaListScreen()
                              ),
                          );
                          }, child: Text("Go to Statistika")),
                         ),
                                        
                          
                          SizedBox(height: 50, width: 300, child:
                          
                              ElevatedButton(onPressed: (){
                              Navigator.of(context).push(
                              MaterialPageRoute(
                              builder: (context) => StatistikaDetailsScreen()
                              ),
                          );
                          }, child: Text("Add new Statistika")), 
                          
                          ),
                                        
                      ]
                    ),

                          Row(children: [

                          SizedBox(height: 50, width: 300, child:
                          
                              ElevatedButton(onPressed: (){
                              Navigator.of(context).push(
                              MaterialPageRoute(
                              builder: (context) => UlogaListScreen()
                              ),
                          );
                          }, child: Text("Go to Uloga")),
                          
                          ),
                                        
                          
                          SizedBox(height: 50, width: 300,child: 
                          
                              ElevatedButton(onPressed: (){
                              Navigator.of(context).push(
                              MaterialPageRoute(
                              builder: (context) => UlogaDetailsScreen()
                              ),
                          );
                          }, child: Text("Add new Uloga")), 
                          ),
                                        
                      ],
                    ),
                    Row(children: [

                          SizedBox(height: 50, width: 300, child:
                          
                              ElevatedButton(onPressed: (){
                              Navigator.of(context).push(
                              MaterialPageRoute(
                              builder: (context) => ListaIgracaScreen()
                              ),
                          );
                          }, child: Text("Go to Lista igrača po pozicijama")),
                          
                          ),

                          SizedBox(height: 50, width: 300, child:
                          
                              ElevatedButton(onPressed: (){
                              Navigator.of(context).push(
                              MaterialPageRoute(
                              builder: (context) => ProizvodDetailsScreen()
                              ),
                          );
                          }, child: Text("Add new Proizvod")),
                          
                          ),
                           
                                        
                      ],
                    )
                    ]),
                  ],
                ),
              ),
            ),
          ),
      ),
    );
  }

}