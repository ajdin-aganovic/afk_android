import 'package:afk_admin/models/bolest.dart';
import 'package:afk_admin/models/korisnik.dart';
import 'package:afk_admin/models/search_result.dart';
import 'package:afk_admin/models/transakcijski_racun.dart';
import 'package:afk_admin/providers/bolest_provider.dart';
import 'package:afk_admin/providers/transakcijski_racun_provider.dart';
import 'package:afk_admin/screens/bolest_list_screen.dart';
import 'package:afk_admin/widgets/master_screen.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart' as dotenv;
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

import 'package:provider/provider.dart';

import '../providers/korisnik_provider.dart';


class BolestDetailsScreen extends StatefulWidget {

  Bolest? bolest;
  Korisnik?korisnik;

  BolestDetailsScreen({this.bolest, this.korisnik, super.key});

  @override
  State<BolestDetailsScreen> createState() => _BolestDetailsScreen();
}

class _BolestDetailsScreen extends State<BolestDetailsScreen> {

  final _formKey=GlobalKey<FormBuilderState>();

  Map<String,dynamic>_initialValue={};

  late BolestProvider _bolestProvider;
  late KorisnikProvider _korisnikProvider;

  SearchResult<Bolest>? _bolestResult;
  SearchResult<Korisnik>? _korisnikResult;
 
  bool isLoading=true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  _initialValue= {
    'bolestId':widget.bolest?.bolestId.toString(),
    'sifraPovrede':widget.bolest?.sifraPovrede,
    'tipPovrede':widget.bolest?.tipPovrede,
    'trajanjePovredeDani':widget.bolest?.trajanjePovredeDani.toString(),
    
  };

  _bolestProvider=context.read<BolestProvider>(); 
  _korisnikProvider=context.read<KorisnikProvider>();

  initForm();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();

  }


  Future initForm()async{
      _korisnikResult=await _korisnikProvider.get();
      _bolestResult=await _bolestProvider.get();
      // print(_BolestResult);
      // print(_transakcijskiRacunResult);

      // setState(() {
      //   isLoading=false;
      // });
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      title: 'Bolest ID: ${widget.bolest?.bolestId}' ?? "Bolest details",
      // child: 
      // Column(
      //   children: [
      //     buildForm(),
      //     Row(
      //       children:[
      //         ElevatedButton(onPressed: () async{
      //           _formKey.currentState?.saveAndValidate();
      //           print(_formKey.currentState?.value);
      //           try{
      //             if(widget.bolest==null) {
      //               await _bolestProvider.insert(_formKey.currentState?.value);
      //             } else {
      //               await _bolestProvider.update(widget.bolest!.bolestId!, _formKey.currentState?.value);
      //             }

      //           } on Exception catch (err) {
      //             showDialog(context: context, builder: (BuildContext context) => 
      //                     AlertDialog(
      //                       title: const Text("Error"),
      //                       content: Text(err.toString()),
      //                       actions: [
      //                         TextButton(onPressed: ()=>{
      //                           Navigator.pop(context),
      //                         }, child: const Text("OK"))
      //                       ],
      //                     ));
      //           }
      //         }, child: Text("Save"))
      //       ]
      //     )
      //   ],
      // )
      child:
       buildForm(),
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
                decoration: const InputDecoration(labelText: "Bolest ID"), 

                name: 'bolestId',
                
                    ),
            ),
          // Expanded(
          //   child: FormBuilderTextField (
          //                   decoration: const InputDecoration(labelText: "Transakcijski Racun Id"), 
                
          //       name: 'transakcijskiRacunId',
                
          //   ),
          // ),   //od prije ID što radi
          
          Expanded(
            child: FormBuilderTextField (
                decoration: const InputDecoration(labelText: "Šifra povrede"), 

                name: 'sifraPovrede',
                
            ),
          ),
          Expanded(
            child: FormBuilderTextField (
              decoration: const InputDecoration(labelText: "Tip povrede"), 

                name: 'tipPovrede',
                
            ),
          ),
          Expanded(
            child: FormBuilderTextField (
              decoration: const InputDecoration(labelText: "Trajanje povrede (dani)"), 

                name: 'trajanjePovredeDani',
                
            ),
          ),
          Row(
            children: [
              ElevatedButton(onPressed: () async{
                _formKey.currentState?.saveAndValidate(focusOnInvalid: false);
                print(_formKey.currentState?.value);
                try{
                  if(widget.bolest==null) {
                    await _bolestProvider.insert(_formKey.currentState?.value);
                  } else {
                    await _bolestProvider.update(widget.bolest!.bolestId!, _formKey.currentState?.value);
                  }
                 Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => BolestListScreen(),

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
                    builder: (context) => BolestListScreen(),
                  ),
                );
              }, child: Text("Sve bolesti")),

             ElevatedButton(onPressed: () async{
                  showDialog(context: context, builder: (BuildContext context) => 
                    AlertDialog(
                      title: const Text("Warning!!!"),
                      content: Text("Are you sure you want to delete bolest ${widget.bolest!.bolestId}?"),
                      actions: [
                        
                        TextButton(onPressed: () async =>{
                          
                          await _bolestProvider.delete(widget.bolest!.bolestId!),

                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => BolestListScreen(),
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
          )
          
          ],
          ),
        ),
      
    );
  }
}