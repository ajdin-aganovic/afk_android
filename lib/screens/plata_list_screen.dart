import 'package:afk_admin/models/search_result.dart';
import 'package:afk_admin/providers/platum_provider.dart';
import 'package:afk_admin/screens/plata_details_screen.dart';
import 'package:afk_admin/widgets/master_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart' as dotenv;
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../models/korisnik.dart';
import '../models/platum.dart';
import '../models/transakcijski_racun.dart';
import '../providers/transakcijski_racun_provider.dart';
import '../utils/util.dart';

class PlatumListScreen extends StatefulWidget {
Korisnik?korisnik;
  PlatumListScreen({this.korisnik, super.key});

  @override
  State<PlatumListScreen> createState() => _PlatumListScreen();
}

class _PlatumListScreen extends State<PlatumListScreen> {
  late PlatumProvider _platumProvider;
  SearchResult<Platum>? result;

  late TransakcijskiRacunProvider _transakcijskiRacunProvider;

  SearchResult<TransakcijskiRacun>? _transakcijskiRacunResult;

   
  final TextEditingController _stateMachine=TextEditingController();
  final TextEditingController _minIznos=TextEditingController();
  final TextEditingController _maxIznos=TextEditingController();

  final ScrollController _horizontal = ScrollController(),
      _vertical = ScrollController();


  @override void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    _platumProvider=context.read<PlatumProvider>();
    _transakcijskiRacunProvider=context.read<TransakcijskiRacunProvider>();
    initForm();
  }

  Future initForm()async{
      _transakcijskiRacunResult=await _transakcijskiRacunProvider.get();
  }

  String getBrojRacuna(int id)
  {
    var pronadjeniRacun=_transakcijskiRacunResult?.result.firstWhere((element) => element.transakcijskiRacunId==id);
    String? pronadjeniBrojRacuna=pronadjeniRacun!.brojRacuna??"Nije pronađen";
    return pronadjeniBrojRacuna;
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      title_widget: const Text("Plata list"),
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
                  const InputDecoration(labelText: "Pretraga po stanju"), 
                  controller:_stateMachine,
                ),
            ),
            const SizedBox(width: 8,), 

            Expanded(child:
            
                  TextField(
                    decoration: 
                    const InputDecoration(labelText: "Minimalna plata"), 
                    controller:_minIznos,
                  ),
            
            ),
            const SizedBox(
              height: 8,
            ),
            Expanded(child:
            
              TextField(
                decoration: 
                const InputDecoration(labelText: "Maximalna plata"), 
                controller:_maxIznos
              ),
            
            ),
            const SizedBox(
              height: 8,
            ),
            ElevatedButton(onPressed:() async{
                
            var data=await _platumProvider.get(filter: {
              'StateMachine':_stateMachine.text,
              'MinIznos':_minIznos.text,
              'MaxIznos':_maxIznos.text
            }
            );
        
            setState(() {
              result=data;
            });
        
            // print("data: ${data.result[0].plataId}");
          
          
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
  SizedBox(
    height: 500,
    width: 800,
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
            // scrollDirection:Axis.vertical,
            child: DataTable(
                columns: const [
                    DataColumn(label: Expanded(
                    child: Text("ID",
                    style: TextStyle(fontStyle: FontStyle.italic),),
                    
                    ),
                    ),

                    DataColumn(label: Expanded(
                    child: Text("Br. tr. računa",
                    style: TextStyle(fontStyle: FontStyle.italic),),
                    ),
                    ),

                    DataColumn(label: Expanded(
                    child: Text("Status plate",
                    style: TextStyle(fontStyle: FontStyle.italic),),
                    ),
                    ),

                    DataColumn(label: Expanded(
                    child: Text("Iznos",
                    style: TextStyle(fontStyle: FontStyle.italic),),
                    ),
                    ),

                    DataColumn(label: Expanded(
                    child: Text("Datum slanja",
                    style: TextStyle(fontStyle: FontStyle.italic),),
                    
                    ),
                    ),

                    DataColumn(label: Expanded(
                    child: Text("Izmijeni status",
                    style: TextStyle(fontStyle: FontStyle.italic),),
                    
                    ),
                    ),
                    ],

              rows: 
                result?.result.map((Platum e) => DataRow(
                  onSelectChanged: (yxc)=>{
                    if((Authorization.ulogaKorisnika=="Administrator"||Authorization.ulogaKorisnika=="Računovođa")&&yxc==true)
                      {
                        print('selected: ${e.plataId}'),
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (context)=> PlatumDetailsScreen(platum: e,)
                          )
                      ) 
                      }
                    else
                    {
                      showDialog(context: context, builder: (BuildContext context) => 
                        AlertDialog(
                          title: Text("You have chosen ${e.plataId}"),
                          content: Text("Transakcijski račun ID: ${getBrojRacuna(e.transakcijskiRacunId!)}\nStanje: ${e.stateMachine}\nIznos: ${e.iznos}\nDatum slanja: ${e.datumSlanja}"),
                          actions: [
                            TextButton(onPressed: ()=>{
                              Navigator.pop(context),
                            }, child: const Text("OK"))
                          ],
                        )),
                    }
                  },
                  cells: [
                  DataCell(Text(e.plataId?.toString()??"")),
                  // DataCell(Text(e.transakcijskiRacunId.toString() ??"")),
                  DataCell(Text(getBrojRacuna(e.transakcijskiRacunId!) ??"")),
                  DataCell(Text(e.stateMachine ??"")),
                  DataCell(Text(e.iznos.toString() ??"")),
                  DataCell(Text(e.datumSlanja.toString() ??"")),
                  DataCell(const Text("Edit"), onTap: () async => {
                        if(Authorization.ulogaKorisnika=="Administrator"&&e.stateMachine!.contains("active"))
                        {
                          // Navigator.of(context).push(
                          //       MaterialPageRoute(builder: (context)=> InsertScreen(korisnik: e,)
                          //       )
                          //   ) 
                         await _platumProvider.hidePlatum(e.plataId!),
                          showDialog(context: context, builder: (BuildContext context) => 
                              AlertDialog(
                                title: Text("Successful operation!"),
                                content: Text("Plata je zatvorena"),
                                actions: [
                                  TextButton(onPressed: ()=>{
                                    Navigator.of(context).push(
                                        MaterialPageRoute(builder: (context)=> PlatumListScreen()
                                        )
                                    ) 
                                  }, child: const Text("OK"))
                                ],
                              )),
                        }
                        else if(Authorization.ulogaKorisnika=="Administrator"&&e.stateMachine!.contains("draft"))
                        {
                           await _platumProvider.activatePlatum(e.plataId!),
                          showDialog(context: context, builder: (BuildContext context) => 
                              AlertDialog(
                                title: Text("Successful operation!"),
                                content: Text("Plata je otvorena"),
                                actions: [
                                  TextButton(onPressed: ()=>{
                                    Navigator.of(context).push(
                                        MaterialPageRoute(builder: (context)=> PlatumListScreen()
                                        )
                                    ) 
                                  }, child: const Text("OK"))
                                ],
                              )),
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
    ),
  );
}
}
 