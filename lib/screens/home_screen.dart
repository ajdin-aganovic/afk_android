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
import 'package:afk_admin/screens/igrac_opcije_screen.dart';
import 'package:afk_admin/screens/korisnici_list_screen.dart';
import 'package:afk_admin/screens/korisnik_insert_screen.dart';
import 'package:afk_admin/screens/medicinsko_opcije_screen.dart';
import 'package:afk_admin/screens/plata_details_screen.dart';
import 'package:afk_admin/screens/pozicija_details_screen.dart';
import 'package:afk_admin/screens/pozicija_list_screen.dart';
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
import 'package:afk_admin/screens/uprava_opcije_screen.dart';
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

import '../models/korisnik.dart';
import '../models/search_result.dart';
import 'administracija_opcije_screen.dart';

class HomePage extends StatefulWidget {
  final Korisnik? loggovaniUser;
  HomePage({this.loggovaniUser, super.key});

  @override
  State<HomePage> createState() => _HomePage();
}

class _HomePage extends State<HomePage>{
  
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
      // _korisnikResult=await _korisnikProvider.get();
      _korisnikResult=await _korisnikProvider.get(filter:{
        'KorisnickoIme':Authorization.username
      });

      // print(_korisnikResult);
  }


  @override
  Widget build(BuildContext context) {
    // // var izabrani=_korisnikResult?.result.where((element) => widget.korisnik!.korisnikId==element.korisnikId);
    var izabrani=_korisnikResult?.result.first;
    // var izabrani=_korisnikProvider.get();
    // _korisnikResult=_korisnikProvider.get() as SearchResult<Korisnik>?;
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
                    Padding(
                      padding: const EdgeInsets.all(9.0),
                      child: 
                        Column(
                          children: [
                              SizedBox(height: 12,),
                              Text('Aplikacija Fudbalskog Kluba',
                              style: TextStyle(fontSize: 30),), 
                              SizedBox(height: 12,),
                              // Text('Dobrodošli ${widget.loggovaniUser?.korisnickoIme??"nazad"}',
                              Text('Dobrodošli ${Authorization.username}',

                              
                              // Text('Dobrodošli ${widget.korisnik?.korisnickoIme}',
                              style: TextStyle(fontSize: 30),),
                              SizedBox(height: 24,),
                                          
      

                              
                            Row(
                              children: [
                                Row(
                                  
                                  children: [
                                    SizedBox(height: 80, width: 200, child: 
                                    
                                    ElevatedButton(onPressed: (){
                                    if(Authorization.ulogaKorisnika=="Administrator")
                                    // if(1==1)
                                    { 
                                    Navigator.of(context).push(
                                    MaterialPageRoute(
                                    builder: (context) => AdminScreen()
                                    ),
                                    );
                                    }
                                      else
                                      {
                                         showDialog(context: context, builder: (BuildContext context) => 
                                    AlertDialog(
                                      title: const Text("You are not Admin."),
                                      content: Text("Try again"),
                                      actions: [
                                        TextButton(onPressed: ()=>{
                                          Navigator.pop(context),
                                        }, child: const Text("OK"))
                                      ],
                                    ));
                                      }
                                    }, child: Text("Go to Admin dio")),
                                    
                                    )
                                  ],
                                ),


                                Row(
                                  children: [
                                    SizedBox(height: 80, width: 200, child: 
                                    ElevatedButton(onPressed: (){
                                    if(Authorization.ulogaKorisnika=="Glavni trener"||Authorization.ulogaKorisnika=="Pomoćni trener")
                                    // if(1==1)
                           { 
                                    Navigator.of(context).push(
                                    MaterialPageRoute(
                                    builder: (context) => UpravaScreen()
                                    ),
                                    );
                                    }
                                      else
                                      {
                                         showDialog(context: context, builder: (BuildContext context) => 
                                    AlertDialog(
                                      title: const Text("You are not Uprava."),
                                      content: Text("Try again"),
                                      actions: [
                                        TextButton(onPressed: ()=>{
                                          Navigator.pop(context),
                                        }, child: const Text("OK"))
                                      ],
                                    ));
                                      }
                                    }, child: Text("Go to Uprava dio")),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            
                            
                                 Row(
                                   children: [
                                     Row(
                                       children: [
                                        SizedBox(height: 80, width: 200, child: 
                                         ElevatedButton(onPressed: (){
                            if(Authorization.ulogaKorisnika=="Doktor")
                            // if(1==1)
                           { 
                            Navigator.of(context).push(
                            MaterialPageRoute(
                            builder: (context) => MedicinskoScreen()
                            ),
                            );
                            }
                              else
                              {
                                         showDialog(context: context, builder: (BuildContext context) => 
                            AlertDialog(
                              title: const Text("You are not Medicinsko osoblje."),
                              content: Text("Try again"),
                              actions: [
                                TextButton(onPressed: ()=>{
                                          Navigator.pop(context),
                                }, child: const Text("OK"))
                              ],
                            ));
                              }
                            }, child: Text("Go to Medicinski dio")),
                                        ),
                                       ],
                                     ),


                           
                          Row(
                            children: [
                              SizedBox(height: 80, width: 200, child: 
                              ElevatedButton(onPressed: (){
                                if(Authorization.ulogaKorisnika=="Igrač")
                                // if(1==1)
                               { 
                                Navigator.of(context).push(
                                MaterialPageRoute(
                                builder: (context) => IgracScreen()
                                ),
                                );
                                }
                                  else
                                  {
                                         showDialog(context: context, builder: (BuildContext context) => 
                                          AlertDialog(
                                            title: const Text("You are not Igrač."),
                                            content: Text("Try again"),
                                            actions: [
                                              TextButton(onPressed: ()=>{
                                                Navigator.pop(context),
                                              }, child: const Text("OK"))
                                            ],
                                          ));
                                  }
                                }, child: Text("Go to Igrač dio")),
                              ),
                            ],
                          ),
                                   ],
                                 ),

                            
                            
                            Row(
                              children: [
                                SizedBox(height: 80, width: 200, child: 
                                ElevatedButton(onPressed: () async {
                                  
                                  try {
                                    
                                    var data1313=_korisnikProvider.get(filter: {
                                      'KorisnickoIme':Authorization.username
                                    });

                                    setState(() {
                                      _korisnikResult!=data1313;
                                    });

                                    var pronadjeniKorisnik=_korisnikResult!.result.first;
                                  
                                    Navigator.of(context).push(
                                    MaterialPageRoute(
                                    builder: (context) => KorisnikDetailsScreen(korisnik: pronadjeniKorisnik,)
                                    ),
                                    );

                                  } on Exception catch (e) {
                                    showDialog(context: context, builder: (BuildContext context) => 
                                        AlertDialog(
                                          title: const Text("Error"),
                                          content: Text("${e.toString()}"),
                                          actions: [
                                            TextButton(onPressed: ()=>{
                                              Navigator.pop(context),
                                            }, child: const Text("OK"))
                                          ],
                                        ));
                                  }


                                }, child: Text("Account details"),


                                ),

                                
                                ),

                                SizedBox(height: 80, width: 200, child: 
                                  ElevatedButton(onPressed: (){
                                    
                                    Navigator.of(context).push(
                                    MaterialPageRoute(
                                    builder: (context) => ProizvodListScreen()
                                    ),
                                    );
                                    
                                      
                                    }, child: Text("Go to Fan shop")),
                                  ),
                                
                              ],
                            )
                            
                          ],
                        ),
                      
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