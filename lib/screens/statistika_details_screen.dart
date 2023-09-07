import 'package:afk_admin/models/platum.dart';
import 'package:afk_admin/models/search_result.dart';
import 'package:afk_admin/models/transakcijski_racun.dart';
import 'package:afk_admin/providers/platum_provider.dart';
import 'package:afk_admin/providers/statistika_provider.dart';
import 'package:afk_admin/providers/transakcijski_racun_provider.dart';
import 'package:afk_admin/screens/statistika_list_screen.dart';
import 'package:afk_admin/widgets/master_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

import 'package:afk_admin/providers/platum_provider.dart';
import 'package:afk_admin/providers/uloga_provider.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart' as dotenv;

import '../models/korisnik.dart';
import '../models/statistika.dart';
import '../models/uloga.dart';
import '../providers/korisnik_provider.dart';

class StatistikaDetailsScreen extends StatefulWidget {
  Korisnik?korisnik;
  Statistika? statistika;

  StatistikaDetailsScreen({this.statistika,this.korisnik, super.key});

  @override
  State<StatistikaDetailsScreen> createState() => _StatistikaDetailsScreen();
}

class _StatistikaDetailsScreen extends State<StatistikaDetailsScreen> {

  final _formKey=GlobalKey<FormBuilderState>();

  Map<String,dynamic>_initialValue={};

  late StatistikaProvider _statistikaProvider;
  SearchResult<Statistika>? _statistikaResult;

  late KorisnikProvider _korisnikProvider;
  SearchResult<Korisnik>? _korisnikResult;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    DateTime dt=DateTime.now();
    final result = '${dt.year}-${dt.month}-${dt.day} (${dt.hour}:${dt.minute}:${dt.second}})';
  _initialValue= {
    'statistikaId':widget.statistika?.statistikaId.toString()??"0",
    'korisnikId':widget.statistika?.korisnikId.toString()??"2",
    'golovi':widget.statistika?.golovi.toString()??"0",
    'asistencije':widget.statistika?.asistencije.toString()??"0",
    'igracMjeseca':widget.statistika?.igracMjeseca??true,
    'bezPrimGola':widget.statistika?.bezPrimGola.toString()??"0",
    'zutiKartoni':widget.statistika?.zutiKartoni.toString()??"0",
    'crveniKartoni':widget.statistika?.crveniKartoni.toString()??"0",
    'prosjecnaOcjena':widget.statistika?.prosjecnaOcjena.toString()??"0",
    'ocjenaZadUtak':widget.statistika?.ocjenaZadUtak.toString()??"0",
    
  };

    _statistikaProvider=context.read<StatistikaProvider>(); 
_korisnikProvider=context.read<KorisnikProvider>(); 

  initForm();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();

  }


  Future initForm()async{
    _statistikaResult=await _statistikaProvider.get();
      _korisnikResult=await _korisnikProvider.get();
      
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
      title: 'Statistika ID: ${widget.statistika?.statistikaId}' ?? "Statistika detalji",
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
                // readOnly: true,
                decoration: const InputDecoration(labelText: "Statistika ID"), 

                name: 'statistikaId',
                
                    ),
            ),
          // Expanded(
          //   child: FormBuilderTextField (
          //       decoration: const InputDecoration(labelText: "Korisnik ID"), 
                
          //       name: 'korisnikId',
          //   ),
          // ),
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
          Expanded(
            child: FormBuilderTextField (
                            decoration: const InputDecoration(labelText: "Golovi"), 

                name: 'golovi',
                
            ),
          ),
          Expanded(
            child: FormBuilderTextField (
                decoration: const InputDecoration(labelText: "Asistencije"), 
                name: 'asistencije',
            ),
          ),

          Expanded(
            child:
            FormBuilderDropdown(
              name: 'igracMjeseca',
              decoration: InputDecoration(labelText: 'Igrač mjeseca'),
              items: const[ 
                DropdownMenuItem(value: true, child: Text('Yes'),), 
                DropdownMenuItem(value: false, child: Text('No'),), 
              ],
              onChanged: (value) {
                setState(() {
                  widget.korisnik?.podUgovorom = value!;
                });
              },
              validator: (value) {
                if (value == null) {
                  return 'Please enter the igracMjeseca';
                }
                return null;
              },
            ),
          ),

          Expanded(
            child: FormBuilderTextField (
                decoration: const InputDecoration(labelText: "Bez primljenog gola"), 
                name: 'bezPrimGola',
            ),
          ),

          Expanded(
            child: FormBuilderTextField (
                decoration: const InputDecoration(labelText: "Žuti kartoni"), 
                name: 'zutiKartoni',
            ),
          ),

          Expanded(
            child: FormBuilderTextField (
                decoration: const InputDecoration(labelText: "Crveni kartoni"), 
                name: 'crveniKartoni',
            ),
          ),

          Expanded(
            child: FormBuilderTextField (
                decoration: const InputDecoration(labelText: "Prosječna ocjena"), 
                name: 'prosjecnaOcjena',
            ),
          ),

          Expanded(
            child: FormBuilderTextField (
                decoration: const InputDecoration(labelText: "Ocjena zadnje utakmice"), 
                name: 'ocjenaZadUtak',
            ),
          ),
          
          ElevatedButton(onPressed: () async{
                _formKey.currentState?.saveAndValidate(focusOnInvalid: false);
                print(_formKey.currentState?.value);
                try{
                  if(widget.statistika==null) {
                    await _statistikaProvider.insert(_formKey.currentState?.value);
                  } else {
                    await _statistikaProvider.update(widget.statistika!.statistikaId!, _formKey.currentState?.value);
                  }
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => StatistikaListScreen(),

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
                    builder: (context) => StatistikaListScreen(),
                  ),
                );
              }, child: Text("Sve statistike")),

              ElevatedButton(onPressed: () async{
                // _formKey.currentState?.saveAndValidate();
                setState(() {
                  
                });
              }, child: Text("Refresh podataka")),
              ElevatedButton(onPressed: () async{
                  showDialog(context: context, builder: (BuildContext context) => 
                            AlertDialog(
                              title: const Text("Warning!!!"),
                              content: Text("Are you sure you want to delete statistika ${widget.statistika!.statistikaId} from ${widget.statistika!.korisnikId}?"),
                              actions: [
                                
                                TextButton(onPressed: () async =>{
                                  
                                  await _statistikaProvider.delete(widget.statistika!.statistikaId!),

                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => StatistikaListScreen(),
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