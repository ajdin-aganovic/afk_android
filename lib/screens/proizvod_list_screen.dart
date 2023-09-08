import 'package:afk_android/models/search_result.dart';
import 'package:afk_android/providers/proizvod_provider.dart';
import 'package:afk_android/screens/proizvod_details_screen.dart';
import 'package:afk_android/screens/proizvod_editable_screen.dart';
import 'package:afk_android/widgets/master_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/korisnik.dart';
import '../models/proizvod.dart';
import '../utils/util.dart';

class ProizvodListScreen extends StatefulWidget {
  static const String routeName = "/product";

  Korisnik?korisnik;
  ProizvodListScreen({this.korisnik, super.key});

  @override
  State<ProizvodListScreen> createState() => _ProizvodListScreen();
}

class _ProizvodListScreen extends State<ProizvodListScreen> {
  late ProizvodProvider _proizvodProvider;
  SearchResult<Proizvod>? result;
  final TextEditingController _nazivController=TextEditingController();
  final TextEditingController _sifraController=TextEditingController();


  final ScrollController _horizontal = ScrollController(),
      _vertical = ScrollController();


  @override void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    _proizvodProvider=context.read<ProizvodProvider>();
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      title_widget: const Text("Lista proizvoda"),
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
                  controller:_nazivController,
                ),
            ),

            Expanded(
              child: 
              TextField(
                  decoration: 
                  const InputDecoration(labelText: "Pretraga po šifri"), 
                  controller:_sifraController,
                ),
            ),
            
            ElevatedButton(onPressed:() async{
                
            var data=await _proizvodProvider.get(
              filter: {
                'NazivProizvoda':_nazivController.text, //ako ne radi pretraga, ovo promijeniti
                'SifraProizvoda':_sifraController.text
              }
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
                    child: Text("Proizvod ID",
                    style: TextStyle(fontStyle: FontStyle.italic),),
                    
                    ),
                    ),

                    DataColumn(label: Expanded(
                    child: Text("Naziv proizvoda",
                    style: TextStyle(fontStyle: FontStyle.italic),),
                    ),
                    ),

                    DataColumn(label: Expanded(
                    child: Text("Šifra proizvoda",
                    style: TextStyle(fontStyle: FontStyle.italic),),
                    ),
                    ),

                    DataColumn(label: Expanded(
                    child: Text("Kategorija proizvoda",
                    style: TextStyle(fontStyle: FontStyle.italic),),
                    ),
                    ),

                    DataColumn(label: Expanded(
                    child: Text("Cijena proizvoda",
                    style: TextStyle(fontStyle: FontStyle.italic),),
                    ),
                    ),

                    DataColumn(label: Expanded(
                    child: Text("Količina",
                    style: TextStyle(fontStyle: FontStyle.italic),),
                    ),
                    ),

                    ],

              rows: 
                result?.result.map((Proizvod e) => DataRow(
                  onSelectChanged: (yxc)=>{
                    if((Authorization.ulogaKorisnika=="Administrator")&&yxc==true)
                      {
                        print('selected: ${e.proizvodId}'),
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (context)=> ProizvodEditableScreen(proizvod: e,)
                          )
                      ) 
                      }
                    else
                    {
                      // showDialog(context: context, builder: (BuildContext context) => 
                      //   AlertDialog(
                      //     title: Text("You have chosen ${e.proizvodId}"),
                      //     content: Text("${e.naziv}/${e.kategorija}"),
                      //     actions: [
                      //       TextButton(onPressed: ()=>{
                      //         Navigator.pop(context),
                      //       }, child: const Text("OK"))
                      //     ],
                      //   )),
                      print('selected: ${e.proizvodId}'),
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (context)=> ProizvodDetailsScreen(proizvod: e,)
                          )
                      ) 
                    }
                  },
                  cells: [
                  DataCell(Text(e.proizvodId.toString()??"0")),
                  DataCell(Text(e.naziv??"---")),
                  DataCell(Text(e.sifra??"---")),
                  DataCell(Text(e.kategorija??"---")),
                  DataCell(Text(e.cijena.toString()??"---")),
                  DataCell(Text(e.kolicina.toString()??"---")),

                  ]
                )).toList()??[]
              
              ),
          ),
        ),
      ),
  );
}
}
 