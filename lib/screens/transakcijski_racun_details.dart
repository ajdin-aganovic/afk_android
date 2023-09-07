import 'package:afk_admin/models/platum.dart';
import 'package:afk_admin/models/search_result.dart';
import 'package:afk_admin/models/transakcijski_racun.dart';
import 'package:afk_admin/providers/platum_provider.dart';
import 'package:afk_admin/providers/transakcijski_racun_provider.dart';
import 'package:afk_admin/screens/transakcijski_racun_list_screen.dart';
import 'package:afk_admin/widgets/master_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart' as dotenv;

import 'package:afk_admin/providers/platum_provider.dart';
import 'package:afk_admin/providers/uloga_provider.dart';
import 'package:provider/provider.dart';

import '../models/korisnik.dart';
import '../models/uloga.dart';
import '../providers/korisnik_provider.dart';

class TransakcijskiRacunDetailsScreen extends StatefulWidget {

  Korisnik?korisnik;
  TransakcijskiRacun?transakcijskiRacun;

  TransakcijskiRacunDetailsScreen({this.transakcijskiRacun, this.korisnik, super.key});

  @override
  State<TransakcijskiRacunDetailsScreen> createState() => _TransakcijskiRacunDetailsScreen();
}

class _TransakcijskiRacunDetailsScreen extends State<TransakcijskiRacunDetailsScreen> {

  final _formKey=GlobalKey<FormBuilderState>();

  Map<String,dynamic>_initialValue={};

  late PlatumProvider _platumProvider;
  SearchResult<Platum>? _platumResult;
  
  late TransakcijskiRacunProvider _transakcijskiRacunProvider;
  SearchResult<TransakcijskiRacun>? _transakcijskiRacunResult;


  late KorisnikProvider _korisnikProvider;
  SearchResult<Korisnik>? _korisnikResult;
 
  bool isLoading=true;

  @override
  void initState() {  
    // TODO: implement initState
    super.initState();
  _initialValue= {
    'transakcijskiRacunId':widget.transakcijskiRacun?.transakcijskiRacunId.toString()??"0",
    'brojRacuna':widget.transakcijskiRacun?.brojRacuna??"---",
    'adresaPrebivalista': widget.transakcijskiRacun?.adresaPrebivalista??"---", 
    'nazivBanke':widget.transakcijskiRacun?.nazivBanke??"---",
    'korisnikId':widget.transakcijskiRacun?.korisnikId.toString()??"2",
  };

  _transakcijskiRacunProvider=context.read<TransakcijskiRacunProvider>();
  _korisnikProvider=context.read<KorisnikProvider>(); 

  initForm();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

  }


  Future initForm()async{
      _transakcijskiRacunResult=await _transakcijskiRacunProvider.get();
      _korisnikResult=await _korisnikProvider.get();

      // _platumResult=await _platumProvider.get();
  }

  String getKorisnickoIme(int id)
  {
    var pronadjeniKorisnik=_korisnikResult?.result.firstWhere((element) => element.korisnikId==id);
    // String? pronadjenoIme=_korisnikResult?.result.firstWhere((element) => element.korisnikId==id).korisnickoIme??"Nije pronađeno";
    String? pronadjenoIme="${pronadjeniKorisnik!.ime} ${pronadjeniKorisnik.prezime} - ${pronadjeniKorisnik.korisnickoIme}"??"Nije pronađeno";
    return pronadjenoIme;
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      title: 'Broj računa: ${widget.transakcijskiRacun?.brojRacuna}' ?? "Detalji računa",
      child: buildForm()
      );
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
                decoration: const InputDecoration(labelText: "Transakcijski račun ID"), 

                name: 'transakcijskiRacunId',
                
                    ),
            ),
          Expanded(
            child: FormBuilderTextField (
                            decoration: const InputDecoration(labelText: "Broj računa"), 
                
                name: 'brojRacuna',
                onChanged:(value) => {
                },
                
            ),
          ),   //od prije ID što radi
          
          Expanded(
            child: FormBuilderTextField (
                            decoration: const InputDecoration(labelText: "Adresa prebivališta"), 

                name: 'adresaPrebivalista',
                onChanged:(value) => {
                },
                
            ),
          ),
          Expanded(
            child: FormBuilderTextField (
                            decoration: const InputDecoration(labelText: "Naziv banke"), 
                  onChanged:(value) => {
                },
                name: 'nazivBanke',
                
            ),
          ),

          Expanded(
              child: 
                FormBuilderDropdown(
                      name: 'korisnikId',
                      decoration: const InputDecoration(labelText: 'Korisnik'),
                      items: 
                      List<DropdownMenuItem>.from(
                        _korisnikResult?.result.map(
                          (e) => DropdownMenuItem(
                            value: e.korisnikId.toString(),
                            child: Text("${e.ime} ${e.prezime} / ${e.korisnickoIme}"??"Nema imena"),
                            )).toList()??[]),

                      onChanged: (value) {
                        setState(() {
                          
                          print("Odabrani ${value}");
                        });
                      },
                      validator: (value) {
                        if (value == null) {
                          return 'Please enter the Korisnik';
                        }
                        return null;
                      },
                    ),
                    ),

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(onPressed: () async{
                  _formKey.currentState?.saveAndValidate(focusOnInvalid: false);
                  // print(_formKey.currentState?.value);
                  //individualno pristupanje vrijednostima iz forme 
                  print(_formKey.currentState?.value['nazivBanke']);
                  print(_formKey.currentState?.value['brojRacuna']);
                  print(_formKey.currentState?.value['adresaPrebivalista']);

                  try{
                    if(widget.transakcijskiRacun==null) {
                      await _transakcijskiRacunProvider.insert(_formKey.currentState?.value);
                    } else {
                      await _transakcijskiRacunProvider.update(widget.transakcijskiRacun!.transakcijskiRacunId!, _formKey.currentState?.value);
                    }
                Navigator.of(context).push(
                    MaterialPageRoute(
                      // builder: (context) => HomePage(naziv: username,),
                      builder: (context) => TransakcijskiRacunListScreen(),

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
                
          ),
          ElevatedButton(onPressed: () async{
                // _formKey.currentState?.saveAndValidate();
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => TransakcijskiRacunListScreen(),
                  ),
                );
              }, child: Text("Svi transakcijski računi")),

              ElevatedButton(onPressed: () async{
                        setState(() { });
                      }, child: Text("Refresh podataka")),

              ElevatedButton(onPressed: () async{
                  showDialog(context: context, builder: (BuildContext context) => 
            AlertDialog(
              title: const Text("Warning!!!"),
              content: Text("Are you sure you want to delete TRačun ${widget.transakcijskiRacun!.transakcijskiRacunId}?"),
              actions: [
                
                TextButton(onPressed: () async =>{
                  
                  await _transakcijskiRacunProvider.delete(widget.transakcijskiRacun!.transakcijskiRacunId!),

                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => TransakcijskiRacunListScreen(),
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