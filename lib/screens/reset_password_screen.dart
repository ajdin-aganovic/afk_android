import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart' as dotenv;

import '../main.dart';


class ContactPage extends StatefulWidget {
  const ContactPage({Key? key}):super(key:key);

  @override
  State<ContactPage> createState() => _ContactPageState();
}

  final nameController = TextEditingController();
  final subjectController = TextEditingController();
  final emailController = TextEditingController();
  final messageController = TextEditingController();
  final usernameController = TextEditingController();

  Future sendEmail()async{
    final url=Uri.parse("https://api.emailjs.com/api/v1.0/email/send");
    const serviceId="service_smd9uuu";
    const templateId="template_i9f6la9";
    const userId="lHaUrvKDqOO16pVqT";
    final response=await http.post(url,
    headers:{'Content-Type':'application/json'},
    body: json.encode({
      "service_id":serviceId,
      "template_id":templateId,
      "user_id":userId,
      "template_params":{
        "name":nameController.text,
        "user_name":usernameController.text,
        "message":messageController.text,
        "subject":subjectController.text,
        "user_email":emailController.text
      }
      })
    );
    return response.statusCode;
  }

class _ContactPageState extends State<ContactPage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.red),

      home: Scaffold(
        appBar: AppBar(
          // backgroundColor: Colors.grey[400],
        ),
        body: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Form(
            child: Column(children: [
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(
                  // icon: const Icon(Icons.account_circle),
                  labelText: 'Name',
                  hintText: 'Name'),
              ),
              SizedBox(height: 25,),
              TextFormField(
                controller: usernameController,
                decoration: const InputDecoration(
                  // icon: const Icon(Icons.account_circle),
                  labelText: 'Username',
                  hintText: 'Username'),
              ),
              SizedBox(height: 25,),
              TextFormField(
                controller: messageController,
                decoration: const InputDecoration(
                  // icon: const Icon(Icons.account_circle),
                  labelText: 'Message',
                  hintText: 'Message'),
              ),
              SizedBox(height: 25,),
              TextFormField(
                controller: subjectController,
                decoration: const InputDecoration(
                  // icon: const Icon(Icons.account_circle),
                  labelText: 'Subject',
                  hintText: 'Subject'),
              ),
              SizedBox(height: 25,),
              TextFormField(
                controller: emailController,
                decoration: const InputDecoration(
                  // icon: const Icon(Icons.account_circle),
                  labelText: 'Email',
                  hintText: 'Email'),
              ),
              SizedBox(height: 25,),
              ElevatedButton(onPressed: (){
                sendEmail();
                Navigator.pop(context);
              }, child: Text("Pošalji", 
              style: TextStyle(fontSize: 20),)),
              SizedBox(height: 25,),
              ElevatedButton(onPressed: (){
                Navigator.of(context).push(
                MaterialPageRoute(
                  // builder: (context) => HomePage(naziv: username,),
                  builder: (context) => LoginPage(),

                ),
              );
              }, child: Text("Nazad na login", 
              style: TextStyle(fontSize: 20),))
            ]),
          ),
        ),
      ),
    );

  }
}