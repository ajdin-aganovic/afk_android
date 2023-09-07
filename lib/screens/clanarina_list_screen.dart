import 'package:afk_admin/models/search_result.dart';
import 'package:afk_admin/providers/platum_provider.dart';
import 'package:afk_admin/providers/clanarina_provider.dart';
import 'package:afk_admin/screens/plata_details_screen.dart';
import 'package:afk_admin/screens/clanarina_details_screen.dart';
import 'package:afk_admin/widgets/master_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart' as dotenv;

import '../models/korisnik.dart';
import '../models/platum.dart';
import '../models/clanarina.dart';
import '../providers/korisnik_provider.dart';
import '../providers/transakcijski_racun_provider.dart';
import '../utils/util.dart';

class ClanarinaListScreen extends StatefulWidget {
  Korisnik?korisnik;
  ClanarinaListScreen({this.korisnik, super.key});

  @override
  State<ClanarinaListScreen> createState() => _ClanarinaListScreen();
}

class _ClanarinaListScreen extends State<ClanarinaListScreen> {
  late ClanarinaProvider _clanarinaProvider;
  SearchResult<Clanarina>? result;
  
  late KorisnikProvider _korisnikProvider;
  SearchResult<Korisnik>? korisnikResult;

  final ScrollController _horizontal = ScrollController(),
      _vertical = ScrollController();


  @override void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    _clanarinaProvider=context.read<ClanarinaProvider>();
    _korisnikProvider=context.read<KorisnikProvider>();
    initForm();
  }

  Future initForm()async{
      korisnikResult=await _korisnikProvider.get();
  }

   String getKorisnikDetails(int id)
  {
    var pronadjeniRacun=korisnikResult?.result.firstWhere((element) => element.korisnikId==id);
    String? pronadjeniBrojRacuna="${pronadjeniRacun?.ime} ${pronadjeniRacun?.prezime}"??"Nije pronađen";
    return pronadjeniBrojRacuna;
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      title_widget: const Text("Lista članarina"),
      child: Container(
        child: Column(children: [
          _buildSearch(),
          _buildDataListView(),
          
        ],),

        
      )
    );
  }

  Widget _buildSearch(){
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: 
      Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
            const SizedBox(
              height: 8,
            ),
            ElevatedButton(onPressed:() async{
                
            var data=await _clanarinaProvider.get(
            );
        
            setState(() {
              result=data;
              
            });
            }, 
            child: const Text("Load data")),
        ],
      ),
    
    );
  }


Widget _buildDataListView() {
  return 
  // SizedBox(
  //   height: 500,
  //   width: 400,
  //   child: 
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
                    child: Text("ID",
                    style: TextStyle(fontStyle: FontStyle.italic),),
                    
                    ),
                    ),

                    DataColumn(label: Expanded(
                    child: Text("KorisnikId",
                    style: TextStyle(fontStyle: FontStyle.italic),),
                    ),
                    ),

                    DataColumn(label: Expanded(
                    child: Text("Iznos članarine",
                    style: TextStyle(fontStyle: FontStyle.italic),),
                    ),
                    ),

                    DataColumn(label: Expanded(
                    child: Text("Dug",
                    style: TextStyle(fontStyle: FontStyle.italic),),
                    ),
                    ),
                    ],

              rows: 
                result?.result.map((Clanarina e) => DataRow(
                  onSelectChanged: (yxc)=>{
                    if((Authorization.ulogaKorisnika=="Administrator"||Authorization.ulogaKorisnika=="Računovođa")&&yxc==true)
                      {
                        print('selected: ${e.clanarinaId}'),
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (context)=> ClanarinaDetailsScreen(clanarina: e,)
                          )
                      ) 
                      }
                    else
                    {
                      showDialog(context: context, builder: (BuildContext context) => 
                        AlertDialog(
                          title: Text("You have chosen ${e.clanarinaId}"),
                          content: Text("KorisnikID: ${e.korisnikId}\nIznos članarine: ${e.iznosClanarine}\nDug: ${e.dug}"),
                          actions: [
                            TextButton(onPressed: ()=>{
                              Navigator.pop(context),
                            }, child: const Text("OK"))
                          ],
                        )),
                    }
                  },
                  cells: [
                  DataCell(Text(e.clanarinaId.toString()??"0")),
                  // DataCell(Text(e.korisnikId.toString()??"0")),
                  DataCell(Text(getKorisnikDetails(e.korisnikId!)??"2")),
                  DataCell(Text(e.iznosClanarine.toString()??"0")),
                  DataCell(Text(e.dug.toString()??"0")),
                  // DataCell(Text(e.datumClanarinaa.toString()??DateTime.now().toString())),

                  ]
                )).toList()??[]
              
              ),
          ),
        ),
      ),
    // ),
  );
}
}
 