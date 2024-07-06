
import 'package:afk_android/models/cart.dart';
import 'package:afk_android/models/search_result.dart';
import 'package:afk_android/providers/proizvod_provider.dart';
import 'package:afk_android/screens/proizvod_list_screen.dart';
import 'package:afk_android/widgets/master_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

import 'package:provider/provider.dart';

import '../models/korisnik.dart';
import '../models/proizvod.dart';
import '../providers/cart_provider.dart';

class ProizvodDetailsScreen extends StatefulWidget {
  static const String routeName = "/product";

  Korisnik?korisnik;
  Proizvod? proizvod;

  ProizvodDetailsScreen({this.proizvod,this.korisnik, super.key});

  @override
  State<ProizvodDetailsScreen> createState() => _ProizvodDetailsScreen();
}

class _ProizvodDetailsScreen extends State<ProizvodDetailsScreen> {

  final _formKey=GlobalKey<FormBuilderState>();

  Map<String,dynamic>_initialValue={};

  late ProizvodProvider _proizvodProvider;
  SearchResult<Proizvod>? _proizvodResult;
  
  CartProvider? _cartProvider;
  SearchResult<Cart>? _cartResult;



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  _initialValue= {
    'proizvodId':widget.proizvod?.proizvodId.toString()??"0",
    'naziv':widget.proizvod?.naziv??"---",
    'sifra': widget.proizvod?.sifra??"---", 
    'kategorija': widget.proizvod?.kategorija??"---", 
    'cijena': widget.proizvod?.cijena.toString()??"---", 
    'kolicina': widget.proizvod?.kolicina.toString()??"---", 
  };

    _proizvodProvider=context.read<ProizvodProvider>(); 
    // _cartProvider=context.watch<CartProvider>();
  initForm();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();

  }

  Future initForm()async{
    _proizvodResult=await _proizvodProvider.get();
  }

  Future<Proizvod> getProizvod()async
  {
    Proizvod pronadjeni=await _proizvodResult!.result.first;
    return pronadjeni;
  }   

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      title: 'Proizvod ID: ${widget.proizvod?.proizvodId}' ?? "Proizvod detalji",
      child: buildForm()
     
      );
  }

  FormBuilder buildForm() {
    return FormBuilder(
      key: _formKey,
      initialValue: _initialValue,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(children: [
            Expanded(
              child: FormBuilderTextField (
                // readOnly: true,
                decoration: const InputDecoration(labelText: "Proizvod ID"), 
                readOnly: true,

                name: 'proizvodId',
                
                    ),
            ),
          Expanded(
            child: FormBuilderTextField (
                decoration: const InputDecoration(labelText: "Naziv proizvoda"), 
                readOnly: true,
                
                name: 'naziv',
            ),
          ),
          Expanded(
            child: FormBuilderTextField (
                            decoration: const InputDecoration(labelText: "Šifra proizvoda"), 
                readOnly: true,

                name: 'sifra',
                
            ),
          ),
          Expanded(
            child: FormBuilderTextField (
                            decoration: const InputDecoration(labelText: "Kategorija proizvoda"), 
                readOnly: true,
                name: 'kategorija',
                
            ),
          ),
          Expanded(
            child: FormBuilderTextField (
                            decoration: const InputDecoration(labelText: "Cijena proizvoda"), 

                readOnly: true,
                name: 'cijena',
                
            ),
          ),
          Expanded(
            child: FormBuilderTextField (
                            decoration: const InputDecoration(labelText: "Količina proizvoda"), 
                readOnly: true,

                name: 'kolicina',
                
            ),
          ),
          
          ElevatedButton(onPressed: () async{
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => ProizvodListScreen(),
              ),
            );
          }, child: const Text("Svi proizvodi")),

          ElevatedButton(onPressed: () async{
            Navigator.pushNamed(context, "${ProizvodDetailsScreen.routeName}/${widget.proizvod?.proizvodId}");
            // _cartProvider!.addToCart(widget.proizvod!);
          }, child: const Text("Dodaj u korpu")),

          ],
          ),
        ),
      
    );
  }
}