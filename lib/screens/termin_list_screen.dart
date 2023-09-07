import 'package:afk_admin/models/search_result.dart';
import 'package:afk_admin/providers/platum_provider.dart';
import 'package:afk_admin/providers/termin_provider.dart';
import 'package:afk_admin/screens/plata_details_screen.dart';
import 'package:afk_admin/screens/termin_details_screen.dart';
import 'package:afk_admin/widgets/master_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart' as dotenv;

import '../models/korisnik.dart';
import '../models/platum.dart';
import '../models/stadion.dart';
import '../models/termin.dart';
import '../providers/stadion_provider.dart';
import '../providers/transakcijski_racun_provider.dart';
import '../utils/util.dart';

class TerminListScreen extends StatefulWidget {
  Korisnik?korisnik;
  TerminListScreen({this.korisnik, super.key});

  @override
  State<TerminListScreen> createState() => _TerminListScreen();
}

class _TerminListScreen extends State<TerminListScreen> {
  late TerminProvider _terminProvider;
  SearchResult<Termin>? result;

  late StadionProvider _stadionProvider;
  SearchResult<Stadion>? stadionResult;

  final ScrollController _horizontal = ScrollController(),
      _vertical = ScrollController();


  @override void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    _terminProvider=context.read<TerminProvider>();
    _stadionProvider=context.read<StadionProvider>();
    initForm();
  }

  Future initForm()async{
      stadionResult=await _stadionProvider.get();
  }

   String getStadionDetails(int id)
  {
    var pronadjeniRacun=stadionResult?.result.firstWhere((element) => element.stadionId==id);
    String? pronadjeniBrojRacuna="${pronadjeniRacun?.nazivStadiona}"??"Nije pronađen";
    return pronadjeniBrojRacuna;
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      title_widget: const Text("Lista termina"),
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
                
            var data=await _terminProvider.get(
            //   filter: {
            //   'StateMachine':_stateMachine.text,
            //   'MinIznos':_minIznos.text,
            //   'MaxIznos':_maxIznos.text
            // }
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

  
// 'plataId':widget.platum?.plataId.toString(),
//     'transakcijskiRacunId':widget.platum?.transakcijskiRacunId.toString(),
//     'stateMachine': widget.platum?.stateMachine, 
//     'iznos':widget.platum?.iznos.toString(),
//     'datumSlanja':widget.platum?.datumSlanja.toString()

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
                    child: Text("Šifra termina",
                    style: TextStyle(fontStyle: FontStyle.italic),),
                    ),
                    ),

                    DataColumn(label: Expanded(
                    child: Text("Tip termina",
                    style: TextStyle(fontStyle: FontStyle.italic),),
                    ),
                    ),

                    DataColumn(label: Expanded(
                    child: Text("Stadion",
                    style: TextStyle(fontStyle: FontStyle.italic),),
                    ),
                    ),

                    // DataColumn(label: Expanded(
                    // child: Text("Datum termina",
                    // style: TextStyle(fontStyle: FontStyle.italic),),
                    
                    // ),
                    // ),
                    ],

              rows: 
                result?.result.map((Termin e) => DataRow(
                  onSelectChanged: (yxc)=>{
                    if((Authorization.ulogaKorisnika=="Administrator"||Authorization.ulogaKorisnika=="Doktor"||Authorization.ulogaKorisnika=="Glavni trener")&&yxc==true)
                      {
                        print('selected: ${e.terminId}'),
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (context)=> TerminDetailsScreen(termin: e,)
                          )
                      ) 
                      }
                    else
                    {
                      showDialog(context: context, builder: (BuildContext context) => 
                        AlertDialog(
                          title: Text("You have chosen ${e.terminId}"),
                          content: Text("Šifra termina: ${e.sifraTermina}\nTip termina: ${e.tipTermina}\nStadion: ${getStadionDetails(e.stadionId!)}"),
                          actions: [
                            TextButton(onPressed: ()=>{
                              Navigator.pop(context),
                            }, child: const Text("OK"))
                          ],
                        )),
                    }
                  },
                  cells: [
                  DataCell(Text(e.terminId.toString()??"0")),
                  DataCell(Text(e.sifraTermina??"---")),
                  DataCell(Text(e.tipTermina??"---")),
                  DataCell(Text(getStadionDetails(e.stadionId!)??"1")),

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
 