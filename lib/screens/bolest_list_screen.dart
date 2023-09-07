import 'package:afk_admin/main.dart';
import 'package:afk_admin/models/korisnik.dart';
import 'package:afk_admin/models/search_result.dart';
import 'package:afk_admin/providers/bolest_provider.dart';
import 'package:afk_admin/screens/bolest_details_screen.dart';
import 'package:afk_admin/screens/korisnik_details_screen.dart';
import 'package:afk_admin/utils/util.dart';
// import 'package:afk_admin/screens/plata_details_screen.dart';
import 'package:afk_admin/widgets/master_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart' as dotenv;

// import '../models/platum.dart';
import '../models/bolest.dart';
import '../providers/korisnik_provider.dart';

class BolestListScreen extends StatefulWidget {
  Korisnik?korisnik;

  BolestListScreen({this.korisnik,super.key});

  @override
  State<BolestListScreen> createState() => _BolestListScreen();
}

class _BolestListScreen extends State<BolestListScreen> {
  late BolestProvider _bolestProvider;
  SearchResult<Bolest>? resultBolest;

  late KorisnikProvider _korisnikProvider;
  SearchResult<Korisnik>? resultKorisnik;
   
  final TextEditingController _sifraPovrede=TextEditingController();
  final TextEditingController _tipPovrede=TextEditingController();

  final ScrollController _horizontal = ScrollController(),
      _vertical = ScrollController();


  @override void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    _bolestProvider=context.read<BolestProvider>();
    _korisnikProvider=context.read<KorisnikProvider>();
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      title_widget: const Text("Bolests list"),
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
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
            Expanded(
              child: 
              TextField(
                  decoration: 
                  const InputDecoration(labelText: "Šifra bolesti"), 
                  controller:_sifraPovrede,
                ),
            ),
            const SizedBox(width: 8,), 

            Expanded(child:
            
                  TextField(
                    decoration: 
                    const InputDecoration(labelText: "Tip povrede"), 
                    controller:_tipPovrede,
                  ),
            
            ),
            const SizedBox(
              height: 8,
            ),
            ElevatedButton(onPressed:() async{
                
            var data=await _bolestProvider.get(filter: {
              'SifraPovrede':_sifraPovrede.text,
              'TipPovrede':_tipPovrede.text
            }
            );
        
            setState(() {
              resultBolest=data;
            });
        
            // print("data: ${data.result[0].bolestId}");
          
          
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
                    child: Text("Šifra povrede",
                    style: TextStyle(fontStyle: FontStyle.italic),),
                    ),
                    ),

                    DataColumn(label: Expanded(
                    child: Text("Tip povrede",
                    style: TextStyle(fontStyle: FontStyle.italic),),
                    ),
                    ),

                    DataColumn(label: Expanded(
                    child: Text("Trajanje povrede (dani)",
                    style: TextStyle(fontStyle: FontStyle.italic),),
                    ),
                    ),

                    ],

              rows: 
                resultBolest?.result.map((Bolest e) => DataRow(

                  onSelectChanged: (yxc)=>{
                    if((Authorization.ulogaKorisnika=="Administrator"||Authorization.ulogaKorisnika=="Doktor")&&yxc==true)
                      {
                        print('selected: ${e.bolestId}'),
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (context)=> BolestDetailsScreen(bolest: e,)
                          )
                      ) 
                      }
                    else
                    {
                      showDialog(context: context, builder: (BuildContext context) => 
                        AlertDialog(
                          title: Text("You have chosen ${e.bolestId}"),
                          content: Text("${e.tipPovrede}/${e.sifraPovrede}"),
                          actions: [
                            TextButton(onPressed: ()=>{
                              Navigator.pop(context),
                            }, child: const Text("OK"))
                          ],
                        )),
                    }
                  },
                  cells: [
                  DataCell(Text(e.bolestId?.toString()??"")),
                  DataCell(Text(e.sifraPovrede ??"")),
                  DataCell(Text(e.tipPovrede ??"")),
                  DataCell(Text(e.trajanjePovredeDani.toString() ??"")),
                  ]
                )).toList()??[]
              
              ),
          ),
        ),
      // ),
    ),
  );
}
}
 