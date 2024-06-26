
import 'package:afk_android/models/search_result.dart';
import 'package:afk_android/providers/proizvod_provider.dart';
import 'package:afk_android/screens/proizvod_list_screen.dart';
import 'package:afk_android/utils/util.dart';
import 'package:afk_android/widgets/master_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

import 'package:provider/provider.dart';

import '../models/korisnik.dart';
import '../models/proizvod.dart';

class ProizvodEditableScreen extends StatefulWidget {
  Korisnik?korisnik;
  Proizvod? proizvod;

  ProizvodEditableScreen({this.proizvod,this.korisnik, super.key});

  @override
  State<ProizvodEditableScreen> createState() => _ProizvodEditableScreen();
}

class _ProizvodEditableScreen extends State<ProizvodEditableScreen> {

  final _formKey=GlobalKey<FormBuilderState>();

  Map<String,dynamic>_initialValue={};

  late ProizvodProvider _proizvodProvider;
  SearchResult<Proizvod>? _proizvodResult;
  // bool isLoading=true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  _initialValue= {
    'proizvodId':widget.proizvod?.proizvodId.toString()??"0",
    'naziv':widget.proizvod?.naziv??"---",
    'sifra': widget.proizvod?.sifra??"---", 
    'kategorija': widget.proizvod?.kategorija??"---", 
    'cijena': widget.proizvod?.cijena.toString()??"---", 
    'kolicina': widget.proizvod?.kolicina.toString()??"---", 
    'stateMachine':widget.proizvod?.stateMachine??"draft",
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
                              decoration: const InputDecoration(labelText: 'Kategorija proizvoda'),
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

          Expanded(
            child: FormBuilderTextField (
                            decoration: const InputDecoration(labelText: "Status proizvoda"), 

                name: 'stateMachine',
                
            ),
          ),
          
          Row(
            children: [
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
                  }, child: const Text("Save")),
                  
                  ElevatedButton(onPressed: () async{
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => ProizvodListScreen(),
                      ),
                    );
                  }, child: const Text("Svi proizvodi")),
            ],
          ),

             Row(
               children: [
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
                            
                          }, child: const Text("Izbriši")),
                 
                          
                      ElevatedButton(onPressed: () async{
                        showDialog(context: context, builder: (BuildContext context) => 
                        AlertDialog(
                          title: const Text("Uspješna operacija!!!"),
                          content: Text("Aktivirali/Zaključali ste proizvod ${widget.proizvod!.proizvodId}?"),
                          actions: [
                            TextButton(onPressed: () async =>{

                               if(Authorization.ulogaKorisnika=="Administrator"&&widget.proizvod!.stateMachine!.contains("active"))
                            {
                              // Navigator.of(context).push(
                              //       MaterialPageRoute(builder: (context)=> InsertScreen(korisnik: e,)
                              //       )
                              //   ) 
                             await _proizvodProvider.hidePlatum(widget.proizvod!.proizvodId!),
                              showDialog(context: context, builder: (BuildContext context) => 
                                  AlertDialog(
                                    title: const Text("Successful operation!"),
                                    content: const Text("Proizvod je zatvoren"),
                                    actions: [
                                      TextButton(onPressed: ()=>{
                                        Navigator.of(context).push(
                                            MaterialPageRoute(builder: (context)=> ProizvodListScreen()
                                            )
                                        ) 
                                      }, child: const Text("OK"))
                                    ],
                                  )),
                            }
                            else if(Authorization.ulogaKorisnika=="Administrator"&&widget.proizvod!.stateMachine!.contains("draft"))
                            {
                               await _proizvodProvider.activatePlatum(widget.proizvod!.proizvodId!),
                              showDialog(context: context, builder: (BuildContext context) => 
                                  AlertDialog(
                                    title: const Text("Successful operation!"),
                                    content: const Text("Proizvod je otvoren"),
                                    actions: [
                                      TextButton(onPressed: ()=>{
                                        Navigator.of(context).push(
                                            MaterialPageRoute(builder: (context)=> ProizvodListScreen()
                                            )
                                        ) 
                                      }, child: const Text("OK"))
                                    ],
                                  )),
                            }
                            else
                            {
                              showDialog(context: context, builder: (BuildContext context) => 
                                  AlertDialog(
                                    title: const Text("Warning!"),
                                    content: const Text("Unauthorized call of a function.\nYou do not have the permission!"),
                                    actions: [
                                      TextButton(onPressed: ()=>{
                                        Navigator.pop(context),
                                      }, child: const Text("OK"))
                                    ],
                                  )),
                            }

                            }, child: const Text("Yes")),
                              TextButton(onPressed: ()=>{
                              Navigator.pop(context),
                            }, child: const Text("No")),
                  
                          ],
                        ));
                      }, child: const Text("Aktiviraj/Zaključaj proizvod")),
               ],
             ),
          ],
          ),
        ),
      
    );
  }
}