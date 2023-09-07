import 'package:afk_admin/models/platum.dart';
import 'package:afk_admin/models/search_result.dart';
import 'package:afk_admin/models/transakcijski_racun.dart';
import 'package:afk_admin/providers/platum_provider.dart';
import 'package:afk_admin/providers/pozicija_provider.dart';
import 'package:afk_admin/providers/transakcijski_racun_provider.dart';
import 'package:afk_admin/screens/pozicija_list_screen.dart';
import 'package:afk_admin/widgets/master_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

import 'package:afk_admin/providers/platum_provider.dart';
import 'package:afk_admin/providers/uloga_provider.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart' as dotenv;

import '../models/korisnik.dart';
import '../models/pozicija.dart';
import '../models/uloga.dart';

class PozicijaDetailsScreen extends StatefulWidget {
  Korisnik?korisnik;
  Pozicija? pozicija;

  PozicijaDetailsScreen({this.pozicija,this.korisnik, super.key});

  @override
  State<PozicijaDetailsScreen> createState() => _PozicijaDetailsScreen();
}

class _PozicijaDetailsScreen extends State<PozicijaDetailsScreen> {

  final _formKey=GlobalKey<FormBuilderState>();

  Map<String,dynamic>_initialValue={};

  late PozicijaProvider _pozicijaProvider;
  SearchResult<Pozicija>? _pozicijaResult;
  // bool isLoading=true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    DateTime dt=DateTime.now();
    final result = '${dt.year}-${dt.month}-${dt.day} (${dt.hour}:${dt.minute}:${dt.second}})';
  _initialValue= {
    'pozicijaId':widget.pozicija?.pozicijaId.toString()??"0",
    'nazivPozicije':widget.pozicija?.nazivPozicije??"---",
    'kategorijaPozicije': widget.pozicija?.kategorijaPozicije??"---", 
  };

    _pozicijaProvider=context.read<PozicijaProvider>(); 

  initForm();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();

  }


  Future initForm()async{
    _pozicijaResult=await _pozicijaProvider.get();
      
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      title: 'Pozicija ID: ${widget.pozicija?.pozicijaId}' ?? "Pozicija detalji",
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
                decoration: const InputDecoration(labelText: "Pozicija ID"), 

                name: 'pozicijaId',
                
                    ),
            ),
          Expanded(
            child: FormBuilderTextField (
                decoration: const InputDecoration(labelText: "Naziv pozicije"), 
                
                name: 'nazivPozicije',
            ),
          ),
          Expanded(
            child: FormBuilderTextField (
                            decoration: const InputDecoration(labelText: "Kategorija pozicije"), 

                name: 'kategorijaPozicije',
                
            ),
          ),
          
          ElevatedButton(onPressed: () async{
                _formKey.currentState?.saveAndValidate(focusOnInvalid: false);
                print(_formKey.currentState?.value);
                try{
                  if(widget.pozicija==null) {
                    await _pozicijaProvider.insert(_formKey.currentState?.value);
                  } else {
                    await _pozicijaProvider.update(widget.pozicija!.pozicijaId!, _formKey.currentState?.value);
                  }
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => PozicijaListScreen(),

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
                    builder: (context) => PozicijaListScreen(),
                  ),
                );
              }, child: Text("Sve pozicije")),

             ElevatedButton(onPressed: () async{
          showDialog(context: context, builder: (BuildContext context) => 
                    AlertDialog(
                      title: const Text("Warning!!!"),
                      content: Text("Are you sure you want to delete pozicija ${widget.pozicija!.pozicijaId}?"),
                      actions: [
                        
                        TextButton(onPressed: () async =>{
                          
                          await _pozicijaProvider.delete(widget.pozicija!.pozicijaId!),

                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => PozicijaListScreen(),
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