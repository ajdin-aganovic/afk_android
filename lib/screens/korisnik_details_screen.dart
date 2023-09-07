import 'package:afk_admin/models/korisnik.dart';
import 'package:afk_admin/models/search_result.dart';
import 'package:afk_admin/providers/korisnik_uloga_provider.dart';
import 'package:afk_admin/providers/platum_provider.dart';
import 'package:afk_admin/screens/bolest_list_screen.dart';
import 'package:afk_admin/screens/korisnici_editable_screen.dart';
import 'package:afk_admin/screens/korisnici_list_screen.dart';
import 'package:afk_admin/screens/korisnik_insert_screen.dart';
import 'package:afk_admin/widgets/master_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart' as dotenv;

import 'package:afk_admin/providers/korisnik_provider.dart';
import 'package:afk_admin/providers/uloga_provider.dart';
import 'package:afk_admin/screens/korisnik_details_screen.dart';
import 'package:provider/provider.dart';

import '../models/platum.dart';
import '../models/korisnik_uloga.dart';
import '../models/uloga.dart';
import '../utils/util.dart';
import 'home_screen.dart';

class KorisnikDetailsScreen extends StatefulWidget {

  Korisnik? korisnik;
  KorisnikUloga? korisnikUloga;
  String? usernameKorisnika;
  Uloga? uloga;
  int? korisnikId;

  KorisnikDetailsScreen({this.korisnik, this.korisnikId,this.usernameKorisnika, super.key});

  @override
  State<KorisnikDetailsScreen> createState() => _KorisnikDetailsScreen();
}

class _KorisnikDetailsScreen extends State<KorisnikDetailsScreen> {

  final _formKey=GlobalKey<FormBuilderState>();

  Map<String,dynamic>_initialValue={};

  late KorisnikProvider _korisnikProvider;
  

  SearchResult<Korisnik>? _korisnikResult;

   late KorisnikUlogaProvider _korisnikUlogaProvider;
  

  SearchResult<KorisnikUloga>? _korisnikUlogaResult;

  late UlogaProvider _ulogaProvider;
  

  SearchResult<Uloga>? _ulogaResult;

  Korisnik? pronadjeni;
 

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    
    
  // var pronadjeniKorisnik=_korisnikUlogaResult?.result.first;
  // var spremljenaUloga=_ulogaResult?.result.first;


  _initialValue= {
  'korisnikId' : widget.korisnik?.korisnikId.toString()??'nema zapisan',
  'ime':widget.korisnik?.ime??'nema zapisan',
  'prezime':widget.korisnik?.prezime??'nema zapisan',
  'korisnickoIme':widget.korisnik?.korisnickoIme??'nema zapisan',
  'email':widget.korisnik?.email??'nema zapisan',
  'lozinkaHash':widget.korisnik?.lozinkaHash??'nema zapisan',
  'lozinkaSalt':widget.korisnik?.lozinkaSalt??'nema zapisan',
  'password':widget.korisnik?.password??'nema zapisan',
  'passwordPotvrda':widget.korisnik?.passwordPotvrda??'nema zapisan',
  'strucnaSprema':widget.korisnik?.strucnaSprema??'nema zapisan',
  'datumRodjenja':widget.korisnik?.datumRodjenja.toString()??'nema zapisan',
  'podUgovorom':widget.korisnik?.podUgovorom.toString()??'nema zapisan',
  'podUgovoromOd':widget.korisnik?.podUgovoromOd.toString()??'nema zapisan',
  'podUgovoromDo':widget.korisnik?.podUgovoromDo.toString()??'nema zapisan',
  // 'uloga':spremljenaUloga?.nazivUloge??"Nema uloge",
  'uloga':widget.korisnik?.uloga??"Nema uloge"
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

      
  }

  @override
  Widget build(BuildContext context) {

    return MasterScreenWidget(
      // ignore: sort_child_properties_last
      title: 'Korisnički ID ${widget.korisnik?.korisnikId}' ?? "Detalji korisnika",
      child: 
        buildForm(),
       
      );
  }

  FormBuilder buildForm() {
    return 
    FormBuilder(
      key: _formKey,
      initialValue: _initialValue,
        child: 
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: 
          Column(children: [
            Expanded(
            child: FormBuilderTextField (
                decoration: const InputDecoration(labelText: "KorisnikID"), 
                readOnly: true,
                name: 'korisnikId',
                
            ),
          ),
          Expanded(
            child: FormBuilderTextField (
                decoration: const InputDecoration(labelText: "Ime"), 
                readOnly: true,
                name: 'ime',
                
            ),
          ),
          Expanded(
            child: FormBuilderTextField (
                            decoration: const InputDecoration(labelText: "Prezime"), 
                readOnly: true,

                name: 'prezime',
                
            ),
          ),
          Expanded(
            child: FormBuilderTextField (
                            decoration: const InputDecoration(labelText: "Korisničko ime"), 
                readOnly: true,

                name: 'korisnickoIme',
                
            ),
          ),
          Expanded(
            child: FormBuilderTextField (
                            decoration: const InputDecoration(labelText: "Email"), 
                readOnly: true,

                name: 'email',
                
            ),
          ),
          Expanded(
            child: FormBuilderTextField (
                            decoration: const InputDecoration(labelText: "Stručna sprema"), 
                readOnly: true,

                name: 'strucnaSprema',
                
            ),
          ),
          Expanded(
            child: FormBuilderTextField (
                            decoration: const InputDecoration(labelText: "Datum rođenja"), 
                readOnly: true,

                name: 'datumRodjenja',
                
            ),
          ),
          Expanded(
            child: FormBuilderTextField (
                            decoration: const InputDecoration(labelText: "Pod ugovorom"), 
                readOnly: true,

                name: 'podUgovorom',
                
            ),
          ),
          Expanded(
            child: FormBuilderTextField (
                            decoration: const InputDecoration(labelText: "Pod ugovorm od"), 
                readOnly: true,

                name: 'podUgovoromOd',
                
            ),
          ),
          Expanded(
            child: FormBuilderTextField (
                            decoration: const InputDecoration(labelText: "Pod ugovorom do"), 
                readOnly: true,

                name: 'podUgovoromDo',
                
            ),
          ),

          Expanded(
            child: FormBuilderTextField (
                            decoration: const InputDecoration(labelText: "Uloga"), 
                readOnly: true,

                name: 'uloga',
                
            ),
          ),
          
          
            Row(
              children: [
                Column(
                  children: [
                    ElevatedButton(onPressed: () async{
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            
                            builder: (context) => KorisniciEditableScreen(),
                          ),
                        );
                      }, child: Text("Svi korisnici")),
                  ],
                ),

                  Column(
                    children: [
                      ElevatedButton(onPressed: () async{
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            
                            builder: (context) => HomePage(),
                          ),
                        );
                      }, child: Text("Home page")),
                    ],
                  ),
              ],
            ),
              
          ],
        ),
      ),
          
      
        
    
    );
           
    
  }

FormBuilder zaboravljenPassword() {
  return FormBuilder(child: 
  Text("Dob"));
  }
}