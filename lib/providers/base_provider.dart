import 'dart:async';
import 'dart:convert';
import 'dart:io';


import 'package:afk_android/models/search_result.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart';
import 'package:flutter/foundation.dart';
import 'package:http/io_client.dart';

import 'package:flutter_dotenv/flutter_dotenv.dart';


import '../utils/util.dart';



abstract class BaseProvider<T> with ChangeNotifier {
  static String? _baseUrl;
  String? _endpoint;
  String get envValue=>dotenv.env['MOBILNA_DOCKER']??"https://google.com";
  String get envValueInternet=>dotenv.env['MOBILNA_INTERNET']??"https://youtube.com";
  String get envValueLokalna=>dotenv.env['MOBILNA_LOKALNA']??"https://instagram.com";
  HttpClient client = HttpClient();
  IOClient? http;

  BaseProvider(String endpoint) {

    // _baseUrl=envValue;
    // _baseUrl=envValueLocal;
    _baseUrl=envValueLokalna;

    print("baseurl: $_baseUrl");

    if (_baseUrl!.endsWith("/") == false) {
      _baseUrl = "${_baseUrl!}/";
    }

    _endpoint = endpoint;
    client.badCertificateCallback = (cert, host, port) => true;
    http = IOClient(client);
  }

  Future<List<T>> getById(int id, [dynamic additionalData]) async {
    var url = Uri.parse("$_baseUrl$_endpoint/$id");

    Map<String, String> headers = createHeaders();

    var response = await http!.get(url, headers: headers);

    if (isValidResponse(response)) {
      var data = jsonDecode(response.body);
      return data.map((x) => fromJson(x)).cast<T>().toList();
    } else {
      throw Exception("Exception... handle this gracefully");
    }
  }

  Future<SearchResult<T>>get({dynamic filter})async{
    var fullAPI="$_baseUrl$_endpoint";

    if(filter!=null)
    {
      var queryString=getQueryString(filter);
      fullAPI="$fullAPI?$queryString";
    }
    var uriFullApi=Uri.parse(fullAPI);
    var headerz=createHeaders();

    var response = await http!.get(uriFullApi, headers: headerz);

    if(isValidResponse(response))
    {
      var data=jsonDecode(response.body);

      var result = SearchResult<T>();
      result.count=data['count'];
      
      for(var item in data['result'])
      {
        
        result.result.add(fromJson(item));

      }

      return result;
    }
    else {
      throw Exception("Unknown error.");
    }
    

  }

  Future<T?> insert(dynamic request) async {
    var url = "$_baseUrl$_endpoint";
    var uri = Uri.parse(url);

    Map<String, String> headers = createHeaders();
    var jsonRequest = jsonEncode(request);
    var response =
        await http!.post(uri, headers: headers, body: jsonRequest);

    if (isValidResponse(response)) {
      var data = jsonDecode(response.body);
      return fromJson(data);
    } else {
      return null;
    }
  }

  Future<T?> update(int id, [dynamic request]) async {
    var url = "$_baseUrl$_endpoint/$id";
    var uri = Uri.parse(url);

    Map<String, String> headers = createHeaders();

    var response =
        await http!.put(uri, headers: headers, body: jsonEncode(request));

    if (isValidResponse(response)) {
      var data = jsonDecode(response.body);
      return fromJson(data);
    } else {
      return null;
    }
  }

    Future<T> delete(int id)async{
    var fullAPI="$_baseUrl$_endpoint/Delete/$id";
    var uriFullApi=Uri.parse(fullAPI);
    var headerz=createHeaders();

    var jsonRequest=jsonEncode(id);

    var response=await http!.delete(uriFullApi, headers: headerz, body: jsonRequest);
    if(isValidResponse(response)==true)
        {
          var data=jsonDecode(response.body);
          return fromJson(data);
        }
        else {
          throw Exception("Unknown error.");
        }
  }

  Future<T> activatePlatum(int id)async{
    var fullAPI="$_baseUrl$_endpoint/$id/activate";
    var uriFullApi=Uri.parse(fullAPI);
    var headerz=createHeaders();

    var jsonRequest=jsonEncode(id);

    var response=await http!.put(uriFullApi, headers: headerz, body: jsonRequest);
    if(IsValidResponse(response))
        {
          var data=jsonDecode(response.body);
          return fromJson(data);
        }
        else {
          throw Exception("Unknown error.");
        }
  }

  bool IsValidResponse(Response response){
  if(response.statusCode<299) {
    return true;
  } else if(response.statusCode==401)
    {
      throw Exception("Unauthorized");
    }
    else if(response.statusCode==403)
    {
      throw Exception("You do not have permissions");
    }
    else
    {
      throw Exception("Something happened. Try again${response.statusCode}");
      // throw Exception("Something happened. Try again" + response.toString());

    }
}

  Future<T> hidePlatum(int id)async{
    var fullAPI="$_baseUrl$_endpoint/$id/hide";
    var uriFullApi=Uri.parse(fullAPI);
    var headerz=createHeaders();

    var jsonRequest=jsonEncode(id);

    var response=await http!.put(uriFullApi, headers: headerz, body: jsonRequest);
    if(IsValidResponse(response))
        {
          var data=jsonDecode(response.body);
          return fromJson(data);
        }
        else {
          throw Exception("Unknown error.");
        }
  }


  Map<String, String> createHeaders() {
    String? username = Authorization.username;
    String? password = Authorization.password;

    String basicAuth =
        "Basic ${base64Encode(utf8.encode('$username:$password'))}";

    var headers = {
      "Content-Type": "application/json",
      "Authorization": basicAuth
    };
    return headers;
  }

  T fromJson(data) {
    throw Exception("Override method");
  }

  String getQueryString(Map params,
      {String prefix= '&', bool inRecursion= false}) {
    String query = '';
    params.forEach((key, value) {
      if (inRecursion) {
        if (key is int) {
          key = '[$key]';
        } else if (value is List || value is Map) {
          key = '.$key';
        } else {
          key = '.$key';
        }
      }
      if (value is String || value is int || value is double || value is bool) {
        var encoded = value;
        if (value is String) {
          encoded = Uri.encodeComponent(value);
        }
        query += '$prefix$key=$encoded';
      } else if (value is DateTime) {
        query += '$prefix$key=${(value).toIso8601String()}';
      } else if (value is List || value is Map) {
        if (value is List) value = value.asMap();
        value.forEach((k, v) {
          query +=
              getQueryString({k: v}, prefix: '$prefix$key', inRecursion: true);
        });
      }
    });
    return query;
  }

  bool isValidResponse(Response response) {
    if (response.statusCode == 200) {
      if (response.body != "") {
        return true;
      } else {
        return false;
      }
    } else if (response.statusCode == 204) {
      return true;
    } else if (response.statusCode == 400) {
      throw Exception("Bad request");
    } else if (response.statusCode == 401) {
      throw Exception("Unauthorized");
    } else if (response.statusCode == 403) {
      throw Exception("Forbidden");
    } else if (response.statusCode == 404) {
      throw Exception("Not found");
    } else if (response.statusCode == 500) {
      throw Exception("Internal server error");
    } else {
      throw Exception("Exception... handle this gracefully");
    }
  }
}

// abstract class BaseProvider<T> with ChangeNotifier{
//   static String? _baseUrl;
//   String _endpoint="";
//   HttpClient client=new HttpClient();
//   IOClient? http;
//   // late KorisnikProvider _korisniciProvider;


//   BaseProvider(String endpoint){
//     _endpoint=endpoint;
//     _baseUrl=const String.fromEnvironment("baseUrl",defaultValue: "https://10.0.2.2/");

//   }

//   Future<T> insert(dynamic request)async{
//     var fullAPI="$_baseUrl$_endpoint";
//     var uriFullApi=Uri.parse(fullAPI);
//     var headerz=createHeaders();

//     var jsonRequest=jsonEncode(request);

//     var response=await http!.post(uriFullApi, headers: headerz, body: jsonRequest);
//     if(IsValidResponse(response))
//         {
//           var data=jsonDecode(response.body);
//           return fromJson(data);
//         }
//         else {
//           throw Exception("Unknown error.");
//         }
//   }

//   Future<T> update(int id, [dynamic request])async{
//     var fullAPI="$_baseUrl$_endpoint/$id";
//     var uriFullApi=Uri.parse(fullAPI);
//     var headerz=createHeaders();

//     var jsonRequest=jsonEncode(request);

//     var response=await http!.put(uriFullApi, headers: headerz, body: jsonRequest);
//     if(IsValidResponse(response)==true)
//         {
//           var data=jsonDecode(response.body);
//           return fromJson(data);
//         }
//         else {
//           throw Exception("Unknown error.");
//         }
//   }

//   Future<T> activatePlatum(int id)async{
//     var fullAPI="$_baseUrl$_endpoint/$id/activate";
//     var uriFullApi=Uri.parse(fullAPI);
//     var headerz=createHeaders();

//     var jsonRequest=jsonEncode(id);

//     var response=await http!.put(uriFullApi, headers: headerz, body: jsonRequest);
//     if(IsValidResponse(response))
//         {
//           var data=jsonDecode(response.body);
//           return fromJson(data);
//         }
//         else {
//           throw Exception("Unknown error.");
//         }
//   }

//   Future<T> hidePlatum(int id)async{
//     var fullAPI="$_baseUrl$_endpoint/$id/hide";
//     var uriFullApi=Uri.parse(fullAPI);
//     var headerz=createHeaders();

//     var jsonRequest=jsonEncode(id);

//     var response=await http!.put(uriFullApi, headers: headerz, body: jsonRequest);
//     if(IsValidResponse(response))
//         {
//           var data=jsonDecode(response.body);
//           return fromJson(data);
//         }
//         else {
//           throw Exception("Unknown error.");
//         }
//   }

  

//   Future<T> changePassword(int id, [dynamic request])async{
//     var fullAPI="$_baseUrl$_endpoint/passwordChange/$id";
//     var uriFullApi=Uri.parse(fullAPI);
//     var headerz=createHeaders();

//     var jsonRequest=jsonEncode(request);

//     var response=await http!.put(uriFullApi, headers: headerz, body: jsonRequest);
//     if(IsValidResponse(response)==true)
//         {
//           var data=jsonDecode(response.body);
//           return fromJson(data);
//         }
//         else {
//           throw Exception("Unknown error.");
//         }
//   }

//   T fromJson(data)
//   {
//     throw Exception("Method not implemented");
//   }

// bool IsValidResponse(Response response){
//   if(response.statusCode<299) {
//     return true;
//   } else if(response.statusCode==401)
//     {
//       throw Exception("Unauthorized");
//     }
//     else if(response.statusCode==403)
//     {
//       throw Exception("You do not have permissions");
//     }
//     else
//     {
//       throw Exception("Something happened. Try again" + response.statusCode.toString());
//     }
// }


//   Map<String,String>createHeaders(){
//     String username=Authorization.username??"";
//     String password=Authorization.password??"";
//     String ulogaKorisnika=Authorization.ulogaKorisnika??"";

 
//     print("passed creds: $username, $password, $ulogaKorisnika");

//     String basicAuth="Basic ${base64Encode(utf8.encode('$username:$password'))}";
    
//     var headers={
//       "Content-Type":"application/json",
//       "Authorization":basicAuth
//     };

//     return headers;
    

//   }

  
// }




// String getQueryString(Map params,
//       {String prefix= '&', bool inRecursion= false}) {
//     String query = '';
//     params.forEach((key, value) {
//       if (inRecursion) {
//         if (key is int) {
//           key = '[$key]';
//         } else if (value is List || value is Map) {
//           key = '.$key';
//         } else {
//           key = '.$key';
//         }
//       }
//       if (value is String || value is int || value is double || value is bool) {
//         var encoded = value;
//         if (value is String) {
//           encoded = Uri.encodeComponent(value);
//         }
//         query += '$prefix$key=$encoded';
//       } else if (value is DateTime) {
//         query += '$prefix$key=${(value as DateTime).toIso8601String()}';
//       } else if (value is List || value is Map) {
//         if (value is List) value = value.asMap();
//         value.forEach((k, v) {
//           query +=
//               getQueryString({k: v}, prefix: '$prefix$key', inRecursion: true);
//         });
//       }
//     });
//     return query;
//   }