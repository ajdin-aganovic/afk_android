import 'package:afk_admin/models/search_result.dart';
import 'package:afk_admin/providers/platum_provider.dart';
import 'package:afk_admin/screens/plata_details_screen.dart';
import 'package:afk_admin/screens/trening_details_screen.dart';
import 'package:afk_admin/widgets/master_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart' as dotenv;

import '../models/korisnik.dart';
import '../models/platum.dart';
import '../models/trening.dart';
import '../providers/transakcijski_racun_provider.dart';
import '../providers/trening_provider.dart';
import '../utils/util.dart';

class TreningListScreen extends StatefulWidget {
  Korisnik?korisnik;
   TreningListScreen({this.korisnik, super.key});

  @override
  State<TreningListScreen> createState() => _TreningListScreen();
}

class _TreningListScreen extends State<TreningListScreen> {
  late TreningProvider _treningProvider;
  SearchResult<Trening>? result;

  // late TransakcijskiRacunProvider _transakcijskiRacunProvider;

  
  final TextEditingController _nazivTreninga=TextEditingController();

  final ScrollController _horizontal = ScrollController(),
      _vertical = ScrollController();


  @override void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    _treningProvider=context.read<TreningProvider>();
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      title_widget: const Text("Lista treninga"),
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
            Expanded(
              child: 
              TextField(
                  decoration: 
                  const InputDecoration(labelText: "Pretraga po nazivu"), 
                  controller:_nazivTreninga,
                ),
            ),
            const SizedBox(width: 8,),
            const SizedBox(
              height: 8,
            ),
            ElevatedButton(onPressed:() async{
                
            var data=await _treningProvider.get(filter: {
              'NazivTreninga':_nazivTreninga.text,
            }
            );
        
            setState(() {
              result=data;
            });
        
            print("data: ${data.result[0].treningId}");
          
          
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
                    child: Text("NazivTreninga",
                    style: TextStyle(fontStyle: FontStyle.italic),),
                    ),
                    ),

                    DataColumn(label: Expanded(
                    child: Text("TipTreninga",
                    style: TextStyle(fontStyle: FontStyle.italic),),
                    ),
                    ),

                    // DataColumn(label: Expanded(
                    // child: Text("Datum treninga",
                    // style: TextStyle(fontStyle: FontStyle.italic),),
                    // ),
                    // ),
              ],

              rows: 
                result?.result.map((Trening e) => DataRow(
                  onSelectChanged: (yxc)=>{
                    if((Authorization.ulogaKorisnika=="Administrator"||Authorization.ulogaKorisnika=="Glavni trener"||Authorization.ulogaKorisnika=="Pomoćni trener")&&yxc==true)
                      {
                        print('selected: ${e.treningId}'),
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (context)=> TreningDetailsScreen(trening: e,)
                          )
                      ) 
                      }
                    else
                    {
                      showDialog(context: context, builder: (BuildContext context) => 
                        AlertDialog(
                          title: Text("You have chosen ${e.treningId}"),
                          content: Text("${e.tipTreninga}/${e.nazivTreninga}/${e.datumTreninga}"),
                          actions: [
                            TextButton(onPressed: ()=>{
                              Navigator.pop(context),
                            }, child: const Text("OK"))
                          ],
                        )),
                    }
                  },
                  cells: [
                  DataCell(Text(e.treningId?.toString()??"0")),
                  DataCell(Text(e.nazivTreninga ??"---")),
                  DataCell(Text(e.tipTreninga ??"---")),
                  // DataCell(Text(e.datumTreninga.toString() ??DateTime.now().toString())),

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
 