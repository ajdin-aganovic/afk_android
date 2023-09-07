import 'package:afk_admin/models/platum.dart';
import 'package:afk_admin/models/search_result.dart';
import 'package:afk_admin/models/transakcijski_racun.dart';
import 'package:afk_admin/providers/platum_provider.dart';
import 'package:afk_admin/providers/proizvod_provider.dart';
import 'package:afk_admin/providers/transakcijski_racun_provider.dart';
import 'package:afk_admin/screens/proizvod_list_screen.dart';
import 'package:afk_admin/widgets/master_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

import 'package:afk_admin/providers/platum_provider.dart';
import 'package:afk_admin/providers/uloga_provider.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart' as dotenv;

import '../models/korisnik.dart';
import '../models/proizvod.dart';
import '../models/uloga.dart';

class ProizvodDetailsScreen extends StatefulWidget {
  Korisnik?korisnik;
  Proizvod? proizvod;

  ProizvodDetailsScreen({this.proizvod,this.korisnik, super.key});

  @override
  State<ProizvodDetailsScreen> createState() => _ProizvodDetailsScreen();
}

class _ProizvodDetailsScreen extends State<ProizvodDetailsScreen> {

  final _formKey=GlobalKey<FormBuilderState>();

  Map<String,dynamic>_initialValue={};

  late ProizvodProvider _proizvodProvider;
  SearchResult<Proizvod>? _proizvodResult;
  // bool isLoading=true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    DateTime dt=DateTime.now();
    final result = '${dt.year}-${dt.month}-${dt.day} (${dt.hour}:${dt.minute}:${dt.second}})';
  _initialValue= {
    'proizvodId':widget.proizvod?.proizvodId.toString()??"0",
    'naziv':widget.proizvod?.naziv??"---",
    'sifra': widget.proizvod?.sifra??"---", 
    'kategorija': widget.proizvod?.kategorija??"---", 
    'cijena': widget.proizvod?.cijena.toString()??"---", 
    'kolicina': widget.proizvod?.kolicina.toString()??"---", 
  };

    _proizvodProvider=context.read<ProizvodProvider>(); 

  initForm();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();

  }


  Future initForm()async{
    _proizvodResult=await _proizvodProvider.get();
      
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      title: 'Proizvod ID: ${widget.proizvod?.proizvodId}' ?? "Proizvod detalji",
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
                decoration: const InputDecoration(labelText: "Proizvod ID"), 

                name: 'proizvodId',
                
                    ),
            ),
          Expanded(
            child: FormBuilderTextField (
                decoration: const InputDecoration(labelText: "Naziv proizvoda"), 
                
                name: 'naziv',
            ),
          ),
          Expanded(
            child: FormBuilderTextField (
                            decoration: const InputDecoration(labelText: "Sifra proizvoda"), 

                name: 'sifra',
                
            ),
          ),
          Expanded(
                      child:
                      FormBuilderDropdown(
                              name: 'kategorija',
                              decoration: InputDecoration(labelText: 'Kategorija proizvoda'),
                              items: const[ 
                                DropdownMenuItem(value: 'Dresovi', child: Text('Dresovi'),), 
                                DropdownMenuItem(value: 'Dukserice', child: Text('Dukserice'),), 
                                DropdownMenuItem(value: 'Dodaci', child: Text('Dodaci'),), 
                                DropdownMenuItem(value: 'Pribor', child: Text('Pribor'),), 
                                DropdownMenuItem(value: 'Razno', child: Text('Razno'),), 
                              ],
                              onChanged: (value) {
                                setState(() {
                                  widget.korisnik?.strucnaSprema = value!.toString();
                                });
                              },
                              validator: (value) {
                                if (value == null) {
                                  return 'Please enter the Stručna sprema';
                                }
                                return null;
                              },
                            ),
                    ),
          Expanded(
            child: FormBuilderTextField (
                            decoration: const InputDecoration(labelText: "Cijena proizvoda"), 

                name: 'cijena',
                
            ),
          ),
          Expanded(
            child: FormBuilderTextField (
                            decoration: const InputDecoration(labelText: "Kolicina proizvoda"), 

                name: 'kolicina',
                
            ),
          ),
          
          ElevatedButton(onPressed: () async{
                _formKey.currentState?.saveAndValidate(focusOnInvalid: false);
                print(_formKey.currentState?.value);
                try{
                  if(widget.proizvod==null) {
                    await _proizvodProvider.insert(_formKey.currentState?.value);
                  } else {
                    await _proizvodProvider.update(widget.proizvod!.proizvodId!, _formKey.currentState?.value);
                  }
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => ProizvodListScreen(),

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
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => ProizvodListScreen(),
                  ),
                );
              }, child: Text("Svi proizvodi")),

             ElevatedButton(onPressed: () async{
          showDialog(context: context, builder: (BuildContext context) => 
                    AlertDialog(
                      title: const Text("Warning!!!"),
                      content: Text("Are you sure you want to delete proizvod ${widget.proizvod!.proizvodId}?"),
                      actions: [
                        
                        TextButton(onPressed: () async =>{
                          
                          await _proizvodProvider.delete(widget.proizvod!.proizvodId!),

                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => ProizvodListScreen(),
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