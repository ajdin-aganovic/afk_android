import 'package:afk_admin/models/platum.dart';
import 'package:afk_admin/models/search_result.dart';
import 'package:afk_admin/models/transakcijski_racun.dart';
import 'package:afk_admin/providers/platum_provider.dart';
import 'package:afk_admin/providers/transakcijski_racun_provider.dart';
import 'package:afk_admin/providers/trening_provider.dart';
import 'package:afk_admin/screens/trening_list_screen.dart';
import 'package:afk_admin/widgets/master_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

import 'package:afk_admin/providers/platum_provider.dart';
import 'package:afk_admin/providers/uloga_provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart' as dotenv;
import 'package:provider/provider.dart';

import '../models/korisnik.dart';
import '../models/trening.dart';
import '../models/uloga.dart';

class TreningDetailsScreen extends StatefulWidget {

  Trening? trening;
  Korisnik?korisnik;

  TreningDetailsScreen({this.trening, this.korisnik, super.key});

  @override
  State<TreningDetailsScreen> createState() => _TreningDetailsScreen();
}

class _TreningDetailsScreen extends State<TreningDetailsScreen> {

  final _formKey=GlobalKey<FormBuilderState>();

  Map<String,dynamic>_initialValue={};

  SearchResult<Trening>? _treningResult;


  late TreningProvider _treningProvider;

  @override
  void initState() {
    super.initState();
    var godina=DateTime.now().year;
    var mjesec=DateTime.now().month;
    var dan=DateTime.now().day;
  _initialValue= {
    'treningId':widget.trening?.treningId.toString()??"0",
    'nazivTreninga':widget.trening?.nazivTreninga??"---",
    'tipTreninga': widget.trening?.tipTreninga??"---", 
    'datumTreninga':widget.trening?.datumTreninga.toString()??DateTime(godina, mjesec, dan).toString(),
  };

  _treningProvider=context.read<TreningProvider>();

  initForm();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

  }


  Future initForm()async{
      _treningResult=await _treningProvider.get();
    
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      title: 'Trening ID: ${widget.trening?.treningId}' ?? "Trening detalji",
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
                decoration: const InputDecoration(labelText: "Trening ID"), 

                name: 'treningId',
                
                    ),
            ),
          Expanded(
            child: FormBuilderTextField (
                            decoration: const InputDecoration(labelText: "Naziv treninga"), 
                
                name: 'nazivTreninga',
                
            ),
          ),   
          Expanded(
            child: FormBuilderTextField (
                            decoration: const InputDecoration(labelText: "Tip treninga"), 

                name: 'tipTreninga',
                
            ),
          ),
          // Expanded(
          //   child: FormBuilderTextField (
          //                   decoration: const InputDecoration(labelText: "Datum treninga"), 

          //       name: 'datumTreninga',
                
          //   ),
          // ),
          
          ElevatedButton(onPressed: () async{
                _formKey.currentState?.saveAndValidate(focusOnInvalid: false);
                print(_formKey.currentState?.value);
                try{
                  if(widget.trening==null) {
                    await _treningProvider.insert(_formKey.currentState?.value);
                  } else {
                    await _treningProvider.update(widget.trening!.treningId!, _formKey.currentState?.value);
                  }
Navigator.of(context).push(
                    MaterialPageRoute(
                      // builder: (context) => HomePage(naziv: username,),
                      builder: (context) => TreningListScreen(),

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
                    builder: (context) => TreningListScreen(),
                  ),
                );
              }, child: Text("Svi treninzi")),
              ElevatedButton(onPressed: () async{
                  showDialog(context: context, builder: (BuildContext context) => 
                AlertDialog(
                  title: const Text("Warning!!!"),
                  content: Text("Are you sure you want to delete trening ${widget.trening!.treningId}?"),
                  actions: [
                    
                    TextButton(onPressed: () async =>{
                      
                      await _treningProvider.delete(widget.trening!.treningId!),

                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => TreningListScreen(),
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