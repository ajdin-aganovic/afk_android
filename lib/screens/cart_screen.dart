
// import 'package:afk_android/models/cart.dart';
// import 'package:afk_android/screens/home_screen.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// import '../../providers/narudzba_provider.dart';
// import '../providers/cart_provider.dart';
// import '../widgets/master_screen.dart';

// class CartScreen extends StatefulWidget {
//   static const String routeName = "/cart";

//   const CartScreen({Key? key}) : super(key: key);

//   @override
//   State<CartScreen> createState() => _CartScreenState();
// }

// class _CartScreenState extends State<CartScreen> {

//   late CartProvider _cartProvider;
//   late NarudzbaProvider _orderProvider;
//   double suma=0.0;
  
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
    
//   }


//   @override
//   void didChangeDependencies() {
//     // TODO: implement didChangeDependencies
//     super.didChangeDependencies();
//     _cartProvider = context.watch<CartProvider>();
//     _orderProvider = context.read<NarudzbaProvider>();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return MasterScreenWidget(
//       title: "Korpa",
//         child: Column(
//           children: [
//             Expanded(child:_buildProductCardList()),
//             _buildBuyButton(),
//           ],
//         ),
//       );
//   }

//   Widget _buildProductCardList() {
//     return Container(
//       child: ListView.builder(
//         itemCount: _cartProvider.cart.items.length,
//         itemBuilder: (context, index) {
          
//           return _buildProductCard(_cartProvider.cart.items[index]);
//         },
//       ),
//     );
//   }

//   Widget _buildProductCard(CartItem item) {
//     // suma+=(item.product.cijena as double);
//     return ListTile(
//       title: Text(item.product.naziv ?? ""),
//       subtitle: Text(item.product.cijena.toString()),
//       trailing: Text(item.count.toString()),
//     );
//   }

//   Widget _buildBuyButton() {
//     for(var item in _cartProvider.cart.items)
//     {
//       double cijenaArtikla=item.product.cijena!*item.count;
//       suma+=(cijenaArtikla)??0.0;
//     }
//     return TextButton(
//       child: Text("Buy ${suma.toString()} "),
//       onPressed: () async {
//         List<Map> items = [];
//         for (var item in _cartProvider.cart.items) {
//           items.add({
//             "proizvodId": item.product.proizvodId,
//             "kolicina": item.count,
//           });
//         }
//         Map order = {
//           "items": items,
//         };

//         // await _orderProvider.insert(order);

//         _cartProvider.cart.items.clear();

//         showDialog(context: context, builder: (BuildContext context) => 
//           AlertDialog(
//             title: const Text("Završili ste sa kupovinom?"),
//             content: Text("Konačna cijena (u KM): ${suma.toString()}"),
//             actions: [
              
//               TextButton(onPressed: () async =>{
    
//                 Navigator.of(context).push(
//                   MaterialPageRoute(
//                     builder: (context) => HomePage(),
//                   ),
//                 )
            
    
//               }, child: const Text("Da, kupi")),
//               TextButton(onPressed: ()=>{
//                 suma=0.0,
//                 Navigator.pop(context),
//               }, child: const Text("Odustani od kupovine")),
    
//             ],
//           ));
//         setState(() {
//         });
//       },
//     );
//   }
// }

////RAZGRANICENJE
///
///import 'package:flutter/material.dart';
import 'package:afk_android/models/korisnik.dart';
import 'package:provider/provider.dart';
// import '../util/email_util.dart'; // Import the email utility
import '../models/cart.dart';
import '../providers/cart_provider.dart';
import '../providers/korisnik_provider.dart';
import '../providers/narudzba_provider.dart';
import '../widgets/master_screen.dart';
import 'home_screen.dart';
import 'package:flutter/material.dart';
import 'package:afk_android/utils/email_util.dart';

// import 'package:afk_android/models/cart.dart';
// import 'package:afk_android/screens/home_screen.dart';
// import 'package:provider/provider.dart';

// import '../../providers/narudzba_provider.dart';
// import '../providers/cart_provider.dart';
// import '../widgets/master_screen.dart';

class CartScreen extends StatefulWidget {
  static const String routeName = "/cart";

  const CartScreen({Key? key}) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  late CartProvider _cartProvider;
  late NarudzbaProvider _orderProvider;
  late KorisnikProvider _korisnikProvider;
  double suma = 0.0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _cartProvider = context.watch<CartProvider>();
    _orderProvider = context.read<NarudzbaProvider>();
    _korisnikProvider=context.read<KorisnikProvider>();
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      title: "Korpa",
      child: Column(
        children: [
          Expanded(child: _buildProductCardList()),
          _buildBuyButton(),
          // _buildDeleteButton(), //popraviti delete dugme
        ],
      ),
    );
  }

    Widget _buildDeleteButton() {
          _cartProvider.cart.items.clear();
      return AlertDialog(
              title: const Text("Ispraznili ste korpu"),
              content: Text("Vaša korpa je sada prazna."),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => HomePage(),
                      ),
                    );
                  },
                  child: const Text("OK"),
                ),
              ],
            );
        }


  Widget _buildProductCardList() {
    return ListView.builder(
      itemCount: _cartProvider.cart.items.length,
      itemBuilder: (context, index) {
        return _buildProductCard(_cartProvider.cart.items[index]);
      },
    );
  }

  Widget _buildProductCard(CartItem item) {
    return ListTile(
      title: Text(item.product.naziv ?? ""),
      subtitle: Text(item.product.cijena.toString()),
      trailing: Text(item.count.toString()),
    );
  }

  Widget _buildBuyButton() {
    for (var item in _cartProvider.cart.items) {
      double cijenaArtikla = item.product.cijena! * item.count;
      suma += cijenaArtikla;
    }

    return TextButton(
      child: Text("Kupi ${suma.toString()} "),
      onPressed: () async {
        List<Map> items = [];
        for (var item in _cartProvider.cart.items) {
          items.add({
            "proizvodId": item.product.proizvodId,
            "kolicina": item.count,
          });
        }
        Map order = {
          "items": items,
        };

        // Simulate payment process
        bool paymentSuccess = await _cartProvider.processPayment(suma);

        if (paymentSuccess) {
          // If payment is successful, proceed with order placement
          // await _orderProvider.insert(order);

          _cartProvider.cart.items.clear();

          // Send email notification
          await EmailUtil.sendEmail(
            recipientEmail: 'ajdinaganovic23@gmail.com', // Customer's email
            // recipientEmail: 'customer@example.com', // Customer's email
            subject: 'Potvrda kupnje',
            body: 'Hvala Vam na Vašoj kupovini! Vaša narudžba iznosi ${suma.toString()} KM.',
          );

          showDialog(
            context: context,
            builder: (BuildContext context) => AlertDialog(
              title: const Text("Uspješna kupovina"),
              content: Text("Vaša narudžba je uspješno kreirana. Ukupno: ${suma.toString()}"),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => HomePage(),
                      ),
                    );
                  },
                  child: const Text("OK"),
                ),
              ],
            ),
          );
        } else {
          // Handle payment failure
          showDialog(
            context: context,
            builder: (BuildContext context) => AlertDialog(
              title: const Text("Kupovina nije uspjela"),
              content: Text("Nastao je problem prilikom kupovine. Molimo Vas pokušajte ponovo."),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("OK"),
                ),
              ],
            ),
          );
        }

        setState(() {
          suma = 0.0;
        });
      },
    );
  }
}
