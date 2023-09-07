import 'package:afk_admin/models/search_result.dart';
import 'package:afk_admin/providers/platum_provider.dart';
import 'package:afk_admin/providers/stadion_provider.dart';
import 'package:afk_admin/screens/plata_details_screen.dart';
import 'package:afk_admin/screens/stadion_details_screen.dart';
import 'package:afk_admin/widgets/master_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart' as dotenv;

import '../models/korisnik.dart';
import '../models/platum.dart';
import '../models/stadion.dart';
import '../providers/transakcijski_racun_provider.dart';
import '../utils/util.dart';

class StadionListScreen extends StatefulWidget {
  Korisnik?korisnik;
  StadionListScreen({this.korisnik, super.key});

  @override
  State<StadionListScreen> createState() => _StadionListScreen();
}

class _StadionListScreen extends State<StadionListScreen> {
  late StadionProvider _stadionProvider;
  SearchResult<Stadion>? result;

  // late TransakcijskiRacunProvider _transakcijskiRacunProvider;

   
  // final TextEditingController _stateMachine=TextEditingController();
  // final TextEditingController _minIznos=TextEditingController();
  // final TextEditingController _maxIznos=TextEditingController();

  final ScrollController _horizontal = ScrollController(),
      _vertical = ScrollController();


  @override void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    _stadionProvider=context.read<StadionProvider>();
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      title_widget: const Text("Lista stadiona"),
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
                
            var data=await _stadionProvider.get(
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
                    child: Text("Naziv stadiona",
                    style: TextStyle(fontStyle: FontStyle.italic),),
                    ),
                    ),

                    DataColumn(label: Expanded(
                    child: Text("Kapacitet stadiona",
                    style: TextStyle(fontStyle: FontStyle.italic),),
                    ),
                    ),

                    ],

              rows: 
                result?.result.map((Stadion e) => DataRow(
                  onSelectChanged: (yxc)=>{
                    if((Authorization.ulogaKorisnika=="Administrator")&&yxc==true)
                      {
                        print('selected: ${e.stadionId}'),
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (context)=> StadionDetailsScreen(stadion: e,)
                          )
                      ) 
                      }
                    else
                    {
                      showDialog(context: context, builder: (BuildContext context) => 
                        AlertDialog(
                          title: Text("You have chosen ${e.stadionId}"),
                          content: Text("Naziv stadiona: ${e.nazivStadiona}\nKapacitet stadiona: ${e.kapacitetStadiona}"),
                          actions: [
                            TextButton(onPressed: ()=>{
                              Navigator.pop(context),
                            }, child: const Text("OK"))
                          ],
                        )),
                    }
                  },
                  cells: [
                  DataCell(Text(e.stadionId.toString()??"0")),
                  DataCell(Text(e.nazivStadiona??"---")),
                  DataCell(Text(e.kapacitetStadiona.toString()??"---")),
                  // DataCell(Text(e.datumStadiona.toString()??DateTime.now().toString())),

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
 