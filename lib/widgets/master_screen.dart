import 'package:afk_android/main.dart';
import 'package:afk_android/models/search_result.dart';
import 'package:afk_android/screens/korisnik_details_screen.dart';
import 'package:afk_android/screens/plata_details_screen.dart';
import 'package:afk_android/screens/plata_list_screen.dart';
import 'package:afk_android/screens/korisnici_list_screen.dart';
import 'package:afk_android/screens/termin_details_screen.dart';
import 'package:afk_android/screens/transakcijski_racun_details.dart';
import 'package:afk_android/screens/transakcijski_racun_list_screen.dart';
import 'package:afk_android/screens/trening_details_screen.dart';
import 'package:afk_android/utils/util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart' as dotenv;


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
  @override
  Widget build(BuildContext context) {
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
                    
                    builder: (context) => HomePage(),
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