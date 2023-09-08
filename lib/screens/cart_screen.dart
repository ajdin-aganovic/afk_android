
import 'package:afk_android/models/cart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/order_provider.dart';
import '../providers/cart_provider.dart';
import '../widgets/master_screen.dart';

class CartScreen extends StatefulWidget {
  static const String routeName = "/cart";

  const CartScreen({Key? key}) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {

  late CartProvider _cartProvider;
  late OrderProvider _orderProvider;
  
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    _cartProvider = context.watch<CartProvider>();
    _orderProvider = context.read<OrderProvider>();
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
        child: Column(
          children: [
            Expanded(child:_buildProductCardList()),
            _buildBuyButton(),
          ],
        ),
      );
  }

  Widget _buildProductCardList() {
    return Container(
      child: ListView.builder(
        itemCount: _cartProvider.cart.items.length,
        itemBuilder: (context, index) {
          return _buildProductCard(_cartProvider.cart.items[index]);
        },
      ),
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
    return TextButton(
      child: const Text("Buy"),
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

        await _orderProvider.insert(order);

        _cartProvider.cart.items.clear();
        setState(() {
        });
      },
    );
  }
}