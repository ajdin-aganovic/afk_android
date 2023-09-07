import 'dart:math';

import 'package:afk_admin/screens/korisnici_editable_screen.dart';
import 'package:afk_admin/screens/korisnici_list_screen.dart';
import 'package:afk_admin/screens/password_reset_admin.dart';
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
import '../providers/uloga_provider.dart';


class DodajScreen extends StatefulWidget {
  Korisnik? korisnik;

  DodajScreen(
    // int? korisnikId, 
    {this.korisnik, super.key});
  @override
  _DodajScreenState createState() => _DodajScreenState();
}

class _DodajScreenState extends State<DodajScreen> {

  final _formKey = GlobalKey<FormBuilderState>();
  final _lozinkaController = TextEditingController();
  final _lozinkaProvjeraController = TextEditingController();
  final _datumRodjenjaController = TextEditingController();
  final _podUgovoromOdController = TextEditingController();
  final _podUgovoromDoController = TextEditingController();
  
  Map<String,dynamic>_initialValue={};
final ScrollController _vertical = ScrollController();

  late KorisnikProvider _korisnikProvider;
  SearchResult<Korisnik>? _korisnikResult;

  late UlogaProvider _ulogaProvider;
  SearchResult<Uloga>? _ulogaResult;
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
      'korisnikId':"0",
      // 'ime':widget.korisnik?.ime??'nema zapisan',
      // 'prezime':widget.korisnik?.prezime??'nema zapisan',
      // 'email':widget.korisnik?.email.toString()??'nema zapisan',
      // 'password':widget.korisnik?.lozinkaHash.toString()??'nema zapisan',
      // 'passwordPotvrda':widget.korisnik?.lozinkaSalt.toString()??'nema zapisan',
      // 'strucnaSprema':widget.korisnik?.strucnaSprema.toString()??"No option",
      'datumRodjenja':defaultDate,
      'podUgovorom':true,
      'podUgovoromOd':defaultDate,
      'podUgovoromDo':defaultDate,
      // 'uloga':widget.korisnik?.uloga.toString()??"Bez uloge",
      // 'korisnickoIme':widget.korisnik?.korisnickoIme.toString()??'nema zapisan',
      
    };
    _korisnikProvider=context.read<KorisnikProvider>();
    _ulogaProvider=context.read<UlogaProvider>();
    
  initForm();

  }

 @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();

  }

  Future initForm()async{
      _korisnikResult=await _korisnikProvider.get();
      _ulogaResult=await _ulogaProvider.get();
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
                      Expanded(
                        child: FormBuilderTextField (
                          // readOnly: true,
                          decoration: const InputDecoration(labelText: "Korisnik ID"), 
                          
                          name: 'korisnikId',
                          
                          
                              ),
                              
                      ),
                           
                    Expanded(
                      child: FormBuilderTextField (
                          decoration: const InputDecoration(labelText: "Ime", hintText:'Unesi ime',), 
                          
                          name: 'ime',
                      ),
                    ),   
                    Expanded(
                      child: FormBuilderTextField (
                                      decoration: const InputDecoration(labelText: "Prezime", 
                                      hintText:'Unesi prezime',), 
                           
                          name: 'prezime',
                          
                      ),
                    ),
                           
                    Expanded(
                      child: FormBuilderTextField (
                          decoration: const InputDecoration(labelText: "Korisničko ime",
                          hintText:'Unesi korisničko ime',), 
                          name: 'korisnickoIme',
                      ),
                    ),
                           
                    Expanded(
                      child: FormBuilderTextField (
                          decoration: const InputDecoration(labelText: "Email"
                          , hintText:'Unesi email',), 
                          name: 'email',
                          validator: (value) {
                            if(value==null)
                            {
                              return 'Please enter the email';
                            }
                            return null;
                          },
                      ),
                    ),

                    Expanded(
                      child: FormBuilderTextField (
                        controller: _lozinkaController,
                          decoration: const InputDecoration(labelText: "Password"
                          , hintText:'Unesi password',), 
                          name: 'password',
                          obscureText: true,

                      ),
                    ),

                    Expanded(
                      child: FormBuilderTextField (
                        controller: _lozinkaProvjeraController,
                          decoration: const InputDecoration(labelText: "Potvrdi password"
                          , hintText:'Potvrdite password',), 
                          name: 'passwordPotvrda',
                          obscureText: true,
                          validator: (value) {
                            if(value!=_lozinkaController.text)
                            {
                              return 'Please enter the same password';
                            }
                            return null;
                          },
                      ),
                      
                    ),
                           
                    Expanded(
                      child:
                      FormBuilderDropdown(
                              name: 'strucnaSprema',
                              decoration: InputDecoration(labelText: 'Stručna sprema'),
                              items: const[ 
                                DropdownMenuItem(value: 'SSS', child: Text('SSS'),), 
                                DropdownMenuItem(value: 'VSS', child: Text('VSS'),), 
                                DropdownMenuItem(value: 'BA', child: Text('BA'),), 
                                DropdownMenuItem(value: 'MA', child: Text('MA'),), 
                                DropdownMenuItem(value: 'No option', child: Text('No option'),), 
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
                          decoration: const InputDecoration(labelText: "Datum rođenja"), 
                          onTap: () => {
                            showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime(1950,1,1), lastDate:DateTime(2003,1,1))
                          },
                          name: 'datumRodjenja',
                      ),
                    ),

                    // Expanded(
                    //   child: FormBuilderDateTimePicker (
                    //         controller: _datumRodjenjaController,
                    //         name: 'datumRodjenja',
                    //         inputType: InputType.date,
                    //         format: DateFormat('yyyy-MM-dd'),
                    //         enabled: true,
                    //         decoration:const InputDecoration(
                    //             labelText: 'Datum rođenja',
                    //                           ),
                    //         onChanged:(value) => {
                    //           // _formKey.currentState!.value=value;
                    //         },
                    //                   ),
                    // ),
                           
                    Expanded(
                      child:
                      FormBuilderDropdown(
                        
                              name: 'podUgovorom',
                              decoration: InputDecoration(labelText: 'Pod ugovorom'),
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
                                  return 'Please enter the Pod ugovorom';
                                }
                                return null;
                              },
                            ),
                    ),
                           
                    Expanded(
                      child: FormBuilderTextField (
                          decoration: const InputDecoration(labelText: "Pod ugovorom od"), 
                          name: 'podUgovoromOd',
                      ),
                    ),
                           
                    Expanded(
                      child: FormBuilderTextField (
                          decoration: const InputDecoration(labelText: "Pod ugovorom do"), 
                          name: 'podUgovoromDo',
                      ),
                    ),

                    //  Expanded(
                    //   child: FormBuilderDateTimePicker (
                    //         controller: _podUgovoromOdController,
                    //         name: 'podUgovoromOd',
                    //         inputType: InputType.date,
                    //         format: DateFormat('yyyy-MM-dd'),
                    //         enabled: true,
                    //         decoration:const InputDecoration(
                    //             labelText: 'Pod ugovorom od',
                    //                           ),
                    //         onChanged:(value) => {
                    //           // _formKey.currentState!.value=value;
                    //         },
                    //                   ),
                    // ),

                    //  Expanded(
                    //   child: FormBuilderDateTimePicker (
                    //         controller: _podUgovoromDoController,
                    //         name: 'podUgovoromDo',
                    //         inputType: InputType.date,
                    //         format: DateFormat('yyyy-MM-dd'),
                    //         enabled: true,
                    //         decoration:const InputDecoration(
                    //             labelText: 'Pod ugovorom do',
                    //                           ),
                    //         onChanged:(value) => {
                    //           // _formKey.currentState!.value=value;
                    //         },
                    //                   ),
                    // ),

                    Expanded(
              child: 
                FormBuilderDropdown(
                      name: 'uloga',
                      decoration: const InputDecoration(labelText: 'Uloga'),
                      items: 
                      List<DropdownMenuItem>.from(
                        _ulogaResult?.result.map(
                          (e) => DropdownMenuItem(
                            value: e.nazivUloge.toString(),
                            child: Text("${e.nazivUloge} ${e.podtipUloge}"??"Nema imena"),
                            )).toList()??[]),

                      onChanged: (value) {
                        setState(() {
                          
                          print("Odabrana ${value}");
                        });
                      },
                      validator: (value) {
                        if (value == null) {
                          return 'Please enter the Uloga';
                        }
                        return null;
                      },
                    ),
                    ),

             
                    Expanded(child: 
                    Row(children: [
             
                    ElevatedButton(onPressed: () async{
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
                          // print("${novaHash}");
                          
                            
                            
                          // if(_formKey.currentState!.saveAndValidate())
                          // {
                          //   final selectedDate =
                          //     _formKey.currentState?.fields['datumRodjenja']?.value;
                          // // final formattedDate =
                          // //     DateFormat('yyyy-MM-dd').format(selectedDate!);
                          // // print('Selected Date: $formattedDate');
                          // }
                          // if(_formKey.currentState!.saveAndValidate())
                          // {
                          //   final selectedDate =
                          //     _formKey.currentState?.fields['podUgovoromOd']?.value;
                          // // final formattedDate =
                          // //     DateFormat('yyyy-MM-dd').format(selectedDate!);
                          // // print('Selected Date: $formattedDate');
                          // }
                          // if(_formKey.currentState!.saveAndValidate())
                          // {
                          //   final selectedDate =
                          //     _formKey.currentState?.fields['podUgovoromDo']?.value;
                          // // final formattedDate =
                          // //     DateFormat('yyyy-MM-dd').format(selectedDate!);
                          // // print('Selected Date: $formattedDate');
                          // }

                          await _korisnikProvider.insert(_formKey.currentState?.value);
                            
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                // builder: (context) => HomePage(naziv: username,),
                                builder: (context) => KorisniciEditableScreen(),

                              ),
                            );
                        }, child: Text("Save")),



                        ElevatedButton(onPressed: () async{
                        // _formKey.currentState?.saveAndValidate();
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => KorisniciEditableScreen(),
                          ),
                        );
                      }, child: Text("Svi korisnici")),
                    
                      ElevatedButton(onPressed: () async{
                        setState(() { });
                      }, child: Text("Refresh podataka")),

             
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

}