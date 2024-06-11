
import 'dart:convert';
import 'dart:math';
import 'package:afk_android/providers/cart_provider.dart';
import 'package:afk_android/providers/clanarina_provider.dart';
import 'package:afk_android/providers/proizvod_provider.dart';
import 'package:afk_android/providers/transakcijski_racun_provider.dart';
import 'package:afk_android/screens/korisnik_details_screen.dart';
import 'package:afk_android/screens/reset_password_screen.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:afk_android/providers/korisnik_provider.dart';
import 'package:afk_android/providers/uloga_provider.dart';
import 'package:afk_android/utils/util.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// import 'package:afk_android/api/client.dart';

import 'models/korisnik.dart';

void main() async {
  // await dotenv.load(fileName: "lib/.env");
  Stripe.publishableKey="pk_test_51NnoBzESdHn89Po93TLLgZ3wTUdjypvSv1WwSQPYxEfPXp2B8veWzxeMS2pVRci6UaVbLNW8xE90ND9JixodNVNX00uDND5nc3";
  
  runApp(MultiProvider(providers:
  [
    ChangeNotifierProvider(create: (_) => KorisnikProvider()),
    ChangeNotifierProvider(create: (_) => UlogaProvider()),
    ChangeNotifierProvider(create: (_) => ClanarinaProvider()),
    ChangeNotifierProvider(create: (_) => TransakcijskiRacunProvider()),
    ChangeNotifierProvider(create: (_) => ProizvodProvider()),
    ChangeNotifierProvider(create: (_) => CartProvider()),

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
        return "error";
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
            title: const Text("Login"),),
            body: Center(
              child: 
              Container(
                constraints: const BoxConstraints(maxHeight: 400,maxWidth: 400),
                  child: Column(children: [
                    const SizedBox(height: 20,),
                    const Text('Aplikacija Fudbalskog Kluba',
                     style: TextStyle(fontSize: 30),),
                      const SizedBox(height: 20,),
                    TextField(
                      decoration: const InputDecoration(
                        labelText: "Username",
                        prefixIcon: Icon(Icons.email),
                      ),
                      controller: _usernamecontroller,
                    ),
                    const SizedBox(height: 20,),
                    TextField(
                      obscureText: true,
                      decoration: const InputDecoration(
                        labelText: "Password",
                        hintText: 'Enter your secure password',
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
                                title: const Text("You must enter credentials."),
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
                                title: const Text("No user found with these credentials."),
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
                                title: const Text("Error"),
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
                    }, child: const Text("Login")),
                    const SizedBox(height: 20,),

                    ElevatedButton(onPressed: (){
                      
                        Navigator.of(context).push(
                        MaterialPageRoute(
                        builder: (context) => const ContactPage(),
                            ),
                            );
                          }, 
                    child: const Text(
                      'Forgot Password',
                      style: TextStyle(color: Colors.white, fontSize: 15),
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
        );
  }
}



































