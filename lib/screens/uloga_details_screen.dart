import 'package:afk_admin/models/platum.dart';
import 'package:afk_admin/models/search_result.dart';
import 'package:afk_admin/models/transakcijski_racun.dart';
import 'package:afk_admin/providers/platum_provider.dart';
import 'package:afk_admin/providers/uloga_provider.dart';
import 'package:afk_admin/providers/transakcijski_racun_provider.dart';
import 'package:afk_admin/screens/uloga_list_screen.dart';
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
import '../models/uloga.dart';

class UlogaDetailsScreen extends StatefulWidget {
  Korisnik?korisnik;
  Uloga? uloga;

  UlogaDetailsScreen({this.uloga,this.korisnik, super.key});

  @override
  State<UlogaDetailsScreen> createState() => _UlogaDetailsScreen();
}

class _UlogaDetailsScreen extends State<UlogaDetailsScreen> {

  final _formKey=GlobalKey<FormBuilderState>();

  Map<String,dynamic>_initialValue={};

  late UlogaProvider _ulogaProvider;
  SearchResult<Uloga>? _ulogaResult;
  // bool isLoading=true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    DateTime dt=DateTime.now();
    final result = '${dt.year}-${dt.month}-${dt.day} (${dt.hour}:${dt.minute}:${dt.second}})';
  _initialValue= {
    'ulogaId':widget.uloga?.ulogaId.toString()??"0",
    'nazivUloge':widget.uloga?.nazivUloge??"---",
    'podtipUloge': widget.uloga?.podtipUloge??"---",
  };

    _ulogaProvider=context.read<UlogaProvider>(); 

  initForm();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();

  }


  Future initForm()async{
    _ulogaResult=await _ulogaProvider.get();
      
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      title: 'Uloga ID: ${widget.uloga?.ulogaId}' ?? "Uloga detalji",
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
                decoration: const InputDecoration(labelText: "Uloga ID"), 

                name: 'ulogaId',
                
                    ),
            ),
          Expanded(
            child: FormBuilderTextField (
                decoration: const InputDecoration(labelText: "Naziv uloge"), 
                
                name: 'nazivUloge',
            ),
          ), 
          Expanded(
            child: FormBuilderTextField (
                            decoration: const InputDecoration(labelText: "Podtip uloge"), 

                name: 'podtipUloge',
                
            ),
          ),
          
          ElevatedButton(onPressed: () async{
                _formKey.currentState?.saveAndValidate(focusOnInvalid: false);
                print(_formKey.currentState?.value);
                try{
                  if(widget.uloga==null) {
                    await _ulogaProvider.insert(_formKey.currentState?.value);
                  } else {
                    await _ulogaProvider.update(widget.uloga!.ulogaId!, _formKey.currentState?.value);
                  }
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => UlogaListScreen(),

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
                    builder: (context) => UlogaListScreen(),
                  ),
                );
              }, child: Text("Sve uloge")),
              ElevatedButton(onPressed: () async{
                  showDialog(context: context, builder: (BuildContext context) => 
            AlertDialog(
              title: const Text("Warning!!!"),
              content: Text("Are you sure you want to delete uloga ${widget.uloga!.ulogaId}?"),
              actions: [
                
                TextButton(onPressed: () async =>{
                  
                  await _ulogaProvider.delete(widget.uloga!.ulogaId!),

                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => UlogaListScreen(),
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