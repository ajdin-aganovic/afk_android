import 'dart:math';

import 'package:afk_admin/screens/korisnici_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart' as dotenv;
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'dart:convert';

import '../models/korisnik.dart';
import '../models/search_result.dart';
import '../providers/korisnik_provider.dart';

import 'dart:typed_data';
import 'package:crypto/crypto.dart';

import 'package:afk_admin/models/search_result.dart';
import 'package:afk_admin/widgets/master_screen.dart';
import 'package:intl/intl.dart';

import '../models/korisnik.dart';
import '../models/termin.dart';
import '../models/uloga.dart';
import '../utils/util.dart';


class PasswordAdmin extends StatefulWidget {
  Korisnik? korisnik;

  PasswordAdmin({this.korisnik, super.key});
  @override
  _PasswordAdmin createState() => _PasswordAdmin();
}

class _PasswordAdmin extends State<PasswordAdmin> {

  final _formKey = GlobalKey<FormBuilderState>(); 
  final _lozinkaController = TextEditingController();
  final _lozinkaProvjeraController = TextEditingController();
  Map<String,dynamic>_initialValue={};
final ScrollController _vertical = ScrollController();
  late KorisnikProvider _korisnikProvider;
  

  SearchResult<Korisnik>? _korisnikResult;

 @override
  void initState()
  {
     super.initState();
     String defaultDate;
    if(DateTime.now().month<10&&DateTime.now().day<10)
      defaultDate="${DateTime.now().year}-0${DateTime.now().month}-0${DateTime.now().day}";
    else if(DateTime.now().day<10)
      defaultDate="${DateTime.now().year}-${DateTime.now().month}-0${DateTime.now().day}";
    else if(DateTime.now().month<10)
      defaultDate="${DateTime.now().year}-0${DateTime.now().month}-${DateTime.now().day}";
    else
      defaultDate="${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}";
    
    var korisnikHash=widget.korisnik?.lozinkaHash.toString();
    var korisnikSalt=widget.korisnik?.lozinkaSalt.toString();
    
     _initialValue={
      'korisnikId':widget.korisnik?.korisnikId.toString()??'nema zapisan',
      'ime':widget.korisnik?.ime??'nema zapisan',
      'prezime':widget.korisnik?.prezime??'nema zapisan',
      'email':widget.korisnik?.email.toString()??'nema zapisan',
      'password':widget.korisnik?.lozinkaHash.toString()??'nema zapisan',
      'passwordPotvrda':widget.korisnik?.lozinkaSalt.toString()??'nema zapisan',
      'strucnaSprema':widget.korisnik?.strucnaSprema.toString()??"No option",
      'datumRodjenja':DateFormat('yyyy-MM-dd').format(widget.korisnik!.datumRodjenja!)??defaultDate,
      'podUgovorom':widget.korisnik?.podUgovorom??true,
      'podUgovoromOd':DateFormat('yyyy-MM-dd').format(widget.korisnik!.podUgovoromOd!)??defaultDate,
      'podUgovoromDo':DateFormat('yyyy-MM-dd').format(widget.korisnik!.podUgovoromDo!)??defaultDate,
      'uloga':widget.korisnik?.uloga.toString()??"Bez uloge",
      'korisnickoIme':widget.korisnik?.korisnickoIme.toString()??'nema zapisan',
      
    };
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
      // print(_korisnikResult);
  }

  FormBuilder buildForm()
  {
    return 
    FormBuilder(
      key: _formKey,
      initialValue: _initialValue,
      
        child: 

        Padding(
          padding: const EdgeInsets.all(10.0),
          
          child: 
           SizedBox(
            height: 800,
            width: 900,
            
               child: 
               Column(children: [
                    
                    Text('Promjena passworda',
                    style: TextStyle(fontSize: 30),), 
                    SizedBox(height: 12,),
                    // Text('Dobrodošli ${widget.loggovaniUser?.korisnickoIme??"nazad"}',
                    Text('za korisnika - ${widget.korisnik?.korisnickoIme??"Nije proslijeđeno"}',
                    
                    // Text('Dobrodošli ${widget.korisnik?.korisnickoIme}',
                    style: TextStyle(fontSize: 30),),

                    //  Expanded(
                    //     child: FormBuilderTextField (
                    //       // readOnly: true,
                    //       decoration: const InputDecoration(labelText: "Korisnik ID"), 
                    //       readOnly: true,
                    //       name: 'korisnikId',
                          
                    //           ),
                    //   ),
                           
                    // Expanded(
                    //   child: FormBuilderTextField (
                    //       decoration: const InputDecoration(labelText: "Ime", hintText:'Unesi ime',), 
                    //       readOnly: true,
                          
                    //       name: 'ime',
                    //   ),
                    // ),   
                    // Expanded(
                    //   child: FormBuilderTextField (
                    //                   decoration: const InputDecoration(labelText: "Prezime", 
                    //                   hintText:'Unesi prezime',), 
                    //       readOnly: true,
                           
                    //       name: 'prezime',
                          
                    //   ),
                    // ),
                           
                    // Expanded(
                    //   child: FormBuilderTextField (
                    //       decoration: const InputDecoration(labelText: "Korisničko ime",
                    //       hintText:'Unesi korisničko ime',), 
                    //       name: 'korisnickoIme',
                    //       readOnly: true,

                    //   ),
                    // ),
                           
                    // Expanded(
                    //   child: FormBuilderTextField (
                    //       decoration: const InputDecoration(labelText: "Email"
                    //       , hintText:'Unesi email',), 
                    //       name: 'email',
                    //       readOnly: true,

                    //   ),
                    // ),
                            
                    Expanded(
                      child: FormBuilderTextField (
                        controller: _lozinkaController,
                          decoration: const InputDecoration(labelText: "Lozinka"), 
                          obscureText: true,
                          name: 'password',
                      ),
                    ),
                           
                    Expanded(
                      child: FormBuilderTextField (
                        controller: _lozinkaProvjeraController,
                          decoration: const InputDecoration(labelText: "Potvrdi lozinku"), 
                          obscureText: true,
                          name: 'passwordPotvrda',
                          validator: (value) {
                                if (value != _lozinkaController.text) {
                                  return 'Passwords do not match';
                                }
                                return null;
                              },
                      ),
                    ),
                           
                    // Expanded(
                    //   child: FormBuilderTextField (
                    //       decoration: const InputDecoration(labelText: "Stručna sprema"), 
                    //       name: 'strucnaSprema',
                    //       readOnly: true,

                    //   ),
                    // ),
                           
                    // Expanded(
                    //   child: FormBuilderTextField (
                    //       decoration: const InputDecoration(labelText: "Datum rođenja"), 
                    //       name: 'datumRodjenja',
                    //       readOnly: true,

                    //   ),
                    // ),
                           
                    // Expanded(
                    //   child:
                    //   FormBuilderDropdown(
                    //           name: 'podUgovorom',
                    //           decoration: InputDecoration(labelText: 'Pod ugovorom'),
                    //           items: const[ 
                    //             DropdownMenuItem(value: true, child: Text('Yes'),), 
                    //             DropdownMenuItem(value: false, child: Text('No'),), 
                    //           ],
                    //           onChanged: (value) {
                    //             setState(() {
                    //               widget.korisnik?.podUgovorom = value!;
                    //             });
                    //           },
                    //           validator: (value) {
                    //             if (value == null) {
                    //               return 'Please enter the Pod ugovorom';
                    //             }
                    //             return null;
                    //           },
                    //         ),
                    // ),
                           
                    // Expanded(
                    //   child: FormBuilderTextField (
                    //       decoration: const InputDecoration(labelText: "Pod ugovorom od"), 
                    //       name: 'podUgovoromOd',
                    //       readOnly: true,

                    //   ),
                    // ),
                           
                    // Expanded(
                    //   child: FormBuilderTextField (
                    //       decoration: const InputDecoration(labelText: "Pod ugovorom do"), 
                    //       name: 'podUgovoromDo',
                    //       readOnly: true,

                    //   ),
                    // ),
                           
                    // Expanded(
                    //   child: FormBuilderTextField (
                    //       decoration: const InputDecoration(labelText: "Uloga"), 
                    //       name: 'uloga',
                    //       readOnly: true,

                    //   ),
                    // ),
                           
                    Expanded(child: 
                    Row(children: [

                     ElevatedButton(onPressed: () async{


                        if (_lozinkaController.text!=null&&_lozinkaController.text!="") {
                                String generateSalt() {
                                        final random = Random.secure();
                                        final List<int> saltBytes = List<int>.generate(16, (_) => random.nextInt(256));
                                        return base64Encode(saltBytes);
                                        }
                                    
                                String generateHash(String password, String salt) {
                                // final salt=generateSalt();
                                final src = base64.decode(salt);
                                final bytes = utf8.encode(password);
                                final dst = Uint8List(src.length + bytes.length);
                                                    
                                dst.setAll(0, src);
                                dst.setAll(src.length, bytes);
                                                    
                                final algorithm = sha1;
                                final inArray = algorithm.convert(dst).bytes;
                                return base64.encode(inArray);
                                                      }
                                    
                                  String lozinkaOdozgo=_lozinkaController.text;
                                  String novaSalt=generateSalt();
                                  String novaHash=generateHash(lozinkaOdozgo, novaSalt);
                                  _formKey.currentState?.saveAndValidate(focusOnInvalid: false);

                                  print(_formKey.currentState?.value);
                                  print("${novaHash}");
                                  
                                
                                    
                                  try{
                                    
                                    await _korisnikProvider.changePassword(widget.korisnik!.korisnikId!, _formKey.currentState?.value);
                                    
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        // builder: (context) => HomePage(naziv: username,),
                                        builder: (context) => KorisniciListScreen(),
                                  
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
                              }
                            else
                            {
                              showDialog(context: context, builder: (BuildContext context) => 
                                            AlertDialog(
                                              title: const Text("Error"),
                                              content: Text("Enter a password"),
                                              actions: [
                                                TextButton(onPressed: ()=>{
                                                  Navigator.pop(context),
                                                }, child: const Text("OK"))
                                              ],
                                            ));
                            }
                        }, child: Text("Save new password")),
                      
                    ],))
                    
                    ],
                    
                 
               
             ),
           ),
            
          
        ),
      
    );
  }

  @override
  Widget build(BuildContext context) {
  
    return 
    
    MasterScreenWidget(
      title: 'Insert new korisnik',
      child: 
       buildForm()
      
      );
  }

 

  Future<void> changePassword(Korisnik korisnik) async {
  final url = Uri.parse('https://localhost:7181/Korisnik/passwordChange/${korisnik.korisnikId}');

  final response = await http.post(
    url,
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode(korisnik.toJson()),
  );

  if (response.statusCode > 199 && response.statusCode<300) {
    // Insert operation successful
    print('Change password successful: ${response.body} ${response.statusCode}');
  } else {
    // Insert operation failed
    print('Change password failed: ${response.body} ${response.statusCode}');
  }
}

}