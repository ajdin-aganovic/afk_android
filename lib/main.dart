// import 'dart:js_interop';
import 'dart:convert';
import 'dart:math';
// import 'dart:convert';
import 'package:afk_admin/providers/base_provider.dart';
import 'package:afk_admin/providers/bolest_provider.dart';
import 'package:afk_admin/providers/clanarina_provider.dart';
import 'package:afk_admin/providers/korisnik_bolest_provider.dart';
import 'package:afk_admin/providers/korisnik_pozicija_provider.dart';
import 'package:afk_admin/providers/korisnik_transakcijski_racun_provider.dart';
import 'package:afk_admin/providers/korisnik_uloga_provider.dart';
import 'package:afk_admin/providers/pozicija_provider.dart';
import 'package:afk_admin/providers/proizvod_provider.dart';
import 'package:afk_admin/providers/stadion_provider.dart';
import 'package:afk_admin/providers/statistika_provider.dart';
import 'package:afk_admin/providers/termin_provider.dart';
import 'package:afk_admin/providers/transakcijski_racun_provider.dart';
import 'package:afk_admin/providers/trening_provider.dart';
import 'package:afk_admin/providers/trening_stadion_provider.dart';
// import 'package:paypal_sdk/paypal_sdk.dart';
// import 'package:afk_admin/screens/bolest_list_screen.dart';
import 'package:afk_admin/screens/home_screen.dart';
// import 'package:afk_admin/screens/korisnici_list_screen.dart';
import 'package:afk_admin/screens/reset_password_screen.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;
import 'package:afk_admin/providers/korisnik_provider.dart';
import 'package:afk_admin/providers/platum_provider.dart';
import 'package:afk_admin/providers/uloga_provider.dart';
import 'package:afk_admin/screens/plata_list_screen.dart';
import 'package:afk_admin/screens/korisnik_details_screen.dart';
import 'package:afk_admin/utils/util.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:afk_admin/widgets/makePayment.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart' as dotenv;
// import 'package:afk_admin/api/client.dart';

import 'models/korisnik.dart';

void main() async {
  // await dotenv.load(fileName: "lib/.env");
  Stripe.publishableKey="pk_test_51NnoBzESdHn89Po93TLLgZ3wTUdjypvSv1WwSQPYxEfPXp2B8veWzxeMS2pVRci6UaVbLNW8xE90ND9JixodNVNX00uDND5nc3";
  
  runApp(MultiProvider(providers:
  [
    ChangeNotifierProvider(create: (_) => PlatumProvider()),
    ChangeNotifierProvider(create: (_) => KorisnikProvider()),
    ChangeNotifierProvider(create: (_) => UlogaProvider()),
    ChangeNotifierProvider(create: (_) => BolestProvider()),
    ChangeNotifierProvider(create: (_) => ClanarinaProvider()),
    ChangeNotifierProvider(create: (_) => PozicijaProvider()),
    ChangeNotifierProvider(create: (_) => StadionProvider()),
    ChangeNotifierProvider(create: (_) => StatistikaProvider()),
    ChangeNotifierProvider(create: (_) => TerminProvider()),
    ChangeNotifierProvider(create: (_) => TransakcijskiRacunProvider()),
    ChangeNotifierProvider(create: (_) => TreningProvider()),
    ChangeNotifierProvider(create: (_) => KorisnikBolestProvider()),
    ChangeNotifierProvider(create: (_) => KorisnikPozicijaProvider()),
    ChangeNotifierProvider(create: (_) => KorisnikTransakcijskiRacunProvider()),
    ChangeNotifierProvider(create: (_) => KorisnikUlogaProvider()),
    ChangeNotifierProvider(create: (_) => TreningStadionProvider()),
    ChangeNotifierProvider(create: (_) => ProizvodProvider()),

  ],
  child: const MyMaterialApp(),));
}

class MyMaterialApp extends StatelessWidget {
  const MyMaterialApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AFK Material app',
      theme: ThemeData(primarySwatch: Colors.red),
      home: LoginPage(),

    );
  }
}

class LoginPage extends StatelessWidget {
//  LoginPage({this.loggovaniUser, super.key});
  LoginPage({Key? key, this.loggovaniUser}) : super(key: key);

  final TextEditingController _usernamecontroller=TextEditingController();
  final TextEditingController _passwordcontroller=TextEditingController();

  late PlatumProvider _plataProvider;
  late KorisnikProvider _korisniciProvider;

  Korisnik? loggovaniUser;

  @override
  Widget build(BuildContext context) {
     
    _plataProvider=context.read<PlatumProvider>();
    _korisniciProvider=context.read<KorisnikProvider>();

    String encodeBase64(String data) {
      if(data!=null)
      {
        List<int> bytes = utf8.encode(data); // Convert string to bytes
        return base64.encode(bytes); // Encode bytes as Base64
      }
      else
      return "error";
    }

    String decodeBase64(String lozinkaGore)
    {
      if(lozinkaGore!=null)
      {
        List<int> bytes=base64.decode(lozinkaGore);

      return utf8.decode(bytes);
      }
      return "error";
    }

    return 
        Scaffold(
          appBar: AppBar(
            title: const Text("Login"),),
            body: Center(
              child: 
              Container(
                constraints: const BoxConstraints(maxHeight: 400,maxWidth: 400),
                // child: Card(
                  child: Column(children: [
                    //Image.network("https://upload.wikimedia.org/wikipedia/en/thumb/7/7a/Manchester_United_FC_crest.svg/285px-Manchester_United_FC_crest.svg.png", height: 100,width: 100,),
                    // Image.asset("assets/images/manchesterunited.png", height: 100,width: 100,),
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
                    // const SizedBox(height: 20,),
                    // ElevatedButton(onPressed: () async{
                      
                    //   }),
                    const SizedBox(height: 20,),
                    ElevatedButton(onPressed: 
                    // _performLogin
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

                          // var lozinkaHashIzUsera=foundFirst.lozinkaHash.toString();
                          // var lozinkaSaltIzUsera=foundFirst.lozinkaSalt.toString();
                          // var kodiranaLozinka1=encodeBase64(lozinkaHashIzUsera);
                          // var kodiraniSaltLozinka1=encodeBase64(lozinkaSaltIzUsera);
                          // var dekodiranaLozinka1=decodeBase64(lozinkaHashIzUsera);
                          // var dekodiraniSalt1=decodeBase64(lozinkaSaltIzUsera);
                          // var kodiranaLozinka2=encodeBase64(password);
                          // var dekodiranaLozinka2=decodeBase64(kodiranaLozinka2);

                          // print("login proceed u:(${username}) p:(${password}) \npassword dekodirani: ${lozinkaIzUsera}");
                          
                          showDialog(context: context, builder: (BuildContext context) => 
                            AlertDialog(
                              // title: Text("Dobro došli (${username}) (${password})"),
                              title: Text("Dobro došli (${username})"),

                              content: Text(
                              //   "password enkodirani1: ${lozinkaHashIzUsera}"+
                              // "\npassword salt enkodirani1: ${lozinkaSaltIzUsera}"+
                              // "\npassword dekodirani1:${dekodiranaLozinka1}"+
                              // "\npassword salt dekodirani1:${dekodiraniSalt1}"+
                              // "\npassword enkodirani2: ${kodiranaLozinka2}"+
                              // "\npassword dekodirani2:${dekodiranaLozinka2}"+
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

                          // Navigator.of(context).push(
                          // MaterialPageRoute(
                          //   builder: (context) => KorisnikDetailsScreen(korisnik: foundFirst,),
                          //   ),
                          // );
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
                        builder: (context) => ContactPage(),
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

  // Future<void> _performLogin() async {
  //   final username = _usernamecontroller.text;
  //   final password = _passwordcontroller.text;

  //   // Make an HTTP request to your API to validate the credentials
  //   final response = await http.post(
  //     "https://localhost:7181/login" as Uri,
  //     body: {'username': username, 'password': password},
  //   );

  //   if (response.statusCode == 200) {
  //     // Successful login
  //     // Navigate to the next screen
  //   } else {
  //     // Failed login
  //     showDialog(
  //       context: context,
  //       builder: (context) {
  //         return AlertDialog(
  //           title: Text('Login Failed'),
  //           content: Text('Invalid username or password.'),
  //           actions: <Widget>[
  //             TextButton(
  //               onPressed: () {
  //                 Navigator.of(context).pop();
  //               },
  //               child: Text('OK'),
  //             ),
  //           ],
  //         );
  //       },
  //     );
  //   }
  
// Future<Korisnik?> authenticateUser(String username, String password) async {
//   final url = Uri.parse('https://localhost:7181/Korisnik');

//   final response = await http.post(
//     url,
//     headers: {'Content-Type': 'application/json'},
//     body: jsonEncode({'username': username, 'password': password}),
//   );

//   if (response.statusCode == 200) {
//     final jsonResponse = jsonDecode(response.body);
//     return Korisnik.fromJson(jsonResponse);
//   } else {
//     return null;
//   }
// }
}



// Login endpoint
// Future<String> login(String username, String password) async {
//   // Perform authentication and validate credentials
//   bool isValidCredentials = await authenticate(username, password);
  
//   if (isValidCredentials) {
//     // Generate a JWT token
//     final token = generateJwtToken(username);
//     return token;
//   } else {
//     throw Exception('Invalid credentials');
//   }
// }

// // Generate JWT token
// String generateJwtToken(String username) {
//   // Generate token with desired payload (e.g., username and expiration time)
//   final payload = {
//     'username': username,
//     'exp': DateTime.now().add(Duration(hours: 1)).millisecondsSinceEpoch ~/ 1000,
//   };

//   // Sign the token using a secret key
//   final token = JwtDecoder.encode(payload, 'your_secret_key');
//   return token;
// }




































