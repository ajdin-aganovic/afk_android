import 'package:afk_admin/models/search_result.dart';
import 'package:afk_admin/providers/platum_provider.dart';
import 'package:afk_admin/providers/pozicija_provider.dart';
import 'package:afk_admin/screens/plata_details_screen.dart';
import 'package:afk_admin/screens/pozicija_details_screen.dart';
import 'package:afk_admin/widgets/master_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart' as dotenv;

import '../models/korisnik.dart';
import '../models/platum.dart';
import '../models/pozicija.dart';
import '../providers/transakcijski_racun_provider.dart';
import '../utils/util.dart';

class PozicijaListScreen extends StatefulWidget {
  Korisnik?korisnik;
  PozicijaListScreen({this.korisnik, super.key});

  @override
  State<PozicijaListScreen> createState() => _PozicijaListScreen();
}

class _PozicijaListScreen extends State<PozicijaListScreen> {
  late PozicijaProvider _pozicijaProvider;
  SearchResult<Pozicija>? result;

  // late TransakcijskiRacunProvider _transakcijskiRacunProvider;

   
  // final TextEditingController _stateMachine=TextEditingController();
  // final TextEditingController _minIznos=TextEditingController();
  // final TextEditingController _maxIznos=TextEditingController();

  final ScrollController _horizontal = ScrollController(),
      _vertical = ScrollController();


  @override void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    _pozicijaProvider=context.read<PozicijaProvider>();
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      title_widget: const Text("Lista pozicijaa"),
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
                
            var data=await _pozicijaProvider.get(
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
            child: 
            DataTable(
                columns: const [
                    DataColumn(label: Expanded(
                    child: Text("ID",
                    style: TextStyle(fontStyle: FontStyle.italic),),
                    
                    ),
                    ),

                    DataColumn(label: Expanded(
                    child: Text("Naziv pozicije",
                    style: TextStyle(fontStyle: FontStyle.italic),),
                    ),
                    ),

                    DataColumn(label: Expanded(
                    child: Text("Kategorija pozicije",
                    style: TextStyle(fontStyle: FontStyle.italic),),
                    ),
                    ),
                    ],

              rows: 
                result?.result.map((Pozicija e) => DataRow(
                  onSelectChanged: (yxc)=>{
                    if((Authorization.ulogaKorisnika=="Administrator"||Authorization.ulogaKorisnika=="Glavni trener")&&yxc==true)
                      {
                        print('selected: ${e.pozicijaId}'),
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (context)=> PozicijaDetailsScreen(pozicija: e,)
                          )
                      ) 
                      }
                    else
                    {
                      showDialog(context: context, builder: (BuildContext context) => 
                        AlertDialog(
                          title: Text("You have chosen ${e.pozicijaId}"),
                          content: Text("${e.nazivPozicije}/${e.kategorijaPozicije}"),
                          actions: [
                            TextButton(onPressed: ()=>{
                              Navigator.pop(context),
                            }, child: const Text("OK"))
                          ],
                        )),
                    }
                  },
                  cells: [
                  DataCell(Text(e.pozicijaId.toString()??"0")),
                  DataCell(Text(e.nazivPozicije??"---")),
                  DataCell(Text(e.kategorijaPozicije??"---")),

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
 