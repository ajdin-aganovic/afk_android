import 'package:afk_admin/models/search_result.dart';
import 'package:afk_admin/providers/korisnik_provider.dart';
import 'package:afk_admin/screens/igrac_vise_detalja_screen.dart';
import 'package:afk_admin/screens/korisnik_details_screen.dart';
import 'package:afk_admin/screens/korisnik_insert_screen.dart';
import 'package:afk_admin/utils/util.dart';
import 'package:afk_admin/widgets/master_screen.dart';
// import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart' as dotenv;

import '../models/korisnik.dart';
import '../models/korisnik_pozicija.dart';
import '../models/pozicija.dart';
import '../providers/korisnik_pozicija_provider.dart';
import '../providers/pozicija_provider.dart';

class ListaIgracaScreen extends StatefulWidget {
  // Korisnik? korisnik;
  // Authorization? noviObjekt;
  ListaIgracaScreen({super.key});

  @override
  State<ListaIgracaScreen> createState() => _ListaIgracaScreen();
}

class _ListaIgracaScreen extends State<ListaIgracaScreen> {
  late KorisnikProvider _korisniciProvider;
  SearchResult<Korisnik>? result;
  SearchResult<Korisnik>? _korisnikResult;
  late KorisnikProvider _korisnikProvider;


  SearchResult<Pozicija>? _pozicijaResult;
  late PozicijaProvider _pozicijaProvider;

  late KorisnikPozicijaProvider _korisnikPozicijaProvider;
  SearchResult<KorisnikPozicija>? _korisnikPozicijaResult;
   
  final TextEditingController _fullNameSearch=TextEditingController();
  final TextEditingController _podUgovorom=TextEditingController();
  final TextEditingController _korisnickoIme=TextEditingController();
  final TextEditingController _uloga=TextEditingController();

  final ScrollController _horizontal = ScrollController(),
      _vertical = ScrollController();

 
  @override void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    _korisnikPozicijaProvider=context.read<KorisnikPozicijaProvider>();
    _korisniciProvider=context.read<KorisnikProvider>();
    _pozicijaProvider=context.read<PozicijaProvider>();
    initForm();
    
  }
Future initForm()async{
      _korisnikPozicijaResult=await _korisnikPozicijaProvider.get();
      _korisnikResult=await _korisnikProvider.get();
      _pozicijaResult=await _pozicijaProvider.get();
  }

   String getKorisnikDetails(int id)
  {
    var pronadjeniRacun=_korisnikResult?.result.firstWhere((element) => element.korisnikId==id);
    String? pronadjeniBrojRacuna="${pronadjeniRacun?.ime} ${pronadjeniRacun?.prezime}"??"Nije pronađen";
    return pronadjeniBrojRacuna;
  }

  String? getPozicijaDetails(int id)
  {
    var getPozicijaDetails=_pozicijaResult?.result.firstWhere((element) => element.pozicijaId==id);
    String ime="${getPozicijaDetails?.nazivPozicije} ${getPozicijaDetails?.kategorijaPozicije}"??"Nije pronađeno";
    return ime;
  }



  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      title_widget: const Text("Lista igrača po pozicijama"),
      child: Container(
        child: Column(children: [
          _buildSearch(),
          _buildDataListView(),
          
        ElevatedButton(onPressed: (){
        Navigator.of(context).push(
        MaterialPageRoute(
        builder: (context) => ViseDetaljaScreen(korisnikPozicija: null,)
        ),
          );
          }, child: Text("Add new KorisnikPozicija")),
        ],
        ),

        
      )
    );
  }

  Widget _buildSearch(){
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: 
      Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
                    Expanded(
                      child: 
                        TextField(
                            decoration: const InputDecoration(labelText: "Pretraga po korisničkom imenu"), 
                            controller:_korisnickoIme,
                          ),
                    ),
              
              const SizedBox(
                height: 8,
              ),
              Expanded(child:
                    
                          TextField(
                            decoration: const InputDecoration(labelText: "Pretraga po stručnoj spremi"), 
                            controller:_fullNameSearch
                          ),
                    
                    ),
              const SizedBox(
                height: 8,
              ),
              Expanded(child:
                    
                          TextField(
                            decoration: const InputDecoration(labelText: "Pretraga po ulozi"), 
                            controller:_uloga
                          ),
                    
                    ),
              const SizedBox(
                height: 8,
              ),
              ElevatedButton(onPressed:() async{
                  // print("logout successful");
                  
                  // var data=await _korisniciProvider.get(filter: {
                  //   'StrucnaSprema':_fullNameSearch.text,
                  //   'KorisnickoIme':_korisnickoIme.text,
                  //   'Uloga':_uloga.text
                  // }
                  // );

                  var data=await _korisnikPozicijaProvider.get();
          
                  setState(() {
                    _korisnikPozicijaResult=data;
                  });
          
                  print("data: successfully loaded");
          
          
                }, child: const Text("Load data")),
      ],
        ),
    
      );
  }

  
  // String? ime;
  // String? prezime;
  // String? email;
  // String? lozinka;
  // String? strucnaSprema;
  // DateTime? datumRodjenja;
  // bool? podUgovorom;
  // DateTime? podUgovoromOd;
  // DateTime? podUgovoromDo;
  // String? korisnickoIme;

  Widget _buildDataListView() {
    
    return 
    SizedBox(
    height: 500,
    width: 1500,
    child: 
        Scrollbar(
          controller: _vertical,
          thumbVisibility: true,
          trackVisibility: true,
          child: Scrollbar(
            controller: _horizontal,
            thumbVisibility: true,
            trackVisibility: true,
            notificationPredicate: (notif) => notif.depth == 1,
            child: SingleChildScrollView(
              controller: _vertical,
              scrollDirection: Axis.vertical,
              child: SingleChildScrollView(
                controller: _horizontal,
                scrollDirection: Axis.horizontal,
                child: DataTable(
                    columns: const [
                DataColumn(label: Expanded(
                        child: Text("KorPozID",
                        style: TextStyle(fontStyle: FontStyle.italic),),
                        
                        ),
                        ),

                        DataColumn(label: Expanded(
                        child: Text("Ime i prezime igrača",
                        style: TextStyle(fontStyle: FontStyle.italic),),
                        ),
                        ),

                        DataColumn(label: Expanded(
                        child: Text("Pozicija / kategorija",
                        style: TextStyle(fontStyle: FontStyle.italic),),
                        ),
                        ),

                        DataColumn(label: Expanded(
                        child: Text("Uredi",
                        style: TextStyle(fontStyle: FontStyle.italic),
                        ),
                        
                        ),
                        ),
                        

                  ],

                  rows: 
                    _korisnikPozicijaResult?.result.map((KorisnikPozicija e) => DataRow(
                      onSelectChanged: (yxc)=>{
                            showDialog(context: context, builder: (BuildContext context) => 
                              AlertDialog(
                                title: Text("You have chosen KorisnikPozicijaID ${e.korisnikPozicijaId}"),
                                content: Text("Ime i prezime: ${getKorisnikDetails(e.korisnikId!)}\nPozicija: ${getPozicijaDetails(e.pozicijaId!)}}"),
                                actions: [
                                  TextButton(onPressed: ()=>{
                                    Navigator.pop(context),
                                  }, child: const Text("OK"))
                                ],
                              )),
                            print("${e.korisnikPozicijaId} ${e.korisnikId} ${e.pozicijaId}")
                      },
                      cells: [
                      DataCell(Text(e.korisnikPozicijaId.toString()??"not set")),
                      DataCell(Text(getKorisnikDetails(e.korisnikId!)??"not set")),
                      DataCell(Text(getPozicijaDetails(e.pozicijaId!)??"not set")),
                      DataCell(const Text("Edit"), onTap: () => {
                        if(Authorization.ulogaKorisnika=="Administrator")
                        {
                          Navigator.of(context).push(
                                MaterialPageRoute(builder: (context)=> ViseDetaljaScreen(korisnikPozicija: e,)
                                )
                            ) 
                        }
                        else
                        {
                          showDialog(context: context, builder: (BuildContext context) => 
                              AlertDialog(
                                title: Text("Warning!"),
                                content: Text("Unauthorized call of a function.\nYou do not have the permission!"),
                                actions: [
                                  TextButton(onPressed: ()=>{
                                    Navigator.pop(context),
                                  }, child: const Text("OK"))
                                ],
                              )),
                        }
                      })

                      ]
                    )).toList()??[]
                  
                  ),
                
                  ),
                  
              ),
              
            ),
          // ),
        ),
                  
    );
    
  }
}

