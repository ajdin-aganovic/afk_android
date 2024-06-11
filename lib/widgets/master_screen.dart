import 'package:afk_android/main.dart';
import 'package:afk_android/models/search_result.dart';
import 'package:afk_android/providers/cart_provider.dart';
import 'package:afk_android/screens/cart_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


import '../models/korisnik.dart';
import '../screens/home_screen.dart';

// ignore: must_be_immutable
class MasterScreenWidget extends StatefulWidget {
  Widget?child;
  String? title;
  Widget? title_widget;
  bool DozvoljenAppBar=false;
  Korisnik? korisnik;

  MasterScreenWidget({this.child, this.title, this.title_widget, this.korisnik, super.key});

  @override
  State<MasterScreenWidget> createState() => _MasterScreenWidgetState();
}

class _MasterScreenWidgetState extends State<MasterScreenWidget> {

  SearchResult<Korisnik>? _korisnikResult;
  CartProvider? _cartProvider;
  @override
  Widget build(BuildContext context) {
    _cartProvider=context.watch<CartProvider>();
    return Scaffold(
      appBar: AppBar(
        title: widget.title_widget?? Text(widget.title??"")
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            ListTile(
              title: const Text("Početna"),
              onTap: (){
                Navigator.of(context).push(
                  MaterialPageRoute(
                    
                    builder: (context) => const HomePage(),
                  ),
                );
              },
            ),
            ListTile(
              title: const Text("Nazad"),
              onTap: (){
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text("Korpa {${_cartProvider?.cart.items.length}}"),
              onTap: (){
                Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>CartScreen()));
              },
            ),
            ListTile(
              title: const Text("Odjava"),
              onTap: (){
                Navigator.of(context).pushAndRemoveUntil<void>
                (
                
                MaterialPageRoute<void>
                (builder: (BuildContext context) => 
                LoginPage()),
                ModalRoute.withName('/Korisnik'),
                  // MaterialPageRoute(
                  //   builder: (context) => LoginPage(),
                  // ),
                );
              },
            ),
            
          ],
        ),
       ),
      body: widget.child!,


    );
  }
}