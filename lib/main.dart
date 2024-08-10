
import 'dart:convert';
import 'dart:math';
import 'package:afk_android/providers/cart_provider.dart';
import 'package:afk_android/providers/clanarina_provider.dart';
import 'package:afk_android/providers/narudzba_provider.dart';
import 'package:afk_android/providers/proizvod_provider.dart';
import 'package:afk_android/providers/transakcijski_racun_provider.dart';
import 'package:afk_android/screens/korisnik_details_screen.dart';
import 'package:afk_android/screens/reset_password_screen.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:afk_android/providers/korisnik_provider.dart';
import 'package:afk_android/providers/uloga_provider.dart';
import 'package:afk_android/utils/util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
// import 'package:afk_android/api/client.dart';

import 'models/korisnik.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  Stripe.publishableKey="pk_test_51NnoBzESdHn89Po93TLLgZ3wTUdjypvSv1WwSQPYxEfPXp2B8veWzxeMS2pVRci6UaVbLNW8xE90ND9JixodNVNX00uDND5nc3";
  
  runApp(MultiProvider(providers:
  [
    ChangeNotifierProvider(create: (_) => KorisnikProvider()),
    ChangeNotifierProvider(create: (_) => UlogaProvider()),
    ChangeNotifierProvider(create: (_) => ClanarinaProvider()),
    ChangeNotifierProvider(create: (_) => TransakcijskiRacunProvider()),
    ChangeNotifierProvider(create: (_) => ProizvodProvider()),
    ChangeNotifierProvider(create: (_) => CartProvider()),
    ChangeNotifierProvider(create: (_) => NarudzbaProvider()),

  ],
  child: const MyMaterialApp(),));
}

class MyMaterialApp extends StatelessWidget {
  const MyMaterialApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AFK Material app',
      theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.red, primary: Colors.deepOrange) ,
        useMaterial3: true,),
      home: LoginPage(),

    );
  }
}

class LoginPage extends StatelessWidget {
//  LoginPage({this.loggovaniUser, super.key});
  LoginPage({Key? key, this.loggovaniUser}) : super(key: key);

  final TextEditingController _usernamecontroller=TextEditingController();
  final TextEditingController _passwordcontroller=TextEditingController();

  late KorisnikProvider _korisniciProvider;

  Korisnik? loggovaniUser;

    final ScrollController _horizontal = ScrollController(),
      _vertical = ScrollController();


  @override
  Widget build(BuildContext context) {
     
    _korisniciProvider=context.read<KorisnikProvider>();

    String encodeBase64(String data) {
      if(data!=null)
      {
        List<int> bytes = utf8.encode(data); // Convert string to bytes
        return base64.encode(bytes); // Encode bytes as Base64
      }
      else {
        return "greška";
      }
    }

    String decodeBase64(String lozinkaGore)
    {
      List<int> bytes=base64.decode(lozinkaGore);

    return utf8.decode(bytes);
    }

    return 
        Scaffold(
          appBar: AppBar(
            title: const Text("Prijava"),),
            body: Center(
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
                child: Container(
                  constraints: const BoxConstraints(maxHeight: 500,maxWidth: 400),
                    child: Column(children: [
                      const SizedBox(height: 20,),
                      const Text('Aplikacija Fudbalskog Kluba',
                       style: TextStyle(fontSize: 30),),
                        const SizedBox(height: 20,),
                      TextField(
                        decoration: const InputDecoration(
                          labelText: "Korisničko ime",
                          prefixIcon: Icon(Icons.email),
                        ),
                        controller: _usernamecontroller,
                      ),
                      const SizedBox(height: 20,),
                      TextField(
                        obscureText: true,
                        decoration: const InputDecoration(
                          labelText: "Lozinka",
                          hintText: 'Unesite Vašu sigurnu lozinku',
                          prefixIcon: Icon(Icons.password_outlined),
                        ),
                        controller: _passwordcontroller, 
                      ),
                      const SizedBox(height: 20,),
                      ElevatedButton(onPressed: 
                      () async {
                        var username=_usernamecontroller.text;
                        var password=_passwordcontroller.text;
                
                        if(username.isEmpty||password.isEmpty)
                        {
                          showDialog(context: context, builder: (BuildContext context) => 
                                AlertDialog(
                                  title: const Text("Morate unijeti validne kredencijale."),
                                  content: Text(e.toString()),
                                  actions: [
                                    TextButton(onPressed: ()=>{
                                      Navigator.pop(context),
                                      _usernamecontroller.text="",
                                      _passwordcontroller.text=""
                                    }, child: const Text("OK"))
                                  ],
                                ));
                        }
                       
                        else {
                            
                            Authorization.username=username;
                            Authorization.password=password;
                            
                            try {
                              var data=await _korisniciProvider.get(filter: {
                              'KorisnickoIme':username,
                              }
                            );
                            
                           
                            loggovaniUser=data.result.first;
                            var foundFirst=data.result.first;
                            var uloga=foundFirst.uloga;
                            Authorization.ulogaKorisnika=uloga;
                            
                            showDialog(context: context, builder: (BuildContext context) => 
                              AlertDialog(
                                // title: Text("Dobro došli (${username}) (${password})"),
                                title: Text("Dobro došli ($username)"),
                
                                content: Text(
                                "\nuloga usera: ${Authorization.ulogaKorisnika}"
                                ),
                                actions: [
                                  TextButton(onPressed: ()=>{
                                    Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => KorisnikDetailsScreen(korisnik: foundFirst,),
                                      ),
                                    )
                                    }, child: const Text("OK"))
                                ],
                              ));
                            } 
                            catch (e) {
                              if(e is StateError)
                              {
                                showDialog(context: context, builder: (BuildContext context) => 
                                AlertDialog(
                                  title: const Text("Nije pronađen korisnik sa ovim kredencijalima."),
                                  content: Text(e.toString()),
                                  actions: [
                                    TextButton(onPressed: ()=>{
                                      Navigator.pop(context),
                                      _usernamecontroller.text="",
                                      _passwordcontroller.text=""
                                    }, child: const Text("OK"))
                                  ],
                                ));
                              }
                              else
                              {
                                showDialog(context: context, builder: (BuildContext context) => 
                                AlertDialog(
                                  title: const Text("Greška"),
                                  content: Text(e.toString()),
                                  actions: [
                                    TextButton(onPressed: ()=>{
                                      Navigator.pop(context),
                                      _usernamecontroller.text="",
                                      _passwordcontroller.text=""
                                    }, child: const Text("OK"))
                                  ],
                                ));
                              }
                            }
                          }
                      }, child: const Text("Prijava")),
                      const SizedBox(height: 20,),
                
                      ElevatedButton(onPressed: (){
                        
                          Navigator.of(context).push(
                          MaterialPageRoute(
                          builder: (context) => const ContactPage(),
                              ),
                              );
                            }, 
                      child: const Text(
                        'Zaboravljena lozinka',
                        style: TextStyle(color: Colors.black, fontSize: 15),
                       ),
                       
                      ),
                
                      // const SizedBox(height: 20,),
                      // ElevatedButton(onPressed: (){
                      //   makePayment();
                      // }, 
                      // child: const Text('Go to Payment'),
                      // )
                
                
                    ]),
                  // ),
                ),
              ),
                ),
                ),
              ),
            ),
        );
  }
}



































