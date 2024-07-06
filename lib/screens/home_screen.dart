import 'package:afk_android/main.dart';
import 'package:afk_android/screens/korisnik_details_screen.dart';
import 'package:afk_android/screens/proizvod_list_screen.dart';

import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:afk_android/providers/korisnik_provider.dart';
import 'package:afk_android/utils/util.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/korisnik.dart';
import '../models/search_result.dart';

class HomePage extends StatefulWidget {
  final Korisnik? loggovaniUser;
  const HomePage({this.loggovaniUser, super.key});

  @override
  State<HomePage> createState() => _HomePage();
}

class _HomePage extends State<HomePage>{
  
  final _formKey=GlobalKey<FormBuilderState>();
   final ScrollController _horizontal = ScrollController(),
      _vertical = ScrollController();
  
final Map<String,dynamic>_initialValue={};

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
    super.didChangeDependencies();

  }

    Future initForm()async{
      _korisnikResult=await _korisnikProvider.get(filter: 
      {
        'KorisnickoIme':Authorization.username
      });

  }


  @override
  Widget build(BuildContext context) {
   return 
    SizedBox(
      height: 500,
    width: 600,
      child: 
      Scaffold(
        appBar: AppBar(
          title: const Text("Početna"),),
          body: Center(
            child: 
            Scrollbar(
              controller: _horizontal,
              thumbVisibility: true,
              trackVisibility: true,
              notificationPredicate: (notif) => notif.depth == 1,
              child: Scrollbar(
                controller: _vertical,
                thumbVisibility: true,
                trackVisibility: true,
                child: SingleChildScrollView(
                  controller: _horizontal,
                  scrollDirection: Axis.horizontal,
                  child: SingleChildScrollView(
                    controller: _vertical,
                    scrollDirection: Axis.vertical,

              child: Container(
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
                                const SizedBox(height: 12,),
                                const Text('Aplikacija Fudbalskog Kluba',
                                style: TextStyle(fontSize: 30),), 
                                const SizedBox(height: 12,),
                                Text('Dobrodošli ${Authorization.username}',
                                style: const TextStyle(fontSize: 30),),
                                const SizedBox(height: 24,),
                                
                              Row(
                                children: [
                                  Row(
                                    
                                    children: [
                                      SizedBox(height: 80, width: 200, child: 
                                      
                                      ElevatedButton(onPressed: (){
                                      
                                     Navigator.of(context).pushAndRemoveUntil<void>
                                        (
                                        
                                        MaterialPageRoute<void>
                                        (builder: (BuildContext context) => 
                                        LoginPage()),
                                        ModalRoute.withName('/Korisnik'),
                                          // MaterialPageRoute(
                                          //   builder: (context) => LoginPage(),
                                          // ),
                                        );
                                      },child: const Text("Odjavi se"),
                                      ),
                                      ),
                                    ],
                                  ),
              
              
                                  Row(
                                    children: [
                                      SizedBox(height: 80, width: 200, child: 
                                      ElevatedButton(onPressed: (){
                                      
                                      Navigator.of(context).push(
                                      MaterialPageRoute(
                                      builder: (context) => ProizvodListScreen()
                                      ),
                                      );
                                      
                                       
                                      }, child: const Text("Idi na Katalog")),
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
                                    
                                      print("${pronadjeniKorisnik.korisnickoIme}");
                                       Navigator.of(context).push(
                                      MaterialPageRoute(
                                      builder: (context) => KorisnikDetailsScreen(korisnik: pronadjeniKorisnik,)
                                      ),
                                      );
              
                                    } on Exception catch (e) {
                                      showDialog(context: context, builder: (BuildContext context) => 
                                          AlertDialog(
                                            title: const Text("Greška"),
                                            content: Text(e.toString()),
                                            actions: [
                                              TextButton(onPressed: ()=>{
                                                Navigator.pop(context),
                                              }, child: const Text("OK"))
                                            ],
                                          ));
                                    }
                                  }, child: const Text("Detalji o računu"),
                                  ),
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
              ),
            ),
          ),
      ),
    );
  }

}