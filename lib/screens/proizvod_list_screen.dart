import 'package:afk_android/models/search_result.dart';
import 'package:afk_android/providers/cart_provider.dart';
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
  static const String routeName = "/proizvod";

  Korisnik?korisnik;
  ProizvodListScreen({this.korisnik, super.key});

  @override
  State<ProizvodListScreen> createState() => _ProizvodListScreen();
}

class _ProizvodListScreen extends State<ProizvodListScreen> {
  ProizvodProvider? _proizvodProvider=null;
  SearchResult<Proizvod>? result=null;
  CartProvider? _korpaProvider=null;
  final TextEditingController _nazivController=TextEditingController();
  final TextEditingController _sifraController=TextEditingController();
  final TextEditingController _statusController=TextEditingController();

  final ScrollController _horizontal = ScrollController(),
      _vertical = ScrollController();


  // @override void didChangeDependencies() {
  //   // TODO: implement didChangeDependencies
  //   super.didChangeDependencies();
  //   _proizvodProvider=context.read<ProizvodProvider>();
  // }

  Future loadData()async
  {
    var tmpData = await _proizvodProvider?.get();
    setState(() {
      result = tmpData!;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _proizvodProvider = context.read<ProizvodProvider>();
    _korpaProvider = context.read<CartProvider>();
    print("pozvan initState");
    loadData();
  }


  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      title_widget: const Text("Lista proizvoda"),
      child: 
      SingleChildScrollView(child: 
      Container(child: 
      Column(children: [
        _buildSearch(),
        Container(
          height: 500,
          child: GridView(
            gridDelegate: 
            const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 4/3,
              crossAxisSpacing: 10,
              mainAxisSpacing: 30),
              scrollDirection: Axis.horizontal,
              children: _buildProductCardList(),
          ),
        )
      ],),),)
      // Container(
      //   child: Column(children: [
      //     _buildSearch(),
      //     _buildDataListView(),
      //   ],),
      // )
    );
  }

  List<Widget> _buildProductCardList() {
    if (result?.result?.length == 0) {
      return [Text("Loading...")];
    }

    List<Widget>? list = result?.result.map((x) =>
     Container(
      child: Column(
        children: [
          Container(
            height: 100,
            width: 100,
          ),
          Text(x.naziv ?? ""),
          Text(x.cijena.toString()??""),
          Text(x.sifra??""),
          Text(x.kolicina.toString()??""),
          
          IconButton(onPressed: () {
            if(Authorization.ulogaKorisnika=="Administrator")
            {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context)=> ProizvodEditableScreen(proizvod: x,)
                )
              );
            }
            else
              {
                _korpaProvider?.addToCart(x);
                }
          }, icon:const Icon(Icons.shopping_cart))
        ],
      ),
    )).cast<Widget>().toList()??[];
    
    return list;
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
                  
                  const InputDecoration(labelText: "Pretraga po nazivu", prefixIcon: Icon(Icons.search)), 
                  controller:_nazivController,
                  
                ),
            ),

            Expanded(
              child: 
              TextField(
                  decoration: 
                  const InputDecoration(labelText: "Pretraga po šifri", ), 
                  controller:_sifraController,
                ),
            ),

            Expanded(
              child: 
              TextField(
                  decoration: 
                  const InputDecoration(labelText: "Prikaži sve proizvode", ), 
                  controller:_statusController,
                ),
            ),
            
            ElevatedButton(onPressed:() async{
                
            var data=await _proizvodProvider!.get(
              filter: {
                'NazivProizvoda':_nazivController.text, //ako ne radi pretraga, ovo promijeniti
                'SifraProizvoda':_sifraController.text
                //,'StateMachineProizvoda':_statusController.text
              }
            );
        
            setState(() {
              result=data;
              
            });
            }, 
            child: const Text("Učitaj podatke")),
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

                    DataColumn(label: Expanded(
                    child: Text("Status proizvoda",
                    style: TextStyle(fontStyle: FontStyle.italic),),
                    ),
                    ),

                    ],

              rows: 
                result?.result.map((Proizvod e) => DataRow(
                  onSelectChanged: (yxc)=>{
                    if((Authorization.ulogaKorisnika=="Administrator")&&yxc==true)
                      {
                        print('odabrani: ${e.proizvodId}'),
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (context)=> ProizvodEditableScreen(proizvod: e,)
                          )
                      ) 
                      }
                     else if(e.stateMachine!.startsWith("draft")&&yxc==true)
                      {
                        print('odabrani: ${e.proizvodId}'),
                        showDialog(context: context, builder: (BuildContext context) => 
                          AlertDialog(
                            title: const Text("Greška"),
                            content: Text(e.naziv!+' nije dostupan na web stranici ili ga nema na skladištu.'),
                            actions: [
                              TextButton(onPressed: ()=>{
                                Navigator.pop(context),
                              }, child: const Text("OK"))
                            ],
                          )) 
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
                      print('odabrani: ${e.proizvodId}'),
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (context)=> ProizvodDetailsScreen(proizvod: e,)
                          )
                      ) 
                    }
                  },
                  cells: [
                  DataCell(Text(e.proizvodId.toString()??"nema upisa")),
                  DataCell(Text(e.naziv??"nema upisa")),
                  DataCell(Text(e.sifra??"nema upisa")),
                  DataCell(Text(e.kategorija??"nema upisa")),
                  DataCell(Text(e.cijena.toString()??"nema upisa")),
                  DataCell(Text(e.kolicina.toString()??"nema upisa")),
                  DataCell(Text(e.stateMachine??"nema upisa")),

                  ]
                )).toList()??[]
              
              ),
          ),
        ),
      ),
  );
}
}
 