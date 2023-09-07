import 'package:afk_admin/models/search_result.dart';
import 'package:afk_admin/providers/platum_provider.dart';
import 'package:afk_admin/providers/statistika_provider.dart';
import 'package:afk_admin/screens/plata_details_screen.dart';
import 'package:afk_admin/screens/statistika_details_screen.dart';
import 'package:afk_admin/widgets/master_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart' as dotenv;

import '../models/korisnik.dart';
import '../models/platum.dart';
import '../models/statistika.dart';
import '../providers/korisnik_provider.dart';
import '../providers/transakcijski_racun_provider.dart';
import '../utils/util.dart';

class StatistikaListScreen extends StatefulWidget {
  Korisnik?korisnik;
  StatistikaListScreen({this.korisnik, super.key});

  @override
  State<StatistikaListScreen> createState() => _StatistikaListScreen();
}

class _StatistikaListScreen extends State<StatistikaListScreen> {
  late StatistikaProvider _statistikaProvider;
  SearchResult<Statistika>? result;

  late KorisnikProvider _korisnikProvider;
  SearchResult<Korisnik>? _korisnikResult;

  final ScrollController _horizontal = ScrollController(),
      _vertical = ScrollController();


  @override void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    _statistikaProvider=context.read<StatistikaProvider>();
    _korisnikProvider=context.read<KorisnikProvider>();
    initForm();
  }

  Future initForm()async{
      _korisnikResult=await _korisnikProvider.get();
  }

   String getKorisnikDetails(int id)
  {
    var pronadjeniRacun=_korisnikResult?.result.firstWhere((element) => element.korisnikId==id);
    String? pronadjeniBrojRacuna="${pronadjeniRacun?.ime} ${pronadjeniRacun?.prezime}"??"Nije pronađen";
    return pronadjeniBrojRacuna;
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      title_widget: const Text("Lista statistika"),
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
                
            var data=await _statistikaProvider.get(
            
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
                    child: Text("Korisnik ID",
                    style: TextStyle(fontStyle: FontStyle.italic),),
                    ),
                    ),

                    DataColumn(label: Expanded(
                    child: Text("Golovi",
                    style: TextStyle(fontStyle: FontStyle.italic),),
                    ),
                    ),

                    DataColumn(label: Expanded(
                    child: Text("Asistencije",
                    style: TextStyle(fontStyle: FontStyle.italic),),
                    ),
                    ),

                    DataColumn(label: Expanded(
                    child: Text("Igrač mjeseca",
                    style: TextStyle(fontStyle: FontStyle.italic),),
                    ),
                    ),

                    DataColumn(label: Expanded(
                    child: Text("Bez primljenog gola",
                    style: TextStyle(fontStyle: FontStyle.italic),),
                    ),
                    ),

                    DataColumn(label: Expanded(
                    child: Text("Žuti kartoni",
                    style: TextStyle(fontStyle: FontStyle.italic),),
                    ),
                    ),

                    DataColumn(label: Expanded(
                    child: Text("Crveni kartoni",
                    style: TextStyle(fontStyle: FontStyle.italic),),
                    ),
                    ),

                    DataColumn(label: Expanded(
                    child: Text("Prosječna ocjena",
                    style: TextStyle(fontStyle: FontStyle.italic),),
                    ),
                    ),

                    DataColumn(label: Expanded(
                    child: Text("Ocjena zadnje utakmice",
                    style: TextStyle(fontStyle: FontStyle.italic),),
                    ),
                    ),
                    ],

              rows: 
                result?.result.map((Statistika e) => DataRow(
                  onSelectChanged: (yxc)=>{
                    if((Authorization.ulogaKorisnika=="Administrator"||Authorization.ulogaKorisnika=="Analitičar")&&yxc==true)
                      {
                        print('selected: ${e.statistikaId}'),
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (context)=> StatistikaDetailsScreen(statistika: e,)
                          )
                      ) 
                      }
                    else
                    {
                      showDialog(context: context, builder: (BuildContext context) => 
                        AlertDialog(
                          title: Text("You have chosen ${e.statistikaId}"),
                          content: Text("KorisnikID: ${e.korisnikId}"),
                          actions: [
                            TextButton(onPressed: ()=>{
                              Navigator.pop(context),
                            }, child: const Text("OK"))
                          ],
                        )),
                    }
                  },
                  cells: [
                  DataCell(Text(e.statistikaId.toString()??"0")),
                  // DataCell(Text(e.korisnikId.toString()??"0")),
                  DataCell(Text(getKorisnikDetails(e.korisnikId!)??"0")),
                  DataCell(Text(e.golovi.toString()??"0")),
                  DataCell(Text(e.asistencije.toString()??"0")),
                  DataCell(Text(e.igracMjeseca.toString()??"0")),
                  DataCell(Text(e.bezPrimGola.toString()??"0")),
                  DataCell(Text(e.zutiKartoni.toString()??"0")),
                  DataCell(Text(e.crveniKartoni.toString()??"0")),
                  DataCell(Text(e.prosjecnaOcjena.toString()??"0")),
                  DataCell(Text(e.ocjenaZadUtak.toString()??"0")),

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
 