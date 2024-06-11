
// import 'package:afk_android/screens/proizvod_details_screen.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/src/foundation/key.dart';
// import 'package:flutter/src/widgets/framework.dart';
// import 'package:intl/intl.dart';
// import 'package:provider/provider.dart';

// import '../../providers/cart_provider.dart';
// import '../models/proizvod.dart';
// import '../models/search_result.dart';
// import '../providers/proizvod_provider.dart';
// import '../widgets/master_screen.dart';

// class ProductListScreen extends StatefulWidget {
//   static const String routeName = "/product";

//   const ProductListScreen({Key? key}) : super(key: key);

//   @override
//   State<ProductListScreen> createState() => _ProductListScreenState();
// }

// class _ProductListScreenState extends State<ProductListScreen> {
//   ProizvodProvider? _productProvider = null;
//   CartProvider? _cartProvider = null;
//   // List<Proizvod> data = [];
//   TextEditingController _searchController = TextEditingController();
//   SearchResult<Proizvod>? result;


//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     _productProvider = context.read<ProizvodProvider>();
//     _cartProvider = context.read<CartProvider>();
//     print("called initState");
//     loadData();
//   }

//   Future loadData() async {
//     result = await _productProvider?.get();
//     setState(() {
//      var data = result;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     print("called build ${result}");
//     return MasterScreenWidget(
//       child: SingleChildScrollView(
//         child: Container(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               _buildHeader(),
//               _buildProductSearch(),
//               Container(
//                 height: 500,
//                 child: GridView(
//                   gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                       crossAxisCount: 2,
//                       childAspectRatio: 4 / 3,
//                       crossAxisSpacing: 10,
//                       mainAxisSpacing: 30),
//                   scrollDirection: Axis.horizontal,
//                   children: _buildProductCardList(),
//                 ),
//               )
//             ],
//           ),
//         ),
//       )
//     );
//   }

//   Widget _buildHeader() {
//     return Container(
//       padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//       child: Text("Products", style: TextStyle(color: Colors.grey, fontSize: 40, fontWeight: FontWeight.w600),),
//     );
//   }

//   Widget _buildProductSearch() {
//     return Row(
//       children: [
//         Expanded(
//           child: Container(
//             padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//             child: TextField(
//               controller: _searchController,
//               onSubmitted: (value) async {
//                 var tmpData = await _productProvider?.get(filter: {'naziv': value});
//                 setState(() {
//                   result = tmpData!;
//                 });
//               },
//               decoration: InputDecoration(
//                   hintText: "Search",
//                   prefixIcon: Icon(Icons.search),
//                   border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(10),
//                       borderSide: BorderSide(color: Colors.grey))),
//             ),
//           ),
//         ),
//         Container(
//           padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//           child: IconButton(
//             icon: Icon(Icons.filter_list),
//             onPressed: () async {
//                 var tmpData = await _productProvider?.get(filter: {'naziv': _searchController.text});
//                 setState(() {
//                   result = tmpData!;
//                 });
//             },
//           ),
//         )
//       ],
//     );
//   }


//   List<Widget> _buildProductCardList() {
//     if (result?.count == 0) {
//       return [Text("Loading...")];
//     }

//     List<Widget> list = result?.map((x) => Container(
              
//               child: Column(
//                 children: [
//                   InkWell(
//                     onTap: () {
//                       Navigator.pushNamed(context, "${ProizvodDetailsScreen.routeName}/${x.proizvodId}");
//                     },
//                   ),
//                   Text(x.naziv ?? ""),
//                   Text(x.cijena),
//                   IconButton(
//                     icon: Icon(Icons.shopping_cart),
//                     onPressed: ()  {
//                         _cartProvider?.addToCart(x);
//                     },
//                   )
//                 ],
//               ),
//             ))
//         .cast<Widget>()
//         .toList();

//     return list;
//   }
// }

// import 'package:afk_android/models/proizvod.dart';
// import 'package:afk_android/models/search_result.dart';
// import 'package:afk_android/providers/proizvod_provider.dart';
// // import 'package:afk_android/providers/utils.dart';
// import 'package:afk_android/screens/proizvod_details_screen.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/src/foundation/key.dart';
// import 'package:flutter/src/widgets/framework.dart';
// import 'package:intl/intl.dart';
// import 'package:provider/provider.dart';

// import '../../providers/cart_provider.dart';


// class ProductListScreen extends StatefulWidget {
//   static const String routeName = "/product";

//   const ProductListScreen({Key? key}) : super(key: key);

//   @override
//   State<ProductListScreen> createState() => _ProductListScreenState();
// }

// class _ProductListScreenState extends State<ProductListScreen> {
//   ProizvodProvider? _productProvider = null;
//   CartProvider? _cartProvider = null;
//   SearchResult<Proizvod>? data = null;
//   TextEditingController _searchController = TextEditingController();

//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     _productProvider = context.read<ProizvodProvider>();
//     _cartProvider = context.read<CartProvider>();
//     print("called initState");
//     loadData();
//   }

//   Future loadData() async {
//     var tmpData = await _productProvider?.get();
//     setState(() {
//       data = tmpData!;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return MasterScreen("Proizvodi",
//     SingleChildScrollView(
//       child: Container(
//         child: Column(
//           children: [
//             _buildProductSearch(),
//             Container(
//               height: 500,
//               child: GridView(
//                 gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                   crossAxisCount: 2,
//                   childAspectRatio: 4 / 3,
//                   crossAxisSpacing: 10,
//                   mainAxisSpacing: 30
//                 ),
//                 scrollDirection: Axis.horizontal,
//                 children: _buildProductCardList(),
//               ),
//             )
//           ],
//         ),
//       ),
//     ) );
//   }
  
//   Widget _buildProductSearch() {
//     return Row(
//       children: [
//         Expanded(
//           child: Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: TextField(
//               controller: _searchController,
//               onSubmitted: (value) async {
//                  var tmpData = await _productProvider?.get(filter: {'fts': _searchController.text});
//                 setState(() {
//                   data = tmpData!;
//                 });
//               },
//               decoration: InputDecoration(
//                 hintText: "Search",
//                 prefixIcon: Icon(Icons.search)
//               ),
//             ),
//           )),
//           Container(
//             padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
//             child: IconButton(
//               icon: Icon(Icons.filter_list),
//               onPressed: () async {
//                 print('called product');
//                  var tmpData = await _productProvider?.get(filter: {'fts': _searchController.text});
//                 setState(() {
//                   data = tmpData!;
//                 });
//               },
//             ),
//           )
//       ],
//     );
//   }

  // List<Widget> _buildProductCardList() {
  //   if (data?.result?.length == 0) {
  //     return [Text("Loading...")];
  //   }

  //   List<Widget> list = data!.result.map((x) => Container(
  //     child: Column(
  //       children: [
  //         Container(
  //           height: 100,
  //           width: 100,
  //           child: x.slika == null ? Placeholder() : imageFromString(x.slika!),
  //         ),
  //         Text(x.naziv ?? ""),
  //         Text(formatNumber(x.cijena)),
  //         IconButton(onPressed: () {
  //             _cartProvider?.addToCart(x);
  //         }, icon: Icon(Icons.shopping_cart))
  //       ],
  //     ),
  //   )).cast<Widget>().toList();
    
  //   return list;
  // }
 
// }


