// import 'dart:js_interop';

import 'package:afk_admin/models/platum.dart';
import 'package:afk_admin/models/search_result.dart';
import 'package:afk_admin/models/transakcijski_racun.dart';
import 'package:afk_admin/providers/korisnik_provider.dart';
import 'package:afk_admin/providers/platum_provider.dart';
import 'package:afk_admin/providers/transakcijski_racun_provider.dart';
import 'package:afk_admin/screens/plata_list_screen.dart';
import 'package:afk_admin/widgets/master_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

import 'package:afk_admin/providers/platum_provider.dart';
import 'package:afk_admin/providers/uloga_provider.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart' as dotenv;

import '../models/korisnik.dart';
import '../models/uloga.dart';

class PlatumDetailsScreen extends StatefulWidget {
Korisnik?korisnik;
  Platum? platum;

  PlatumDetailsScreen({this.platum, this.korisnik, super.key});

  @override
  State<PlatumDetailsScreen> createState() => _PlatumDetailsScreen();
}

class _PlatumDetailsScreen extends State<PlatumDetailsScreen> {

  final _formKey=GlobalKey<FormBuilderState>();

  Map<String,dynamic>_initialValue={};

  late PlatumProvider _platumProvider;
  SearchResult<Platum>? _platumResult;

  late TransakcijskiRacunProvider _transakcijskiRacunProvider;
  SearchResult<TransakcijskiRacun>? _transakcijskiRacunResult;

  late KorisnikProvider _korisnikProvider;
  SearchResult<Korisnik>? _korisnikResult;
 
  // bool isLoading=true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    DateTime dt=DateTime.now();
    final result = '${dt.year}-${dt.month}-${dt.day}';
    DateTime? preuzeti=widget.platum?.datumSlanja;
  _initialValue= {
    'plataId':widget.platum?.plataId.toString()??"0",
    'transakcijskiRacunId':widget.platum?.transakcijskiRacunId.toString()??"1",
    'stateMachine': widget.platum?.stateMachine??"creating", 
    'iznos':widget.platum?.iznos.toString(),
    
    // if(widget.platum!.datumSlanja!=null)
    // 'datumSlanja':DateFormat('yyyy-MM-dd').format(preuzeti!)??"nije odabran datum"
    // else
    'datumSlanja':widget.platum?.datumSlanja!.toIso8601String()??dt.toIso8601String()

  };

  _platumProvider=context.read<PlatumProvider>(); 
  _transakcijskiRacunProvider=context.read<TransakcijskiRacunProvider>();
  _korisnikProvider=context.read<KorisnikProvider>();

  initForm();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();

  }


  Future initForm()async{
      _transakcijskiRacunResult=await _transakcijskiRacunProvider.get();
      _platumResult=await _platumProvider.get();
      _korisnikResult=await _korisnikProvider.get();
      
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      title: 'Plata ID: ${widget.platum?.plataId}' ?? "Platum details",
      child: buildForm()
      );
  }

  String getKorisnickoIme(int id)
  {
    var pronadjeniKorisnik=_korisnikResult?.result.firstWhere((element) => element.korisnikId==id);
    // String? pronadjenoIme=_korisnikResult?.result.firstWhere((element) => element.korisnikId==id).korisnickoIme??"Nije pronađeno";
    String? pronadjenoIme="${pronadjeniKorisnik!.ime} ${pronadjeniKorisnik.prezime} - ${pronadjeniKorisnik.korisnickoIme}"??"Nije pronađeno";
    return pronadjenoIme;
  }

  FormBuilder buildForm() {
    return FormBuilder(
      key: _formKey,
      initialValue: _initialValue,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(children: [
            Expanded(
              child: FormBuilderTextField (
                decoration: const InputDecoration(labelText: "Plata ID"), 
                readOnly: true,
                name: 'plataId',
                
                    ),
            ),
          // Expanded(
          //   child: FormBuilderTextField (
          //       decoration: const InputDecoration(labelText: "Transakcijski Racun Id"), 
                
          //       name: 'transakcijskiRacunId',
                
          //   ),
          // ),  
           //od prije ID što radi
         
          Expanded(
              child: 
                FormBuilderDropdown(
                      name: 'transakcijskiRacunId',
                      decoration: const InputDecoration(labelText: 'Broj transakcijskog računa'),
                      items: 
                      List<DropdownMenuItem>.from(
                        _transakcijskiRacunResult?.result.map(
                          (e) => DropdownMenuItem(
                            value: e.transakcijskiRacunId.toString(),
                            child: Text("${getKorisnickoIme(e.korisnikId!)} - ${e.brojRacuna}"??"Nema broja"),
                            )).toList()??[]),

                      onChanged: (value) {
                        setState(() {
                          
                          print("Odabrani ${value}");
                        });
                      },
                      validator: (value) {
                        if (value == null) {
                          return 'Please enter the Transakcijski račun';
                        }
                        return null;
                      },
                    ),
                    ),
          
          Expanded(
            child: FormBuilderTextField (
                            decoration: const InputDecoration(labelText: "Status plate"), 
                readOnly: true,
                name: 'stateMachine',
                
            ),
          ),
          Expanded(
            child: FormBuilderTextField (
                            decoration: const InputDecoration(labelText: "Iznos"), 

                name: 'iznos',
                
            ),
          ),
          Expanded(
          
            child: FormBuilderTextField (
              
                decoration: const InputDecoration(labelText: "Datum Slanja"), 
                name: 'datumSlanja',
            
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the DatumSlanja';
                  }
                  return null;
                },
            ),
            
          ),

          ElevatedButton(onPressed: () async{
                _formKey.currentState?.saveAndValidate(focusOnInvalid: false);
                print(_formKey.currentState?.value);
                try{
                  if(widget.platum==null) {
                    await _platumProvider.insert(_formKey.currentState?.value);
                  } else {
                    await _platumProvider.update(widget.platum!.plataId!, _formKey.currentState?.value);
                  }
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      // builder: (context) => HomePage(naziv: username,),
                      builder: (context) => PlatumListScreen(),

                    ),
                            );
                } on Exception catch (err) {
                  showDialog(context: context, builder: (BuildContext context) => 
                          AlertDialog(
                            title: const Text("Error"),
                            content: Text(err.toString()),
                            actions: [
                              TextButton(onPressed: ()=>{
                                Navigator.pop(context),
                              }, child: const Text("OK"))
                            ],
                          ));
                }
              }, child: Text("Save")),

              ElevatedButton(onPressed: () async{
                // _formKey.currentState?.saveAndValidate();
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => PlatumListScreen(),
                  ),
                );
              }, child: Text("Sve plate")),

              ElevatedButton(onPressed: () async{
                // _formKey.currentState?.saveAndValidate();
                setState(() {
                  
                });
              }, child: Text("Osvježi podatke")),

              ElevatedButton(onPressed: () async{
                  showDialog(context: context, builder: (BuildContext context) => 
                AlertDialog(
                  title: const Text("Warning!!!"),
                  content: Text("Are you sure you want to delete Plata ${widget.platum!.plataId}?"),
                  actions: [
                    
                    TextButton(onPressed: () async =>{
                      
                      await _platumProvider.delete(widget.platum!.plataId!),

                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => PlatumListScreen(),
                        ),
                      )
                  

                    }, child: const Text("Yes")),
                    TextButton(onPressed: ()=>{
                      Navigator.pop(context),
                    }, child: const Text("No")),
          
                  ],
                ));
                        
                      }, child: Text("Izbriši")),
          ],
          ),
        ),
      
    );
  }
}