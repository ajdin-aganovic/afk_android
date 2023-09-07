import 'dart:convert';
import 'dart:ffi';

import 'package:afk_admin/models/platum.dart';
import 'package:afk_admin/models/search_result.dart';
import 'package:afk_admin/models/transakcijski_racun.dart';
import 'package:afk_admin/providers/platum_provider.dart';
import 'package:afk_admin/providers/clanarina_provider.dart';
import 'package:afk_admin/providers/transakcijski_racun_provider.dart';
import 'package:afk_admin/screens/clanarina_list_screen.dart';
import 'package:afk_admin/widgets/master_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:http/http.dart' as http;

import 'package:afk_admin/providers/platum_provider.dart';
import 'package:afk_admin/providers/uloga_provider.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart' as dotenv;

import '../models/korisnik.dart';
import '../models/clanarina.dart';
import '../models/uloga.dart';
import '../providers/korisnik_provider.dart';

import 'package:flutter_stripe/flutter_stripe.dart';


class IgracClanarinaScreen extends StatefulWidget {
  Korisnik?korisnik;
  Clanarina? clanarina;

  IgracClanarinaScreen({this.clanarina,this.korisnik, super.key});

  @override
  State<IgracClanarinaScreen> createState() => _IgracClanarinaScreen();
}

class _IgracClanarinaScreen extends State<IgracClanarinaScreen> {

  final _formKey=GlobalKey<FormBuilderState>();

  Map<String,dynamic>_initialValue={};

  Map<String, dynamic>? paymentIntent;

  late KorisnikProvider _korisnikProvider;
  SearchResult<Korisnik>? _korisnikResult;

  late ClanarinaProvider _clanarinaProvider;
  SearchResult<Clanarina>? _clanarinaResult;
  // bool isLoading=true;

  void makePayment()async
  {
    try {
      // Clanarina odabrana=
      paymentIntent=await createPaymentIntent();
      var gpay= const PaymentSheetGooglePay(
        merchantCountryCode: "US",
        currencyCode: "US",
        testEnv: true,
        );
      await  Stripe.instance.initPaymentSheet(paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: paymentIntent!["client_secret"],
          style: ThemeMode.dark,
          merchantDisplayName: "Aplikacija fudbalskog kluba",
          googlePay: gpay,
           
        ));

        displayPaymentSheet();
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  void displayPaymentSheet() async
  {
    try {
      await Stripe.instance.presentPaymentSheet();
      print("Payment successful");
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  // createPaymentIntent(Clanarina x) async
  createPaymentIntent() async  
  {
    try {
      Map<String, dynamic> body={
        // "amount":"${x.iznosClanarine!*100}",
        "amount":"5000",
        "currency":"USD",
      };
      http.Response response=await http.post(Uri.parse("https://api.stripe.com/v1/payment_intents"),
        body: body,
        headers: {
          "Authorization":"Bearer sk_test_51NnoBzESdHn89Po9rHaBo6iRxEfz0OVa9sshewEnKMVPYXrhj0F73IQfxcz0fvCT4p8cBwmHY7lkaKBtjUGT0oPJ00I5ST6AAm",
          "Content-Type":"application/x-www-form-urlencoded",
        }
      );
      return json.decode(response.body);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  _initialValue= {
    'clanarinaId':widget.clanarina?.clanarinaId.toString()??"0",
    'korisnikId':widget.clanarina?.korisnikId.toString()??"2",
    'iznosClanarine': widget.clanarina?.iznosClanarine.toString()??"---", 
    'dug':widget.clanarina?.dug.toString()??"0",
  };

    _clanarinaProvider=context.read<ClanarinaProvider>(); 
    _korisnikProvider=context.read<KorisnikProvider>();

    initForm();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();

  }


  Future initForm()async{
    _clanarinaResult=await _clanarinaProvider.get();
    _korisnikResult=await _korisnikProvider.get();
      
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      title: 'Clanarina ID: ${widget.clanarina?.clanarinaId}' ?? "Clanarina detalji",
      child: Column(
        children: [
          buildForm(),
           ElevatedButton(onPressed: (){
            
          }, child: Text("Add new KorisnikPozicija")),
        ],
      )
     
      );
  }

  FormBuilder buildForm() {
    return FormBuilder(
      key: _formKey,
      initialValue: _initialValue,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(children: [
              ElevatedButton(onPressed: (){
              makePayment();
              }, child: Text("Plati članarinu")),
             ],
          ),
        ),
      
    );
  }

  // FormBuilder buildForm() {
  //   return FormBuilder(
  //     key: _formKey,
  //     initialValue: _initialValue,
  //       child: Padding(
  //         padding: const EdgeInsets.all(10.0),
  //         child: Column(children: [
  //           Expanded(
  //             child: FormBuilderTextField (
  //               // readOnly: true,
  //               decoration: const InputDecoration(labelText: "Članarina ID"), 

  //               name: 'clanarinaId',
                
  //                   ),
  //           ),

  //          Expanded(
  //             child: 
  //               FormBuilderDropdown(
  //                     name: 'korisnikId',
  //                     decoration: const InputDecoration(labelText: 'Korisnik'),
  //                     items: 
  //                     List<DropdownMenuItem>.from(
  //                       _korisnikResult?.result.map(
  //                         (e) => DropdownMenuItem(
  //                           value: e.korisnikId.toString(),
  //                           child: Text(e.korisnickoIme??"Nema imena"),
  //                           )).toList()??[]),

  //                     onChanged: (value) {
  //                       setState(() {
                          
  //                         print("Odabrana ${value}");
  //                       });
  //                     },
  //                     validator: (value) {
  //                       if (value == null) {
  //                         return 'Please enter the Uloga';
  //                       }
  //                       return null;
  //                     },
  //                   ),
  //                   ),

  //         Expanded(
  //           child: FormBuilderTextField (
  //                           decoration: const InputDecoration(labelText: "Iznos članarine"), 

  //               name: 'iznosClanarine',
                
  //           ),
  //         ),
  //         Expanded(
  //           child: FormBuilderTextField (
  //               decoration: const InputDecoration(labelText: "Dug"), 
  //               name: 'dug',
  //           ),
  //         ),
          

  //         ElevatedButton(onPressed: () async{
  //               setState(() {});
  //             }, child: Text("Reload podataka")),


  //         ElevatedButton(onPressed: () async{
  //           Navigator.of(context).push(
  //             MaterialPageRoute(
  //               builder: (context) => ClanarinaListScreen(),
  //             ),
  //           );
  //         }, child: Text("Sve članarine")),

  //         ElevatedButton(onPressed: (){
  //               makePayment();
  //             }, child: Text("Plati članarinu")),

              
          // ElevatedButton(onPressed: () async{
          //       _formKey.currentState?.saveAndValidate(focusOnInvalid: false);
          //       print(_formKey.currentState?.value);
          //       try{
          //         if(widget.clanarina==null) {
          //           await _clanarinaProvider.insert(_formKey.currentState?.value);
          //         } else {
          //           await _clanarinaProvider.update(widget.clanarina!.clanarinaId!, _formKey.currentState?.value);
          //         }
          //         Navigator.of(context).push(
          //           MaterialPageRoute(
          //             builder: (context) => ClanarinaListScreen(),

          //           ),
          //                   );
          //       } on Exception catch (err) {
          //         showDialog(context: context, builder: (BuildContext context) => 
          //                 AlertDialog(
          //                   title: const Text("Error"),
          //                   content: Text(err.toString()),
          //                   actions: [
          //                     TextButton(onPressed: ()=>{
          //                       Navigator.pop(context),
          //                     }, child: const Text("OK"))
          //                   ],
          //                 ));
          //       }
          //     }, child: Text("Save")),
              
              // ElevatedButton(onPressed: () async{
              //     showDialog(context: context, builder: (BuildContext context) => 
              //       AlertDialog(
              //         title: const Text("Warning!!!"),
              //         content: Text("Are you sure you want to delete clanarina ${widget.clanarina!.clanarinaId}?"),
              //         actions: [
                        
              //           TextButton(onPressed: () async =>{
                          
              //             await _clanarinaProvider.delete(widget.clanarina!.clanarinaId!),

              //             Navigator.of(context).push(
              //               MaterialPageRoute(
              //                 builder: (context) => ClanarinaListScreen(),
              //               ),
              //             )
                      

              //           }, child: const Text("Yes")),
              //           TextButton(onPressed: ()=>{
              //             Navigator.pop(context),
              //           }, child: const Text("No")),
              
              //         ],
              //       ));
                        
              //         }, child: Text("Izbriši")),
  //         ],
  //         ),
  //       ),
      
  //   );
  // }
}